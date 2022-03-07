//
//  FakeUserSessionStore.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

public class FakeUserSessionStore: UserSessionStore {
    
    let hasToken: Bool
    
    public init(hasToken: Bool) {
        self.hasToken = hasToken
    }
    
    public func save(userSession: UserSession) -> Promise<UserSession> {
        return Promise.value(userSession)
    }
    
    public func load() -> Promise<UserSession> {
        return hasToken ? withToken() : withoutToken()
    }
    
    public func delete() -> Promise<Bool> {
        return Promise.value(true)
    }
    
    public func withToken() -> Promise<UserSession> {
        let profile = UserProfile(name:Fake.name, email: Fake.email, mobile: Fake.mobile, avatar: Fake.avatar)
        let remoteSession = RemoteUserSession(token: Fake.token)
        
        return Promise.value(UserSession(profile: profile, remoteUserSession: remoteSession))
    }
    
    // WithoutToken 是报错了.
    // 用这种方式, 实现了类似于 Result 的效果. 能返回正常值, 就可以读取关联类型的数据.
    // 报错了, 就是出错了, 交给 Promise 的下游节点进行处理. 
    public func withoutToken() -> Promise<UserSession> {
        return Promise.init(error: DataKitError.any)
    }
}
