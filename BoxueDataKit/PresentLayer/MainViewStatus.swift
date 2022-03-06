//
//  MainViewStatus.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/15.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

public enum MainViewStatus {
    case launching
    case guiding
    case browsing
}

// 这个为什么要专门实现一下. 
extension MainViewStatus: Equatable {
    public static func == (lhs: MainViewStatus, rhs: MainViewStatus) -> Bool {
        switch (lhs, rhs) {
        case (.launching, .launching):
            return true
        case (.guiding, .guiding):
            return true
        case (.browsing, .browsing):
            return true
        default:
            return false
        }
    }
}
