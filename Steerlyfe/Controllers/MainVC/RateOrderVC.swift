//
//  RateOrderVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 20/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class RateOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource, OrderFeedbackQuestionsDelegate, RatingChangeDelegate, OnProcessCompleteDelegate {
    
    let TAG = "RateOrderVC"
    
    var order_id : String?
    var questionList : [OrderFeedbackQuestionDetail] = []
    var delegate : OnProcessCompleteDelegate?
    
    @IBOutlet weak var submitRating: UIButton!
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonMethods.showLog(tag: TAG, message: "order_id : \(order_id ?? "")")
        setUI()
        CommonWebServices.api.getOrderFeedbackQuestions(navigationController: navigationController, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUI() {
        noDataMessage.isHidden = true
        submitRating.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "RateOrderQuestionTVC", bundle: nil), forCellReuseIdentifier: "RateOrderQuestionTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        CommonMethods.dismissCurrentViewController()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateOrderQuestionTVC", for: indexPath) as! RateOrderQuestionTVC
        cell.setDetail(data: questionList[indexPath.row], delegate: self, position: indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.BUY_AGAIN_PRESSED:
            break
        default:
            break
        }
    }
    
    func onOrderFeedbackQuestionReceived(status: String, message: String, data: OrderFeedbackQuestionsResponse?) {
        CommonMethods.showLog(tag: TAG, message: "onOrderFeedbackQuestionReceived status : \(status)" )
        CommonMethods.showLog(tag: TAG, message: "onOrderFeedbackQuestionReceived message : \(message)" )
        switch status {
        case "1":
            data?.questionList.forEach({ (question) in
                question.rating = 0.0
                self.questionList.append(question)
                //                self.questionList.append(question)
                //                self.questionList.append(question)
                //                self.questionList.append(question)
                //                self.questionList.append(question)
                //                self.questionList.append(question)
            })
            tableView.reloadData()
            noDataMessage.isHidden = self.questionList.count != 0
            submitRating.isHidden = self.questionList.count == 0
            break
        default:
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
            break
        }
    }
    
    @IBAction func submitRatingPressed(_ sender: Any) {
        var isEmpty = false
        var message = ""
        questionList.forEach { (questionData) in
            if !isEmpty{
                CommonMethods.showLog(tag: TAG, message: "submitRatingPressed loop question_id : \(questionData.question_id ?? "")")
                if let rating = questionData.rating{
                    if rating < 1{
                        isEmpty = true
                    }
                }else{
                    isEmpty = true
                }
                if isEmpty{
                    message = """
                    Please rate
                    '\(questionData.question ?? "")'
                    """
                }
            }
        }
        CommonMethods.showLog(tag: TAG, message: "submitRatingPressed isEmpty : \(isEmpty)")
        CommonMethods.showLog(tag: TAG, message: "submitRatingPressed message : \(message)")
        if isEmpty{
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "Ok")
        }else{
            CommonMethods.showLog(tag: TAG, message: "submitRatingPressed done")
            prepareJson()
        }
    }
    
    func onRatingChanged(position: Int, rating: Double?) {
        CommonMethods.showLog(tag: self.TAG, message: "onRatingChanged position : \(position) rating : \(rating ?? 0.0 )")
        self.questionList[position].rating = rating
    }
    
    
    func prepareJson() {
        var jsonCollection = [Any]()
        for loopValue in questionList {
            var dataCollection = [String:Any]()
            dataCollection["question_id"] = loopValue.question_id
            dataCollection["rating"] = loopValue.rating
            jsonCollection.append(dataCollection)
        }
        let finalJson = CommonMethods.prepareJson(from: jsonCollection) ?? "[]"
        CommonMethods.showLog(tag: TAG, message: "finalJson : \(finalJson)")
        CommonWebServices.api.submitOrderReview(navigationController: navigationController, order_id: order_id ?? "", order_reviews: finalJson, delegate: self)
    }
    
    func onProcessComplete(type: String, status: String, message: String) {
        switch type {
        case MyConstants.SUBMIT_ORDER_RATING:
            switch status {
            case "1":
                KVNProgress.showSuccess(withStatus: message) {
                    CommonMethods.dismissCurrentViewController()
                    DispatchQueue.main.async {
                        self.delegate?.onProcessComplete(type: MyConstants.SUBMIT_ORDER_RATING, status: "1", message: message)
                    }
                }
                break
            default:
                MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
                break
            }
            break
        default:
            break
        }
    }
}
