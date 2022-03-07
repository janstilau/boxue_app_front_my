//
//  AuthRemoteAPI.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

public protocol AuthRemoteAPI {
    
    // 登录注册, 这使用一个网络接口调用, 是一个异步操作, 最终, 返回一个 Promise 对象.
    // 调用者根据这个 Promise 对象, 来进行后续的业务逻辑的添加. 
    func signIn(username: String, password: Secret) -> Promise<UserSession>
    func signUp(account: NewAccount) -> Promise<UserSession>
}
