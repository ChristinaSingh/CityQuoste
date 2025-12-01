//
//  FinalPuzzleVC.swift
//  City Quests
//
//  Created by mac on 31/03/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class FinalPuzzleVC: UIViewController {

    @IBOutlet weak var hight3: NSLayoutConstraint!
    @IBOutlet weak var hight2: NSLayoutConstraint!
    @IBOutlet weak var hight1: NSLayoutConstraint!
    @IBOutlet weak var lbl_Titile: UILabel!
 
    @IBOutlet weak var collection_object: UICollectionView!
    @IBOutlet weak var collection_People: UICollectionView!
    @IBOutlet weak var collection_place: UICollectionView!
 
    var arrayList:[JSON] = []

    var strObject:String! = ""
    var strPeople:String! = ""
    var strPlace:String! = ""

    var isObject:Int! = -1
    var isPeople:Int! = -1
    var isPlace:Int! = -1
    var dicAll:JSON!

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
     
//        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "EndGameVC") as! EndGameVC
//        nVC.dicAll = dicAll
//        self.navigationController?.pushViewController(nVC, animated: true)
//
        if isObject != -1 && isPeople != -1 && isPlace != -1 {

            if strObject == "Yes" && strPlace == "Yes" && strPeople == "Yes" {
//                WebEndTime()

                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "EndGameVC") as! EndGameVC
                nVC.dicAll = dicAll
                self.navigationController?.pushViewController(nVC, animated: true)

            } else {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Wrong image selected penalty Time Added 5 min.", on: self)
                WebAddPenality()
            }

        } else {

            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Please select one image in all three section", on: self)

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
        CommunicationManeger.callPostService(apiUrl: Router.get_inventory_event.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    dicAll = swiftyJsonVar
                    arrayList = swiftyJsonVar["result"].arrayValue
                    lbl_Titile.attributedText = swiftyJsonVar["notice"].stringValue.htmlToAttributedString
                    
                    let Places = arrayList.filter({$0["type"].stringValue == "Places"}).count
                    var newS = Places/3
                    newS += 1

//                    if newS%3 == 0 {
                        hight1.constant = CGFloat(130 * newS)
//                    } else {
//                        newS += 1
//                        hight1.constant = CGFloat(130 * newS)
//                    }

                    let People =  arrayList.filter({$0["type"].stringValue == "People"}).count
                    var Peoples = People/3
                        Peoples += 1
//                    if Peoples%3 == 0 {
                        hight2.constant = CGFloat(130 * Peoples)
//                    } else {
//                        Peoples += 1
//                        hight2.constant = CGFloat(130 * Peoples)
//                    }

                 

                    
                    let Objects =  arrayList.filter({$0["type"].stringValue == "Objects"}).count
                    var Objectsd = Objects/3
                    Objectsd += 1

//                    if Objectsd%3 == 0 {
                        hight3.constant = CGFloat(130 * Objectsd)
//                    } else {
//                        Objectsd += 1
//                        hight3.constant = CGFloat(130 * Objectsd)
//                    }


                    
                    
                    collection_place.reloadData()
                    collection_People.reloadData()
                    collection_object.reloadData()

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
                   
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowAllTeamAndTimeVC") as! ShowAllTeamAndTimeVC
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
extension FinalPuzzleVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == collection_place {
            return arrayList.filter({$0["type"].stringValue == "Places"}).count
        } else if collectionView == collection_People {
            return arrayList.filter({$0["type"].stringValue == "People"}).count
        } else {
            return arrayList.filter({$0["type"].stringValue == "Objects"}).count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == collection_place {
           
            let cell = collection_place.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as! BannerCollectionCell
            
            let data = arrayList.filter({$0["type"].stringValue == "Places"})[indexPath.row]
          //  cell.imgView.sd_setShowActivityIndicatorView(true)
            cell.imgView.sd_setImage(with: URL(string: data["final_puzzle_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
            
            if isPlace == indexPath.row {
                cell.img_Checked.image = UIImage.init(named: "ic_checked")
            } else {
                cell.img_Checked.image = UIImage.init(named: "")
            }
            
            return cell
            
        } else if collectionView == collection_People {

            let cell = collection_People.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as! BannerCollectionCell
            
            let data = arrayList.filter({$0["type"].stringValue == "People"})[indexPath.row]
          //  cell.imgView.sd_setShowActivityIndicatorView(true)
            cell.imgView.sd_setImage(with: URL(string: data["final_puzzle_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
            
            if isPeople == indexPath.row {
                cell.img_Checked.image = UIImage.init(named: "ic_checked")
            } else {
                cell.img_Checked.image = UIImage.init(named: "")
            }

            return cell
            
        } else  {
            
            let cell = collection_object.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as! BannerCollectionCell
            
            let data = arrayList.filter({$0["type"].stringValue == "Objects"})[indexPath.row]
         //   cell.imgView.sd_setShowActivityIndicatorView(true)
            cell.imgView.sd_setImage(with: URL(string: data["final_puzzle_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
            
            if isObject == indexPath.row {
                cell.img_Checked.image = UIImage.init(named: "ic_checked")
            } else {
                cell.img_Checked.image = nil
            }

            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        if collectionView == collection_place {
           
            let data = arrayList.filter({$0["type"].stringValue == "Places"})[indexPath.row]
            strPlace = data["final_puzzle_status"].stringValue
            isPlace = indexPath.row
            collection_place.reloadData()

        } else if collectionView == collection_People {
           
            let data = arrayList.filter({$0["type"].stringValue == "People"})[indexPath.row]
            strPeople = data["final_puzzle_status"].stringValue
            isPeople = indexPath.row
            collection_People.reloadData()

        } else  {
            
            let data = arrayList.filter({$0["type"].stringValue == "Objects"})[indexPath.row]
            strObject = data["final_puzzle_status"].stringValue
            isObject = indexPath.row
            collection_object.reloadData()
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        if collectionView == collection_place {
           
            return CGSize(width: self.collection_place.frame.width/3 - 10, height: 130)

        } else if collectionView == collection_People {
           
            return CGSize(width: self.collection_People.frame.width/3 - 10, height: 130)

        } else  {
            
            
            return CGSize(width: self.collection_object.frame.width/3 - 10, height: 130)

        }
    }
    
}

