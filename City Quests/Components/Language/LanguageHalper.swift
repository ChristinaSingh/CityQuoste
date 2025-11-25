//
//  Language.swift
//  Internationalization-iOS9
//
//  Created by Amul Upadhyay on 1/9/18.
//  Copyright © 2018 Ravi Malviya. All rights reserved.
//

import Foundation
import UIKit
enum LanguageIdEnum:String {
    case english = "en"
    case german = "de"
    case french = "fr"
    case italian = "it"
    case spanish = "es"
    case arabic = "ar"
    case portigues = "pt-BR"

}
//"English" = "English";
//"French" = "French";
//"German" = "German";
//"Italian" = "Italian";
//"Spanish" = "Spanish";

import Foundation
import UIKit

extension UIApplication {
    class func isRTL() -> Bool{
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}

struct LLanguage{
    
    static let APPLE_LANGUAGE_KEY = "AppleLanguages"

    static var appleLanguageInShort:String {
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: LLanguage.APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        let endIndex = current.startIndex
        let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
        //String(current[..<current.index(endIndex, offsetBy: 2)]) //
        return currentWithoutLocale
    }
 
    /// set @lang to be the first in Applelanguages list
    static var appleLanguage:String? {
        get {
            let userdef = UserDefaults.standard
            let langArray = userdef.object(forKey: LLanguage.APPLE_LANGUAGE_KEY) as! NSArray
            let current = langArray.firstObject as! String
            return current
        }
        set(lang) {
            let userdef = UserDefaults.standard
            userdef.set([lang], forKey: APPLE_LANGUAGE_KEY)//, appleLanguage
            userdef.synchronize()
        }
    }
    
    static var isRTL: Bool {
        return LLanguage.appleLanguageInShort == LanguageIdEnum.arabic.rawValue
    }
    
    static func updateViewSemanticContentAttribute(){
        if LLanguage.isRTL == true {
            if #available(iOS 9.0, *) {
              //  UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                // Fallback on earlier versions
            }
        }
        else{
            if #available(iOS 9.0, *) {
              //  UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


class LLocalizer {
    
    class func doBaseInternationalization() {
        
       //LLanguage.updateViewSemanticContentAttribute()

        //Language reflect whithout restart app.
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
        
        //Navigation Back Button Mirroring.
//        MethodSwizzleGivenClassName(cls: UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.cstm_userInterfaceLayoutDirection))
//
//       MethodSwizzleGivenClassName(cls: UITextField.self, originalSelector: #selector(UITextField.layoutSubviews), overrideSelector: #selector(UITextField.cstmlayoutSubviews))
//
//       MethodSwizzleGivenClassName(cls: UILabel.self, originalSelector: #selector(UILabel.layoutSubviews), overrideSelector: #selector(UILabel.cstmlayoutSubviews))

    }
}

//MARK: Language Localization using Storyboard/Location String
extension Bundle {
    
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        if self == Bundle.main {
            var bundle = Bundle();
            if let _path = Bundle.main.path(forResource: LLanguage.appleLanguage, ofType: "lproj") {
                bundle = Bundle(path: _path)!
            }else{
                if let _path = Bundle.main.path(forResource: LLanguage.appleLanguageInShort, ofType: "lproj") {
                    bundle = Bundle(path: _path)!
                } else {
                    bundle = Bundle(path: Bundle.main.path(forResource: "Base", ofType: "lproj")!)!
                }
            }
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
        } else {
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
}

//MARK: Navigation Back Button Mirroring
extension UIApplication {
    @objc var cstm_userInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if LLanguage.appleLanguageInShort == LanguageIdEnum.arabic.rawValue {
                direction = .rightToLeft
            }
            return direction
        }
    }
}

//MARK: Mirroring UIImageView in ViewController

//extension UIViewController {
//    func loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: [UIView]) {
//        if subviews.count > 0 {
//            for subView in subviews {
//                if (subView is UIImageView) && subView.tag < 0 {
//                    let toRightArrow = subView as! UIImageView
//                    if let _img = toRightArrow.image {
//                        toRightArrow.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
//                    }
//                }
//                loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
//            }
//        }
//    }
//}
//
//class MirroringViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if LLanguage.appleLanguageInShort == LanguageIdEnum.arabic.rawValue {
////            loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.view.subviews)
//        }
//    }
//}

/// Exchange the implementation of two methods of the same Class
func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}


extension UILabel {
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()

        if self.isKind(of: NSClassFromString("UITextFieldLabel")!) {
            return // handle special case with uitextfields
        }
        if self.tag <= 0  {
            if UIApplication.isRTL()  {
                if self.textAlignment == .right || self.textAlignment == .center {
                    return
                }
            } else {
                if self.textAlignment == .left || self.textAlignment == .center  {
                    return
                }
            }
        }
        if self.tag <= 0 {
            if UIApplication.isRTL()  {
                self.textAlignment = .left
            } else {
                self.textAlignment = .right
            }
        }
    }
}
extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let writingDirection = UIApplication.shared.userInterfaceLayoutDirection
        let factor: CGFloat = writingDirection == .leftToRight ? 1 : -1
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
//extension UIButton {
//    @objc public func cstmlayoutSubviews() {
//        self.cstmlayoutSubviews()
//        if self.tag <= 0 {
//            if UIApplication.isRTL()  {
//                self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right;
//            } else {
//                self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
//            }
//        }
//    }
//}

extension UITextField {
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()
        if self.tag <= 0 {
            if UIApplication.isRTL()  {
                if self.textAlignment == .right { return }
                self.textAlignment = .right
            } else {
                if self.textAlignment == .left { return }
                self.textAlignment = .left
            }
        }
    }
}


