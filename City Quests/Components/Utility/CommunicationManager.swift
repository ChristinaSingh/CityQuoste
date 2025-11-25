//
//  CommunicationManager.swift
//  Shipit
//
//  Created by mac on 24/09/18.
//  Copyright © 2018 Technorizen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CommunicationManeger {
    
    //MARK: - POST API Request
    class func callPostService(apiUrl urlString: String, parameters params : [String: AnyObject]?,  parentViewController parentVC: UIViewController, successBlock success : @escaping ( _ responseData : AnyObject, _  message: String) -> Void, failureBlock failure: @escaping (_ error: Error) -> Void) {
        
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            
            var url:String! = ""
            for dic in params! {
                url += "\(dic.key)=\(dic.value)&"
            }
        print("FULL_API_FOR_BROWSER/**************************************************************************************************/ \(urlString)?\(url ?? "")")
            let session = Session.default
            session.sessionConfiguration.timeoutIntervalForRequest = 120

            session.request(urlString, method: .post, parameters: params)

            //ffmethod: .post,
//            let manager = Alamofire.SessionManager.default
//            manager.session.configuration.timeoutIntervalForRequest = 120
//            manager.request(urlString, method: .post, parameters: params)
                .responseJSON {
                    response in
                    switch (response.result) {
                    case .success(let value):
                        print("Success:", value)
                        success(value as AnyObject, "Successfull")
                        break
                    case .failure(let error):
                        print(error)
                        if error._code == NSURLErrorTimedOut {
                            //HANDLE TIMEOUT HERE
                            print(error.localizedDescription)
                            failure(error)
                        } else {
                            print("\n\nAuth request failed with error:\n \(error)")
                            failure(error)
                        }
                        break
                    }
            }
        } else {
            parentVC.hideProgressBar();
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: NETWORK_ERROR_MSG, delegate: nil, parentViewController: parentVC)
        }
    }
        
}
