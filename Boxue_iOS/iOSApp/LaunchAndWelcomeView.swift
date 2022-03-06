//
//  LaunchAndWelcomeView.swift
//  Boxue_iOS
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation
import BoxueUIKit

public class LaunchAndWelcomeView: NiblessView {
    /// - Constants
    static let APP_TITLE_WIDTH: CGFloat = 300.0
    static let APP_TITLE_HEIGHT: CGFloat = 90.0
    
    /// - Properties
    var viewNotReady = true
    
    let bgImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LaunchScreen_iPhoneX_dark"))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.background
        return imageView
    }()
    
    let appTitleView: UIView = {
        let frame = CGRect(x: 0, y: 0,
                           width: LaunchAndWelcomeView.APP_TITLE_WIDTH,
                           height: LaunchAndWelcomeView.APP_TITLE_HEIGHT)
        let view = UIView(frame: frame)
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        // 是一个从左上角, 到右下角, 逐步渐变颜色的效果
        gradient.colors = [
            Color.appTitleGradientBegin.cgColor,
            Color.appTitleGradientMid.cgColor,
            Color.appTitleGradientEnd.cgColor
        ]
        view.layer.addSublayer(gradient)
        
        let label = UILabel(frame: view.bounds)
        label.text = .appTitle
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        
        view.addSubview(label)
        // The view’s alpha channel determines how much of the view’s content and background shows through. Fully or partially opaque pixels allow the underlying content to show through but fully transparent pixels block that content.
        /*
         Label 的 alpha 通道, 来控制是否显示内容.
         Label 是黑色的, 非文字的地方透明色, 最终显示效果就是, 渐变色的文字.
         其实是, 文字所在的区域的渐变才能显示, 其他的地方渐变都变透明了. 最终, 显示出渐变颜色的效果. 
         */
        view.mask = label
        
        return view
    }()
    
    let appSlogan: UILabel = {
        let label = UILabel()
        label.text = .appSlogan
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        
        return label
    }()
    
    let rightsInfo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = .rightsInfo
        label.textAlignment = .center
        label.textColor = Color.lightGray3
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    /*
     - (void)willMoveToSuperview:(nullable UIView *)newSuperview;
     - (void)didMoveToSuperview;
     - (void)willMoveToWindow:(nullable UIWindow *)newWindow;
     - (void)didMoveToWindow;
     通过这些方法, 可以让 SubView 的构建延后. 但是代价是, 必须要有一个成员变量来记录是否已经进行过初始化了.
     */
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        guard viewNotReady else {
            return
        }
        
        constructViewHierarchy()
        activateConstraints()
        
        viewNotReady = false
    }
    
    /// - Internal methods
    func constructViewHierarchy() {
        addSubview(bgImage)
        addSubview(appTitleView)
        addSubview(appSlogan)
        addSubview(rightsInfo)
    }
    
    func activateConstraints() {
        activateConstraintsBGImage()
        activateConstraintsAppTitle()
        activateConstraintsAppSlogan()
        activateConstraintsRightsInfo()
    }
    
    func activateConstraintsBGImage() {
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        
        let top = bgImage.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = bgImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leading = bgImage.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = bgImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }
    
    func activateConstraintsAppTitle() {
        appTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        let hCenter = appTitleView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let top = appTitleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140)
        let width = appTitleView.widthAnchor.constraint(equalToConstant: LaunchAndWelcomeView.APP_TITLE_WIDTH)
        let height = appTitleView.heightAnchor.constraint(equalToConstant: LaunchAndWelcomeView.APP_TITLE_HEIGHT)
        
        NSLayoutConstraint.activate([hCenter, top, width, height])
    }
    
    func activateConstraintsAppSlogan() {
        appSlogan.translatesAutoresizingMaskIntoConstraints = false
        
        let hCenter = appSlogan.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let width = appSlogan.widthAnchor.constraint(equalToConstant: LaunchAndWelcomeView.APP_TITLE_WIDTH)
        let top = appSlogan.topAnchor.constraint(equalTo: self.appTitleView.bottomAnchor, constant: 40)
        
        NSLayoutConstraint.activate([hCenter, width, top])
    }
    
    func activateConstraintsRightsInfo() {
        rightsInfo.translatesAutoresizingMaskIntoConstraints = false
        
        let hCenter = rightsInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let width = rightsInfo.widthAnchor.constraint(equalToConstant: LaunchAndWelcomeView.APP_TITLE_WIDTH)
        let bottom = rightsInfo.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        
        NSLayoutConstraint.activate([hCenter, width, bottom])
    }
}


extension String {
    static let appTitle = localized(of: "APP_TITLE")
    static let appSlogan = localized(of: "APP_SLOGAN")
    static let rightsInfo = localized(of: "RIGHTS_INFO")
}
