

import UIKit
import SwiftyJSON
import SDWebImage
import DropDown

class HomeVC: UIViewController {
    
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var bannerCollecView: UICollectionView!
    @IBOutlet weak var nearestCollecView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //Mark:- Properties
    var indexPath = 0
    var timer:Timer?
    var counter = 0
    var bannerResult:[JSON]! = []
    var nearMeEvents:[JSON]! = []
    var drop = DropDown()
    var allnearMeEvents:[JSON]! = []

    var arrlistCity:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebGetCategory()
        pageControlCall()
        
        arrlistCity = ["Los Angeles, CA","San Francisco. CA","Houston. TX","Dallas, TX","Miami, FL","New York, NY","Boston, MA","Atlanta, GA","Philadelphia, PA","Kansas City, KS","Seattle, WA"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    //    setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Login", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        WebGetEvent()
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = .black
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        self.tabBarController?.tabBar.isHidden = false

    }

    //Mark:- Functions
    func pageControlCall(){
        self.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.pageControl.pageIndicatorTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    //Mark:- Button Actions
    @IBAction func cityy(_ sender: UIButton) {

        drop.anchorView = sender
        drop.dataSource = arrlistCity
        drop.bottomOffset = CGPoint(x: 0, y: 50)
        self.drop.show()
        drop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbl_city.text = item
            
         //   arrlistCity = ["Los Angeles, CA","San Francisco. CA","Houston. TX","Dallas, TX","Miami, FL","New York, NY","Boston, MA","Atlanta, GA","Philadelphia, PA","Kansas City, KS","Seattle, WA"]

            if item == "Houston. TX" {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "1"})
            } 
            else if item == "Los Angeles, CA"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "2"})
            } else if item == "San Francisco. CA"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "3"})
            } else if item == "Miami, FL"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "6"})
            } else if item == "Dallas, TX"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "5"})
            } else if item == "New York, NY"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "7"})
            } else if item == "Boston, MA"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "8"})
            } else if item == "Atlanta, GA"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "10"})
            } else if item == "Kansas City, KS"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "11"})
            } else if item == "Philadelphia, PA"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "12"})
            } else if item == "Seattle, WA"  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "13"})
            }
            else  {
                self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "2"})
            }
            self.nearestCollecView.reloadData()
            self.view.endEditing(true)
        }

    }
    @IBAction func backBannerBtn(_ sender: UIButton){
        if counter > self.bannerResult.count{
            //Singleton.shared.showToast(text: "")
        }else{
            counter = counter - 1
            pageControl.currentPage = counter
            bannerCollecView.scrollToItem(at: IndexPath(item: counter, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
   
    @IBAction func frontBannerBtn(_ sender: UIButton){
     
        if counter <= 0{
            counter = 0
        }
        counter = counter + 1
        if counter >= self.bannerResult.count{
         //   Singleton.shared.showToast(text: "")
        } else {
            pageControl.currentPage = counter
            bannerCollecView.scrollToItem(at: IndexPath(item: counter, section: 0), at: .centeredHorizontally, animated: true)
        }
        
        
    }
    //MARK: API
    func WebGetCategory() {
        showProgressBar()
        let paramsDict:[String:AnyObject] = [:]
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_banner.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.bannerResult = swiftyJsonVar["result"].arrayValue
                    self.bannerCollecView.reloadData()
                    self.pageControl.numberOfPages = self.bannerResult.count
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

    func WebGetEvent() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_event.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.allnearMeEvents = swiftyJsonVar["result"].arrayValue
                    self.nearMeEvents = allnearMeEvents.filter({$0["city_id"].stringValue == "1"})
                    self.lbl_city.text = "Houston. TX"
                    self.nearestCollecView.reloadData()
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

  
}



extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollecView{
            return self.bannerResult.count 
        } else {
            return nearMeEvents.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollecView{
            print("Banner")
            let cell = bannerCollecView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as! BannerCollectionCell
            let data = self.bannerResult[indexPath.row]

       //     cell.imgView.sd_setShowActivityIndicatorView(true)
            cell.imgView.sd_setImage(with: URL(string: data["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
            
            return cell
            
        } else {
            print("Nearestsddsd")
            let cell = nearestCollecView.dequeueReusableCell(withReuseIdentifier: "NearestCollectionCell", for: indexPath) as! NearestCollectionCell
            let data = nearMeEvents[indexPath.row]
            cell.img.sd_setImage(with: URL(string: data["image"].stringValue), placeholderImage: UIImage(named: "NoImageAvailable"), options: .refreshCached, completed: nil)
            cell.lblTime.text = data["event_name"].stringValue

            return cell
        }
        
    }
  

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView == nearestCollecView {
            
            let eventid = nearMeEvents[indexPath.row]["id"].stringValue
            //   arrlistCity = ["Los Angeles, CA","San Francisco. CA","Houston. TX","Dallas, TX","Miami, FL","New York, NY","Boston, MA","Atlanta, GA","Philadelphia, PA","Kansas City, KS","Seattle, WA"]

            if self.lbl_city.text == "Houston. TX" || self.lbl_city.text == "Los Angeles, CA" || self.lbl_city.text == "San Francisco. CA"  || self.lbl_city.text == "Dallas, TX" || self.lbl_city.text == "New York, NY" || self.lbl_city.text == "Boston, MA" || self.lbl_city.text == "Atlanta, GA" || self.lbl_city.text == "Philadelphia, PA" {
        
                if eventid == "4"  || eventid == "2" || eventid == "3" || eventid == "5" || eventid == "6" || eventid == "7" || eventid == "8" || eventid == "9" || eventid == "10" || eventid == "11" || eventid == "12" || eventid == "13" || eventid == "14" || eventid == "15" || eventid == "16" || eventid == "17" || eventid == "18"
                {
                   
                   self.tabBarController?.selectedIndex = 3
                    
                } else if eventid == "1"  {
            
                    kappDelegate.dicCurrentVirus = nearMeEvents[indexPath.row]
                    kappDelegate.strGameName = kappDelegate.dicCurrentVirus["event_name"].stringValue

                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "VirsuHomeVC") as! VirsuHomeVC
                    nVC.isINdex = indexPath.row
                    self.navigationController?.pushViewController(nVC, animated: true)

                } else {
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Available soon", on: self)
                }

                
            } else {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Coming soon", on: self)
            }
            
        } else {

        }
        //get_inventory_event
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollecView{
            return CGSize(width: self.bannerCollecView.frame.width, height: self.bannerCollecView.frame.height)
        } else if collectionView == nearestCollecView {
            return CGSize(width: self.nearestCollecView.frame.width/2 - 5, height: self.nearestCollecView.frame.height/2)
        }  else{
            return CGSize()
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.counter = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}


//Mark:- Collection Cell Class
class BannerCollectionCell: UICollectionViewCell{
    @IBOutlet weak var img_Checked: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
}

class NearestCollectionCell: UICollectionViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
}

