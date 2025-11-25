//
//  VirsuHomeVC.swift
//  City Quests
//
//  Created by mac on 05/04/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class VirsuHomeVC: UIViewController {
    
    var dicEvent:JSON!

    @IBOutlet weak var img_Virus: UIImageView!
    @IBOutlet weak var trans_View: UIView!
    @IBOutlet weak var text_Code: UITextField!
    
    var isINdex:Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        WebGetEvent()
        trans_View.isHidden = true
        img_Virus.sd_setImage(with: URL(string: kappDelegate.dicCurrentVirus["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
        self.tabBarController?.tabBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Welcome to \(kappDelegate.strGameName!)", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

    }

    @IBAction func crosss(_ sender: Any) {
        trans_View.isHidden = true

    }
    
    @IBAction func submit(_ sender: Any) {
        trans_View.isHidden = true
        WebApplyCode()
    }
    @IBAction func useAcode(_ sender: Any) {
        if dicEvent != nil {
            
            if dicEvent["event_status"].stringValue != "END" {
                
                
                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                self.navigationController?.pushViewController(nVC, animated: true)

//                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "LevelVC") as! LevelVC
//                nVC.isIndexN = isINdex
//                self.navigationController?.pushViewController(nVC, animated: true)

            } else {
                trans_View.isHidden = false
            }
        } else {
            trans_View.isHidden = false
        }
    }
    
    func WebGetEvent() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentVirus["id"].stringValue as AnyObject

        
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_event_code.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    dicEvent = swiftyJsonVar["result"]
                    kappDelegate.strEventCode = swiftyJsonVar["result"]["event_code"].stringValue
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    
    func WebApplyCodeS() {
        
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentVirus["id"].stringValue as AnyObject
        paramsDict["event_code"]     =   text_Code.text! as AnyObject
        paramsDict["team_name"]     =   "" as AnyObject
        paramsDict["lat"]     =   kappDelegate.CURRENT_LAT as AnyObject
        paramsDict["lon"]     =   kappDelegate.CURRENT_LON as AnyObject
        paramsDict["level"]     =   kappDelegate.strLevelId as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.event_start_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                    self.navigationController?.pushViewController(nVC, animated: true)

                } else {
                    self.dismiss(animated: false, completion: nil)
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

    func WebApplyCode() {
    
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_code"]     =   text_Code.text as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentVirus["id"].stringValue as AnyObject

        
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.virus_event_apply_code.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in

            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    WebGetEvent()
                  //  WebApplyCodeS()
                    kappDelegate.strEventCode = text_Code.text!
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                    self.navigationController?.pushViewController(nVC, animated: true)

                } else {
                    WebGetEvent()
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Code Not Valid", on: self)

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }


}
