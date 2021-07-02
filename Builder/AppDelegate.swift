//
//  AppDelegate.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override init() {
        super.init()
//        swizzleFonts()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func swizzleFonts() {
//        UIFont.swizzleClassSelector(#selector(UIFont.init(name:size:)), with: #selector(UIFont.swizzleInitFont(name:size:)))
        UIFont.swizzleClassSelector(#selector(UIFont.preferredFont(forTextStyle:)), with: #selector(UIFont.swizzlePreferredFont(forTextStyle:)))
//        UIFont.swizzleClassSelector(#selector(UIFont.preferredFont(forTextStyle:compatibleWith:)), with: #selector(UIFont.swizzlePreferredFont(forTextStyle:compatibleWith:)))
        UIFont.swizzleClassSelector(#selector(UIFont.systemFont(ofSize:)), with: #selector(UIFont.swizzleSystemFont(ofSize:)))
        UIFont.swizzleClassSelector(#selector(UIFont.systemFont(ofSize:weight:)), with: #selector(UIFont.swizzleSystemFont(ofSize:weight:)))
        UIFont.swizzleClassSelector(#selector(UIFont.boldSystemFont(ofSize:)), with: #selector(UIFont.swizzleBoldSystemFont(ofSize:)))
    }
}

extension NSObject {
    public static func swizzleClassSelector(_ selector1: Selector, with selector2: Selector) {
        let aClass: AnyClass? = object_getClass(self)
        let method1: Method? = class_getClassMethod(aClass, selector1)
        let method2: Method? = class_getClassMethod(aClass, selector2)
        if let originalMethod = method1, let swizzledMethod = method2 {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

let customFontName = "Chalkduster"

let customFonts: [UIFont.TextStyle: UIFont] = [
    .largeTitle: UIFont(name: customFontName, size: 34)!,
    .title1: UIFont(name: customFontName, size: 28)!,
    .title2: UIFont(name: customFontName, size: 22)!,
    .title3: UIFont(name: customFontName, size: 20)!,
    .headline: UIFont(name: customFontName, size: 17)!,
    .body: UIFont(name: customFontName, size: 17)!,
    .callout: UIFont(name: customFontName, size: 16)!,
    .subheadline: UIFont(name: customFontName, size: 15)!,
    .footnote: UIFont(name: customFontName, size: 13)!,
    .caption1: UIFont(name: customFontName, size: 12)!,
    .caption2: UIFont(name: customFontName, size: 11)!
]

extension UIFont {
    @objc class func swizzlePreferredFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        let customFont = customFonts[style]!
        let metrics = UIFontMetrics(forTextStyle: style)
        let scaledFont = metrics.scaledFont(for: customFont)
        return scaledFont
    }
    
    @objc class func swizzlePreferredFont(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont {
        let customFont = customFonts[style]!
        let metrics = UIFontMetrics(forTextStyle: style)
        let scaledFont = metrics.scaledFont(for: customFont) // recursive
        return scaledFont
    }
    
    @objc class func swizzleSystemFont(ofSize size: CGFloat) -> UIFont {
        let customFont = UIFont(name: customFontName, size: size)
        return customFont!
    }

    @objc class func swizzleSystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let customFont = UIFont(name: customFontName, size: size)
        return customFont!
    }

    @objc class func swizzleBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        let customFont = UIFont(name: customFontName, size: size)
        return customFont!
    }

//    @objc class func swizzleInitFont(name fontName: String, size fontSize: CGFloat) -> UIFont {
//        return swizzleInitFont(name: customFontName, size: fontSize)
//    }
}
