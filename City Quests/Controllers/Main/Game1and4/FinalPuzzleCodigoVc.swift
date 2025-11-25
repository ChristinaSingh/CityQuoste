//
//  FinalPuzzleCodigoVc.swift
//  City Quests
//
//  Created by mac on 05/07/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class FinalPuzzleCodigoVc: UIViewController {
    
    @IBOutlet weak var text_Answr: UITextField!
    @IBOutlet weak var collection_place: UICollectionView!
 
    var arrayList:[JSON] = []
    var dicAll:JSON!

    var strObject:String! = ""
    var strPeople:String! = ""
    var strPlace:String! = ""

    var isObject:Int! = -1
    var isPeople:Int! = -1
    var isPlace:Int! = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.navigationController?.navigationBar.isHidden = false
     
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Final Puzzle", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

      //  lbl_Titile.att = Languages.FinalPuzzle
        WebGetAllInvent()
    }


    @IBAction func finish(_ sender: Any) {
     
        if text_Answr.text?.count != 0 {
            
            if strObject == text_Answr.text! {
                WebEndTime()
            } else {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Wrong answer 5 min. time penalty added", on: self)
                WebAddPenality()
            }
            
        } else {
        
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Please select a people image", on: self)

        }
        
    }
    
    func WebGetAllInvent() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["level"]     =   kappDelegate.strLevelId as AnyObject

 
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_event_instructions_game_images.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    arrayList = swiftyJsonVar["result"].arrayValue
                    strObject = swiftyJsonVar["final_answer"].stringValue.trimmingCharacters(in: .whitespaces)
                    dicAll = swiftyJsonVar
                    collection_place.reloadData()

                } else {

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    func WebEndTime() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.event_end_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
               
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)

                if(swiftyJsonVar["status"].stringValue == "1") {
                   
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "CongratsCodigoVC") as! CongratsCodigoVC
                    nVC.dicInfo = dicAll
                    self.navigationController?.pushViewController(nVC, animated: true)

                } else {

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    func WebAddPenality() {

        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue  as AnyObject
        paramsDict["event_instructions_id"]     =   "1" as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["time"]     =   "5" as AnyObject
        paramsDict["hint_type"]     =   "5" as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.add_hint.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
//            DispatchQueue.main.async {  in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
//            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

}
extension FinalPuzzleCodigoVc: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if kappDelegate.dicCurrentEvent["id"].stringValue == "39" {
            
            if arrayList.count > 4 {
               
                return 4
            } else {
                
                return arrayList.count
                
            }

        } else {
            
            return arrayList.count

        }

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collection_place.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as! BannerCollectionCell
        
        let data = arrayList[indexPath.row]
        
        if data["answer_status"].numberValue == 1 {
            
          //  cell.imgView.sd_setShowActivityIndicatorView(true)
            cell.imgView.sd_setImage(with: URL(string: data["final_puzzle_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
            
        } else {
            
            cell.imgView.image = UIImage.init(named: "")
            cell.imgView.backgroundColor = hexStringToUIColor(hex: "#D7CCC8")
            
        }
        
        return cell
        

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        if kappDelegate.dicCurrentEvent["id"].stringValue == "39" {
            
            return CGSize(width: self.collection_place.frame.width/2, height: self.collection_place.frame.height/2)

        } else {
            
            return CGSize(width: self.collection_place.frame.width/4, height: 120)

        }
    }
    
}


