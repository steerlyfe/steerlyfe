//
//  CartVC.swift
//  Steerlyfe
//
//  Created by nap on 29/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//
import UIKit

class CartVC: UIViewController, UITableViewDelegate, UITableViewDataSource , ButtonPressedAtPositionDelegate{
    
    let TAG = "CartVC"
    let databaseMethods = DatabaseMethods()
    
    var data : [ProductDetail] = []
    
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = databaseMethods.getAllCartProducts()
        CommonMethods.common.showLog(tag: TAG, message: "COUNT : \(data.count)")
        self.setUI()
    }
    
    func setUI() {
        tableView.register(UINib(nibName: "ProductListTVC", bundle: nil), forCellReuseIdentifier: "ProductListTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        CommonMethods.common.setTableViewSeperatorColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        if data.count > 0{
            noDataMessage.isHidden = true
            checkoutView.isHidden = false
        }else{
            noDataMessage.isHidden = false
            checkoutView.isHidden = true
        }
        tableView.reloadData()
        itemCountLabel.text = "\(data.count) ITEMS"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTVC", for: indexPath) as! ProductListTVC
        cell.setDetail(data: data[indexPath.row], delegate: self, position: indexPath.row, databaseMethods: databaseMethods)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.common.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case "ViewDetail":
            break
        default:
            break
        }
    }
    
    @IBAction func checkoutNow(_ sender: Any) {
        CommonMethods.common.showLog(tag: TAG, message: "checkoutNow")
    }
}
