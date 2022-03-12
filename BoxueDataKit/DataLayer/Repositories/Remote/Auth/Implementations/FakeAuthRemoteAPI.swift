//
//  FakeAuthRemoteAPI.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

// 将, 所有的 Fake 数据, 集中在一点进行定义. 
struct Fake {
    static let email = "lj0011977@163.com"
    static let password = "123456"
    static let name = "archer"
    static let mobile = "18012690219"
    static let avatar = makeURL()
    static let token = "testToken"
}

/*
 在开发的过程中, 专门定义一个 Mock 类, 可以大大的简化开发的工作量.
 这个类, 将网络请求这一层需要依赖外部实现不稳定因素干掉, 在里面返回固定的 Fake 数据.
 在开发的时候, 使用固定的 Fake 数据, 可以保证代码的流程不会因为外部原因中断. 
*/

public struct FakeAuthRemoteAPI: AuthRemoteAPI {
    
    public func signIn(username: String, password: Secret) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            // Fake 的账号, 一定要是 Fake 的用户名密码.
            guard username == Fake.email && password == Fake.password else {
                return seal.reject(DataKitError.any)
            }
            
            let profile = UserProfile(name: Fake.name, email: Fake.email, mobile: Fake.mobile, avatar: Fake.avatar)
            let remoteSession = RemoteUserSession(token: Fake.token)
            let userSession = UserSession(profile: profile, remoteUserSession: remoteSession)
            
            // 得到了期望的值，就调用seal.fulfill，对应的then或者done就会执行
            seal.fulfill(userSession)
        }
    }
    
    public func signUp(account: NewAccount) -> Promise<UserSession> {
        let profile = UserProfile(name: account.name, email: account.email, mobile: account.mobile, avatar: makeURL())
        
        let remoteSession = RemoteUserSession(token: Fake.token)
        let userSession = UserSession(profile: profile, remoteUserSession: remoteSession)
        
        return Promise.value(userSession)
    }
    
    public init() {}
    
    
}
