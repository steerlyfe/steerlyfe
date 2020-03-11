//
//  CustomExtensions.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIButton {
    
    func makeRoundCorner(cornerRadius : CGFloat){
        self.layer.borderWidth = 0
        self.layer.cornerRadius = cornerRadius
    }
    
    func buttonColorPrimary(){
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.backgroundColor =  UIColor.colorPrimary.cgColor
        self.setTitleColor(UIColor.black, for: .normal)
    }
    
    func buttonColorPrimaryDark(){
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.backgroundColor =  UIColor.colorPrimaryDark.cgColor
        self.setTitleColor(UIColor.black, for: .normal)
    }
    
    func buttonStrokeColorPrimary(){
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.colorPrimary.cgColor
        self.layer.backgroundColor =  UIColor.white.cgColor
        self.setTitleColor(UIColor.colorPrimary, for: .normal)
    }
    
    func buttonStrokeColorPrimaryDark(){
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.colorPrimaryDark.cgColor
        self.layer.backgroundColor =  UIColor.white.cgColor
        self.setTitleColor(UIColor.colorPrimaryDark, for: .normal)
    }
    
    func buttonStrokeColorPrimaryTranBack(){
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.colorPrimary.cgColor
        //        self.layer.backgroundColor =  UIColor(white: 1, alpha: 0.0) as! CGColor
        self.setTitleColor(UIColor.colorPrimary, for: .normal)
    }
}

extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension UITextView{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    
    
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
        } else {
            return self
        }
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
        } else {
            return self
        }
    }
    
}


extension UIColor {
    
    static var colorPrimary: UIColor {
        return UIColor(red: 145/255, green: 21/255, blue: 221/255, alpha: 1.0)
    }
    
    static var colorPrimaryDark: UIColor {
        return UIColor(red: 0/255, green: 127/255, blue: 214/255, alpha: 1.0)
    }
    
    static var colorPrimaryDarkTrans: UIColor {
        return UIColor(red: 0/255, green: 127/255, blue: 214/255, alpha: 0.1)
    }
    
    static var colorPrimaryDarkTransLight: UIColor {
        return UIColor(red: 0/255, green: 127/255, blue: 214/255, alpha: 0.01)
    }
    
    static var colorSecondary: UIColor {
        return UIColor(red: 4/255, green: 188/255, blue: 177/255, alpha: 1.0)
    }
    
    static var transparentBackground: UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
    }
    
    static var myLineColor: UIColor {
        return UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
    }
    
    static var myLineLightColor: UIColor {
        return UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.5)
    }
    
    static var myGreyColor: UIColor {
        return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
    }
    
    static var myStarColor: UIColor {
        return UIColor(red: 255/255, green: 199/255, blue: 0/255, alpha: 1.0)
    }
    
    static var myOffWhiteColor: UIColor {
        return UIColor(red: 245/255, green: 242/255, blue: 208/255, alpha: 1.0)
    }
    
    static var statusIndicatorDark: UIColor {
        return UIColor(red: 4/255, green: 188/255, blue: 177/255, alpha: 1.0)
    }
    
    static var statusIndicatorLight: UIColor {
        return UIColor(red: 4/255, green: 188/255, blue: 177/255, alpha: 0.2)
    }
    
    static var statusIndicatorUnchecked: UIColor {
        return UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1.0)
    }
}

extension UIView{
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
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true, cornerRadius : CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)        
        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 16.0
    @IBInspectable var rightInset: CGFloat = 16.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    func updatePadding(topInset: CGFloat, bottomInset: CGFloat, leftInset: CGFloat, rightInset: CGFloat) {
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.leftInset = leftInset
        self.rightInset = rightInset
    }
}
