//
//  WelcomeVC.swift
//  City Quests
//
//  Created by mac on 06/04/23.
//

import UIKit
import SwiftyJSON
import SDWebImage
import WebKit

class WelcomeVC: UIViewController,UIWebViewDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var hightText: NSLayoutConstraint!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
     
        print("\(kappDelegate.dicCurrentVirus["description_image"].stringValue)")
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "BIENVENIDO", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        img_user.sd_setImage(with: URL(string: kappDelegate.dicCurrentVirus["description_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
//
//        let strDetail = kappDelegate.dicCurrentVirus["description\(Singleton.shared.languagePar!)"].stringValue
//        
//        webView.scrollView.isScrollEnabled = true
//        webView.scrollView.bounces = false
//        webView.allowsBackForwardNavigationGestures = false
//        webView.contentMode = .scaleToFill
//        webView.navigationDelegate = self
//        webView.loadHTMLString(Singleton.shared.header + strDetail + "</body>", baseURL: nil)
//        webView.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        webView.isHidden = true
        

        if kappDelegate.dicCurrentVirus["description\(Singleton.shared.languagePar!)"].stringValue.count > 10  {
            text_Detail.text = kappDelegate.dicCurrentVirus["description\(Singleton.shared.languagePar!)"].stringValue
                text_Detail.isHidden = false

            
        }else {
            text_Detail.isHidden = true
            hightText.constant = 0.0
        }
            

    }

    @IBAction func cross(_ sender: Any) {

        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        nVC.strFrom = "virus"
        self.navigationController?.pushViewController(nVC, animated: true)

    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        print("sdsdsd")
    }

}
