//
//  CustomPointAnnotation.swift
//  FastEasyRideUser
//
//  Created by mac on 26/08/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String?
    var point:String?
}

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageName: String
    var answer: String?
    var numbering: String?

    init(coordinate: CLLocationCoordinate2D, title: String, imageName: String, isAnser: String, numberingN: String) {
        self.coordinate = coordinate
        self.title = title
        self.imageName = imageName
        self.answer = isAnser
        self.numbering = numberingN

    }
}
class CustomAnnotationView: MKAnnotationView {
    private let titleLabel = UILabel()

    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else { return }
            canShowCallout = false // Disable the default callout
            
            if kappDelegate.dicCurrentEvent["id"].stringValue == "15" {
                setupTitleLabel()
            }
            titleLabel.text = customAnnotation.numbering
        }
    }

    private func setupTitleLabel() {
        titleLabel.frame = CGRect(x: -5, y: -17, width: 30, height: 20) // Adjust frame as needed
        titleLabel.backgroundColor = UIColor.white
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(titleLabel)
    }
}
