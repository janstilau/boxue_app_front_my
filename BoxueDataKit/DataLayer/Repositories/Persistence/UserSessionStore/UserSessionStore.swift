//
//  UserSessionStore.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/16.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import PromiseKit

/*
 引入了 Promise, 所有的操作, 都是一个异步操作.
 */
public protocol UserSessionStore {
    func save(userSession: UserSession) -> Promise<UserSession>
    func load() -> Promise<UserSession>
    func delete() -> Promise<Bool>
}
