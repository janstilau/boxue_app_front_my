//
//  LaunchViewController.swift
//  Boxue_iOS
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import RxSwift
import BoxueDataKit
import BoxueUIKit

// VC 没有直接和把 View 的构建细节, 写到自身的内部. View 如何构建, 交由 View 内部自己进行管理. 
public class LaunchViewController: NiblessViewController {

    let viewModel: LaunchViewModel
    let bag: DisposeBag = DisposeBag()
    
    // 传入的不是一个 ViewModel, 而是一个 ViewModel 的工厂类.
    init(launchViewModelFactory: LaunchViewModelFactory) {
        self.viewModel = launchViewModelFactory.makeLaunchViewModel()
        super.init()
    }
    
    override public func loadView() {
        self.view = LaunchRootView(viewModel: viewModel)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        viewModel.gotoNextScreen()
    }
}

protocol LaunchViewModelFactory {
    func makeLaunchViewModel() -> LaunchViewModel
}
