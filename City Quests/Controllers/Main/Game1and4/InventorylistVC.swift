//
//  InventorylistVC.swift
//  City Quests
//
//  Created by mac on 31/03/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class InventorylistVC: UIViewController {
    
    
    @IBOutlet weak var table_list: UITableView!
    
    var arrayList:[JSON] = []
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        table_list.estimatedRowHeight = 100
//        table_list.rowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
       setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Inventory", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        WebGetAllInvent()
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
        CommunicationManeger.callPostService(apiUrl: Router.get_all_inventory_event.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    arrayList = swiftyJsonVar["result"].arrayValue
                    table_list.reloadData()
                } else {

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

}
extension InventorylistVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return arrayList.filter({$0["type"].stringValue == "Places"}).count
        } else if section == 1 {
            return arrayList.filter({$0["type"].stringValue == "People"}).count
        } else if section == 2 {
            return arrayList.filter({$0["type"].stringValue == "Objects"}).count
        }

         return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = table_list.dequeueReusableCell(withIdentifier: "TransactionTableCell", for: indexPath) as! TransactionTableCell
        
        var dic:JSON!
      
        if indexPath.section == 0 {
            dic = arrayList.filter({$0["type"].stringValue == "Places"})[indexPath.row]
        } else if indexPath.section == 1 {
            dic = arrayList.filter({$0["type"].stringValue == "People"})[indexPath.row]
        } else if indexPath.section == 2 {
            dic = arrayList.filter({$0["type"].stringValue == "Objects"})[indexPath.row]
        }

        cell.lbl_lang.attributedText = dic["hint_discovered"].stringValue.htmlToAttributedString
        cell.img_Tr.sd_setImage(with: URL(string: dic["final_puzzle_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

       
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dic:JSON!
      
        if indexPath.section == 0 {
            dic = arrayList.filter({$0["type"].stringValue == "Places"})[indexPath.row]
        } else if indexPath.section == 1 {
            dic = arrayList.filter({$0["type"].stringValue == "People"})[indexPath.row]
        } else if indexPath.section == 2 {
            dic = arrayList.filter({$0["type"].stringValue == "Objects"})[indexPath.row]
        }

        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InventaryDetailVC") as! InventaryDetailVC
        nVC.dicInfo = dic
        self.navigationController?.pushViewController(nVC, animated: true)

    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
       switch(section) {
         case 0:return "Places"
         case 1:return "People"
         case 2:return "Object"
         default :return ""
       }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .black
        }
    }

}
