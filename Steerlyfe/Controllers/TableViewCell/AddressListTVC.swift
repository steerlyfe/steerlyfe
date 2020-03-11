//
//  AddressListTVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 04/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class AddressListTVC: UITableViewCell {
    
    var delegate : ButtonPressedAtPositionDelegate?
    var position : Int = 0
    
    @IBOutlet weak var makeDefaultButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var deleteAddessButton: UIButton!
    @IBOutlet weak var useAddressButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0,shadowColor: UIColor.lightGray)
        CommonMethods.addCardViewStyle(uiView: mainView, cornerRadius: 10.0, shadowRadius: 5.0, shadowColor: UIColor.lightGray)
        CommonMethods.addRoundCornerStroke(uiview: useAddressButton, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: makeDefaultButton, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
        CommonMethods.addRoundCornerStroke(uiview: deleteAddessButton, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: 5.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : AddressDetail, delegate : ButtonPressedAtPositionDelegate?, position : Int, calledForChoose : Bool) {
        self.delegate = delegate
        self.position = position
        addressLabel.text = CommonMethods.getAddressText(addressDetail: data)
        if calledForChoose{
            useAddressButton.isHidden = false
            makeDefaultButton.isHidden = true
        }else{
            useAddressButton.isHidden = true
            if data.isDefault ?? false{
                makeDefaultButton.isHidden = true
            }else{
                makeDefaultButton.isHidden = false
            }
        }
    }
    
    @IBAction func useAddressPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.USE_ADDRESS, position: position)
    }
    
    @IBAction func deleteAddressPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.DELETE_ADDRESS, position: position)
    }
    
    @IBAction func makeDefaultPressed(_ sender: Any) {
        delegate?.onButtonPressed(type: MyConstants.MAKE_DEFAULT_ADDRESS, position: position)
    }
}
