//
//  ShowFinalIPreviewVC.swift
//  City Quests
//
//  Created by Gajendra on 08/07/24.
//

import UIKit
 import SDWebImage

class ShowFinalIPreviewVC: UIViewController {
    @IBOutlet weak var imgPuzzleVC: UIImageView!
    
    var strImage:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Final Puzzle", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

     //   imgPuzzleVC.sd_setShowActivityIndicatorView(true)
        imgPuzzleVC.sd_setImage(with: URL(string: strImage), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
