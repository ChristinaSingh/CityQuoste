//
//  CabanaVC.swift
//  City Quests
//
//  Created by mac on 18/08/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

class CabanaVC: UIViewController {
    
    @IBOutlet weak var transViewOpt: UIView!
    @IBOutlet weak var lbl_AnTap: UILabel!
    @IBOutlet weak var height_table: NSLayoutConstraint!

    @IBOutlet weak var lbl_Answe: UILabel!
    @IBOutlet weak var btnGIve: UIButton!
    @IBOutlet weak var btnHint: UIButton!
    @IBOutlet weak var view_Text: UIView!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var text_Answer: UITextField!
    @IBOutlet weak var lbl_Timer: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
    @IBOutlet weak var table_Answer: UITableView!

    
    var arrAllQuestion:[JSON]! = []
    var isCurrentQuestion:Int! = 0
    var dicCurrentQuestion:JSON!

    var totalSecond = Int()
    var timer:Timer?

    
    var arroption:[String] = []
    var isIndex:Int! = -1
    var arroptionAdnswer:[String] = ["A","B","C","D"]
    var isAnswer:String! = ""
    var strCustom:String! = "no"

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        WebGetVirusQues()
        transView.isHidden = true
        transViewOpt.isHidden = true

        self.navigationController?.navigationBar.isHidden = false
     
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")


    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()

    }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }

    @objc func countdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int

//        if totalSecond == 0 {
//            timer?.invalidate()
//        }
        totalSecond = totalSecond + 1
        hours = totalSecond / 3600
        minutes = (totalSecond % 3600) / 60
        seconds = (totalSecond % 3600) % 60
        lbl_Timer.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    @IBAction func submitt(_ sender: Any) {

        
        if dicCurrentQuestion["custom_ans"].stringValue != "" {

            if text_Answer.text?.count != 0 {
                isAnswer = text_Answer.text!
                WebFinalAnswerGame()
            } else {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Enter answer", on: self)

            }

        } else {
            if isIndex != -1 {
                WebFinalAnswerGame()
            } else {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Choose option", on: self)

            }

        }
//        if text_Answer.text?.count != 0 {
//            WebFinalAnswerGame()
//        } else {
//            if dicCurrentQuestion["option_Ans"].stringValue == "None" {
//                changeQuestion()
//            } else {
//                print("Yes all")
//            }
//        }

    }
    @IBAction func Croono(_ sender: Any) {
        transViewOpt.isHidden = true
    }
    @IBAction func no(_ sender: Any) {
        transView.isHidden = true
    }
    @IBAction func yes(_ sender: Any) {
        transView.isHidden = true
        WebAddPenality()
    }
    @IBAction func SubmitAnswer(_ sender: Any) {
        transViewOpt.isHidden = false

    }
    @IBAction func GiveUp(_ sender: Any) {
        transView.isHidden = false
    }
    @IBAction func Hint(_ sender: Any) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "HIntAnswerVC") as! HIntAnswerVC
        objVC.completion = {
        }
        objVC.arroption = ["Show Hint1 (2 minutes penalty)","Show Hint2 (5 minutes penalty)"]
        objVC.dicCurrentQuestion =  dicCurrentQuestion
        objVC.strFrom =  "virus"
        objVC.modalPresentationStyle = .overCurrentContext
        objVC.modalTransitionStyle = .crossDissolve
        self.present(objVC, animated: false, completion: nil)
    }

    func changeQuestion()  {
       
        isCurrentQuestion += 1

        if arrAllQuestion.count > isCurrentQuestion {
            
            dicCurrentQuestion = arrAllQuestion[isCurrentQuestion]
            
            if dicCurrentQuestion["option_Ans"].stringValue == "None" {
             
//                view_Text.isHidden = true
                btnHint.isHidden = true
                btnGIve.isHidden = true
                lbl_Answe.isHidden = true
             
                btn_Submit.setTitle("Next", for: .normal)

            } else {
              
//                view_Text.isHidden = false
                btnHint.isHidden = false
                btnGIve.isHidden = false
                lbl_Answe.isHidden = false
              
                btn_Submit.setTitle("Answer", for: .normal)

                callAnswrTextAndOPtion()

            }
            
            img_user.sd_setImage(with: URL(string: dicCurrentQuestion["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
            text_Detail.attributedText = dicCurrentQuestion["instructions"].stringValue.htmlToAttributedString
            text_Answer.text = ""

        } else {
            
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "EndGameVC") as! EndGameVC
            nVC.strFromVirus = "virus"
            self.navigationController?.pushViewController(nVC, animated: true)

        }
        

    }
    
    func callAnswrTextAndOPtion()  {
        
        view_Text.isHidden = true
        lbl_AnTap.isHidden = true
        arroption = []
        
        if dicCurrentQuestion["custom_ans"].stringValue != "" {
            
            view_Text.isHidden = false
            lbl_AnTap.isHidden = false
            strCustom = "yes"
            height_table.constant = 0
            
            
        } else {
            height_table.constant = 280

            arroption.append(dicCurrentQuestion["option_A"].stringValue)
            arroption.append(dicCurrentQuestion["option_B"].stringValue)
            arroption.append(dicCurrentQuestion["option_C"].stringValue)
            arroption.append(dicCurrentQuestion["option_D"].stringValue)

        }
//        } else if dicCurrentQuestion["option_A"].stringValue != "" {
//            arroption.append(dicCurrentQuestion["option_A"].stringValue)
//            height_table.constant = 70
//        } else if dicCurrentQuestion["option_B"].stringValue != "" {
//            arroption.append(dicCurrentQuestion["option_B"].stringValue)
//            height_table.constant = 140
//        } else if dicCurrentQuestion["option_C"].stringValue != "" {
//            arroption.append(dicCurrentQuestion["option_C"].stringValue)
//            height_table.constant = 210
//        } else if dicCurrentQuestion["option_D"].stringValue != "" {
//            arroption.append(dicCurrentQuestion["option_D"].stringValue)
//            height_table.constant = 280
//
//        }

        table_Answer.reloadData()

    }
    func WebAddPenality() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   dicCurrentQuestion["event_id"].stringValue as AnyObject
        paramsDict["event_instructions_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["time"]     =   "10" as AnyObject
        paramsDict["hint_type"]     =   "3" as AnyObject
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.add_virus_hint.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    
                    callAnswrTextAndOPtion()
                    text_Answer.text = dicCurrentQuestion["option_Ans"].stringValue
                    transViewOpt.isHidden = false
                    isAnswer = dicCurrentQuestion["option_Ans"].stringValue
                    isIndex = arroptionAdnswer.firstIndex(of: isAnswer)
                    table_Answer.reloadData()

                } else if(swiftyJsonVar["status"].stringValue == "2") {
                    
                    callAnswrTextAndOPtion()
                    text_Answer.text = dicCurrentQuestion["option_Ans"].stringValue
                    transViewOpt.isHidden = false
                    isAnswer = dicCurrentQuestion["option_Ans"].stringValue
                    isIndex = arroptionAdnswer.firstIndex(of: isAnswer)
                    table_Answer.reloadData()

//                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: swiftyJsonVar["result"].stringValue, on: self)
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

    func WebGetVirusQues() {
       
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentVirus["id"].stringValue as AnyObject
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject

        
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_virus_event_answer_new.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    
                    arrAllQuestion = swiftyJsonVar["result"].arrayValue
                    dicCurrentQuestion = arrAllQuestion[isCurrentQuestion]
                    img_user.sd_setImage(with: URL(string: dicCurrentQuestion["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
                    text_Detail.attributedText = dicCurrentQuestion["instructions\(Singleton.shared.languagePar!)"].stringValue.htmlToAttributedString
                    

                    callAnswrTextAndOPtion()

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

    func WebFinalAnswerGame() {
    
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_code"]     =   kappDelegate.strEventCode as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentVirus["id"].stringValue as AnyObject
        paramsDict["event_game_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["ans"]     =   isAnswer as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.add_virus_event_ans.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in

            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    changeQuestion()
                    transViewOpt.isHidden = true

                } else if(swiftyJsonVar["status"].stringValue == "2") {
                    changeQuestion()
                    transViewOpt.isHidden = true

                } else  {
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

extension CabanaVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arroption.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_Answer.dequeueReusableCell(withIdentifier: "TransactionTableCell", for: indexPath) as! TransactionTableCell
       
        cell.lbl_lang.text = arroption[indexPath.row]
        
        if indexPath.row == isIndex {
            cell.img_Tr.image = UIImage.init(named: "checkIn")
        } else {
            cell.img_Tr.image = UIImage.init(named: "uncheckIn")
        }
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isIndex = indexPath.row
        isAnswer = arroptionAdnswer[indexPath.row]
        table_Answer.reloadData()
    }

}

