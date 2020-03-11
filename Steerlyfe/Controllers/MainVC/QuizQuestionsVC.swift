//
//  QuizQuestionsVC.swift
//  Steerlyfe
//
//  Created by nap on 01/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class QuizQuestionsVC: UIViewController, OnProcessCompleteDelegate, UITableViewDelegate, UITableViewDataSource, ConfirmationDialogDelegate {
    
    let TAG = "QuizQuestionsVC"
    let databaseMethods = DatabaseMethods()
    var quizQuestions : [QuizQuestionDetail] = []
    var currentIndex = 0
    var isSkipPressed = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionOuterView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.isHidden = true
        nextButton.isHidden = true
        CommonMethods.addCardViewStyle(uiView: questionOuterView, cornerRadius: 20.0, shadowColor: UIColor.gray)
        questionOuterView.isHidden = true
        tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        CommonMethods.addRoundCornerFilled(uiview: nextButton, borderWidth: 0.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: nextButton.frame.height / 2.0)
        CommonMethods.addRoundCornerFilled(uiview: previousButton, borderWidth: 0.0, borderColor: UIColor.black, backgroundColor: UIColor.black, cornerRadius: previousButton.frame.height / 2.0)
        //        CommonMethods.roundCornerFilledGradient(uiView: nextButton, cornerRadius: 20.0)
        //        CommonMethods.roundCornerFilledGradient(uiView: previousButton, cornerRadius: 20.0)
        quizQuestions = databaseMethods.getAllQuizQuestions()
        CommonMethods.showLog(tag: TAG, message: "SIZE : \(quizQuestions.count)")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UINib(nibName: "QuizQuestionOptionTVC", bundle: nil), forCellReuseIdentifier: "QuizQuestionOptionTVC")
        tableView.delegate = self
        tableView.dataSource = self
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        if quizQuestions.count > 0{
            setDetail()
        }else{
            KVNProgress.show()
            CommonWebServices.api.getStaticData(delegate: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "currentIndex : \(currentIndex)")
        if currentIndex == quizQuestions.count - 1{
            if quizQuestions[currentIndex].selected_options_index.count > 0{
                isSkipPressed = false
                CommonAlertMethods.showConfirmationAlert(navigationController: navigationController, title: MyConstants.APP_NAME, message: "Do you want to submit these questions?", yesText: "Submit", noString: "Cancel", delegate: self)
            }else{
                MyNavigations.showCommonMessageDialog(message: "Please choose your option", buttonTitle: "Ok")
            }
        }else{
            if currentIndex < quizQuestions.count {
                if quizQuestions[currentIndex].selected_options_index.count > 0{
                    if currentIndex < quizQuestions.count - 1{
                        currentIndex = currentIndex + 1
                        setDetail()
                    }
                }else{
                    MyNavigations.showCommonMessageDialog(message: "Please choose your option", buttonTitle: "Ok")
                }
            }
        }
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        if currentIndex != 0{
            currentIndex = currentIndex - 1
            setDetail()
        }
    }
    
    func setDetail() {
        if currentIndex >= 0 && currentIndex < quizQuestions.count{
            questionOuterView.isHidden = false
            //            questionNumberLabel.text = "Question # \(currentIndex + 1)"
            questionCountLabel.text = "\(currentIndex + 1) of \(quizQuestions.count)"
            questionLabel.text = quizQuestions[currentIndex].question
            if currentIndex < quizQuestions.count - 1{
                nextButton.setTitle("Next Question".uppercased(), for: .normal)
            }else{
                nextButton.setTitle("Submit Questions".uppercased(), for: .normal)
            }
            nextButton.isHidden = false
            previousButton.setTitle("Previous Question", for: .normal)
            if currentIndex == 0{
                previousButton.isHidden = true
            }else{
                previousButton.isHidden = false
            }
            tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    func onProcessComplete(type: String, status: String, message: String) {
        KVNProgress.dismiss {
            CommonMethods.showLog(tag: self.TAG, message: "onProcessComplete type : \(type)")
            CommonMethods.showLog(tag: self.TAG, message: "onProcessComplete status : \(status)")
            CommonMethods.showLog(tag: self.TAG, message: "onProcessComplete message : \(message)")
            switch type {
            case "GetStaticData":
                switch status{
                case "1":
                    self.quizQuestions = self.databaseMethods.getAllQuizQuestions()
                    if self.quizQuestions.count > 0{
                        self.currentIndex = 0
                        self.setDetail()
                    }else{
                        CommonMethods.dismissCurrentViewController()
                        MyNavigations.goToMain(navigationController: self.navigationController)
                    }
                    break
                default:
                    break
                }
                break
            default:
                MyNavigations.showCommonMessageDialog(message: "Unable to get Quiz Questions", buttonTitle: "Ok")
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quizQuestions.count > 0{
            return quizQuestions[currentIndex].options_list.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizQuestionOptionTVC", for: indexPath) as! QuizQuestionOptionTVC
            if quizQuestions.count > 0{
                let innerData = quizQuestions[currentIndex]
                cell.setDetail(data: innerData, currentIndex: indexPath.row)
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentIndex<quizQuestions.count{
            let currentData = quizQuestions[currentIndex]
            if currentData.selected_options_index.contains(indexPath.row){
                if let index = currentData.selected_options_index.firstIndex(of: indexPath.row){
                    CommonMethods.showLog(tag: TAG, message: "index : \(index)")
                    currentData.selected_options_index.remove(at: index)
                }
            }else{
                currentData.selected_options_index.append(indexPath.row)
            }
            tableView.reloadData()
        }
    }
    
    func prepareApiData()->String {
        var jsonCollection = [Any]()
        for loopValue in quizQuestions {
            if loopValue.selected_options_index.count > 0{
                var dataCollection = [String:Any]()
                dataCollection["question_id"] = loopValue.question_id
                var innerDataCollection = [String]()
                loopValue.selected_options_index.forEach { (position) in
                    if position < loopValue.options_list.count{
                        innerDataCollection.append(loopValue.options_list[position])
                    }
                }
                dataCollection["options"] = innerDataCollection
                jsonCollection.append(dataCollection)
            }
        }
        return CommonMethods.prepareJson(from: jsonCollection) ?? "[]"
    }
    
    func onConfirmationButtonPressed(yesPressed: Bool) {
        if yesPressed{
            if isSkipPressed{
                CommonWebServices.api.submitQuizQuestions(navigationController: navigationController, isSkipped: 1, quizResponse: "")
            }else{                
                let jsonData = prepareApiData()
                CommonMethods.showLog(tag: TAG, message: "jsonData : \(jsonData)")
                CommonWebServices.api.submitQuizQuestions(navigationController: navigationController, isSkipped: 0, quizResponse: jsonData)
            }
        }
    }   
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        isSkipPressed = true
        CommonAlertMethods.showConfirmationAlert(navigationController: navigationController, title: MyConstants.APP_NAME, message: "Do you want to skip quiz questions?", yesText: "Skip", noString: "Cancel", delegate: self)
    }
}
