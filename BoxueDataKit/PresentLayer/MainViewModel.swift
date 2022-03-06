//
//  MainViewModel.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/15.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import RxSwift

public class MainViewModel: GuideResponder, BrowseResponder {
    /// - Properties
    
    // BehaviorSubject 的含义, 就是要有初值, 这样第一次注册的时候, Observer 可以获取到这个值. 
    public let viewSubject = BehaviorSubject<MainViewStatus>(value: .launching)
    public var viewStatus: Observable<MainViewStatus> {
        return viewSubject.asObservable()
    }
    
    /// - Methods
    public init() {}
    
    // ModelAction. 调用 ViewModel 的方法, 改变了 Model 的数据, 并且触发信号的发出.
    public func guide() {
        viewSubject.onNext(.guiding)
    }
    
    // ModelAction. 调用 ViewModel 的方法, 改变了 Model 的数据, 并且触发信号的发出.
    public func browse() {
        viewSubject.onNext(.browsing)
    }
}
