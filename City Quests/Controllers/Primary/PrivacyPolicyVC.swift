//
//  PrivacyPolicyVC.swift
//  VIBRAS
//
//  Created by mac on 20/06/22.
//

import UIKit
import SwiftyJSON

class PrivacyPolicyVC: UIViewController {
    
    //Mark:- IBOutlets
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var txtDetails: UITextView!
    
    //Mark:- Properties
    var screenType:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txtDetails.text = ""
        if self.screenType == "A" {
            getAboutUsAPI(strAPI: Router.get_term_conditions.url())
            self.lblHead.text = Languages.AboutUs
        } else if self.screenType == "P" {
            getAboutUsAPI(strAPI: Router.get_term_conditions.url())
            self.lblHead.text = Languages.privac
        } else if self.screenType == "T" {
            getAboutUsAPI(strAPI: Router.get_term_conditions.url())
            self.lblHead.text = Languages.terms
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    //Mark:- Functions
    func getAboutUsAPI(strAPI:String){
     
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["language"]     =   Singleton.shared.language as AnyObject
    
        print(paramsDict)
        
        CommunicationManeger.callPostService(apiUrl: strAPI, parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"] == "successfull") {
                    self.txtDetails.attributedText = swiftyJsonVar["result"]["description"].stringValue.htmlToAttributedString
                } else {
                    let message = swiftyJsonVar["result"].string
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: message!, on: self)
                }
                self.hideProgressBar()
            }
        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
        
        //Mark:- Button Actions
    @IBAction func backBtnClick(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)

    }


}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
}
//Poppins-Regular 18.0


extension UILabel {
    func setHTMLFromString(htmlText: String) {
//        let modifiedFont = String(format:"<style>body{font-family: '%@'; font-size:%f17;}</style>", htmlText)
        let modifiedFont = NSString(format:"<span style=\"color:\(self.textColor.toHexString());font-family: '-apple-system', 'Poppins-Regular'; font-size: \(17.0)\">%@</span>" as NSString, htmlText)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr

//        let attrStr = try! NSAttributedString(
//            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
//            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
//            documentAttributes: nil)
//
//        self.attributedText = attrStr
    }
}


extension NSAttributedString {

    convenience init(htmlString html: String, font: UIFont? = nil, useDocumentFontSize: Bool = true) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }

        let fontSize: CGFloat? = useDocumentFontSize ? nil : font!.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }

                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }

        self.init(attributedString: attr)
    }

}
extension UIColor {
    convenience init(hexString:String) {
        let hexString:NSString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
