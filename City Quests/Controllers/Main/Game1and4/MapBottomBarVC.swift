//
//  MapBottomBarVC.swift
//  City Quests
//
//  Created by mac on 27/06/23.
//

import UIKit
import MapKit
import SwiftyJSON

class MapBottomBarVC: UIViewController {
    
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var view_Bottom: UIView!
    @IBOutlet weak var mapView: MKMapView!
   
    var arrlist:[JSON]! = []
    
    var totalSecond = Int()
    var timer:Timer?
    var puzzueDImage:UIImage!
    var isboolPause:Bool! = false
    var strPauseId:String! = ""
    var totalMiliSeco:String! = "0"

    var strStopLat:String! = "0.0"
    var strStoplon:String! = "0.0"

    override func viewDidLoad() {
        super.viewDidLoad()
        btnPause.setImage(UIImage.init(systemName: "pause.circle.fill"), for: .normal)
       // WebGetCode()
        lbl_Time.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        WebGetCode()
    }
    override func viewDidAppear(_ animated: Bool) {
        WebGetTime()
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()

    }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }

    @objc func countdown() {
    
        var hours: Int
        var minutes: Int
        var seconds: Int

        totalSecond = totalSecond + 1
        hours = totalSecond / 3600
        minutes = (totalSecond % 3600) / 60
        seconds = (totalSecond % 3600) % 60
        
        totalMiliSeco = "\(totalSecond * 1000)"
        lbl_Time.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)

    }
    @IBAction func backk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pause(_ sender: Any) {
        
        if isboolPause {
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you're wher you left it?", preferredStyle: .alert)
            let yesAction: UIAlertAction = UIAlertAction(title: "Confirm", style: .default) { [self] action -> Void in
                
                
                if strStopLat != "" && strStopLat != ""  {
                    
                    let coordinate1v = CLLocation(latitude: Double(strStopLat .removingWhitespaces())!, longitude: Double(strStoplon.removingWhitespaces())!)
                    print("coordinate1v \(coordinate1v)")
                    print("coordinate1vc \(kappDelegate.coordinate2)")
                    let differnceDista = kappDelegate.coordinate2.distance(from: coordinate1v)
                    print("distacne \(kappDelegate.coordinate2)")
                    print("distacne \(differnceDista)")

                    if differnceDista < 50 {
                        WebPauseTime(strStaus: "START")
                    } else {
                        GlobalConstant.showAlertMessage(withOkButtonAndTitle: "Alert", andMessage: "Please go back to location wher you paused game", on: self)
                    }
                } else {
                    WebPauseTime(strStaus: "START")

                }
                
               


            }
            let noAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true, completion: nil)

        } else {
            
            let alertController = UIAlertController(title: "Alert", message: "Whenever you restart this game, you will have to be at around this location.", preferredStyle: .alert)
            let yesAction: UIAlertAction = UIAlertAction(title: "Confirm", style: .default) { [self] action -> Void in
                WebPauseTime(strStaus: "STOP")
                
            }
            let noAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true, completion: nil)

        }

    }
    //MARK:Map
     
    func updateMapViewAndAnnotation(_ address: String, _ location_coordinate: CLLocationCoordinate2D) {
        if CLLocationCoordinate2DIsValid(location_coordinate) {
            self.initMapViewAnnotation()
            let annotation = MKPointAnnotation()
            annotation.title = address
            annotation.coordinate = location_coordinate
            mapView.addAnnotation(annotation)
            
            mapView.mapType = MKMapType.standard
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: location_coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        } else {
            alert(alertmessage: "Location Not Found!")
        }
    }
    
    @IBAction func Archived(_ sender: UIButton) {

            if sender.tag == 0 {
              
                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InventorylistVC") as! InventorylistVC
                 self.navigationController?.pushViewController(nVC, animated: true)

            } else if sender.tag == 1 {
                
              
                let strEId = kappDelegate.dicCurrentEvent["id"].stringValue
               
                if strEId == "2" || strEId == "6" || strEId == "8" || strEId == "10" || strEId == "12" || strEId == "14" || strEId == "16" || strEId == "18" || strEId == "20" || strEId == "22" {

                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FinalPuzzleCodigoVc") as! FinalPuzzleCodigoVc
                    self.navigationController?.pushViewController(nVC, animated: true)
                    
                } else {
                    
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FinalPuzzleVC") as! FinalPuzzleVC
                    self.navigationController?.pushViewController(nVC, animated: true)

                }

            } else if sender.tag == 2 {
             
                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "FlgMaViewVC") as! FlgMaViewVC
                self.navigationController?.pushViewController(nVC, animated: true)

            } else if sender.tag == 3 {
                
                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "InstructionVC") as! InstructionVC
                nVC.strDetail = kappDelegate.dicCurrentEvent["event_instructions"].stringValue
                nVC.strfrom = "map"
                self.navigationController?.pushViewController(nVC, animated: true)

            }

//     }
        
    }
    
    
    func initMapViewAnnotation() {
        self.mapView.removeOverlays(mapView.overlays)
        self.mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
        }
    }

// MARK:  API
    func WebPauseTime(strStaus:String) {
        
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["event_status"]     =   strStaus as AnyObject
        paramsDict["pause_id"]     =   strPauseId as AnyObject
        paramsDict["lat"]     =   kappDelegate.coordinate2.coordinate.latitude as AnyObject
        paramsDict["lon"]     =    kappDelegate.coordinate2.coordinate.longitude as AnyObject
        paramsDict["total_time"]     =    totalMiliSeco as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.event_pause_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {

                    if strStaus == "START" {
                        btnPause.setImage(UIImage.init(systemName: "pause.circle.fill"), for: .normal)
                        isboolPause = false
                        timer?.invalidate()
                        startTimer()

                    } else {
                        btnPause.setImage(UIImage.init(systemName: "play.circle.fill"), for: .normal)
                        isboolPause = true
                        timer?.invalidate()

                    }
         //           strPauseId = swiftyJsonVar["result"].arrayValue[0]["id"].stringValue

                    
                } else {
                    
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Some went wrong?", on: self)

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    func WebGetTime() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["level"]     =   kappDelegate.strLevelId as AnyObject

        
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_event_time.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {

                    
                    let sec = Int(truncating: swiftyJsonVar["result"].numberValue).msToSeconds
                    totalMiliSeco = "\(swiftyJsonVar["result"].numberValue)"
                    print("secsec \(sec)")
                    totalSecond = Int(sec)
                    print("secsec \(totalSecond)")
                    strPauseId = swiftyJsonVar["pause_id"].stringValue
                    
                    strStopLat = swiftyJsonVar["lat"].stringValue
                    strStoplon = swiftyJsonVar["lon"].stringValue

                    print("secsec \(swiftyJsonVar["pause_id"].numberValue)")
                    print("secsec \(swiftyJsonVar["pause_id"].stringValue)")

                    if swiftyJsonVar["pause_id"].stringValue.count == 0 {
                        WebPauseTime(strStaus: "START")
                    }

                    if swiftyJsonVar["pause_status"].stringValue == "STOP" {
                        btnPause.setImage(UIImage.init(systemName: "play.circle.fill"), for: .normal)
                        isboolPause = true
                        countdown()
                    } else {
                        timer?.invalidate()
                        startTimer()
                        btnPause.setImage(UIImage.init(systemName: "pause.circle.fill"), for: .normal)
                        isboolPause = false

                    }
                    
                } else {
                    WebPauseTime(strStaus: "START")
                    totalSecond = 0
                    startTimer()
                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

    func WebGetCode() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]     =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["event_id"]     =   kappDelegate.dicCurrentEvent["id"].stringValue as AnyObject
        paramsDict["event_code"]     =    kappDelegate.strEventCode as AnyObject
        paramsDict["lang"]     =   Singleton.shared.language as AnyObject
        paramsDict["level"]     =   kappDelegate.strLevelId as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_event_instructions_game.url(), parameters: paramsDict, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async { [self] in
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    arrlist = swiftyJsonVar["result"].arrayValue
                    showAnnotaionOnMap(arrAll: arrlist)
                } else {
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "No puzzle found", on: self)

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    

}

extension MapBottomBarVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        let strId = view.annotation?.title ?? ""
        print("didSelectAnnotationTapped \(view.annotation?.title ?? "")")
        let arr = arrlist.filter({$0["id"].stringValue == strId})
        print("didSelectAnnotationTapped \(arr)")
       
        if arr.count == 0  {
            return
        }
        
        
        var coordinate1v = CLLocation(latitude: Double(arr[0]["lat"].stringValue.removingWhitespaces())!, longitude: Double(arr[0]["lon"].stringValue.removingWhitespaces())!)
        
        print("coordinate1v \(coordinate1v)")
        print("coordinate1vc \(kappDelegate.coordinate2)")
        
        let d = kappDelegate.coordinate2.distance(from: coordinate1v)
        
        print("distacne \(kappDelegate.coordinate2)")
        
        let strGameId = kappDelegate.dicCurrentEvent["id"].stringValue
            //puzzle (Mexico)
        if strGameId == "1" ||
           
            //crime (Mexico,Gudaljar)
            strGameId == "5" ||
            strGameId == "20" ||
            
            //zoombi (Mexico,Gudaljar)
            strGameId == "15"  ||
            
            //Codigo (Mexico)
            strGameId == "8" ||
            
            //mision_magica (Mexico,Gudaljar,Montery,Puebla)
            strGameId == "24" || strGameId == "22" || strGameId == "31" || strGameId == "32" ||
            
            //riddle (Mexico)
            strGameId == "40" ||

            //rescate (Mexico,Gudaljar,Montery)
            strGameId == "18" || strGameId == "19" ||
            strGameId == "28"  {
            
            if arr[0]["geolocation"].stringValue == "on" {
                
                if d < 100 {
//
                    if arr[0]["Jigsaw_puzzle_status"].stringValue == "enable" {

                        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "PuzzleCollectionViewController") as! PuzzleCollectionViewController
                        nVC.dicCurrentQuestion = arr[0]
                        kappDelegate.strIsFrom = "No"
                        nVC.puzzueDImage = puzzueDImage
                        self.navigationController?.pushViewController(nVC, animated: true)

                        
                    } else if arr[0]["argument_reality"].stringValue == "on" {
                        
                        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ArkitViewController") as! ArkitViewController
                        nVC.dicCurrentQuestion = arr[0]
                        kappDelegate.strIsFrom = "No"
                        self.navigationController?.pushViewController(nVC, animated: true)


                    } else {
                        
                        let nVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerVC") as! AnswerVC
                        nVC.dicCurrentQuestion = arr[0]
                        kappDelegate.strIsFrom = "No"
                        self.navigationController?.pushViewController(nVC, animated: true)
                    }

                } else {

                    GlobalConstant.showAlertMessageClose(withOkButtonAndTitle: "UBICACION LEJANA", andMessage: "Distance :- \(d) Meter's\n\nIParece que no estás dentro del radio cercano a las marcas del juego.Debes estar al menos 100 metros próximos a la ubicación marcada.", on: self)

                }

            } else {
                
                if arr[0]["Jigsaw_puzzle_status"].stringValue == "enable" {
                    
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "PuzzleCollectionViewController") as! PuzzleCollectionViewController
                    nVC.dicCurrentQuestion = arr[0]
                    kappDelegate.strIsFrom = "No"
                    nVC.puzzueDImage = puzzueDImage
                    self.navigationController?.pushViewController(nVC, animated: true)

                    
                } else if arr[0]["argument_reality"].stringValue == "on" {
                    
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ArkitViewController") as! ArkitViewController
                    nVC.dicCurrentQuestion = arr[0]
                    kappDelegate.strIsFrom = "No"
                    self.navigationController?.pushViewController(nVC, animated: true)


                } else {
                    
                    
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerVC") as! AnswerVC
                    nVC.dicCurrentQuestion = arr[0]
                    kappDelegate.strIsFrom = "No"
                    self.navigationController?.pushViewController(nVC, animated: true)
                }
            }
            
        } else {
            
            
            if arr[0]["Jigsaw_puzzle_status"].stringValue == "enable" {

                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "PuzzleCollectionViewController") as! PuzzleCollectionViewController
                nVC.dicCurrentQuestion = arr[0]
                kappDelegate.strIsFrom = "No"
                nVC.puzzueDImage = puzzueDImage
                self.navigationController?.pushViewController(nVC, animated: true)

                
            } else if arr[0]["argument_reality"].stringValue == "on" {
                
                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "ArkitViewController") as! ArkitViewController
                nVC.dicCurrentQuestion = arr[0]
                kappDelegate.strIsFrom = "No"
                self.navigationController?.pushViewController(nVC, animated: true)


            } else {
                
                
                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerVC") as! AnswerVC
                nVC.dicCurrentQuestion = arr[0]
                kappDelegate.strIsFrom = "No"
                self.navigationController?.pushViewController(nVC, animated: true)


            }

        }
       
    }
    
    func usernameTest(testStr:String) -> Bool {
         
         let letters = CharacterSet.punctuationCharacters
         let range = testStr.rangeOfCharacter(from: letters)
         // range will be nil if no letters is found
         if range != nil {
            return true
         }
         else {
            return false
         }
        
    }
//    func checkIfMutlipleCoordinates(latitude : Float , longitude : Float) -> CLLocationCoordinate2D {
//
//            var lat = latitude
//            var lng = longitude
//
//            // arrFilterData is array of model which is giving lat long
//
//            let arrTemp = self.arrFilteredData.filter {
//
//                return (((latitude == $0.latitute) && (longitude == $0.longitute)))
//            }
//
//            // arrTemp giving array of objects with similar lat long
//
//            if arrTemp.count > 1{
//                // Core Logic giving minor variation to similar lat long
//
//                let variation = (randomFloat(min: 0.0, max: 2.0) - 0.5) / 1500
//                lat = lat + variation
//                lng = lng + variation
//            }
//            let finalPos = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
//            return  finalPos
//        }
//
//     func randomFloat(min: Float, max:Float) -> Float {
//            return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
//        }

    func showAnnotaionOnMap(arrAll:[JSON]) {
        
        mapView.removeAnnotations(mapView.annotations)
        var arrAllAnn:[MKAnnotation] =  []
        var coordinates:[CLLocationCoordinate2D] =  []
        var allLocations:[CLLocationCoordinate2D] = []

        var isCurrentId:Double! = 0.0
       
        if kappDelegate.strIsFrom == "Yes" {
            
            let pdiLat = kappDelegate.dicCurrentQuestion["lat"].stringValue.trimmingCharacters(in: .whitespaces)
            let pdiLot = kappDelegate.dicCurrentQuestion["lon"].stringValue.trimmingCharacters(in: .whitespaces)
            isCurrentId = Double(kappDelegate.dicCurrentQuestion["id"].stringValue.trimmingCharacters(in: .whitespaces))! + 1.0
            coordinates.append(CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!))

        }
        for i  in 0..<arrAll.count {
            
            let dic = arrAll[i]
            
            var pickupCoordinat:CLLocationCoordinate2D!
            let pdiLat = dic["lat"].stringValue.trimmingCharacters(in: .whitespaces)
            let pdiLot = dic["lon"].stringValue.trimmingCharacters(in: .whitespaces)
            let idISCurent = dic["id"].stringValue.trimmingCharacters(in: .whitespaces)

//            let sourceAnnotation = CustomPointAnnotation()

            let sourceAnnotation = CustomAnnotation(
                                coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                                title: "",
                                imageName: "", isAnser: "", numberingN: "")
//            let annotation = CustomAnnotation(
//                coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
//                title: "San Francisco",
//                imageName: "sanfran_image"
//            )
        //    mapView.addAnnotation(annotation)

//            if usernameTest(testStr: pdiLat) == true {
//                print("No Routesfs \(usernameTest(testStr: pdiLat))")
//
//            }

            print("numberingnumberingnumbering \(dic["numbering"].stringValue)")
            if pdiLat != "" &&  pdiLot != ""  && dic["answer_status"].numberValue == 0  {
                pickupCoordinat = CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!)
                let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinat!, addressDictionary: nil)
                sourceAnnotation.coordinate = sourcePlacemark.coordinate
                sourceAnnotation.imageName = "flag_red"
                sourceAnnotation.title = dic["id"].stringValue
                sourceAnnotation.numbering = dic["numbering"].stringValue
                sourceAnnotation.answer = "\(dic["answer_status"].numberValue)"

                allLocations.append(pickupCoordinat)
            } else if pdiLat != "" &&  pdiLot != "" && dic["answer_status"].numberValue == 1  {
                pickupCoordinat = CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!)
                let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinat!, addressDictionary: nil)
                sourceAnnotation.coordinate = sourcePlacemark.coordinate
                sourceAnnotation.imageName = "flag_green"
                sourceAnnotation.title = dic["id"].stringValue
                sourceAnnotation.numbering = dic["numbering"].stringValue
                
                sourceAnnotation.answer = "\(dic["answer_status"].numberValue)"

                allLocations.append(pickupCoordinat)

            }
            
            
            print("No Routesfs \(isCurrentId)")
            print("No Routefssf \(Double(idISCurent)!)")

            if kappDelegate.strIsFrom == "Yes"  {
                print("Yes Route ")

                if isCurrentId == Double(idISCurent)! {
                    coordinates.append(CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!))
                    
                    let sourcePlacemark = MKPlacemark(coordinate: coordinates[0], addressDictionary: nil)
                    let destinationPlacemark = MKPlacemark(coordinate: coordinates[1], addressDictionary: nil)
                    
                    

                    let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

                    // Calculate the direction
                    
                    let directionRequest = MKDirections.Request()
                    directionRequest.source = sourceMapItem
                    directionRequest.destination = destinationMapItem
                    directionRequest.transportType = .automobile

                    let directions = MKDirections(request: directionRequest)
                    
                    directions.calculate {
                        (response, error) -> Void in
                        
                        guard let response = response else {
                            if let error = error {
                                print("Error: \(error)")
                            }
                            
                            return
                        }
                        
                        let route = response.routes[0]
                        self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                        
                        //            let rect = route.polyline.boundingMapRect
                        //            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                        
                        let mapRect = MKPolygon(points: route.polyline.points(), count: route.polyline.pointCount)
                        self.mapView.setVisibleMapRect(mapRect.boundingMapRect, edgePadding: UIEdgeInsets(top: 150.0,left: 50.0,bottom: 150.0,right: 50.0), animated: true)
                        
                        print("Yes Route dsdsd")

                    }
                }
            } else {
                
                print("No Route")
                
            }
        //

            arrAllAnn.append(sourceAnnotation)
        }

       
        self.initMapViewAnnotation()

        self.mapView.showAnnotations(arrAllAnn, animated: true )

        if kappDelegate.strIsFrom != "Yes"  {
            
            let poly:MKPolygon = MKPolygon(coordinates: &allLocations, count: allLocations.count)

            self.mapView.setVisibleMapRect(poly.boundingMapRect, edgePadding: UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0), animated: false)

        }

    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? CustomAnnotation {
            let identifier = "CustomAnnotationView"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = customAnnotation
            }
            
            if customAnnotation.answer == "0" {
                annotationView?.image = UIImage(named: "flag_red")
            } else {
                annotationView?.image = UIImage(named: "flag_green")
            }
       //     annotationView?.image = UIImage(named: "flag_red") // Set your custom image
            return annotationView
        }
        
        return nil
    }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard !(annotation is MKUserLocation) else {
//            return nil
//        }
//        
//        if !(annotation is CustomPointAnnotation) {
//            return nil
//        }
//        
//        let reuseId = "test"
//        
//        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//        if anView == nil {
//            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            anView!.canShowCallout = true
//        }
//        else {
//            anView!.annotation = annotation
//        }
//        
//        let cpa = annotation as! CustomPointAnnotation
//        
//        anView?.image = UIImage.init(named: cpa.imageName ?? "")
//      //  anView?.ti = cpa
//        
//        return anView
//        
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        //        if let overlay = overlay as? MKPolyline {
        /// define a list of colors you want in your gradient
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = hexStringToUIColor(hex: MAIN_COLOR)
            renderer.lineWidth = 7
            return renderer
        }
        
        return MKOverlayRenderer()
        
        //        let gradientColors = [ hexStringToUIColor(hex: MAIN_COLOR), hexStringToUIColor(hex: MAIN_COLOR)]
        //
        //        /// Initialise a GradientPathRenderer with the colors
        //        let polylineRenderer = GradientPathRenderer(polyline: overlay as! MKPolyline, colors: gradientColors)
        //
        //        /// set a linewidth
        //        polylineRenderer.lineWidth = 7
        //        return polylineRenderer
        //        }
        
    }

}

extension Int {
    var msToSeconds: Double { Double(self) / 1000 }
}
extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension String {
    func containsOnlyLetters(input: String) -> Bool {
       for chr in input {
          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
             return false
          }
       }
       return true
    }
}
