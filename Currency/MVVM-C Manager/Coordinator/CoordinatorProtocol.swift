//
//  File.swift
//  Currency
//
//  Created by Mohamed Samir on 19/09/2022.
//

import Foundation

protocol Coordinator: AnyObject {
    
    var children  : [Coordinator] { get set }
    var router    : Router        { get}
    
    func present(animated: Bool, onDismissed: VoidReturn)
    func dismiss(animated: Bool)
    func presentChild(_ child: Coordinator, animated: Bool,onDismissed: VoidReturn)
}

extension Coordinator {
    
    private func removeChild(_ child: Coordinator){
        guard let index = children.firstIndex(where: { $0 === child}) else { return }
        children.remove(at: index)
    }
    
    public func dismiss(animated: Bool){
        router.dismiss(animated: true)
    }
    
    public func presentChild(_ child: Coordinator, animated: Bool,onDismissed: VoidReturn){
        children.append(child)
        child.present(animated: true, onDismissed: { [weak self, weak child] in
            guard let self = self , let child = child else { return }
            self.removeChild(child)
            onDismissed?()
        })
    }
}



