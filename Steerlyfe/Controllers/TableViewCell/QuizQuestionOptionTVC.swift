//
//  QuizQuestionOptionTVC.swift
//  Steerlyfe
//
//  Created by nap on 01/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class QuizQuestionOptionTVC: UITableViewCell {

    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var optionView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetail(data : QuizQuestionDetail, currentIndex : Int) {
        optionName.text = data.options_list[currentIndex]
        if data.selected_options_index.contains(currentIndex){
            setColorStyle(isSelected: true)
        }else{
            setColorStyle(isSelected: false)
        }
        
//        if isSelected{
//            if selectedIndex == currentIndex{
//                setColorStyle(isSelected: true)
//            }else{
//                setColorStyle(isSelected: false)
//            }
//        }else{
//            setColorStyle(isSelected: false)
//        }
    }
    
    func setDetail(option : String, isSelected : Bool, selectedIndex: Int, currentIndex : Int) {
        optionName.text = option
        if isSelected{
            if selectedIndex == currentIndex{
                setColorStyle(isSelected: true)
            }else{
                setColorStyle(isSelected: false)
            }
        }else{
            setColorStyle(isSelected: false)
        }
    }
    
    func setColorStyle(isSelected : Bool) {
        if isSelected {
            optionView.backgroundColor = UIColor.black
            optionName.textColor = UIColor.white
        }else{
            optionView.backgroundColor = UIColor.white
            optionName.textColor = UIColor.black
        }
        var color = UIColor.colorPrimaryDark
        color = color.withAlphaComponent(0.5)
        CommonMethods.addCardViewStyle(uiView: optionView, cornerRadius: 20.0, shadowColor: color)
    }
}
