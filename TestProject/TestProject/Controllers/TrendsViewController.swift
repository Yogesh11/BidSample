//
//  TrendsViewController.swift
//  TestProject
//
//  Created by wooqer on 06/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import SVProgressHUD
class TrendsViewController: UIViewController {
    private var trendsViewModel : TrendsViewModel! = TrendsViewModel()
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
        tableLayout.delegate    = self
        tableLayout.dataSource  = self
        tableLayout.estimatedRowHeight = UITableViewAutomaticDimension
        tableLayout.tableFooterView = UIView(frame: .zero)
        tableLayout.refreshControl        = refreshControl
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
    }

    private func getData(){
        SVProgressHUD.show()
        trendsViewModel.fetchData { (json, error) in
            if let err = error {
                self.showAlert(message: err.errorMessage, title: err.errortitle)
            }
            else{
                self.tableLayout.reloadData()
            }
            SVProgressHUD.dismiss()
        }
    }
    
    @objc private func pullToRefresh(_ refreshControl: UIRefreshControl){
        refreshControl.endRefreshing()
        getData()
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

extension TrendsViewController : UITableViewDelegate, UITableViewDataSource, HomeCellDelegate {
    func startBid(index: Int) {
        openDetail(indexValue: index)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendsViewModel.trendsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell1
        cell.delegate = self
        cell.indexValue = indexPath.row
        cell.displayData(model: trendsViewModel.trendsModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openDetail(indexValue: indexPath.row)
    }
    
    private func openDetail(indexValue : Int){
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.model = trendsViewModel.trendsModel[indexValue]
        self.navigationController?.pushViewController(detailController, animated: true);
    }
}

