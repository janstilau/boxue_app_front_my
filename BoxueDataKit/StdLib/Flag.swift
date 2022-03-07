//
//  Flag.swift
//  BoxueDataKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import UserNotifications

final public class Flag {
    
    // 这种 typealias 应该多多使用, 能够带来代码的可读性增加.
    public typealias Getter = () -> Bool
    public typealias Setter = (Bool) -> Void
    
    /// - Attributes
    var wasSet: Bool
    public var wasNotSet: Bool {
        return !wasSet
    }
    
    /// - Initializers
    public init(getter: Getter, setter: Setter) {
        self.wasSet = getter()
        
        if !wasSet {
            setter(true)
        }
    }
    
    convenience init(userDefaults: UserDefaults = UserDefaults.standard,
                     for key: String) {
        self.init {
            userDefaults.bool(forKey: key)
        } setter: { value in
            userDefaults.set(value, forKey: key)
        }
    }
}

extension Flag {
    /*
     这种条件编译, 和 C 风格没有任何区别. 只是这种宏定义, 必须在 Xcode 的 Setting 里面添加.
     之前的宏定义, 确实是有问题, 可以在任意地方进行定义, 还会出现定义覆盖的情况, 现在统一定义, 起码能够保证顺序.
     */
#if TEST
    public static let isFirstLaunch = true
#else
    public static let isFirstLaunch = Flag(for: "io.boxue.Launch.wasLaunchedBefore").wasNotSet
#endif
    
#if TEST
    public static let isiOS12OrLater = false
#else
    public static var isiOS12OrLater: Bool {
        if #available(iOS 12.0, *) {
            return true
        }
        return false
    }
#endif
}
