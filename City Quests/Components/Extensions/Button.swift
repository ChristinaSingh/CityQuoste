

import UIKit
//import Toaster

//class Singleton
//{
//    
//    static let shared = Singleton()
//    var serviceWant = String()
//    var snowCategory = String()
////    var userInfo = LoginResponseData()
//    var current_lat:String?
//    var current_long:String?
//    var userID:String?
//    var userType:String?
//    
//    private init(){
////        self.userInfo = getUserData()
//    }
//    
//    func showToast(text: String) {
//        Toast(text:text).show()
//        Toast(text:text).view.bottomOffsetPortrait = 20.0
//        Toast(text:text).cancel()
//    }
//    
//}


class UnderlineTextButton: UIButton {
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: .normal)
        self.setAttributedTitle(self.attributedString(), for: .normal)
    }
    
    private func attributedString() -> NSAttributedString? {
        let attributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19.0),
            NSAttributedString.Key.foregroundColor : UIColor.red,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
        return attributedString
    }
}


// MARK: - Add a border to one side of a view

public enum BorderSide {
    case top, bottom, left, right
}

extension UIView {
    public func addBorder(side: BorderSide, color: UIColor, width: CGFloat) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        self.addSubview(border)
        
        let topConstraint = topAnchor.constraint(equalTo: border.topAnchor)
        let rightConstraint = trailingAnchor.constraint(equalTo: border.trailingAnchor)
        let bottomConstraint = bottomAnchor.constraint(equalTo: border.bottomAnchor)
        let leftConstraint = leadingAnchor.constraint(equalTo: border.leadingAnchor)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: width)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)
        
        
        switch side {
        case .top:
            NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
        case .right:
            NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
        case .bottom:
            NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
        case .left:
            NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
        }
    }
}


@IBDesignable
class LeftAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        //        let availableSpace = UIEdgeInsetsInsetRect(bounds, contentEdgeInsets)
        //        var availableSpace = frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        let availableSpace = frame.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2, bottom: 0, right: 0)
    }
}

@IBDesignable
class RightAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        //        let availableSpace = UIEdgeInsetsInsetRect(bounds, contentEdgeInsets)
        let availableSpace = frame.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth / 2)
    }
}
