//
//  ProfileVC.swift
//  City Quests
//
//  Created by mac on 28/03/23.
//

import UIKit
import SwiftyJSON

class ProfileVC: UIViewController {
    
    @IBOutlet weak var text_Email: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Edit Details", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        CheckGetAPI()
        
    }
    @IBAction func deleteAcc(_ sender: Any) {
        logout()
    }
    func logout() {
        let alertController = UIAlertController(title: APP_NAME, message: "Are you sure you want to delete account?", preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { [self] action -> Void in
        
            deleteAcc()
        }
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
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
                errorMessage = Languages.PleaseEnterValidEmail
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
            paramsDict["user_id"]     =   kUserDefault.value(forKey: USERID) as AnyObject

            print(paramsDict)
        
            CommunicationManeger.callPostService(apiUrl: Router.update_profile.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
                
                DispatchQueue.main.async { [self] in
                    let swiftyJsonVar = JSON(responseData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["status"] == "1") {
                        self.perform(#selector(gBack), with: nil, afterDelay: 1.0)
                        GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Update Successfully", on: self)
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
    func deleteAcc() {
        showProgressBar()
        
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   kUserDefault.value(forKey: USERID) as AnyObject
       
        print(paramsDict)
    
        CommunicationManeger.callPostService(apiUrl: Router.account_delete.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"] == "successfull") {
                    UserDefaults.standard.removeObject(forKey: USERID)
                    UserDefaults.standard.synchronize()
                    Switcher.updateRootVC()
                    
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

    func CheckGetAPI() {
        showProgressBar()
        
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   kUserDefault.value(forKey: USERID) as AnyObject
       
        print(paramsDict)
    
        CommunicationManeger.callPostService(apiUrl: Router.get_profile.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"] == "1") {
                    text_Email.text = swiftyJsonVar["result"]["email"].stringValue
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
