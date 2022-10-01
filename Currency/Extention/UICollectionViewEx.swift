
//
//  UICollectionView+Generics.swift
//
//  Created by Mohamed Samir on 29/09/2022.

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        ControlEvent(events: Observable.zip(
            self.modelSelected(modelType),
            self.itemSelected
        ))
    }
}

extension UICollectionView{
     //Simple way to Register Collection view using nib file
    func RegisterNib<Cell : UICollectionViewCell>(Cell : Cell.Type){
        
        let nibName = String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }

     //Simple way to deque cell using class name automatically
    func dequeue<Cell : UICollectionViewCell>(IndexPath : IndexPath) -> Cell{
        
        let identifier = String(describing: Cell.self)
        //let CellForIndex = Cell as UITableViewCell
        guard let Cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath ) as? Cell  else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        return Cell
    }
}
