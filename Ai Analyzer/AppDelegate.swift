//
//  AppDelegate.swift
//  Ai Analyzer
//
//  Created by Saif Mukadam on 12/05/24.
//

import UIKit
import IQKeyboardManagerSwift
import RevenueCat
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        IQKeyboardManager.shared.enable = true
        application.isStatusBarHidden = true
        FirebaseApp.configure()
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_nPYYnDYhenOWqqkQGEoaininKOM")
        isPurchasesed()
        Manager.isnumberofTimesAppOpenKey = Manager.isnumberofTimesAppOpenKey + 1
        
        return true
    }
    
    func isPurchasesed() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if !(customerInfo?.entitlements.active.isEmpty ?? false) {
                Manager.isPro = true
            }else{
                Manager.isPro = false
            }
        }
    }
    
}

extension UIView {
    // Adds a corner radius attribute to all UIViews
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


