//
//  LifeStyleVC.swift
//  Steerlyfe
//
//  Created by nap on 29/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class LifeStyleVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AllPostsDelegate, UITableViewDelegate, UITableViewDataSource, ButtonPressedAtPositionDelegate {
    
    let TAG = "LifeStyleVC"
    let databaseMethods = DatabaseMethods()
    let refreshControl = UIRefreshControl()
    
    var refresh = true
    var isLoading = false
    var showLoading : Bool = false
    var isLast = false
    var categoryList : [CategoryDetail] = []
    var categoryDetail : CategoryDetail?
    var postList : [PostDetail] = []
    var viewedPostIds : [String] = []
    var submittedViewedPostIds : [String] = []
    
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainOuterView: UIView!
    @IBOutlet weak var mainContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryList = databaseMethods.getAllCategories()
        if categoryList.count > 0{
            categoryDetail = categoryList[0]
            setUI()
            getData()
        }
    }
    
    func setUI() {
        CommonMethods.addRoundCornerFilled(uiview: mainOuterView, borderWidth: 0.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: 20.0)
        CommonMethods.addRoundCornerFilled(uiview: mainContainer, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 20.0)
        collectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoryTitleCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryTitleCVC")
        
        
        tableView.register(UINib(nibName: "PostListTVC", bundle: nil), forCellReuseIdentifier: "PostListTVC")
        tableView.register(UINib(nibName: "PaginationTVC", bundle: nil), forCellReuseIdentifier: "PaginationTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tableView.reloadData()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryTitleCVC", for: indexPath) as! CategoryTitleCVC
        cell.setDetail(data: categoryList[indexPath.row], currentCategory: categoryDetail)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categoryDetail?.categoryId != categoryList[indexPath.row].categoryId{
            categoryDetail = categoryList[indexPath.row]
            collectionView.reloadData()
            DispatchQueue.main.async {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                if self.postList.count > 0{
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    DispatchQueue.main.async {
                        self.refresh = true
                        self.getData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: collectionView.frame.height)
    }
    
    @objc func onRefresh(_ sender : Any) {
        refreshControl.endRefreshing()
        refresh = true
        getData()
    }
    
    func getData() {
        noDataMessage.isHidden = true
        var paginationCount = 0
        if refresh {
            paginationCount = 0
            KVNProgress.show()
        }else{
            paginationCount = postList.count
        }
        isLoading = true
        CommonWebServices.api.getPosts(navigationController: navigationController, categoryId: categoryDetail?.categoryId ?? "", count: paginationCount, delegate: self)
        checkAndSubmitViews()        
    }
    
    func onPostDataReceived(status: String, message: String, data: AllPostsResponse?) {
        showLoading = false
        self.refreshControl.endRefreshing()
        isLoading = false
        switch status {
        case "1":
            KVNProgress.dismiss()
            if refresh{
                self.postList = []
            }
            data?.postList.forEach({ (postDetail) in
                self.postList.append(postDetail)
            })
            refresh = false
            if (data?.postList.count ?? 0) < (data?.perPageItems ?? 10){
                isLast = true
            }else{
                showLoading = true
                isLast = false
            }
            if self.postList.count > 0{
                noDataMessage.isHidden = true
            }else{
                noDataMessage.isHidden = false
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            break
        default:
            CommonMethods.dismissLoadingAndShowMessage(message: message, buttonTitle: "OK")
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return postList.count
        case 1:
            return showLoading ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            switch indexPath.section {
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaginationTVC", for: indexPath) as! PaginationTVC
                cell.setDetail()
                addLoadingCell()
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostListTVC", for: indexPath) as! PostListTVC
                cell.setDetail(data: postList[indexPath.row], uiViewController: self, delegate: self, position: indexPath.row)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                postViewed(postId: postList[indexPath.row].postId)
                return cell
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func addLoadingCell() {
        if !isLoading && !isLast{
            getData()
        }
    }
    
    func postViewed(postId : String?) {
        CommonMethods.showLog(tag: TAG, message: "postViewed postId : \(postId ?? "")")
        if let id = postId{
            if !viewedPostIds.contains(id){
                viewedPostIds.append(id)
            }
            CommonMethods.showLog(tag: TAG, message: "postViewed size : \(viewedPostIds.count)")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        CommonMethods.showLog(tag: TAG, message: "viewDidDisappear viewedPostIds size : \(viewedPostIds.count)")
        CommonMethods.showLog(tag: TAG, message: "viewDidDisappear submittedViewedPostIds size : \(submittedViewedPostIds.count)")
        checkAndSubmitViews()
    }
    
    func checkAndSubmitViews(){
        var jsonCollection = [Any]()
        for loopValue in viewedPostIds {
            if !submittedViewedPostIds.contains(loopValue){
                submittedViewedPostIds.append(loopValue)
                jsonCollection.append(loopValue)
            }
        }
        if jsonCollection.count > 0{
            let finalJson = CommonMethods.prepareJson(from: jsonCollection) ?? "[]"
            CommonMethods.showLog(tag: TAG, message: "finalJson : \(finalJson)")
            CommonWebServices.api.updatePostViews(postIds: finalJson)
        }
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "onButtonPressed type : \(type) position : \(position)")
        switch type {
        case MyConstants.SHARE_POST:
            let postData = postList[position]
            CommonMethods.sharePost(navigationController: navigationController, postPublicId: postData.postPublicId ?? "", sourceView: self.view)
            break
        default:
            break
        }
    }
    
}
