//
//  HIntAnswerVC.swift
//  City Quests
//
//  Created by mac on 30/03/23.
//

import UIKit
import SwiftyJSON
import SDWebImage
import MapKit


class HIntAnswerVC: UIViewController {
    
   
    @IBOutlet weak var table_list: UITableView!
    @IBOutlet weak var trans_View: UIView!
    
    var completion: (() -> Void)?
    var dicCurrentQuestion:JSON!
    var arroption:[String] = []
    var arroptionAdnswer:[String] = ["2","5","10"]
    var arrHint:[String] = ["","",""]
    
    var isIndex:Int! = -1
    var strPenalityTime:String! = ""
    var strFrom:String! = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_list.estimatedRowHeight = 100
        table_list.rowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }

    
    @IBAction func useAcode(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    func WebAddPenality() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   dicCurrentQuestion["event_id"].stringValue as AnyObject
        paramsDict["event_instructions_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["time"]     =   strPenalityTime as AnyObject
        paramsDict["hint_type"]     =   "\(isIndex!)" as AnyObject
        paramsDict["level"]     =   kappDelegate.strLevelId as AnyObject

        var strAPI:String! = ""

        if strFrom == "virus" {
            strAPI = Router.add_virus_hint.url()
        } else {
            strAPI = Router.add_hint.url()
        }
        
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: strAPI, parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    arrHint[isIndex - 1] = dicCurrentQuestion["instructions_hint\(isIndex!)"].stringValue
                    table_list.reloadData()
                } else {
                    arrHint[isIndex - 1] = dicCurrentQuestion["instructions_hint\(isIndex!)"].stringValue
                    table_list.reloadData()
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

    func isValidHtmlString(_ value: String) -> Bool {
        if value.isEmpty {
            return false
        }
        return (value.range(of: "<(\"[^\"]*\"|'[^']*'|[^'\">])*>", options: .regularExpression) != nil)
    }


}
extension HIntAnswerVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arroption.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_list.dequeueReusableCell(withIdentifier: "TransactionTableCell", for: indexPath) as! TransactionTableCell
       
        cell.lbl_lang.text = arroption[indexPath.row]
      //  cell.lbl_Detail.attributedText = arrHint[indexPath.row].htmlToAttributedString
    //    cell.lbl_Detail.text = arrHint[indexPath.row]
        
        if isValidHtmlString(arrHint[indexPath.row]) {
            cell.lbl_Detail.setHTMLFromString(htmlText: arrHint[indexPath.row])
        } else {
            cell.lbl_Detail.text = arrHint[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isIndex = 0
        isIndex = indexPath.row + 1
        strPenalityTime = arroptionAdnswer[indexPath.row]
        WebAddPenality()
    }

}
