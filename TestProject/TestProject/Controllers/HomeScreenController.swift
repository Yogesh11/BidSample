//
//  HomeScreenController.swift
//  TestProject
//
//  Created by wooqer on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeScreenController: UIViewController {
    @IBOutlet weak var tableLayout: UITableView!
    private var homeViewModel : HomeViewModel! = HomeViewModel()
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
           tableLayout.delegate    = self
          tableLayout.dataSource  = self
        tableLayout.estimatedRowHeight = UITableViewAutomaticDimension
        tableLayout.tableFooterView = UIView(frame: .zero)
        tableLayout.refreshControl        = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
    }
    
    private func getData(){
        SVProgressHUD.show()
        homeViewModel.fetchData { (json, error) in
            if let err = error {
                self.showAlert(message: err.errorMessage, title: err.errortitle)
            }
            else{
                self.tableLayout.reloadData()
            }
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userData")
        UserDefaults.standard.synchronize()
        dismiss(animated: true, completion:  nil)
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

extension HomeScreenController : UITableViewDelegate, UITableViewDataSource, HomeCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.homeModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell1
         cell.delegate = self
        cell.indexValue = indexPath.row
        cell.displayData(model: homeViewModel.homeModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openDetail(indexValue: indexPath.row)
    }
    
    func startBid(index: Int) {
        openDetail(indexValue: index)
    }
    
    private func openDetail(indexValue : Int){
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.model = homeViewModel.homeModels[indexValue]
        self.navigationController?.pushViewController(detailController, animated: true);
    }
}

