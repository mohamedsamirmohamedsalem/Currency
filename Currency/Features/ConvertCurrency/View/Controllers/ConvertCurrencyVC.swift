//
//  ConvertCurrencyViewController.swift
//  Currency
//
//  Created by Mohamed Samir on 06/07/2022.
//

import UIKit
import RxSwift
import RxCocoa


protocol ConvertCurrencyVCDelegate: AnyObject {
    func navigateToNextScreen(_ viewController: ConvertCurrencyVC)
}


class ConvertCurrencyVC: UIViewController {
    
    //MARK:- Instances
    var navDelegate: ConvertCurrencyVCDelegate?
    var window: UIWindow?
    var activityView =  UIActivityIndicatorView ()
    let transparentView = UIView()
    let fromTableView = UITableView()
    let toTableView = UITableView()
    var symbolsList = [String]()
    let disposeBag = DisposeBag()
    var currencyVM: ConvertCurrencyVM?
    var convertFromSymbol: String = ""
    var convertToSymbol: String = ""

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- IBOutlets
    
    @IBOutlet weak var fromButton : UIButton!
    @IBOutlet weak var toButton : UIButton!
    @IBOutlet weak var exchangeButton : UIButton!
    @IBOutlet weak var detailsButton: UIBarButtonItem!
    @IBOutlet weak var fromTextField : UITextField!
    @IBOutlet weak var toTextFiled : UITextField!
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- App Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        subscribeOnLoading()
        subscribeOnSymbols()
        subscribeOnButtons()
        subscribeOnDidSelectTableViewCell()
        subscribeOnConvertCurrency()
        
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- Methods
    
   
    
    private func  subscribeOnLoading(){
        currencyVM?.loadingObservable.subscribe(onNext: { [weak self] isLoading in
            if(isLoading){
                self?.activityView.startAnimating()
            }else{
                self?.activityView.stopAnimating()
            }
        }).disposed(by: disposeBag)
    }
    
    private func subscribeOnSymbols(){
        
        currencyVM?.gettingSymbolsFromApi()
        
        currencyVM?.symbolsObservable.bind(to: fromTableView.rx.items(cellIdentifier: "CurrencyTableViewCell", cellType: CurrencyTableViewCell.self)) {  row , symbols , cell in
            cell.configureCell(text: symbols)
        }.disposed(by: disposeBag)
        
        currencyVM?.symbolsObservable.bind(to: toTableView.rx.items(cellIdentifier: "CurrencyTableViewCell", cellType: CurrencyTableViewCell.self)) {  row , symbols , cell in
            cell.configureCell(text: symbols)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeOnButtons(){
        fromButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            self.addFromTransparentView()
        }).disposed(by: disposeBag)
        
        toButton.rx.tap.subscribe(onNext: {  [weak self] in
            guard let self = self else {return}
            self.addToTransparentView()
        }).disposed(by: disposeBag)
        
        exchangeButton.rx.tap.subscribe(onNext: {  [weak self] in
            guard let self = self else {return}

            if !(self.fromButton.titleLabel?.text == "From" || self.toButton.titleLabel?.text == "To" ||
               self.fromButton.titleLabel?.text == "To"   || self.toButton.titleLabel?.text == "From" ){
            
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
            self.navDelegate?.navigateToNextScreen(self)
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
                if let fromCurrency = fromCurrency , !self.convertFromSymbol.isEmpty,!self.convertToSymbol.isEmpty{
                    self.currencyVM?.getConvertedAmount(to: self.convertToSymbol, from: self.convertFromSymbol, amount: fromCurrency)
                }else{
                    self.presentAlertView()
                }
            }).disposed(by: disposeBag)
        
        //first way to bind data
//        currencyViewModel.convertCurrencyObservable.bind { [weak self]    convertCurrencyModel in
//            self?.toTextFiled.text = convertCurrencyModel.result == 0 ? "failed": "\(String(describing: convertCurrencyModel.result))"
//        }.disposed(by: disposeBag)
        
        let data = currencyVM?.convertCurrencyObservable.asDriver(onErrorJustReturn: ConvertCurrencyResponse.errorModel)
    
        data?.map {$0.result == 0 ? "failed": "\(String(describing: $0.result))"}
        .drive(self.toTextFiled.rx.text)
        .disposed(by: disposeBag)
    }
    
    private func presentAlertView(){
        let alert = UIAlertController(title: "Alert", message: "You must fill all data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style:.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

