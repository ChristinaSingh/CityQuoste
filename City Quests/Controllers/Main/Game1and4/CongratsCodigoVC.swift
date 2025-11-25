//
//  CongratsCodigoVC.swift
//  City Quests
//
//  Created by mac on 05/07/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class CongratsCodigoVC: UIViewController {
    
    @IBOutlet weak var text_Detail: UITextView!
    @IBOutlet weak var img_Promo: UIImageView!
 
    var dicInfo:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.navigationController?.navigationBar.isHidden = false
      
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Felicidades", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        let strAll = dicInfo["after_finish_text"].stringValue
        text_Detail.attributedText = strAll.htmlToAttributedString
        img_Promo.sd_setImage(with: URL(string: dicInfo["after_finish_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

    }
    
    override func leftClick() {
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowAllTeamAndTimeVC") as! ShowAllTeamAndTimeVC
        self.navigationController?.pushViewController(nVC, animated: true)
    }

    @IBAction func finish(_ sender: Any) {
        
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowAllTeamAndTimeVC") as! ShowAllTeamAndTimeVC
        self.navigationController?.pushViewController(nVC, animated: true)

    }
    
    
}

