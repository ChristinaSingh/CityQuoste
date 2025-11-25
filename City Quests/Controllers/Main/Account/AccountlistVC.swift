//
//  AccountlistVC.swift
//  City Quests
//
//  Created by mac on 27/03/23.
//

import UIKit

class AccountlistVC: UIViewController {
    
    //Mark:- IBOutelts
    @IBOutlet weak var tblView: UITableView!
    
    var arrLangu = ["Edit Details","Change Password","Play a Game","Visit Website","Privacy Policy","Contact Us","Change Language"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "", CenterTitle: "Edit Details", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: BLACK_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
    }

    @IBAction func langua(_ sender: UIButton) {
      
        logout()
    }
    func logout() {
        let alertController = UIAlertController(title: APP_NAME, message: "Are you sure you want to log out?", preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            UserDefaults.standard.removeObject(forKey: USERID)
            UserDefaults.standard.synchronize()
            Switcher.updateRootVC()
        }
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }

}

extension AccountlistVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLangu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "TransactionTableCell", for: indexPath) as! TransactionTableCell
        cell.lbl_lang.text = arrLangu[indexPath.row]
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(nVC, animated: true)
        } else if indexPath.row == 1 {
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassVC") as! ChangePassVC
            self.navigationController?.pushViewController(nVC, animated: true)
        } else if indexPath.row == 2 {
            self.tabBarController?.selectedIndex = 3
        } else if indexPath.row == 3 {
            if let url = URL(string: "http://cityquests.games/cityquest/") {
                UIApplication.shared.open(url)
            }
        } else if indexPath.row == 4 {
            let tcVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            tcVC.screenType = "P"
            self.navigationController?.pushViewController(tcVC, animated: true)
        } else if indexPath.row == 5 {
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
            self.navigationController?.pushViewController(nVC, animated: true)
        } else if indexPath.row == 6 {
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLangugeVC") as! ChangeLangugeVC
            nVC.strFrom = 0
            self.navigationController?.pushViewController(nVC, animated: true)
        } 
    }

}
