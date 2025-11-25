//
//  FlgMaViewVC.swift
//  City Quests
//
//  Created by mac on 29/03/23.
//

import UIKit
import MapKit
import SwiftyJSON

class FlgMaViewVC: UIViewController {
    
    @IBOutlet weak var lbl_Timer: UILabel!
    @IBOutlet weak var view_Bottom: UIView!
    @IBOutlet weak var mapView: MKMapView!
   
    var arrlist:[JSON]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // WebGetCode()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
       setNavigationBarItem(LeftTitle: "", LeftImage: "back", CenterTitle: "Map", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: NAAV_BG_COLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        WebGetCode()
        
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        kappDelegate.strIsFrom = "No"
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
    
    @IBAction func Archived(_ sender: Any) {
        view_Bottom.isHidden = true
        WebGetCode()

    }
    func initMapViewAnnotation() {
        self.mapView.removeOverlays(mapView.overlays)
        self.mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
        }
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
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: swiftyJsonVar["result"].stringValue, on: self)

                }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

}

extension FlgMaViewVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
        let strId = view.annotation?.title ?? ""
        print("didSelectAnnotationTapped \(view.annotation?.title ?? "")")
        let arr = arrlist.filter({$0["id"].stringValue == strId})
        print("didSelectAnnotationTapped \(arr)")

        print("coordinate1v \(arr[0]["lat"].string) \(arr[0]["lon"].string)")

        if arr.count == 0   {
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
                    
                    let nVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerVC") as! AnswerVC
                    nVC.dicCurrentQuestion = arr[0]
                    kappDelegate.strIsFrom = "No"
                    self.navigationController?.pushViewController(nVC, animated: true)

                } else {
                    
                    GlobalConstant.showAlertMessageClose(withOkButtonAndTitle: "UBICACION LEJANA", andMessage: "Distance :- \(d) Meter's\n\nIParece que no estás dentro del radio cercano a las marcas del juego.Debes estar al menos 100 metros próximos a la ubicación marcada.", on: self)
                    
                }

            } else {
                
                let nVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerVC") as! AnswerVC
                nVC.dicCurrentQuestion = arr[0]
                kappDelegate.strIsFrom = "No"
                self.navigationController?.pushViewController(nVC, animated: true)

            }
            
        } else {
            
            let nVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerVC") as! AnswerVC
            nVC.dicCurrentQuestion = arr[0]
            kappDelegate.strIsFrom = "No"
            self.navigationController?.pushViewController(nVC, animated: true)

        }
        
    }

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

         //   let sourceAnnotation = CustomPointAnnotation()
            let sourceAnnotation = CustomAnnotation(
                                coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                                title: "",
                                imageName: "", isAnser: "", numberingN: "")


            if pdiLat != "" &&  pdiLot != "" && dic["answer_status"].numberValue == 0 {
                pickupCoordinat = CLLocationCoordinate2DMake(Double(pdiLat)!, Double(pdiLot)!)
                let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinat!, addressDictionary: nil)
                sourceAnnotation.coordinate = sourcePlacemark.coordinate
                sourceAnnotation.imageName = "flag_red"
                sourceAnnotation.title = dic["id"].stringValue
                sourceAnnotation.numbering = dic["numbering"].stringValue
                sourceAnnotation.answer = "\(dic["answer_status"].numberValue)"

                allLocations.append(pickupCoordinat)

            
            } else if pdiLat != "" &&  pdiLot != "" && dic["answer_status"].numberValue == 1 {
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
            
            arrAllAnn.append(sourceAnnotation)
        }

       
        self.initMapViewAnnotation()

        self.mapView.showAnnotations(arrAllAnn, animated: true )

        

        if kappDelegate.strIsFrom == "Yes" {
            view_Bottom.isHidden = false
            lbl_Timer.text = "You have only \(kappDelegate.dicCurrentQuestion["arrival_time"].stringValue) Minutes To Reach Next CheckPoint Hurry up!"
        } else  {
            view_Bottom.isHidden = true
            var poly:MKPolygon = MKPolygon(coordinates: &allLocations, count: allLocations.count)

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
         //   annotationView?.image = UIImage(named: "flag_red") // Set your custom image
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
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
