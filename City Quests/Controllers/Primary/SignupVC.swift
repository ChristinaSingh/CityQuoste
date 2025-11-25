//
//  SignupVC.swift
//  AdSpot
//
//  Created by mac on 08/01/22.
//

import UIKit
import SwiftyJSON

class SignupVC: UIViewController {

    @IBOutlet weak var text_ConfirmPass: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var text_Pass: UITextField!
    @IBOutlet weak var text_Email: UITextField!
    
    var strType:String! = ""
    var strCode:String! = "+91"
    var countryList = CountryList()

    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Create Account", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

    }

 
    @IBAction func signUp(_ sender: Any) {
        if isValidInput() {
            WebSignUp()
        }

    }

    @IBAction func login(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: - Validation
    
    func isValidInput() -> Bool {
        
        var isValid : Bool = true;
        var errorMessage : String = ""
        if !(GlobalConstant.isValidEmail(text_Email.text!)) {
            isValid = false
            errorMessage = "Please Enter Valid Email"
            text_Email.becomeFirstResponder()
        } else if (text_Pass.text?.count == 0) {
            isValid = false
            errorMessage = "Please Enter Password"
            text_Pass.becomeFirstResponder()
        } else if (text_ConfirmPass.text?.count == 0) {
            isValid = false
            errorMessage = "Please Enter Confirm Password"
            text_Pass.becomeFirstResponder()
        } else if (text_ConfirmPass.text! != text_Pass.text!) {
            isValid = false
            errorMessage = "Please Enter Same Password"
            text_Pass.becomeFirstResponder()
        }
        if (isValid == false) {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: errorMessage, on: self)
        }
        return isValid

    }

    //MARK: API
    
    func WebSignUp() {
        
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
   
        paramsDict["email"]     =   self.text_Email.text! as AnyObject
        paramsDict["password"]  =   self.text_Pass.text! as AnyObject
        paramsDict["ios_register_id"]  =   USER_DEFAULT.value(forKey: IOS_TOKEN) as AnyObject?
        paramsDict["register_id"]  =   "IOS" as AnyObject?

        print(paramsDict)
        
        CommunicationManeger.callPostService(apiUrl: Router.signUp.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"] == "1") {
                    self.perform(#selector(gBack), with: nil, afterDelay: 1.0)
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: swiftyJsonVar["message"].string!, on: self)
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
extension SignupVC:CountryListDelegate {
    
    func selectedCountry(country: Country) {
        print(country.name)
        print(country.flag)
        print(country.countryCode)
        print(country.phoneExtension)
        strCode = "+\(country.phoneExtension)"
//        lbl_Coin.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
    }
}
