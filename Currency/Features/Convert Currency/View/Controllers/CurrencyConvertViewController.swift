//
//  ConvertCurrencyViewController.swift
//  Currency
//
//  Created by Mohamed Samir on 06/07/2022.
//

import UIKit

class CurrencyConvertViewController: UIViewController {

    
    //MARK:- Instances
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- IBOutlets
    
    @IBOutlet weak var fromButton : UIButton!
    @IBOutlet weak var toButton : UIButton!
    @IBOutlet weak var fromTextField : UITextField!
    @IBOutlet weak var toTextFiled : UITextField!
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- App Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerNibFiles()
      
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- IBActions
    
    @IBAction func onClickFromButton(_ sender: Any) {
        dataSource = ["A","B","C","D","E","F","G","A","B","C","D","E","F","G","A","B","C","D"]
        selectedButton = fromButton
        addTransparentView()
    }
    
    @IBAction func onClickToButton(_ sender: Any){
        dataSource = ["A","B","C","D","E","F","G","A","B","C","D","E","F","G",].reversed()
        selectedButton = toButton
        addTransparentView()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- Methods
    
    //This Funvtion to register cell in tableview
    private func registerNibFiles(){
        tableView.RegisterNib(Cell: CuurencyTableViewCell.self)
    }
    
    private func addTransparentView(){
        let frames = selectedButton.frame
        let window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
        transparentView.frame = window?.frame ?? self.view.frame
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(transparentView)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTranparentView))
        transparentView.addGestureRecognizer(tapGesture)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
        tableView.reloadData()
    }
    
    @objc private func removeTranparentView(){
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0,  options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        },completion: nil)
    }
}
