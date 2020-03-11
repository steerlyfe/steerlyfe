//
//  CombinedSearchVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 28/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import CoreLocation

class CombinedSearchVC: UIViewController, CommonSearchDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ButtonPressedAtPositionDelegate, RefreshProductsListDelegate, CLLocationManagerDelegate{
    
    let TAG = "CombinedSearchVC"
    let databaseMethods = DatabaseMethods()
    let locationManager = CLLocationManager()
    
    var data: CommonSearchResponse?
    var isDataSearched = false
    var currentLat = 25.790654
    var currentLng = -80.1300455
    var myLocationAvailable = false
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = searchView.frame.height / 2.0
        CommonMethods.addCardViewStyle(uiView: searchView, cornerRadius: height, shadowRadius: height * 2.0, shadowColor: UIColor.colorPrimaryDarkTrans)
        searchTextField.delegate = self
        setUI()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
        if MyConstants.FILL_STATIC_FORM{
            searchTextField.text = "luxury"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CommonMethods.showLog(tag: TAG, message: "viewWillAppear")
        navigationController?.navigationBar.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        CommonMethods.showLog(tag: TAG, message: "locationManager didChangeAuthorization \(status.rawValue)")
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        CommonMethods.showLog(tag: TAG, message: "locationManager didUpdateLocations \(locations)")
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy>1{
            locationManager.stopUpdatingLocation()
            currentLat = location.coordinate.latitude
            currentLng = location.coordinate.longitude
            myLocationAvailable = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        CommonMethods.showLog(tag: TAG, message: "LOCATION ERROR\(error)")
        myLocationAvailable = false
    }
    
    func setUI() {
        tableView.register(UINib(nibName: "CommonSearchTitleTVC", bundle: nil), forCellReuseIdentifier: "CommonSearchTitleTVC")
        tableView.register(UINib(nibName: "CommonSearchNoDataTVC", bundle: nil), forCellReuseIdentifier: "CommonSearchNoDataTVC")
        tableView.register(UINib(nibName: "CommonSearchStoresTVC", bundle: nil), forCellReuseIdentifier: "CommonSearchStoresTVC")
        tableView.register(UINib(nibName: "ProductListTVC", bundle: nil), forCellReuseIdentifier: "ProductListTVC")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        //        CommonMethods.setTableViewSeperatorColor(tableView: tableView)
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.searchTextField.becomeFirstResponder()
        }
    }
    
    func getData() {
        searchTextField.resignFirstResponder()
        let searchText = searchTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if searchText.count == 0{
            MyNavigations.showCommonMessageDialog(message: "Please type search keyword", buttonTitle: "OK")
        }else{
            CommonWebServices.api.searchProduct(navigationController: navigationController, name: searchText, lat: currentLat, lng: currentLng, myLocationAvailable: myLocationAvailable, delegate: self)
        }
    }
    
    func onSearchResultReceived(status: String, message: String, data: CommonSearchResponse?) {
        CommonMethods.showLog(tag: TAG, message: "onSearchResultReceived status : \(status)")
        CommonMethods.showLog(tag: TAG, message: "onSearchResultReceived message : \(message)")
        switch status {
        case "1":
            self.data = data
            isDataSearched = true
            tableView.reloadData()
            break
        default:
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return isDataSearched ? 1 : 0
        case 1:
            return data?.storeList?.count == 0 ? 1 : 0
        case 2:
            return data?.storeList?.count == 0 ? 0 : 1
        case 3:
            return isDataSearched ? 1 : 0
        case 4:
            return data?.productList?.count == 0 ? 1 : 0
        case 5:
            return data?.productList?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonSearchTitleTVC", for: indexPath) as! CommonSearchTitleTVC
            cell.titleLabel.text = "Stores"
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonSearchNoDataTVC", for: indexPath) as! CommonSearchNoDataTVC
            cell.messageLabel.text = "It seems like there is no store available for this keyword."
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonSearchStoresTVC", for: indexPath) as! CommonSearchStoresTVC
            cell.setDetail(storesList: data?.storeList ?? [], navigationController: navigationController)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonSearchTitleTVC", for: indexPath) as! CommonSearchTitleTVC
            cell.titleLabel.text = "Products"
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonSearchNoDataTVC", for: indexPath) as! CommonSearchNoDataTVC
            cell.messageLabel.text = "It seems like there is no product available for this keyword."
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTVC", for: indexPath) as! ProductListTVC
            cell.setDetail(data: data?.productList?[indexPath.row], delegate: self, position: indexPath.row, databaseMethods: databaseMethods, calledFrom: MyConstants.VIEW_ALL_PRODUCTS)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonSearchTitleTVC", for: indexPath) as! CommonSearchTitleTVC
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        backButtonPressed(sender)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        CommonMethods.showLog(tag: TAG, message: "textFieldShouldReturn")
        getData()
        return true
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.ADD_TO_CART:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: data?.productList?[position].product_id, refreshProductsListDelegate: self)
            break
        case MyConstants.REFRESH_DATA:
            tableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
            break
        default:
            break
        }
    }
    
    func onProductRefreshCalled() {
        CommonMethods.showLog(tag: TAG, message: "onProductRefreshCalled")
        tableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        searchTextField.resignFirstResponder()
        CommonMethods.dismissCurrentViewController()
    }
}
