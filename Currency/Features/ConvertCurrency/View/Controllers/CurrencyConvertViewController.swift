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
        
        
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- Methods
    
    private func updateUI(){
        showActivityIndicatory()
        fromTableView.delegate = self
        fromTableView.dataSource = self
        toTableView.delegate = self
        toTableView.dataSource = self
        window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
        registerNibFiles()
        
    }
    //This Funvtion to register cell in tableview
    private func registerNibFiles(){
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeFromTranparentView))
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeToTranparentView))
        transparentView.addGestureRecognizer(tapGesture)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.toTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: self.view.frame.height * 0.6)
        }, completion: nil)
        toTableView.reloadData()
    }
    
    @objc private func removeFromTranparentView(){
        let frames = fromButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0,  options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.0
            self.fromTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        },completion: nil)
    }
    
    @objc private func removeToTranparentView(){
        let frames = toButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0,  options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.0
            self.toTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        },completion: nil)
    }
    
    private func  subscribeOnLoading(){
        currencyViewModel.loadingBehavior.subscribe(onNext: { [weak self] isLoading in
            if(isLoading){
                self?.activityView.startAnimating()
            }else{
                self?.activityView.stopAnimating()
            }
        }).disposed(by: disposeBag)
    }
    
    private func subscribeOnSymbols(){
        
        self.currencyViewModel.gettingSymbolsFromApi()
        currencyViewModel.symbolsObservable.subscribe(onNext:  { [weak self]  symbolsList in
            self?.symbolsList = symbolsList
            self?.fromTableView.reloadData()
        }).disposed(by: disposeBag)
        
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
    
}
