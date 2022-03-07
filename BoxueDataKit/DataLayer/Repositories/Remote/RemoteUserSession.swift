//
//  RemoteUserSession.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

// 一个纯数据类, 存储用户网络 URL 的 Token 值. 
public struct RemoteUserSession: Codable {
    
    let token: String
    
    public init(token: String) {
        self.token = token
    }
}

extension RemoteUserSession: Equatable {
    public static func ==(lhs: RemoteUserSession, rhs: RemoteUserSession) -> Bool {
        return lhs.token == rhs.token
    }
}
