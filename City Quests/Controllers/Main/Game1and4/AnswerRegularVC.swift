//
//  AnswerRegularVC.swift
//  SecretMissionSociety
//
//  Created by Gajendra on 25/12/25.
//

import UIKit
import MapKit
import SwiftyJSON
import SDWebImage
import WebKit

class AnswerRegularVC: UIViewController ,UIWebViewDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswerlabel: UILabel!
    @IBOutlet weak var heightAnswer: NSLayoutConstraint!
    @IBOutlet weak var view_Answer: UIView!
    @IBOutlet weak var text_Answer: UITextField!
    @IBOutlet weak var img_Bg: UIImageView!
    @IBOutlet weak var lbl_Count: UILabel!
    @IBOutlet weak var view_A: UIView!
    @IBOutlet weak var height_table: NSLayoutConstraint!
    @IBOutlet weak var img_Answer: UIImageView!
    @IBOutlet weak var view_QuizSolved: UIView!
    @IBOutlet weak var view_Question: UIView!
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var text_Detail: UITextView!
  
    @IBOutlet weak var heightIMage: NSLayoutConstraint!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var table_Answer: UITableView!
    var dicCurrentQuestion:JSON!
   // var arroption:[String] = ["A - LEFT","B - RIGHT","C - CENTER"]
    var arroption:[String] = []
    var arroptionAdnswer:[String] = []

    var isIndex:Int! = -1
   // var arroptionAdnswer:[String] = ["A","B","C"]
    var isAnswer:String! = ""
    var strCustom:String! = "clue"

    var totalSecond = Int()
    var timer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblQuestion.text = dicCurrentQuestion["regular_clue_question"].stringValue
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//
//        if dicCurrentQuestion["timer"].stringValue != "0" {
//            self.navigationController?.navigationBar.isHidden = false
//            view_A.isHidden = true
//
//        } else {
//            self.navigationController?.navigationBar.isHidden = false
//            view_A.isHidden = true
//
//        }
//        if dicCurrentQuestion["timer"].stringValue != "0" {
//            view_A.isHidden = false
//            self.navigationController?.navigationBar.isHidden = true
//            totalSecond = Int(dicCurrentQuestion["timer"].stringValue)!
//            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "bacj", withExtension: "gif")!)
//            let advTimeGif = UIImage.gifImageWithData(imageData!)
//            img_Bg.image = advTimeGif
//            startTimer()
//            
//        } else {
            view_A.isHidden = true
            self.navigationController?.navigationBar.isHidden = false

//        }

        
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: dicCurrentQuestion["event_type"].stringValue, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
  
        transView.isHidden = true
    
//        webView.scrollView.isScrollEnabled = true
//        webView.scrollView.bounces = false
//        webView.allowsBackForwardNavigationGestures = false
        
//        if dicCurrentQuestion["instructions"].stringValue.contains("http") {
//            heightIMage.constant = 0
//            img_user.isHidden = true
//            webView.contentMode = .scaleToFill
//
//        } else {
//            heightIMage.constant = 220
//            img_user.isHidden = false
//            webView.contentMode = .scaleToFill
//
//        }
       

        table_Answer.estimatedRowHeight = 65
        table_Answer.rowHeight = UITableView.automaticDimension

     
   
//        webView.contentMode = .scaleToFill
//        webView.navigationDelegate = self
//        webView.loadHTMLString(Singleton.shared.header + "\(dicCurrentQuestion["instructions"].stringValue)" + "</body>", baseURL: nil)
//        webView.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        webView.isHidden = true
        
        img_user.sd_setImage(with: URL(string: dicCurrentQuestion["regular_clue_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

        heightAnswer.constant = 0
        view_Answer.isHidden = true

//        if dicCurrentQuestion["custom_ans"].stringValue != "" {
//            arroption.append("Or Enter answer")
//            isIndex = 0
//            heightAnswer.constant = 50.0
//            view_Answer.isHidden = false
//            strCustom = "custom"
//            height_table.constant = 70
//        } else {
//        }
 
                    arroption.append(dicCurrentQuestion["regular_clue_A"].stringValue)
                    arroption.append(dicCurrentQuestion["regular_clue_B"].stringValue)
                    arroption.append(dicCurrentQuestion["regular_clue_C"].stringValue)

        arroptionAdnswer.append(dicCurrentQuestion["regular_clue_A"].stringValue)
        arroptionAdnswer.append(dicCurrentQuestion["regular_clue_B"].stringValue)
        arroptionAdnswer.append(dicCurrentQuestion["regular_clue_C"].stringValue)

        table_Answer.reloadData()
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

        if totalSecond <= 0 {
            timer?.invalidate()
            
//            if strCustom == "custom" {
//                isAnswer = dicCurrentQuestion["custom_ans"].stringValue
//            } else  {
//                isAnswer = dicCurrentQuestion["regular_clue_answer"].stringValue
//            }
            WebAddPenality(strepn: "10")
            WebAddAnswer()
            lbl_Count.text = "Time's Up"

        } else {
            totalSecond = totalSecond - 1
            hours = totalSecond / 3600
            minutes = (totalSecond % 3600) / 60
            seconds = (totalSecond % 3600) % 60
            lbl_Count.text = String(format: "%02d",totalSecond)
        }
        
    }

    @IBAction func cross(_ sender: Any) {
        transView.isHidden = true
        if dicCurrentQuestion["timer"].stringValue != "0" {
            self.navigationController?.navigationBar.isHidden = false
            view_A.isHidden = true
            totalSecond = Int(dicCurrentQuestion["timer"].stringValue)!
            timer?.invalidate()
        } else {
            view_A.isHidden = true
        }

    }
    
    @IBAction func gotoMap(_ sender: Any) {
      
        if dicCurrentQuestion["timer"].stringValue != "0" {
            kappDelegate.strIsFrom = "Yes"
            kappDelegate.dicCurrentQuestion = dicCurrentQuestion
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func submitAnswer(_ sender: Any) {
        
        
//        if dicCurrentQuestion["custom_ans"].stringValue != "" {
//            
//            if text_Answer.text?.count != 0 {
//                isAnswer = text_Answer.text!
//
//                if text_Answer.text!.hasSuffix(" ") {
//                    isAnswer = String(text_Answer.text!.dropLast())
//                }
//
//                WebAddAnswer()
//            } else {
//                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Enter answer", on: self)
//
//            }
//            
//        } else {
            if isIndex != -1 {
                WebAddAnswer()
            } else {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Choose option", on: self)

            }

//        }
    }
    @IBAction func hintt(_ sender: Any) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "HIntAnswerVC") as! HIntAnswerVC
        objVC.completion = {
        }
        objVC.arroption = ["Show Hint1 (2 minutes penalty)","Show Hint2 (5 minutes penalty)","Show Hint3 (10 minutes penalty)"]
        objVC.dicCurrentQuestion =  dicCurrentQuestion
        objVC.modalPresentationStyle = .overCurrentContext
        objVC.modalTransitionStyle = .crossDissolve
        self.present(objVC, animated: false, completion: nil)

    }
    @IBAction func answer(_ sender: Any) {
        transView.isHidden = false
        view_QuizSolved.isHidden = true
        view_Question.isHidden = false
    
//        if dicCurrentQuestion["timer"].stringValue != "0" {
//            view_A.isHidden = false
//            self.navigationController?.navigationBar.isHidden = true
//            totalSecond = Int(dicCurrentQuestion["timer"].stringValue)!
//            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "bacj", withExtension: "gif")!)
//            let advTimeGif = UIImage.gifImageWithData(imageData!)
//            img_Bg.image = advTimeGif
//            startTimer()
//
//        } else {
//            view_A.isHidden = true
//            self.navigationController?.navigationBar.isHidden = false
//
//        }

    }
    
    @IBAction func backk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:API
    func WebAddAnswer() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   dicCurrentQuestion["event_id"].stringValue as AnyObject
        paramsDict["event_game_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["ans"]     =   isAnswer as AnyObject
        paramsDict["custom_type"]     =   strCustom as AnyObject
        paramsDict["level"]     =   kappDelegate.strLevelId as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.event_instructions_game_ans.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1" || swiftyJsonVar["status"].stringValue == "2") {
                    transView.isHidden = false
                    view_QuizSolved.isHidden = false
                    view_Question.isHidden = true
                    img_Answer.isHidden = true
                    lblAnswerlabel.text = swiftyJsonVar["message"].stringValue
//                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Elegiste CORRECTAMENTE y por lo tanto te descontamos 5 minutos a tu tiempo", on: self)

//                    img_Answer.sd_setImage(with: URL(string: dicCurrentQuestion["final_puzzle_image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)

                } else {
                 //   lblAnswerlabel.text = swiftyJsonVar["message"].stringValue

                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: swiftyJsonVar["result"].stringValue, on: self)
                    WebAddPenality(strepn: "5")
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    func WebAddPenality(strepn:String) {

        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   dicCurrentQuestion["event_id"].stringValue as AnyObject
        paramsDict["event_instructions_id"]     =   dicCurrentQuestion["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["ans"]     =   isAnswer as AnyObject
        paramsDict["time"]     =   strepn as AnyObject
        paramsDict["hint_type"]     =   "2" as AnyObject
        paramsDict["level"]     =   kappDelegate.strLevelId as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.add_hint.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    
                } else {

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(Singleton.shared.javascript, completionHandler: nil)
        print("sdsdsd")
    }

}

extension AnswerRegularVC: UITableViewDelegate,UITableViewDataSource {
    
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

