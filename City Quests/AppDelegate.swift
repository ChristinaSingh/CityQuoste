
import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import SwiftyJSON

//import Instabug
//0527984448
//Pharma01
//Play Store

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? 
    var CURRENT_LAT = "23.51366763042601"
    var CURRENT_LON = "-102.20122149999999"
    var isValidLocation:Bool = true
    var coordinate1 = CLLocation(latitude: 0.0, longitude: 0.0)
    var coordinate2 = CLLocation(latitude: 0.0, longitude: 0.0)

    var strEventTeamNam:String! = ""
    var strEventCode:String! = ""
    var dicCurrentEvent:JSON!
    var dicCurrentVirus:JSON!

    var dicCurrentQuestion:JSON!
    var strIsFrom:String! = ""
    var strGameName:String! = ""
    var dicCurrentlevle:JSON!
    var strLevelId:String! = "1"


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.isEnabled = true
        LocationManager.sharedInstance.delegate = APP_DELEGATE
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.startUpdatingLocation()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true

       
        USER_DEFAULT.set("IOS123", forKey: IOS_TOKEN)
        UIApplication.shared.applicationIconBadgeNumber = 0
        Singleton.shared.language = "sp"
    
        Switcher.updateRootVC()
        
//        if (self.isRunningLive()) {app_icon
//            Instabug.start(withToken: "363d05776701b35c675d4b9279bead47", invocationEvents: [.floatingButton, .shake, .screenshot])
//        } else {
//            Instabug.start(withToken: "9e8c43305be9d5b6ba103305bac93738", invocationEvents: [.floatingButton, .shake, .screenshot])
////get_event_instructions_game_images
//
//        }
//        CrashReporting.enabled = true

//        Instabug.willSendReportHandler = { report in
//            report.appendTag("tag1")
//            report.logVerbose("Verbose log.")
//            report.append(toConsoleLogs: "Console log statement.")
//            report.setUserAttribute("value", withKey: "key")
//
//            return report
//        }
        return true
        
        
        
    }
    func isRunningLive() -> Bool {
         #if targetEnvironment(simulator)
        return false
        #else
        let isRunningTestFlightBeta  = (Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt")
        let hasEmbeddedMobileProvision = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil
        if (isRunningTestFlightBeta || hasEmbeddedMobileProvision) {
            return false
        } else {
            return true
        }
        #endif
    }

    func applicationWillResignActive(_ application: UIApplication) {
   
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
//    func configureNotification() {
//
//        if #available(iOS 10.0, *) {
//            let center = UNUserNotificationCenter.current()
//            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
//        }
//        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//        UIApplication.shared.registerForRemoteNotifications()
//
//    }
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        Messaging.messaging().token { token, error in
//            if let error = error {
//                print("Error fetching FCM registration token: \(error)")
//            } else if let token = token {
//                print("FCM registration token: \(token)")
//                USER_DEFAULT.set(token, forKey: IOS_TOKEN)
//                //k.iosRegisterId = token
//            }
//        }
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        // k.iosRegisterId = deviceTokenString
//        Messaging.messaging().apnsToken = deviceToken
//        print("APNs device token: \(deviceTokenString)")
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("APNs registration failed: \(error)")
//
//    }
//
//    // MARK:-  Received Remote Notification
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//        print("Call APNS")
//        NotificationCenter.default.post(name: NSNotification.Name("NewMessage"), object: "On Ride", userInfo: nil)
//        if let info = userInfo["aps"] as? Dictionary<String, AnyObject> {
//            print(info)
//        }
////        let visibleVC = UIApplication.topViewController()
////        if visibleVC is UserChat {
////            completionHandler()
////        } else {
//            completionHandler(UIBackgroundFetchResult.newData)
//        //}
//    }
//

}

extension AppDelegate:LocationManagerDelegate {
    
    func tracingLocation(currentLocation: CLLocation) {
        coordinate2 = currentLocation
        let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
        if distanceInMeters > 250 {
            CURRENT_LAT = String(currentLocation.coordinate.latitude)
            CURRENT_LON = String(currentLocation.coordinate.longitude)
            coordinate1 = currentLocation
        }
        
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        
    }

}

//MARK:Extention

//extension AppDelegate: UNUserNotificationCenterDelegate {
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        print(userInfo)
//        NotificationCenter.default.post(name: NSNotification.Name("NewMessage"), object: "On Ride", userInfo: nil)
//        print("Call FCM")
//
//        if let info = userInfo as? Dictionary<String, AnyObject> {
//            let alert1 = info["aps"]!["alert"] as! Dictionary<String, AnyObject>
//            let title = alert1["title"] as! String
//            hanleNotification(info: info, strStatus: title, strFrom: "Back")
//
//        }
//        completionHandler()
//    }
//
//    //MARK:GoViewCotroller
//
//    func hanleNotification(info:Dictionary<String,AnyObject>,strStatus:String,strFrom:String) {
//
//        let visibleVC = UIApplication.topViewController()
//        goChatVC()
//
//        if strStatus == "Your driver has Start" || strStatus == "Your driver has Arrived" || strStatus == "Your driver has Arrived" || strStatus == "Your driver has on the way" {
//
////            if visibleVC is ShowOnMapVC {
////                NotificationCenter.default.post(name: Notification.Name("ChangeStatus"), object: nil, userInfo: ["Renish":"Dadhaniya"])
////            } else {
////                Switcher.updateAcceptRootVC()
////            }
//
//        } else if strStatus == "request is Finish."  {
//          //  Switcher.updateRootVC()
//
//        } else if strStatus == "booking order accepted"  {
//          //  Switcher.updateRootVC()
//
//        }
//
//    }
//
//    func goChatVC() {
//        let visibleVC = UIApplication.topViewController()!
//        visibleVC.tabBarController?.selectedIndex = 2
//        //    Utility.showAlertMessage(withTitle: APPNAME, message: "", delegate: nil, parentViewController: visibleVC)
//    }
//
//    func OpenNewme(dict:NSDictionary,application:UIApplication) {
//        //        let visibleVC = UIApplication.topViewController()
//        //        let vc = Mainboard.instantiateViewController(withIdentifier: "UserChat") as! UserChat
//        //        visibleVC?.navigationController?.pushViewController(vc, animated: true)
//    }
//
//}
