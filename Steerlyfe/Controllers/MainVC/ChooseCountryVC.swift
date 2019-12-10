//
//  ChooseCountryVC.swift
//  Steerlyfe
//
//  Created by nap on 26/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit

class ChooseCountryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ButtonPressedAtPositionDelegate {
    
    let TAG = "ChooseCountryVC"
    let databaseMethods = DatabaseMethods()
    
    var pageTitle = ""
    var searchedList : [CountryDetail] = []
    var countryList : [CountryDetail] = []
    var countrySelectionDelegate : CountrySelectionDelegate?
    
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.barTintColor = UIColor.colorPrimaryDark
        countryList = databaseMethods.getAllCountries()
        searchedList = countryList
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        noDataMessage.isHidden = true
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        checkAndShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        CommonMethods.common.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: pageTitle)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableViewCell", for: indexPath) as! CountryListTableViewCell
        //            cell.setDetail(data: mealList[indexPath.row], buttonDelegate: self, position: indexPath.row)
        cell.setDetail(data: searchedList[indexPath.row], buttonDelegate: self, position: indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedList.count
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        CommonMethods.common.showLog(tag: TAG, message: "searchBarSearchButtonClicked")
//        if let text = searchBar.text{
//            refresh = true
//            currentPage = 1
//            KVNProgress.show()
//            getData(text: text)
//        }else{
//            MyNavigations.navigation.showCommonMessageDialog(message: "Enter meal name", buttonTitle: "OK")
//        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        CommonMethods.common.showLog(tag: TAG, message: "searchBarCancelButtonClicked")
        closeViewController()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        CommonMethods.common.showLog(tag: TAG, message: "searchText : \(searchText)")
        searchedList = []
        countryList.forEach { (countryDetail) in
            if let name = countryDetail.countryName?.lowercased(){
                if name.contains(searchText.lowercased()){
                    searchedList.append(countryDetail)
                }
            }
        }
        tableView.reloadData()
        checkAndShow()
    }
    
    func onButtonPressed(type: String, position: Int) {
        switch type {
        case "CountrySelected":
            countrySelectionDelegate?.onCountrySelected(countryDetail: searchedList[position])
            closeViewController()
            break
        default:
            break
        }
    }
    
    func closeViewController() {
        navigationController?.popViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func checkAndShow() {
        if searchedList.count > 0 {
            noDataMessage.isHidden = true
        }else{
            noDataMessage.isHidden = false
        }
    }
    
}
