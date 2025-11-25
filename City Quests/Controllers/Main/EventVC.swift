//
//  EventVC.swift
//  City Quests
//
//  Created by mac on 27/03/23.
//

import UIKit
import SwiftyJSON
 import SDWebImage

class EventVC: UIViewController {
    
    @IBOutlet weak var nearestCollecView: UICollectionView!
    
    //Mark:- Properties
    var indexPath = 0
    var timer:Timer?
    var counter = 0
    var nearMeEvents:[JSON]! = []


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "", CenterTitle: "Logros", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        WebGetEvent()
        self.tabBarController?.tabBar.isHidden = false
        nearestCollecView.isHidden  = false
    }

    func WebGetEvent() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_Accomplishments.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.nearMeEvents = swiftyJsonVar["result"].arrayValue
                    self.nearestCollecView.reloadData()
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

  
}



extension EventVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
           return nearMeEvents.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
            
        print("Nearestsddsd")
           
        let cell = nearestCollecView.dequeueReusableCell(withReuseIdentifier: "NearestCollectionCell", for: indexPath) as! NearestCollectionCell
          
        let data = nearMeEvents[indexPath.row]
            cell.lblTime.text = data["title"].stringValue

        if data["event_award"].stringValue == "false" {
            cell.img.sd_setImage(with: URL(string: data["incomplete_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
        } else {
            cell.img.sd_setImage(with: URL(string: data["complete_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
        }
        
            return cell
        
    }
  

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
  
//        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 8 {
//
//           self.tabBarController?.selectedIndex = 3
//
//        } else if indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7 {
//            kappDelegate.dicCurrentVirus = nearMeEvents[indexPath.row]
//            kappDelegate.strGameName = kappDelegate.dicCurrentVirus["event_name"].stringValue
//
//            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "VirsuHomeVC") as! VirsuHomeVC
//            self.navigationController?.pushViewController(nVC, animated: true)
//
//        } else {
//            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Coming soon", on: self)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return CGSize(width: self.nearestCollecView.frame.width/3.2 - 5, height: self.nearestCollecView.frame.height/3)
        
    }
    
}
