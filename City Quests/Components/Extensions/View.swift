//
//  View.swift
//  FastEasyRideUser
//
//  Created by mac on 26/08/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class BorderView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   //     self.layer.cornerRadius = 5
      //  self.layer.borderWidth = 1.5
     //   self.layer.borderColor = UIColor.init(red: 241/256, green: 241/256, blue: 241/256, alpha: 1).cgColor
        
     //   self.layer.shadowColor = UIColor.lightGray.cgColor
      //  self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
      //  self.layer.shadowRadius = 2
      //  self.layer.shadowOpacity = 1.0
        
//self.layer.masksToBounds = false
        // set backgroundColor in order to cover the shadow inside the bounds
      //  self.layer.backgroundColor = UIColor.white.cgColor
        
        //        self.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0)
    }
}

extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
