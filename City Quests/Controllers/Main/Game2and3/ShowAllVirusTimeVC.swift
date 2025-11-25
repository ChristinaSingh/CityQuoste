//
//  ShowAllVirusTimeVC.swift
//  City Quests
//
//  Created by mac on 13/04/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ShowAllVirusTimeVC: UIViewController {
    
    var nearMeEvents:[JSON]! = []
    var arr_Leaderbard:[JSON]! = []

    @IBOutlet weak var lbl_TeamMember: UILabel!
    @IBOutlet weak var lbl_TotalPenal: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var img_Event: UIImageView!
    @IBOutlet weak var tableList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
   
        WebGetFinishTime()
       
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Teams", CenterImage: "", RightTitle: "", RightImage: "Home", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")


    }
    override func rightClick() {
        Switcher.updateRootVC()
    }

    
    func WebGetFinishTime() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_code"]     =   kappDelegate.strEventCode as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentVirus["id"].stringValue as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_event_finish_time_game4.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.nearMeEvents = swiftyJsonVar["result"].arrayValue
                    self.tableList.reloadData()
                    let dic = swiftyJsonVar["event_details"]
                    lbl_Name.text = dic["event_name"].stringValue
                    img_Event.sd_setImage(with: URL(string: dic["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

                    lbl_Time.text = swiftyJsonVar["event_total_time"].stringValue
                    lbl_TotalPenal.text = "\(swiftyJsonVar["penalty_time"].numberValue) minutes"
                    //lbl_TeamMember.text = "Team Members: 6/\(swiftyJsonVar["total_ticket"].stringValue)"

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    


}
extension ShowAllVirusTimeVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return nearMeEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JoinedEventCell
        
        

            let data = nearMeEvents[indexPath.row]

            cell.lbl_EventName.text = "+\(data["time"].stringValue)"
            let arr = data["date_time"].stringValue.components(separatedBy: " ")
            cell.lbl_Addrss.text = arr[0]


           return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 51

    }
}
