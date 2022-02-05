//
//  TextFieldStyle.swift
//  Amako
//
//  Created by Khim Chua on 6/2/22.
//

import UIKit

class TextFieldUnderline: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setIcon()
        underline()
    }
    func setIcon() {
        var image:UIImage?
        if(tag == 0){
            image = UIImage(named: "user")
        }else if(tag == 1){
            image = UIImage(named: "lock")
        }
        
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 30, height: 30))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 50, height: 40))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    func underline(){
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(origin: CGPoint(x: 0, y:self.frame.height - 1), size: CGSize(width: self.frame.width, height:  2))
        bottomLine1.backgroundColor = UIColor.black.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine1)
    }
}
