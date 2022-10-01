//
//  ViewController.swift
//  BestWayForCollectionViewInsideTableView
//
//  Created by Mohamed Samir on 29/09/2022.

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        ControlEvent(events: Observable.zip(
            self.modelSelected(modelType),
            self.itemSelected
        ))
    }
}

extension UITableView{
     //Simple way to Register table view using nib file
    func RegisterNib<Cell : UITableViewCell>(Cell : Cell.Type){
    
        let nibName = String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
     //Simple way to deque cell using class name automatically
    func dequeue<Cell : UITableViewCell>(IndexPath : IndexPath) -> Cell{
        
        let identifier = String(describing: Cell.self)
        //let CellForIndex = Cell as UITableViewCell
        guard let Cell = self.dequeueReusableCell(withIdentifier: identifier, for: IndexPath ) as? Cell  else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        return Cell
    }
}

