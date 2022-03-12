//
//  SignInViewModel.swift
//  BoxueDataKit
//
//  Created by ArcherLj on 2019/4/17.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift
import RxCocoa

public class SignInViewModel {
    
    /// - Properties
    let userSessionRepository: UserSessionRepository
    let browseResponder: BrowseResponder
    let navigateToRequestNotification: NavigateToRequestNotification
    
    
    public let signInButtonTapped = PublishSubject<Void>()
    public let emailInput = BehaviorSubject<String>(value: "")
    public let emailInputEnabled = BehaviorSubject<Bool>(value: true)
    public let passwordInput = BehaviorSubject<String>(value: "")
    public let passwordInputEnabled = BehaviorSubject<Bool>(value: true)
    public let signInButtonEnabled = BehaviorSubject<Bool>(value: true)
    public let signInActivityIndicatorAnimating = BehaviorSubject<Bool>(value: false)
    
    public let err = ErrorMessage(title: .signInErrorTitle, description: .signInErrorDesc)
    private let errorMessageSubject = PublishSubject<ErrorMessage>()
    public var errorMessage: Observable<ErrorMessage> {
        return errorMessageSubject.asObservable()
    }
    
    public let bag = DisposeBag()
    
    /// - Init Methods
    public init (userSessionRepository: UserSessionRepository,
                 browseResponder: BrowseResponder,
                 navigateToRequestNotification: NavigateToRequestNotification) {
        
        self.userSessionRepository = userSessionRepository
        self.browseResponder = browseResponder
        self.navigateToRequestNotification = navigateToRequestNotification
        
        // 这里我觉不太好, 直接 View Model 暴露一个接口, 比如 RequestSignIn 不比这种要好的太多了.
        // 更加的清晰, 这种方式, 外界绑定, 内部绑定, 然后触发了 SignIn. 但是逻辑一点不清晰.
        signInButtonTapped.asObservable().subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.signIn()
        }).disposed(by: bag)
    }
    
    
    // ViewModel 就是控制层. 各种 Publisher 其实是 ViewState. 所以在 model action 的时候, 进行状态变更, 更新 UI 也是 ViewModel 的逻辑.
    // 只不过, 原来的 Controller 的 UI 更新, 变为了 ViewModel 的状态更新, 而 ViewModel 的状态更新, 通过在 VC 的绑定机制, 触发了 View 的更新.
    public func indicateSigningIn() {
        emailInputEnabled.onNext(false)
        passwordInputEnabled.onNext(false)
        signInButtonEnabled.onNext(false)
        signInActivityIndicatorAnimating.onNext(true)
    }
    
    public func indicateSignInError(_ error: Error) {
        errorMessageSubject.onNext(err)
        emailInputEnabled.onNext(true)
        passwordInputEnabled.onNext(true)
        signInButtonEnabled.onNext(true)
        signInActivityIndicatorAnimating.onNext(false)
    }
    
    public func getEmailAndPassword() -> (String, Secret) {
        do {
            let email = try emailInput.value()
            let password = try passwordInput.value()
            return (email, password)
        } catch {
            fatalError("Failed to reading email and password from subject behavior.")
        }
    }
    
    func navigateToNotification() {
        self.navigateToRequestNotification.navigateToRequestNotification()
    }
    
    func navigateToBrowse() {
        self.browseResponder.browse()
    }
    
    @objc public func signIn() {
        indicateSigningIn()
        let (email, password) = getEmailAndPassword()
        
        // ViewModel, 就是 Controller 层的东西.
        // 但是网络请求还是要放到特定的地方, 所以 userSessionRepository 还是必要存在的.
        userSessionRepository.signIn(email: email, password: password)
            .then { _ in
                // func signIn(email: String, password: Secret) -> Promise<UserSession>
                // 上面是 SignIn 的返回值. 所以实际上, 这里面 then 没有使用 Promise 里面的 UserSession 数据, 做后续的处理.
                UNUserNotificationCenter.current().isNotificationPermissionNotDetermined()
            }.done {
                self.transmute(withPermissionNotDeterJmined: $0)
            }.catch(
                // 出错了, 统一在一个地方进行处理就可以了.
                self.indicateSignInError
            )
    }
    
    public func transmute(withPermissionNotDetermined: Bool) {
        withPermissionNotDetermined ? navigateToNotification() : navigateToBrowse()
    }
}

extension String {
    static let signInErrorTitle = localized(of: "SIGN_IN_ERROR_TITLE")
    static let signInErrorDesc = localized(of: "SIGN_IN_ERROR_DESC")
}
