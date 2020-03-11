//
//  AddressListVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 04/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class AddressListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddressListDelegate, ButtonPressedAtPositionDelegate, ConfirmationDialogDelegate, OnProcessCompleteDelegate, ChooseAddressDelegate {
    
    let TAG = "AddressListVC"
    let refreshControl = UIRefreshControl()
    
    var data : [AddressDetail] = []
    var currentPosition : Int = 0
    var calledForChoose : Bool = false
    var delegate : ChooseAddressDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addNewAddess))
        setUI()
        KVNProgress.show()
        getAddress()
    }
    
    func getAddress()  {
        CommonWebServices.api.allAddress(navigationController: navigationController, delegate: self)
    }
    
    @objc func onRefresh(_ sender : Any) {
        getAddress()
    }
    
    func setUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "AddressListTVC", bundle: nil), forCellReuseIdentifier: "AddressListTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
//        tableView.backgroundColor = UIColor.gray
        tableView.reloadData()
        noDataMessage.isHidden = true
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        CommonMethods.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: "Manage Address")
    }
    
    @objc func addNewAddess(){
        CommonMethods.showLog(tag: TAG, message: "addNewAddess")
        MyNavigations.goToAddAddress(navigationController: navigationController, delegate: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTVC", for: indexPath) as! AddressListTVC
        cell.setDetail(data: data[indexPath.row], delegate: self, position: indexPath.row, calledForChoose: calledForChoose)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func onAddressListReceived(status: String, message: String, data: AddressListResponse?) {
        CommonMethods.showLog(tag: TAG, message: "onAddressAdded status : \(status)")
        CommonMethods.showLog(tag: TAG, message: "onAddressAdded message : \(message)")
        CommonMethods.showLog(tag: TAG, message: "onAddressAdded address list count : \(data?.addressList.count ?? 0)")
        refreshControl.endRefreshing()
        switch status {
        case "1":
            KVNProgress.dismiss()
            self.data = data?.addressList ?? []
            tableView.reloadData()
            noDataMessage.isHidden = self.data.count != 0
            break
        default:
            if KVNProgress.isVisible(){
                KVNProgress.dismiss {
                    MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
                }
            }else{
                MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
            }
            break
        }
    }
        
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.USE_ADDRESS:
            CommonMethods.dismissCurrentViewController()
            DispatchQueue.main.async {
                self.delegate?.onAddressChoosed(type: MyConstants.CHOOSE_ADDRESS, addressDetail: self.data[position])
            }
            break
        case MyConstants.MAKE_DEFAULT_ADDRESS:
            currentPosition = position
            CommonWebServices.api.changeDefaultAddress(navigationController: navigationController, addressId: data[currentPosition].address_id ?? "", delegate: self)
            break
        case MyConstants.DELETE_ADDRESS:
            currentPosition = position
            CommonAlertMethods.showConfirmationAlert(navigationController: navigationController, title: MyConstants.APP_NAME, message: "Do you want to delete this address?", yesText: "Delete Address", noString: "Cancel", delegate: self)
            break
        default:
            break
        }
    }
    
    func onConfirmationButtonPressed(yesPressed: Bool) {
        if yesPressed{
            CommonWebServices.api.deleteAddress(navigationController: navigationController, addressId: data[currentPosition].address_id ?? "", delegate: self)
        }
    }
    
    func onProcessComplete(type: String, status: String, message: String) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) status : \(status) message : \(message)")
        switch type {
        case MyConstants.DELETE_ADDRESS:
            if status == "1"{
                data.remove(at: currentPosition)
//                let indexPath = IndexPath(item: currentPosition, section: 0)
//                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                noDataMessage.isHidden = self.data.count != 0
            }else{
                MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
            }
            break
        case MyConstants.MAKE_DEFAULT_ADDRESS:
            if status == "1"{
                KVNProgress.showSuccess(withStatus: message) {
                    self.data.forEach { (addressDetail) in
                        addressDetail.isDefault = false
                    }
                    self.data[self.currentPosition].isDefault = true
                    self.tableView.reloadData()
                }
            }else{
                MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
            }
            break
        default:
            break
        }
    }
    
    func onAddressChoosed(type: String, addressDetail: AddressDetail?) {
        CommonMethods.showLog(tag: TAG, message: "onAddressChoosed type : \(type)")
        switch type {
        case MyConstants.NEW_ADDRESS_ADDED:
            if let address = addressDetail{
                CommonMethods.showLog(tag: TAG, message: "IF")
                data.forEach { (addressDetail) in
                    addressDetail.isDefault = false
                }
                data.insert(address, at: 0)
                tableView.reloadData()
                noDataMessage.isHidden = self.data.count != 0
            }else{
                CommonMethods.showLog(tag: TAG, message: "ELSE")
            }
            break
        default:
            break
        }
    }
}
