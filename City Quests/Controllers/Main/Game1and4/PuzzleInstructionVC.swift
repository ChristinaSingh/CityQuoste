//
//  PuzzleInstructionVC.swift
//  City Quests
//
//  Created by mac on 24/05/23.
//

import UIKit
import SwiftyJSON
import MapKit
import WebKit

class PuzzleInstructionVC: UIViewController,UIWebViewDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var img_user: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
     
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Introduction", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        img_user.sd_setImage(with: URL(string: kappDelegate.dicCurrentEvent["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

        
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = false
        webView.contentMode = .scaleToFill
        webView.navigationDelegate = self
        webView.loadHTMLString(Singleton.shared.header + "\(kappDelegate.dicCurrentEvent["intro_sp"].stringValue)" + "</body>", baseURL: nil)
        webView.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        webView.isHidden = false

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        print("sdsdsd")
    
}

    @IBAction func cross(_ sender: Any) {

        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        self.navigationController?.pushViewController(nVC, animated: true)

    }
    
}
