//
//  Langauge.swift
//  MyLocalizaion
//
//  Created by ahmed on 6/21/17.
//  Copyright © 2017 MyCompany. All rights reserved.
//

import Foundation

class Language {
    
    class func currentLanguage() -> String{
        
        let def = UserDefaults.standard
        let langs = def.object(forKey: "AppleLanguages") as! NSArray
        let firstLanguage = langs.firstObject as! String
        
        return firstLanguage
    }
    
    class func setAppLanguage(lang: String) {
        
        let def = UserDefaults.standard
        def.set([lang], forKey: "AppleLanguages")
        def.synchronize()
    }
    
}

