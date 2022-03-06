//
//  UIViewController_Ext.swift
//  BoxueUIKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import BoxueDataKit

extension UIViewController {
    
    public func addFullScreen(childViewController child: UIViewController) {
        guard child.parent == nil else {
            return
        }
        
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: child.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
            ].compactMap {$0})
        
        /*
         Your view controller can override this method when it wants to react to being added to a container.
         If you are implementing your own container view controller, it must call the didMove(toParent:) method of the child view controller after the transition to the new controller is complete or, if there is no transition, immediately after calling the addChild(_:) method.
         The removeFromParent() method automatically calls the didMove(toParent:) method of the child view controller after it removes the child.
         */
        // 这主要是给 VC 一个触发点, 如果需要在里面写某些逻辑.
        child.didMove(toParent: self)
    }
    
    public func remove(childViewController child: UIViewController) {
        guard child.parent != nil else { return }
        
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

extension UIViewController {
    public func present(errorMessage: ErrorMessage) {
        let alertController = UIAlertController(title: errorMessage.title,
                                                message: errorMessage.description,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func presentSettingAlert(title: String,
                                    message: String,
                                    confirmButtonText: String,
                                    cancelButtonText: String,
                                    cancelHandler:((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: confirmButtonText, style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        let cancelAction = UIAlertAction(title: cancelButtonText, style: .default, handler: cancelHandler)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
