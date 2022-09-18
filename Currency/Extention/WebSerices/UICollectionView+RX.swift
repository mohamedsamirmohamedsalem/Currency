//
//  UIs+Reactive.swift
//  Currency
//
//  Created by Mohamed Samir on 19/07/2022.

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
