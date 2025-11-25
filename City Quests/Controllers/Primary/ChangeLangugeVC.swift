//
//  ChangeLangugeVC.swift
//  VIBRAS
//
//  Created by mac on 18/01/23.
//

import UIKit


class TransactionTableCell: UITableViewCell {
    @IBOutlet weak var img_Tr: UIImageView!
    @IBOutlet weak var lbl_Detail: UILabel!
    @IBOutlet weak var lbl_lang: UILabel!
}
class ChangeLangugeVC: UIViewController {
    
    //Mark:- IBOutelts
    @IBOutlet weak var tblView: UITableView!
    
    var arrLangu = ["English","Spanish"]
    var isIndex:Int! = 0
    var strFrom:Int! = 1

    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func backBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func langua(_ sender: UIButton) {
      
        if strFrom == 0 {

            if isIndex == 0 {
                UserDefaults.standard.set("en", forKey: KLanaguage)
                changePassAPICall(strLang: "en")
            } else {
                UserDefaults.standard.set("sp", forKey: KLanaguage)
                changePassAPICall(strLang: "sp")
            }

        } else {
            
            
            if isIndex == 0 {
//               LLanguage.appleLanguage = LanguageIdEnum.english.rawValue
//               LLocalizer.doBaseInternationalization()
                UserDefaults.standard.set("en", forKey: KLanaguage)
                autoLoginUserWith(strK: "en")
            } else {
//                LLanguage.appleLanguage = LanguageIdEnum.spanish.rawValue
//                LLocalizer.doBaseInternationalization()
                UserDefaults.standard.set("sp", forKey: KLanaguage)
                autoLoginUserWith(strK: "sp")
            }


        }

    }
    
    func changePassAPICall(strLang:String){
      
        let param:[String:Any] = ["user_id":Singleton.shared.userID ?? "",
                                  "language":strLang]
        
//        ActivityIndicator.show(view: self.view, color: .black)
//        SessionManager.shared.methodForApiCalling(url: U_BASE + "change_language", method: .post, parameter: param, objectClass: Response.self, requestCode: U_CHANGE_PASSWORD, userToken: nil) { [self] response in
//
//            if isIndex == 0 {
//                UserDefaults.standard.set("en", forKey: KLanaguage)
//                LLanguage.appleLanguage = LanguageIdEnum.english.rawValue
//                LLocalizer.doBaseInternationalization()
//                autoLoginUser(strK: "en")
//
//            } else {
//                UserDefaults.standard.set("sp", forKey: KLanaguage)
//                LLanguage.appleLanguage = LanguageIdEnum.spanish.rawValue
//                LLocalizer.doBaseInternationalization()
//                autoLoginUser(strK: "sp")
//
//            }
//        }
    }

    func autoLoginUserWith(strK:String) {
        
        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginUsreVC") as! LoginUsreVC
        self.navigationController?.pushViewController(nVC, animated: true)
        
    }
    
    func autoLoginUser(strK:String){
        
        var window : UIWindow?
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

//        if UserDefaults.standard.value(forKey: USERTYPE) as? String != nil {
//
//            if UserDefaults.standard.value(forKey: USERTYPE) as! String == "USER" {
//
//                Singleton.shared.userID = UserDefaults.standard.value(forKey: UD_USERID) as? String
//                Singleton.shared.userType = "user"
//                Singleton.shared.language =  strK
//                UserDefaults.standard.set(strK, forKey: KLanaguage)
//                let centerVC: TabBarVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//                self.navigationController?.pushViewController(centerVC, animated: true)
//
//
//            } else {
//
//                Singleton.shared.userID = UserDefaults.standard.value(forKey: UD_USERID) as? String
//                Singleton.shared.userType = "company"
//                Singleton.shared.language =  strK
//                UserDefaults.standard.set(strK, forKey: KLanaguage)
//
//                let centerVC: CompanyTabBarVC = mainStoryboard.instantiateViewController(withIdentifier: "CompanyTabBarVC") as! CompanyTabBarVC
//                let centerNavVC = UINavigationController(rootViewController: centerVC)
//                self.navigationController?.pushViewController(centerVC, animated: true)
//
//            }
//
//        }
        
    }

}

extension ChangeLangugeVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLangu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "TransactionTableCell", for: indexPath) as! TransactionTableCell
        cell.lbl_lang.text = arrLangu[indexPath.row]
        
        if indexPath.row == isIndex {
            cell.img_Tr.image = UIImage.init(named: "checkIn")
        } else {
            cell.img_Tr.image = UIImage.init(named: "uncheckIn")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isIndex = indexPath.row
        tblView.reloadData()
    }

}
