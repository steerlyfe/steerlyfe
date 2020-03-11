//
//  SellerDetailVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 17/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class SellerDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var productDetail : ProductDetail?
    var additionalFeatureIndex : Int?
    var productAvailabilityIndex : Int?
    var sellerDetailIndex : Int?
    var delegate : OnProcessCompleteDelegate?
    var databaseMethods : DatabaseMethods?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        tableView.register(UINib(nibName: "SellerDetailTVC", bundle: nil), forCellReuseIdentifier: "SellerDetailTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerDetailTVC", for: indexPath) as! SellerDetailTVC
        cell.setDetail(productDetail: productDetail, additionalFeatureIndex: additionalFeatureIndex ?? 0, productAvailabilityIndex: productAvailabilityIndex ?? 0, sellerDetailIndex: sellerDetailIndex ?? 0, databaseMethods: databaseMethods, delegate: delegate)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}
