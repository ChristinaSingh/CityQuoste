
import UIKit
import SwiftyJSON
import SDWebImage

class HistoryDetailVC: UIViewController {
    
    var nearMeEvents:[JSON]! = []
    var arr_Leaderbard:[JSON]! = []

    @IBOutlet weak var table_Leaderboard: UITableView!
    @IBOutlet weak var lbl_TeamMember: UILabel!
    @IBOutlet weak var lbl_TotalPenal: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var img_Event: UIImageView!
    @IBOutlet weak var btnTeam: UIButton!
    @IBOutlet weak var btn_Code: UIButton!
    @IBOutlet weak var tableList: UITableView!
    
    var strCode:String! = ""
    var strCodeId:String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
   
        WebGetFinishTime()
     //   WebGetLeader()
       
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Event Result", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        table_Leaderboard.isHidden = true

    }
    override func rightClick() {
        Switcher.updateRootVC()
    }

    @IBAction func teamInfo(_ sender: Any) {
        btnTeam.backgroundColor = UIColor.init(named: "THEMECOLOR")
        btn_Code.backgroundColor = UIColor.white
        btnTeam.setTitleColor(.black, for: .normal)
        btn_Code.setTitleColor(.systemGray3, for: .normal)
        table_Leaderboard.isHidden = true
        self.tableList.reloadData()

    }
    @IBAction func useAcode(_ sender: Any) {
        btn_Code.backgroundColor = UIColor.init(named: "THEMECOLOR")
        btnTeam.backgroundColor = UIColor.white
        btn_Code.setTitleColor(.black, for: .normal)
        btnTeam.setTitleColor(.systemGray3, for: .normal)
        table_Leaderboard.isHidden = false
        self.table_Leaderboard.reloadData()

    }
    
    func WebGetFinishTime() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_code"]     =   strCode as AnyObject
        paramsDict["event_id"]     =   strCodeId as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_event_finish_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.nearMeEvents = swiftyJsonVar["result"].arrayValue
                    self.tableList.reloadData()
                    let dic = swiftyJsonVar["event_details"]
                    lbl_Name.text = "\(dic["event_name"].stringValue) \n\n Team Name : \(swiftyJsonVar["team_name"].stringValue)"
                    img_Event.sd_setImage(with: URL(string: dic["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

                    lbl_Time.text = swiftyJsonVar["event_total_time"].stringValue
                    lbl_TotalPenal.text = "\(swiftyJsonVar["penalty_time"].stringValue) minutes"
                    lbl_TeamMember.text = "Team Members: 6/\(swiftyJsonVar["total_ticket"].stringValue)"

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    
    func WebGetLeader() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_code"]     =   kappDelegate.strEventCode as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_all_event_finish_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.arr_Leaderbard = swiftyJsonVar["result"].arrayValue
                    self.table_Leaderboard.reloadData()
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }


}
extension HistoryDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == table_Leaderboard {
            return arr_Leaderbard.count
        } else {
            return nearMeEvents.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        
        
        if tableView == table_Leaderboard {
         
            let cell = table_Leaderboard.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JoinedEventCell

            let data = arr_Leaderbard[indexPath.row]

            cell.lbl_EventName.text = "\(data["team_name"].stringValue)"
            cell.lbl_Addrss.text = "\(data["event_total_time"].stringValue)"

            return cell

        } else {

            let cell = tableList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JoinedEventCell

            let data = nearMeEvents[indexPath.row]

            cell.lbl_EventName.text = "+\(data["time"].stringValue)"
            let arr = data["date_time"].stringValue.components(separatedBy: " ")
            cell.lbl_Addrss.text = arr[0]

            return cell

        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if tableView == table_Leaderboard {
         
            return 151

        } else {

            return 51

        }

    }
}

