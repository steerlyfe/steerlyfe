//
//  DiscoverVC.swift
//  Steerlyfe
//
//  Created by nap on 30/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class DiscoverVC: UIViewController, UITableViewDelegate, UITableViewDataSource , ButtonPressedAtPositionDelegate{
    
    let TAG = "DiscoverVC"
    let databaseMethods = DatabaseMethods()
    
    var data : [CategoryDetail] = []
    var cellHeight : CGFloat = 0.0
    
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = databaseMethods.getAllCategories()
        CommonMethods.showLog(tag: TAG, message: "COUNT : \(data.count)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setUI()
        }
    }

    func setUI() {
        let height  = tableView.frame.height
        cellHeight = height / 2.0
        tableView.register(UINib(nibName: "DiscoverTVC", bundle: nil), forCellReuseIdentifier: "DiscoverTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        CommonMethods.setTableViewSeperatorColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        if data.count > 0{
            noDataMessage.isHidden = true
        }else{
            noDataMessage.isHidden = false
        }
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTVC", for: indexPath) as! DiscoverTVC
        cell.setDetail(data: data[indexPath.row], delegate: self, position: indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case "ViewDetail":
            break
        default:
            break
        }
    }
}
