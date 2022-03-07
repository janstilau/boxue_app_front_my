//
//  BoxueAppDepedencyContainer.swift
//  Boxue_iOS
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import RxSwift
import BoxueDataKit

/*
 依赖注入, 要保证的是, 注入的是一个抽象类的实现类, 而在被注入的对象里面, 是根据这个抽象类的抽象接口在编码.
 只有这样, 这个注入才是有意义的, 才可以通过传递不同的对象, 来让被注入的类产生不同的行为.
 */
public class BoxueAppDepedencyContainer {
    
    let sharedMainViewModel: MainViewModel
    let sharedUserSessionRepository: BoxueUserSessionRepository
    
    public init() {
        func makeUserSessionStore() -> UserSessionStore {
            return FakeUserSessionStore(hasToken: false)
        }
        
        func makeAuthRemoteAPI() -> AuthRemoteAPI {
            return FakeAuthRemoteAPI()
        }
        
        /*
         BoxueUserSessionRepository
         1. 需要进行当前用户本地存储的工具对象.
         1. 需要进行用户登录登出的网络工具对象.
         
         这两个对象, 又都是使用的抽象接口进行具体功能的调用.
         所以, 在初始化的时候, 使用依赖注入, 在创建的代码位置, 可以进行配置工作.
         
         在开发过程中, 可以使用 Mock 技术, 将返回 Mock 的数据, 加快研发的进度.
         所以,  UserSessionStore, AuthRemoteAPI 这层抽象结构就派上了用场. 使用 mock 类, 实现这层接口, 传递给 BoxueUserSessionRepository 中去.
         BoxueUserSessionRepository 的代码不需要修改, 但是因为传入的两个抽象对象的实现发生了改变, 里面的行为逻辑, 也发生了改变.
         */
        func makeUserSessionRepository() -> BoxueUserSessionRepository {
            return BoxueUserSessionRepository(userSessionStore: makeUserSessionStore(),
                                              authRemoteAPI: makeAuthRemoteAPI())
        }
        
        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }
        
        self.sharedMainViewModel = makeMainViewModel()
        self.sharedUserSessionRepository = makeUserSessionRepository()
    }
    
    public func makeMainViewController() -> MainViewController {
        let launchViewController = {
            return self.makeLaunchViewController()
        }()
        let guideViewControllerFactory = {
            return self.makeGuideViewController()
        }
        let browseViewControllerFactory = {
            return self.makeBrowseViewController()
        }
        
        return MainViewController(viewModel: sharedMainViewModel,
                                  launchViewController: launchViewController,
                                  guideViewControllerFactory: guideViewControllerFactory,
                                  browseViewControllerFactory: browseViewControllerFactory)
    }
    
    public func makeLaunchViewController() -> LaunchViewController {
        return LaunchViewController(launchViewModelFactory: self)
    }
    
    public func makeGuideViewController() -> GuideViewController {
        let di = BoxueGuideDependencyContainer(appDependencyContainer: self)
        return di.makeGuideViewController()
    }
    
    /// - Sign In
    public func makeSigndeInDenpendencyContainer() -> BoxueSignedInDependencyContainer {
        return BoxueSignedInDependencyContainer(appDependencyContainer: self)
    }
    
    public func makeBrowseViewController() -> BrowseViewController {
        return makeSigndeInDenpendencyContainer().makeBrowseViewController()
    }
}

extension BoxueAppDepedencyContainer: LaunchViewModelFactory {
    public func makeLaunchViewModel() -> LaunchViewModel {
        // LaunchViewController 中, 获取 ViewModel 的部分, 真正的实现在这里. 
        return LaunchViewModel(userSessionRepository: self.sharedUserSessionRepository,
                               guideResponder: self.sharedMainViewModel,
                               browserResponder: self.sharedMainViewModel)
    }
}
