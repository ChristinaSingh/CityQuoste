//
//  InventaryDetailVC.swift
//  City Quests
//
//  Created by mac on 03/04/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class InventaryDetailVC: UIViewController {

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
      
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Instructions", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        let strAll = dicInfo["hint_discovered"].stringValue + dicInfo["hint_discovered_sp"].stringValue
        text_Detail.attributedText = strAll.htmlToAttributedString
        img_Promo.sd_setImage(with: URL(string: dicInfo["final_puzzle_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

    }

}
