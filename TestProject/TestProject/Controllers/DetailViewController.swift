//
//  DetailViewController.swift
//  TestProject
//
//  Created by wooqer on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import SVProgressHUD
import SRCountdownTimer

class DetailViewController: UIViewController{
    weak var model : HomeModel?
    var viewModel  : DetailViewModel! = DetailViewModel()
    var willRunAnApi : Bool = true
    var isBidStart : Bool = true
    @IBOutlet weak var tableLayout: UITableView!
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(pullToRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.model = model
        tableLayout.delegate    = self
        tableLayout.dataSource  = self
        tableLayout.estimatedRowHeight =  UITableViewAutomaticDimension
        tableLayout.tableFooterView = UIView(frame: .zero)
        tableLayout.refreshControl        = refreshControl
        self.title = model?.modelName
        fetchUpdatedData(isLoaderNeeded: true)
        tableLayout.isScrollEnabled = true
        let time = model?.getTimeDifferenceInMinutes() as! Date
        var labelValue : String? = nil
        if time.days(from: Date()) > 0{
            labelValue = "Bid Will start after " + "\(Date().offset(from: time))"
        } else{
            if time.hours(from: Date()) > 0{
                labelValue = "Bid Will start after " + "\(time .offset(from: Date()))"
            } else if time.minutes(from: Date()) > 30 {
                 labelValue = "Bid Will start after " + "\(time .offset(from: Date()))"
            } else{
                if time.seconds(from: Date()) > 0 {
                    let counter = SRCountdownTimer(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
                    counter.backgroundColor = UIColor.white
        
                    counter.delegate = self
                    counter.timerFinishingText = "Bid has been closed"
                    counter.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2 + 16)
                    counter.lineColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                    counter.start(beginingValue: time.seconds(from: Date()), interval: 1)
                    self.view.addSubview(counter);
                } else{
                    labelValue = "Bid has been closed"
                }
            }
        }
     //
    
        if labelValue?.isEmpty == false {
            isBidStart = false
            let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 200))
            label.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2-30)
            label.textAlignment = .center
            label.text = labelValue
            self.view.addSubview(label)
        }
        
        
        
        
//        let countdownLabel = CountdownLabel(frame: CGRect(x: 0, y: 100, width: 300, height: 20), minutes: 30) // you can use NSDate as well
//        countdownLabel.start()
    }
    
    deinit {
        willRunAnApi = false
    }
    
    private func fetchUpdatedData(isLoaderNeeded : Bool){
        if isLoaderNeeded{
            SVProgressHUD.show()
        }
        if viewModel != nil {
            viewModel.fetchDataWithCarID { (json, error) in
                if isLoaderNeeded {
                    if let err = error {
                        self.showAlert(message: err.errorMessage, title: err.errortitle)
                    }
                }
                if error == nil {
                    self.tableLayout.reloadData()
                    if self.willRunAnApi {
                        weak var rootController : DetailViewController? = self
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute:{
                            rootController?.fetchUpdatedData(isLoaderNeeded: false)
                        })
                    }
                    
                    
                }
                
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @objc private func pullToRefresh(_ refreshControl: UIRefreshControl){
        refreshControl.endRefreshing()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController : UITableViewDelegate, UITableViewDataSource, DetailCellDelegate, SRCountdownTimerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell
        cell.selectionStyle = .none
        cell.delegate       = self
        if model != nil {
            cell.displayData(data: model!, bidStart : isBidStart)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
   }
    
    func placeBid() {
        let alertController  = UIAlertController(title: title, message: "Enter Bid Amount", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Amount"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        let alertAction = UIAlertAction(title: Constant.ButtonTitle.koKTitle, style: .cancel, handler: { (action) in
            self.willRunAnApi = false
            SVProgressHUD.show()
            let field =  alertController.textFields?.first
            self.viewModel.postBid(price: field?.text ?? "0", completionBlock: { (json, error) in
                if let err = error {
                    self.showAlert(message: err.errorMessage, title: err.errortitle)
                }
                self.willRunAnApi = true
                 SVProgressHUD.dismiss()
            })
        })
        
        
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func timerDidEnd(){
        isBidStart = false
        self.tableLayout.reloadData()
    }
}
