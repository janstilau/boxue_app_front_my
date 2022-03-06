//
//  String_Localized.swift
//  BoxueDataKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

/*
 // Welcome screen
 APP_TITLE="App工匠的4K视频";
 APP_SLOGAN="左手程序，右手诗";
 RIGHTS_INFO="Copyright © 2015-2018 Boxue. All rights reserved.";
 SIGNIN="登录泊学";
 BROWSE_NOW="随便看看";

 // SignIn screen
 WELCOME_LABEL="欢迎回来！";
 EMAIL="电子邮件";
 PASSWORD="登录密码";
 CONTACT_US="联系我们";
 RESET_PASSWORD="重置密码";
 SIGN_IN_ERROR_TITLE="登录失败";
 SIGN_IN_ERROR_DESC="啊喔！使用的登录信息错误，请重试。";

 // Request notification screen
 REQ_NOTI_TITLE="要泊学推送通知嘛?";
 REQ_NOTI_DESC="我们会在内容更新的时候告诉你";
 REQ_NOTI_CONFIRM="好吧";
 REQ_NOTI_NOTNOW="暂时不用";
 */
extension String {
    /*
     从 Bundle 里面, 去查询 tableName 指定的资源, 用 key 去查找里面的 value 值. 
     */
    public static func localized(of key: String, comment: String = "") -> String {
        return NSLocalizedString(key,
                                 tableName: "Localizable",
                                 bundle: Bundle.main,
                                 comment: comment)
    }
}
