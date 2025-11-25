//
//  ChangePassVC.swift
//  City Quests
//
//  Created by mac on 28/03/23.
//

import UIKit
import SwiftyJSON

class ChangePassVC: UIViewController {
    
    @IBOutlet weak var text_Pass: UITextField!
    @IBOutlet weak var text_New: UITextField!
    @IBOutlet weak var text_Confirm: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Change Password", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        
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
        
        if (text_Pass.text?.count == 0) {
            isValid = false
            errorMessage = "Please Enter Old Password"
            text_Pass.becomeFirstResponder()
        } else if (text_New.text?.count == 0) {
            isValid = false
            errorMessage = "Please Enter New Password"
            text_Pass.becomeFirstResponder()
        } else if (text_Confirm.text?.count == 0) {
            isValid = false
            errorMessage = "Please Enter Confirm Password"
            text_Pass.becomeFirstResponder()
        } else if (text_Confirm.text! != text_New.text!) {
            isValid = false
            errorMessage = "Please Enter Same Password"
            text_Pass.becomeFirstResponder()
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
        paramsDict["old_pass"]     =   self.text_Pass.text! as AnyObject
        paramsDict["new_pass"]     =   self.text_New.text! as AnyObject
        paramsDict["user_id"]     =   kUserDefault.value(forKey: USERID) as AnyObject
        
        print(paramsDict)
        
        CommunicationManeger.callPostService(apiUrl: Router.change_password.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"] == "1") {
                    self.perform(#selector(gBack), with: nil, afterDelay: 1.0)
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Update Password Successfully", on: self)
                } else {
                    let message = "Invalid old password"
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: message, on: self)
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
