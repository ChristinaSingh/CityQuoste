//
//  MainInstructionVC.swift
//  City Quests
//
//  Created by mac on 29/03/23.
//

import UIKit
import MapKit
import SwiftyJSON
import WebKit

class MainInstructionVC: UIViewController,UIWebViewDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var img_user: UIImageView!
    
    @IBOutlet weak var web_View: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        self.navigationController?.navigationBar.isHidden = false
   
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Instructions", CenterImage: "", RightTitle: "", RightImage: "Dotss", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
  
        transView.isHidden = true

        web_View.scrollView.isScrollEnabled = true
        web_View.scrollView.bounces = false
        web_View.allowsBackForwardNavigationGestures = false
        web_View.contentMode = .scaleToFill
        web_View.navigationDelegate = self
        web_View.loadHTMLString(Singleton.shared.header + Languages.MainIntstruction + "</body>", baseURL: nil)
        web_View.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        web_View.isHidden = false

    }

    @IBAction func cross(_ sender: Any) {
        transView.isHidden = true
    }
    override func rightClick() {
        transView.isHidden = false

    }
    @IBAction func instruction(_ sender: Any) {
        
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InstructionVC") as! InstructionVC
        nVC.strDetail = kappDelegate.dicCurrentEvent["event_instructions"].stringValue
        self.navigationController?.pushViewController(nVC, animated: true)
        
    }
    
    @IBAction func map(_ sender: Any) {
//        if kappDelegate.dicCurrentEvent["type"].stringValue != "crime" {
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FlgMaViewVC") as! FlgMaViewVC
            self.navigationController?.pushViewController(nVC, animated: true)
//        }
    }
    
    @IBAction func inventery(_ sender: Any) {
//
        //if kappDelegate.dicCurrentEvent["type"].stringValue != "crime" {
          
           let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InventorylistVC") as! InventorylistVC
            self.navigationController?.pushViewController(nVC, animated: true)
        
//        }

    }
    @IBAction func finalPuzzle(_ sender: Any) {
        
//        if kappDelegate.dicCurrentEvent["type"].stringValue != "crime" {
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FinalPuzzleVC") as! FinalPuzzleVC
            self.navigationController?.pushViewController(nVC, animated: true)
//        }


    }
}
