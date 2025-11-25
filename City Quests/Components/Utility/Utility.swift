//
//  Utility.swift
//  Shipit
//
//  Created by mac on 24/09/18.
//  Copyright © 2018 Technorizen. All rights reserved.
//

import UIKit
import MapKit
import Photos

class Utility {
    
    class func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    class func isValidMobileNumber(_ mobileNo: String) -> Bool {
        let mobileNumberPattern: String = "^[0-9]{10}$"
        //@"^[7-9][0-9]{9}$";
        let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", mobileNumberPattern)
        let isValid: Bool = mobileNumberPred.evaluate(with: mobileNo)
        return isValid
    }
    
    class func isValidPassword(_ password: String) -> Bool {
        let mobileNumberPattern: String = "^[0-9]{4}$"
        //@"^[7-9][0-9]{9}$";
        let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", mobileNumberPattern)
        let isValid: Bool = mobileNumberPred.evaluate(with: password)
        return isValid
    }
    
    class func isValidEmail(_ email: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid: Bool = emailPred.evaluate(with: email)
        return isValid
    }
    
    class func isValidPinCode(_ pincode: String) -> Bool {
        let pinRegex: String = "^[0-9]{6}$"
        let pinTest = NSPredicate(format: "SELF MATCHES %@", pinRegex)
        let pinValidates: Bool = pinTest.evaluate(with: pincode)
        return pinValidates
    }
    
    class func getDateFrom(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        return date!
    }
    
    class func getDateString(withAMPM dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = "dd/MMM/yyyy "
        let dateAMPM: String = dateFormatterAMPM.string(from: date!)
        return dateAMPM
    }
    class func getDateStringTime(withAMPM dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = "dd/MMM/yyyy HH:mm:ss"
        let dateAMPM: String = dateFormatterAMPM.string(from: date!)
        return dateAMPM
    }
    class func getDateStringString(withAMPM dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = "hh:mm a"
        let dateAMPM: String = dateFormatterAMPM.string(from: date!)
        return dateAMPM
    }
    
    class func getDateTimeString(withAMPM dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = "dd-MMM-yyyy hh:mm a"
        var dateAMPM:String = ""
        if let dateS = date {
            dateAMPM = dateFormatterAMPM.string(from: dateS)
        }
        return dateAMPM
    }
    
    class func getStringDateFromStringDate(withAMPM dateString: String, outputFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = outputFormate
        var dateAMPM:String = ""
        if let dateS = date {
            dateAMPM = dateFormatterAMPM.string(from: dateS)
        }
        return dateAMPM
    }
    
    class func showAlertMessage(withTitle title: String, message msg: String, delegate del: Any?, parentViewController parentVC: UIViewController) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        //You can use a block here to handle a press on this button
        alertController.addAction(actionOk)
        parentVC.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithAction(withTitle title: String, message msg: String, delegate del: Any?, parentViewController parentVC: UIViewController, completionHandler: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style {
            case .default:
                completionHandler(true)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        parentVC.present(alert as UIViewController, animated: true, completion: nil)
    }
    
    class func showAlertYesNoAction(withTitle title: String, message msg: String, delegate del: Any?, parentViewController parentVC: UIViewController, completionHandler: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style {
            case .default:
                completionHandler(true)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            switch action.style {
            case .default:
                completionHandler(false)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        parentVC.present(alert as UIViewController, animated: true, completion: nil)
    }
    
    class func isUserLogin ()-> Bool {
        if (UserDefaults.standard.bool(forKey: "user_login_status")) {
            return true
        }
        return false
    }
    
    class func checkNetworkConnectivityWithDisplayAlert( isShowAlert : Bool) -> Bool{
        let isNetworkAvaiable = InternetUtilClass.sharedInstance.hasConnectivity()
        return isNetworkAvaiable;
    }
    
    class func getStringFromDate(_ date: Date, outputFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormate
        let newDate = dateFormatter.string(from: date) //pass Date here
        return newDate
    }
    
    class func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    class func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    class func noDataFound(_ message: String, tableViewOt: UITableView, parentViewController parentVC: UIViewController) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableViewOt.bounds.size.width, height: tableViewOt.bounds.size.height))
      
        let center = (tableViewOt.bounds.size.width/2)
        let center_y = (tableViewOt.bounds.size.height/2)
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: center_y - 25, width: tableViewOt.bounds.size.width, height: 20))
        label.font = label.font.withSize(17.0)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.text = message
//        label.textColor = parentVC.hexStringToUIColor(hex: "#5A5C63")
        label.textColor = .darkGray
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        
        view.addSubview(label)
        tableViewOt.backgroundView = view
    }
    class func noDataFoundCollection(_ message: String, tableViewOt: UICollectionView, parentViewController parentVC: UIViewController) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableViewOt.bounds.size.width, height: tableViewOt.bounds.size.height))
      
        let center = (tableViewOt.bounds.size.width/2)
        let center_y = (tableViewOt.bounds.size.height/2)
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: center_y - 25, width: tableViewOt.bounds.size.width, height: 20))
        label.font = label.font.withSize(17.0)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.text = message
//        label.textColor = parentVC.hexStringToUIColor(hex: "#5A5C63")
        label.textColor = .darkGray
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        
        view.addSubview(label)
        tableViewOt.backgroundView = view
    }
    class func getLocationByCoordinates (location: CLLocation, successBlock success: @escaping (_ address: String) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                let address = (formattedAddress.joined(separator: ", "))
                success(address)
            }
        })
    }
    
    class func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = LocationManager.sharedInstance.lastLocation {
            let geocoder = CLGeocoder()
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        } else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    class func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
extension UIApplication {
    class var topViewController: UIViewController? { return getTopViewController() }
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }

    private class func _share(_ data: [Any],
                              applicationActivities: [UIActivity]?,
                              setupViewControllerCompletion: ((UIActivityViewController) -> Void)?) {
        let activityViewController = UIActivityViewController(activityItems: data, applicationActivities: nil)
        setupViewControllerCompletion?(activityViewController)
        UIApplication.topViewController?.present(activityViewController, animated: true, completion: nil)
    }

    class func share(_ data: Any...,
                     applicationActivities: [UIActivity]? = nil,
                     setupViewControllerCompletion: ((UIActivityViewController) -> Void)? = nil) {
        _share(data, applicationActivities: applicationActivities, setupViewControllerCompletion: setupViewControllerCompletion)
    }
    class func share(_ data: [Any],
                     applicationActivities: [UIActivity]? = nil,
                     setupViewControllerCompletion: ((UIActivityViewController) -> Void)? = nil) {
        _share(data, applicationActivities: applicationActivities, setupViewControllerCompletion: setupViewControllerCompletion)
    }
}
extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        self.view.window!.layer.add(transition, forKey: kCATransition)
//        present(viewControllerToPresent, animated: false)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)

    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
    
}
class AnimationView: UIView {
    enum Direction: Int {
        case FromLeft = 0
        case FromRight = 1
    }

    @IBInspectable var direction : Int = 0
    @IBInspectable var delay :Double = 0.0
    @IBInspectable var duration :Double = 0.0
    override func layoutSubviews() {
        initialSetup()
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            if let superview = self.superview {
                           if self.direction == Direction.FromLeft.rawValue {
                               self.center.x += superview.bounds.width
                           } else {
                               self.center.x -= superview.bounds.width
                           }
                       }
        })
    }
    func initialSetup() {
        if let superview = self.superview {
            if direction == Direction.FromLeft.rawValue {
             self.center.x -= superview.bounds.width
            } else {
                self.center.x += superview.bounds.width
            }

        }
    }
}
