//
//  V2ProgressHUD.swift
//  V2ex-Swift
//
//  Created by skyline on 16/3/29.
//  Copyright © 2016年 Fin. All rights reserved.
//

import UIKit
import SVProgressHUD

open class U17ProgressHUD: NSObject {
    open class func show() {
        SVProgressHUD.show()
		SVProgressHUD.setDefaultMaskType(.none)
    }

    open class func showWithClearMask() {
        SVProgressHUD.show()
		SVProgressHUD.setDefaultMaskType(.clear)
    }

    open class func dismiss() {
        SVProgressHUD.dismiss()
    }

    open class func showWithStatus(_ status:String!) {
        SVProgressHUD.show(withStatus: status)
    }

    open class func success(_ status:String!) {
        SVProgressHUD.showSuccess(withStatus: status)
    }

    open class func error(_ status:String!) {
        SVProgressHUD.showError(withStatus: status)
    }

    open class func inform(_ status:String!) {
        SVProgressHUD.showInfo(withStatus: status)
    }
}

public func U17Success(_ status:String!) {
    U17ProgressHUD.success(status)
}

public func U17Error(_ status:String!) {
    U17ProgressHUD.error(status)
}

public func U17Inform(_ status:String!) {
    U17ProgressHUD.inform(status)
}

public func U17BeginLoading() {
    U17ProgressHUD.show()
}

public func U17BeginLoadingWithStatus(_ status:String!) {
    U17ProgressHUD.showWithStatus(status)
}

public func U17EndLoading() {
    U17ProgressHUD.dismiss()
}
