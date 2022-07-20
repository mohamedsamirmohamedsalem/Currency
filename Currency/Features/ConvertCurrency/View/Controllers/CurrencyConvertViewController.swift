//
//  ConvertCurrencyViewController.swift
//  Currency
//
//  Created by Mohamed Samir on 06/07/2022.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyConvertViewController: UIViewController {
    
    
    //MARK:- Instances
    var window: UIWindow?
    var activityView =  UIActivityIndicatorView ()
    let transparentView = UIView()
    let fromTableView = UITableView()
    let toTableView = UITableView()
    var selectedButton = UIButton()
    var symbolsList = [String]()
    let disposeBag = DisposeBag()
    let currencyViewModel = CurrencyViewModel()
    var convertFromSymbol: String = ""
    var convertToSymbol: String = ""
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- IBOutlets
    
    @IBOutlet weak var fromButton : UIButton!
    @IBOutlet weak var toButton : UIButton!
    @IBOutlet weak var exchangeButton : UIButton!
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
    
    private func updateUI(){
        registerTableViewsCell()
        showActivityIndicatory()
        window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
    }
    
    private func registerTableViewsCell(){
        fromTableView.RegisterNib(Cell: CurrencyTableViewCell.self)
        toTableView.RegisterNib(Cell: CurrencyTableViewCell.self)
        
    }
    
    private func showActivityIndicatory() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        
    }
    
    private func addFromTransparentView(){
        let frames = fromButton.frame
        transparentView.frame = window?.frame ?? self.view.frame
        fromTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(transparentView)
        self.view.addSubview(fromTableView)
        fromTableView.layer.cornerRadius = 5
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeFromTableView))
        transparentView.addGestureRecognizer(tapGesture)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.fromTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: self.view.frame.height * 0.6)
        }, completion: nil)
        fromTableView.reloadData()
    }
    
    private func addToTransparentView(){
        let frames = toButton.frame
        let window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
        transparentView.frame = window?.frame ?? self.view.frame
        toTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(transparentView)
        self.view.addSubview(toTableView)
        toTableView.layer.cornerRadius = 5
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeToTableView))
        transparentView.addGestureRecognizer(tapGesture)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.toTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: self.view.frame.height * 0.6)
        }, completion: nil)
        toTableView.reloadData()
    }
    
    @objc private func removeFromTableView(){
        let frames = fromButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0,  options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.0
            self.fromTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        },completion: nil)
    }
    
    @objc private func removeToTableView(){
        let frames = toButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0,  options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.0
            self.toTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        },completion: nil)
    }
    
    private func  subscribeOnLoading(){
        currencyViewModel.loadingObservable.subscribe(onNext: { [weak self] isLoading in
            if(isLoading){
                self?.activityView.startAnimating()
            }else{
                self?.activityView.stopAnimating()
            }
        }).disposed(by: disposeBag)
    }
    
    private func subscribeOnSymbols(){
        
        currencyViewModel.gettingSymbolsFromApi()
        
        currencyViewModel.symbolsObservable.bind(to: fromTableView.rx.items(cellIdentifier: "CurrencyTableViewCell", cellType: CurrencyTableViewCell.self)) {  row , symbols , cell in
            cell.configureCell(text: symbols)
        }.disposed(by: disposeBag)
        
        currencyViewModel.symbolsObservable.bind(to: toTableView.rx.items(cellIdentifier: "CurrencyTableViewCell", cellType: CurrencyTableViewCell.self)) {  row , symbols , cell in
            cell.configureCell(text: symbols)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeOnButtons(){
        fromButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            self.selectedButton = self.fromButton
            self.addFromTransparentView()
        }).disposed(by: disposeBag)
        
        toButton.rx.tap.subscribe(onNext: {
            self.selectedButton = self.toButton
            self.addToTransparentView()
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
        fromTextField.rx.controlEvent([.editingChanged]).asObservable()
            .subscribe( onNext: { [weak self] in
                guard let self = self else {return}
                self.currencyViewModel.getConvertedAmount(to: self.convertToSymbol, from: self.convertFromSymbol, amount: self.fromTextField.text ?? "0")
            }).disposed(by: disposeBag)
        
        
        currencyViewModel.convertCurrencyObservable.bind { [weak self] convertCurrencyModel in
            self?.toTextFiled.text = convertCurrencyModel.result == 0 ? "failed": "\(String(describing: convertCurrencyModel.result))"
        }.disposed(by: disposeBag)
    }
}
