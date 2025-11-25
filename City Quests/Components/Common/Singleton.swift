//
//  Singleton.swift
//  Agile Sports
//
//  Created by AM on 21/06/19.
//  Copyright © 2019 AM. All rights reserved.
//

import Foundation
import UIKit
//import Toaster


class Singleton
{
    
    static let shared = Singleton()
    var serviceWant = String()
    var snowCategory = String()
    var current_lat:String?
    var current_long:String?
    var userID:String?
    var userType:String?
    var language:String?
    var timer : Timer?
    var languagePar:String! = "_sp"
    let header = """
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                <style>
                    body {
                        font-family: "Avenir";
                        font-size: 17px;
                    }
                </style>
            </head>
            <body>
            """
    let javascript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=10.0, user-scalable=yes');document.getElementsByTagName('head')[0].appendChild(meta);"

    
    private init(){
//        self.userInfo = getUserData()
    }
    
    func showToast(text: String) {
//        Toast(text:text).show()
//        Toast(text:text).cancel()
    }

     func noDataFound(_ message: String, tableViewOt: UICollectionView, parentViewController parentVC: UIViewController) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableViewOt.bounds.size.width, height: tableViewOt.bounds.size.height))
        let center = (tableViewOt.bounds.size.width/2)
        let center_y = (tableViewOt.bounds.size.height/2)
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: center_y - 25, width: tableViewOt.bounds.size.width, height: 50))
        label.font = label.font.withSize(17.0)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.text = message
        label.textColor = UIColor(red: CGFloat(90)/255, green: CGFloat(92)/255, blue: CGFloat(99)/255, alpha :1)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
                
        view.addSubview(label)
        tableViewOt.backgroundView = view
    }

}

