//
//  BoxueUserSessionRepository.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

/*
 之前, 对于只有一个实现类的接口嗤之以鼻, 现在算是明白了, 之所以自己不习惯这种写法, 是因为业务场景不够复杂, 没有遇到过这种需要替换实现的地方.
 如此看来, Mock 的存在, 使得在类的设计中, 进行抽象是很有必要的.
 */

// BoxueUserSessionRepository 根据里面的工具对象, 实现自己的接口实现.
/*
 这种一个 Manager 调用自己各个工具类, 来实现自己接口的方式非常实现.
 Manager 是一个对外公开的接口, 算作是门面模式. 真正的实现, 交给具体业务相关的工具类对象, 自己只是做一层转发工作.
 包装一层的意义在于, 使用者无需知道 Module 的实现细节, 使用门面类提供的简单的接口, 就能完成自己的实现. 
*/
public class BoxueUserSessionRepository: UserSessionRepository {
    
    let userSessionStore: UserSessionStore
    let authRemoteAPI: AuthRemoteAPI
    
    public init(userSessionStore: UserSessionStore, authRemoteAPI: AuthRemoteAPI) {
        self.userSessionStore = userSessionStore
        self.authRemoteAPI = authRemoteAPI
    }
    
    public func readUserSession() -> Promise<UserSession> {
        return userSessionStore.load()
    }
    
    public func signUp(newAccount: NewAccount) -> Promise<UserSession> {
        return authRemoteAPI.signUp(account: newAccount).then(userSessionStore.save(userSession:))
    }
    
    public func signIn(email: String, password: Secret) -> Promise<UserSession> {
        return authRemoteAPI.signIn(username: email, password: password).then(userSessionStore.save(userSession:))
    }
    
    public func signOut() -> Promise<Bool> {
        return userSessionStore.delete()
    }
    
    public func isSignedIn() -> Guarantee<Bool> {
        
        // Promise中除了catch用来处理错误外，还有一个wrapper: recover也可以用来处理错误，
        // recover用来出了错误后，需要我们接管这个错误并把它恢复成某种正常状态的情况。他返回的是Promise<T>类型，显然catch是做不到的
        
        // 下面这里，如果读取用户session失败的话，我们就在recover里面把它恢复成false,表示
        // 未登陆就行了（这里，我们并不想把这个错误扩散出去。）。
        return firstly {
            readUserSession()
        }
        .then { _ in Guarantee.value(true)}
        .recover{ _ in Guarantee.value(false)}
        
        // 另外，Pormise给所有的wrapper提供了一个on参数，允许我们定义他们的closure执行的队列,因为所有的.then, .done都是执行在
        // 主线程的，有时候我们需要执行在其他的线程来处理一些耗时操作
    }
}
