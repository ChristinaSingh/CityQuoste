//
//  HistoryVC.swift
//  City Quests
//
//  Created by Gajendra on 13/08/24.
//

import UIKit
import SwiftyJSON
import SDWebImage

class HistoryVC: UIViewController {
    
    var nearMeEvents:[JSON]! = []

    @IBOutlet weak var trans_View: UIView!
    @IBOutlet weak var text_Code: UITextField!
    @IBOutlet weak var tableList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        WebGetEvent()
        trans_View.isHidden = true
     //   tableList.estimatedRowHeight = 200
     //   tableList.rowHeight = UITableView.automaticDimension
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Completed Event", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

    }

    @IBAction func crosss(_ sender: Any) {
        trans_View.isHidden = true

    }
    
    @IBAction func submit(_ sender: Any) {
        trans_View.isHidden = true
        WebApplyCode()
    }
    @IBAction func useAcode(_ sender: Any) {
        trans_View.isHidden = false
    }
    
    func WebGetEvent() {
        
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_finish_event_by_event.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                   
//                    eventid == "1" || eventid == "5" || eventid == "8" || eventid == "15" || eventid == "18" || eventid == "19" || eventid == "20" || eventid == "22" || eventid == "34" || eventid == "24" || eventid == "35" || eventid == "36" || eventid == "31"  || eventid == "28" || eventid == "25"
                    
                    self.nearMeEvents = swiftyJsonVar["result"].arrayValue
                    
//                    self.nearMeEvents = swiftyJsonVar["result"].arrayValue.filter({$0["type"].stringValue == "puzzle" || $0["type"].stringValue == "crime" || $0["type"].stringValue == "codigo_frida" || $0["type"].stringValue == "zombie" || $0["type"].stringValue == "rescate" || $0["type"].stringValue == "mision_magica" || $0["type"].stringValue == "mystery_city" && $0["event_status"].stringValue != "END"})

//                    self.nearMeEvents = nearMeEvents.filter({$0["event_status"].stringValue != "END"})

                    self.tableList.reloadData()
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

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.event_apply_code.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    WebGetEvent()
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
extension HistoryVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearMeEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JoinedEventCell
        let data = nearMeEvents[indexPath.row]
        cell.img_Event.sd_setImage(with: URL(string: data["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
        cell.lbl_EventName.text = data["event_name"].stringValue
        cell.lbl_Date.text = "Start - \(data["event_start_time"].stringValue)"
        cell.lbl_Addrss.text = "End - \(data["event_end_time"].stringValue)"

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        kappDelegate.dicCurrentEvent = nearMeEvents[indexPath.row]
//        kappDelegate.strEventCode = nearMeEvents[indexPath.row]["event_code"].stringValue
//        self.tabBarController?.selectedIndex = 2
     //   strEventCode
        let data = nearMeEvents[indexPath.row]

        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailVC") as! HistoryDetailVC
        nVC.strCode = data["event_code"].stringValue
        nVC.strCodeId = data["event_id"].stringValue
        self.navigationController?.pushViewController(nVC, animated: true)

    }

}

