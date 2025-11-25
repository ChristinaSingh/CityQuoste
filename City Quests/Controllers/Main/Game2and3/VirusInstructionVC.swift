//
//  VirusInstructionVC.swift
//  City Quests
//
//  Created by mac on 06/04/23.
//

import UIKit
import SwiftyJSON
import SDWebImage


class VirusInstructionVC: UIViewController {
    
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
     
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Instruction", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        img_user.sd_setImage(with: URL(string: kappDelegate.dicCurrentVirus["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

        text_Detail.attributedText = kappDelegate.dicCurrentVirus["event_instructions1\(Singleton.shared.languagePar!)"].stringValue.htmlToAttributedString
    }

    @IBAction func cross(_ sender: Any) {

        WebStartGame()

    }
    
    
    func WebStartGame() {
    
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_code"]     =   kappDelegate.strEventCode as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentVirus["id"].stringValue as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.virus_event_start_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in

            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    
                    if kappDelegate.dicCurrentVirus["id"].stringValue == "14"  {
                        
                        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "CabanaVC") as! CabanaVC
                        self.navigationController?.pushViewController(nVC, animated: true)

                    } else {
                        
                       let nVC = self.storyboard?.instantiateViewController(withIdentifier: "VirusAnswerVC") as! VirusAnswerVC
                        self.navigationController?.pushViewController(nVC, animated: true)

                    }

                } else {
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: swiftyJsonVar["result"].stringValue, on: self)
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
}
