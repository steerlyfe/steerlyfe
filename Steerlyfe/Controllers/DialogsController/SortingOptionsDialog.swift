//
//  SortingOptionsDialog.swift
//  Steerlyfe
//
//  Created by Nap Works on 10/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class SortingOptionsDialog: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonPressedAtPositionDelegate {
    
    let TAG = "SortingOptionsDialog"
    
    var selectedType : SortingType?
    var data : [SortingOptions] = []
    var sectionHeight : CGFloat = 50.0
    var delegate : SortingOptionDelegate?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        data = CommonMethods.getSortingOptionsList()
        calculateHeight()
        setUI()
    }
    
    @IBAction func crossButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUI() {
        CommonMethods.addRoundCornerFilled(uiview: mainView, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 10.0)
        tableView.register(UINib(nibName: "SortingOptionTVC", bundle: nil), forCellReuseIdentifier: "SortingOptionTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortingOptionTVC", for: indexPath) as! SortingOptionTVC
        cell.setDetail(data: data[indexPath.row], selectedType: selectedType, delegate: self, position: indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
        
    func calculateHeight()  {
        var finalHeight : CGFloat = 0.0
        finalHeight = sectionHeight * CGFloat(data.count)
        CommonMethods.showLog(tag: TAG, message: "before finalHeight : \(finalHeight)" )
        let screenHeight : CGFloat = self.view.frame.height
        CommonMethods.showLog(tag: TAG, message: "screenHeight : \(screenHeight)" )
        if finalHeight > (screenHeight  - 200.0){
            finalHeight = screenHeight - 200.0
        }
        CommonMethods.showLog(tag: TAG, message: "final finalHeight : \(finalHeight)" )
        tableHeightConstraint.constant = finalHeight
    }
    
    func onButtonPressed(type: String, position: Int) {
        switch type {
        case MyConstants.ITEM_SELECTED:
            selectedType = data[position].sortingType
            dismiss(animated: true) {
                self.delegate?.onSortingChanged(sortingType: self.selectedType)
            }
            break
        default:
            break
        }
    }
    
}
