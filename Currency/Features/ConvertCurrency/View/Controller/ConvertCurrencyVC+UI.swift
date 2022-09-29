//
//  ConvertCurrencyVC+Ex.swift
//  Currency
//
//  Created by Mohamed Samir on 19/09/2022.
//

import UIKit

extension ConvertCurrencyVC {
    
    func updateUI(){
        registerTableViewsCell()
        createActivityIndicatory()
        window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
        self.toTextFiled.isUserInteractionEnabled = false
    }
    
    func registerTableViewsCell(){
        fromTableView.RegisterNib(Cell: CurrencyTableViewCell.self)
        toTableView.RegisterNib(Cell: CurrencyTableViewCell.self)
        
    }
    
    func createActivityIndicatory() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        
    }
    
    func addFromTransparentView(){
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
    }
    
    func addToTransparentView(){
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
    }
    
    @objc  func removeFromTableView(){
        let frames = fromButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0,  options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.0
            self.fromTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        },completion: nil)
    }
    
    @objc  func removeToTableView(){
        let frames = toButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0,  options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.0
            self.toTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        },completion: nil)
    }
    
}
