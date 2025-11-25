//
//  ForgotPasswordVC.swift
//  F5Places
//
//  Created by mac on 22/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SwiftyJSON

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var text_Email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
///event_start_time/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Forgot password", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")


    }
    @IBAction func back(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)

    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        if isValidInput() {
            CheckEmailStatus()
        }
    }
     // MARK: - Validation
        func isValidInput() -> Bool {
            var isValid : Bool = true;
            var errorMessage : String = ""
            if !(GlobalConstant.isValidEmail(text_Email.text!)) {
                isValid = false
                errorMessage = "Please Enter Valid Email"
                text_Email.becomeFirstResponder()
            }
            if (isValid == false) {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: errorMessage, on: self)
            }
            return isValid
        }
        
        //MARK:API
        func CheckEmailStatus() {
            showProgressBar()
            var paramsDict:[String:AnyObject] = [:]
            paramsDict["email"]     =   self.text_Email.text! as AnyObject
            print(paramsDict)
        
            CommunicationManeger.callPostService(apiUrl: Router.forgot_password.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
                
                DispatchQueue.main.async { [self] in
                    let swiftyJsonVar = JSON(responseData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["status"] == "1") {
                        self.perform(#selector(gBack), with: nil, afterDelay: 1.0)
                        GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: swiftyJsonVar["result"].string!, on: self)
                    } else {
                        let message = swiftyJsonVar["message"].string
                        GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: message!, on: self)
                    }
                    self.hideProgressBar()
                }
                
                
            },failureBlock: { (error : Error) in
                self.hideProgressBar()
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
            })
        }
    @objc func gBack()  {
        self.navigationController?.popViewController(animated: true)
    }

}
