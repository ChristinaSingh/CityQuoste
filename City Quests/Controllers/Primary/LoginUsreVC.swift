//
//  LoginUsreVC.swift
//  AdSpot
//
//  Created by mac on 08/01/22.
//

import UIKit
import SwiftyJSON

class LoginUsreVC: UIViewController {
    
    @IBOutlet weak var termsAndConditionLbl: UILabel!
    @IBOutlet weak var btn_Signup: UIButton!
    @IBOutlet weak var text_Pass: UITextField!
    @IBOutlet weak var text_Email: UITextField!
    
    var strType:String! = ""
    var strCode:String! = "+971"
    var countryList = CountryList()

    override func viewDidLoad() {
        super.viewDidLoad()
  
        termsAndConditions()
        termsAndConditionLbl.hyperLinkTwow(originalText: Languages.PTfull, hyperLink: Languages.privac, hyperLink2: Languages.terms, urlString: "", urlString2: "")
    
//        let strNumber: NSString = Languages.registerHa as NSString
//        let range = (strNumber).range(of: Languages.Signup)
//        let attribute = NSMutableAttributedString.init(string: Languages.registerHa)
//        attribute.addAttribute(.foregroundColor, value: UIColor.black, range: range)
//        btn_Signup.setAttributedTitle(attribute, for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Login", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
    }
    
    func termsAndConditions(){
        self.termsAndConditionLbl.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.termsAndConditionLbl.addGestureRecognizer(tapGesture)
    }
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer){
        guard let text = self.termsAndConditionLbl.text else { return }
        var privacyPolicyRange = (text as NSString).range(of: "Privacy Policy")
        var termsConditionsRange = (text as NSString).range(of: "Terms & Conditions")
        if gesture.didTapAttributedTextInLabel(label: self.termsAndConditionLbl, inRange: privacyPolicyRange) {
       //     Term & Conditions
                    print("user tapped on privacy policy text")
            let tcVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            tcVC.screenType = "P"
            self.navigationController?.pushViewController(tcVC, animated: true)
                } else if gesture.didTapAttributedTextInLabel(label: self.termsAndConditionLbl, inRange: termsConditionsRange){
                    print("user tapped on terms and conditions text")
                    let tcVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                    tcVC.screenType = "T"
                    self.navigationController?.pushViewController(tcVC, animated: true)
                }
    }

    
    @IBAction func loginUser(_ sender: Any) {
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
        } else if (text_Pass.text?.count == 0) {
            isValid = false
            errorMessage = "Please Enter Password"
            text_Pass.becomeFirstResponder()
        }
        if (isValid == false) {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: errorMessage, on: self)
        }
        return isValid
    }

    
    //MARK: API
    func CheckEmailStatus() {
        
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
   
        paramsDict["email"]     =   self.text_Email.text! as AnyObject
        paramsDict["password"]  =   self.text_Pass.text! as AnyObject
        paramsDict["ios_register_id"]  =   USER_DEFAULT.value(forKey: IOS_TOKEN) as AnyObject?

        print(paramsDict)
        
        CommunicationManeger.callPostService(apiUrl: Router.logIn.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"] == "successfull") {
                    USER_DEFAULT.set(swiftyJsonVar["result"]["id"].stringValue, forKey: USERID)
                    Switcher.updateRootVC()
//                    let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                    self.navigationController?.pushViewController(objVC, animated: true)

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

    @IBAction func dealer(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(objVC, animated: true)

    }
    
    @IBAction func login(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    

}
extension LoginUsreVC:CountryListDelegate {
    
    func selectedCountry(country: Country) {
        print(country.name)
        print(country.flag)
        print(country.countryCode)
        print(country.phoneExtension)
        strCode = "+\(country.phoneExtension)"
    //    lbl_Coin.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
    }
}
