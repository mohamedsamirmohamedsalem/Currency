//
//  ConvertCurrencyViewController.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol ConvertCurrencyVCDelegate: AnyObject {
    func navigateToNextScreen(_ viewController: ConvertCurrencyVC,data:[Double:String])
}

class ConvertCurrencyVC: UIViewController {
    
    //MARK:  Instances //////////////////////////////////////////////////////////////////////////////
    var convertFromSymbol = "", convertToSymbol = "",from = "From" , to = "To"
    var activityView =  UIActivityIndicatorView ()
    var navDelegate: ConvertCurrencyVCDelegate?
    var viewModel: ConvertCurrencyVM?
    let fromTableView = UITableView()
    let toTableView = UITableView()
    let transparentView = UIView()
    let disposeBag = DisposeBag()
    var symbolsList = [String]()
    var window: UIWindow?
    var isLoading = true
    
    //MARK:  IBOutlets //////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var fromButton : UIButton!
    @IBOutlet weak var toButton : UIButton!
    @IBOutlet weak var exchangeButton : UIButton!
    @IBOutlet weak var detailsButton: UIBarButtonItem!
    @IBOutlet weak var fromTextField : UITextField!
    @IBOutlet weak var toTextFiled : UITextField!
    
    //MARK:  VC Life Cycle //////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        subscribeOnLoading()
        subscribeOnNetworkError()
        subscribeOnSymbols()
        viewModel?.gettingSymbolsFromApi()
        subscribeOnButtons()
        subscribeOnDidSelectTableViewCell()
        subscribeOnConvertCurrency()
        
    }
    //MARK:  Methods //////////////////////////////////////////////////////////////////////////////
    
    private func  subscribeOnLoading(){
        viewModel?.loadingObservable.subscribe(onNext: { [weak self] isLoading in
            if(isLoading){
                self?.activityView.startAnimating()
            }else{
                self?.activityView.stopAnimating()
            }
            self?.isLoading = isLoading
        }).disposed(by: disposeBag)
    }
    
    private func  subscribeOnNetworkError(){
        viewModel?.networkErrorObservable.subscribe(onNext: { [weak self] error in
            AlertViewManager.presentAlertView(from: self!, message: "You finished your free trial requests")
        }).disposed(by: disposeBag)
    }
    
    private func subscribeOnSymbols(){
        
        viewModel?.symbolsObservable.bind(to: fromTableView.rx.items(cellIdentifier: "\(CurrencyTableViewCell.self)", cellType: CurrencyTableViewCell.self)) {  row, symbol, cell in
            cell.configureCell(text: symbol)
        }.disposed(by: disposeBag)
        
        viewModel?.symbolsObservable.bind(to: toTableView.rx.items(cellIdentifier: "\(CurrencyTableViewCell.self)", cellType: CurrencyTableViewCell.self)) {  row, symbol, cell in
            cell.configureCell(text: symbol)
        }.disposed(by: disposeBag)
        
    }
    
    private func subscribeOnButtons(){
        fromButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            if !self.isLoading {
                self.addFromTransparentView()
            }
        }).disposed(by: disposeBag)
        
        toButton.rx.tap.subscribe(onNext: {  [weak self] in
            guard let self = self else {return}
            if !self.isLoading {
                self.addToTransparentView()
            }
        }).disposed(by: disposeBag)
        
        exchangeButton.rx.tap.subscribe(onNext: {  [weak self] in
            guard let self = self else {return}
            
            if !(self.fromButton.titleLabel?.text == self.from || self.toButton.titleLabel?.text == self.to ||
                 self.fromButton.titleLabel?.text == self.to || self.toButton.titleLabel?.text == self.from ){
                
                let tempSymbol = self.convertFromSymbol
                self.convertFromSymbol = self.convertToSymbol
                self.convertToSymbol = tempSymbol
                self.fromButton.setTitle(self.convertFromSymbol, for: .normal)
                self.toButton.setTitle(self.convertToSymbol, for: .normal)
                
                let tempAmount = self.fromTextField.text
                self.fromTextField.text = self.toTextFiled.text
                self.toTextFiled.text = tempAmount
            }
            
            
        }).disposed(by: disposeBag)
        
        detailsButton.rx.tap.subscribe(onNext: {  [weak self] in
            
            guard let self = self else {return}
            
            if let fromAmount = Double(self.fromTextField.text!) {
                self.navDelegate?.navigateToNextScreen(self,data: [fromAmount: self.convertFromSymbol])
            }else{
                AlertViewManager.presentAlertView(from: self, message: "You must choose a currency with it's value")
            }
        }).disposed(by: disposeBag)
    }
    
    private func subscribeOnDidSelectTableViewCell(){
        fromTableView
            .rx
            .modelAndIndexSelected(String.self)
            .subscribe(onNext: { (symbol, indexPath) in
                print("Selected " + symbol + " at \(indexPath.row)")
                self.convertFromSymbol = symbol
                self.fromButton.setTitle(symbol, for: .normal)
                self.removeFromTableView()
                if let fromText = self.fromTextField.text , fromText.isEmpty{
                    self.fromTextField.text = "1"
                }
            }).disposed(by: disposeBag)
        toTableView
            .rx
            .modelAndIndexSelected(String.self)
            .subscribe(onNext: { (symbol, indexPath) in
                print("Selected " + symbol + " at \(indexPath.row)")
                self.convertToSymbol = symbol
                self.toButton.setTitle(symbol, for: .normal)
                self.removeToTableView()
            }).disposed(by: disposeBag)
    }
    
    private func subscribeOnConvertCurrency(){
        fromTextField.rx.controlEvent(.editingChanged).asObservable().map({self.fromTextField.text})
            .subscribe(onNext: {  fromCurrency in
                if !self.isLoading {
                    if let fromCurrency = fromCurrency , !self.convertFromSymbol.isEmpty,!self.convertToSymbol.isEmpty{
                        self.viewModel?.getConvertedAmount(to: self.convertToSymbol, from: self.convertFromSymbol, amount: fromCurrency)
                    }else{
                        AlertViewManager.presentAlertView(from: self, message: "You must fill all data")
                    }
                }
            }).disposed(by: disposeBag)
        
        //first way to bind data
        //        currencyViewModel.convertCurrencyObservable.bind { [weak self]    convertCurrencyModel in
        //            self?.toTextFiled.text = convertCurrencyModel.result == 0 ? "failed": "\(String(describing:     convertCurrencyModel.result))"
        //        }.disposed(by: disposeBag)
        
        let data = viewModel?.convertCurrencyObservable.asDriver(onErrorJustReturn: ConvertCurrencyResponse.errorModel)
        
        data?.map {$0.result == 0 ? "failed": "\(String(describing: $0.result))"}
            .drive(self.toTextFiled.rx.text)
            .disposed(by: disposeBag)
    }
}

