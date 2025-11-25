//
//  Localizer.swift
//  MyLocalizaion
//
//  Created by ahmed on 6/21/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//


import UIKit

class Localizer {
    
    class func doTheExchange(){
        
        ExchangeMethodsForClass(className: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.customlocalizedString(forKey:value:table:)))
        
        ExchangeMethodsForClass(className: UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.custom_userInterfaceLayoutDirection))
    }
}

extension Bundle {
    
    @objc func customlocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        
        let currentLanguage = Language.currentLanguage()
        var bundle = Bundle()
        
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            bundle = Bundle(path: path)!
        }else{
            let path = Bundle.main.path(forResource: "Base", ofType: "lproj")
            bundle = Bundle(path: path!)!
        }
        
        return bundle.customlocalizedString(forKey: key, value: value, table: tableName)
    }
}

extension UIApplication {
    
    @objc var custom_userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        get{
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if Language.currentLanguage() == "ar" {
                direction = .rightToLeft
            }
            return direction
        }
    }
}

func ExchangeMethodsForClass(className: AnyClass, originalSelector: Selector, overrideSelector: Selector){
    
    let originalMethod : Method = class_getInstanceMethod(className, originalSelector)!
    let overrideMethod : Method = class_getInstanceMethod(className, overrideSelector)!
    
    if class_addMethod(className, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod)) {
        
        class_replaceMethod(className, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    }
    else {
        
        method_exchangeImplementations(originalMethod, overrideMethod)
    }
}

