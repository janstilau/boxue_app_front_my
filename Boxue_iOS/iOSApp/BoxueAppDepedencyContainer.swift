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
        
        func makeUserSessionRepository() -> BoxueUserSessionRepository {
            return BoxueUserSessionRepository(userSessionStore: makeUserSessionStore(), authRemoteAPI: makeAuthRemoteAPI())
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
