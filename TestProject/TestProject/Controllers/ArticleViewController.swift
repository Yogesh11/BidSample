//
//  ViewController.swift
//  TestProject
//
//  Created by Yogesh on 08/12/18..
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import SVProgressHUD
import UIScrollView_InfiniteScroll

class ArticleViewController: UIViewController {
    @IBOutlet weak var tableLayout: UITableView!
    private let articleViewModel : ArticleViewModel! = ArticleViewModel()
    /** refreshControl : It is used when user swipe from up. When os detects a swipe then "pullToRefresh" function will be called */
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(pullToRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeView()
        loadFromDb()
        loadMoreSetup()
        loadMore()
    }

    private func loadFromDb(){
        articleViewModel.loadFromDb()
        refreshView()
    }
    
    private func loadMore(){
        SVProgressHUD.show()
        articleViewModel.loadArticles { (json, error) in
            print("json \(json)")
            if let apiError = error {
                self.showAlert(message: apiError.errorMessage, title: apiError.errortitle)
            } else{
                self.refreshView()
            }
            SVProgressHUD.dismiss()
            self.tableLayout.finishInfiniteScroll()
        
        }
    }
    
    /** When user swipe down then below function will call and fetch first batch data from remote*/
    @objc private func pullToRefresh(_ refreshControl: UIRefreshControl){
        articleViewModel.pageNumber = 1
        loadMore()
        refreshControl.endRefreshing()
    }
    
    private func initializeView(){
        tableLayout.delegate    = self
        tableLayout.dataSource  = self
        tableLayout.estimatedRowHeight = UITableViewAutomaticDimension
        tableLayout.tableFooterView = UIView(frame: .zero)
        SVProgressHUD.setDefaultMaskType(.clear)
        tableLayout.refreshControl        = refreshControl
    }
    
    private func refreshView(){
        tableLayout.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** setup for infinite scroll */
    private func loadMoreSetup() {
        tableLayout.addInfiniteScroll { (tableView) -> Void in
            self.articleViewModel.pageNumber = self.articleViewModel.pageNumber + 1
            self.loadMore()
        }
    }


}

extension ArticleViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModel.articleStorage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.kArticleCell) as! ArticleCell
        cell.displayData(articleModel: articleViewModel.articleStorage[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = articleViewModel.articleStorage[indexPath.row]
        if let clickableUrl = model.clickableUrl {
            UIApplication.shared.openURL(clickableUrl)
        } else{
            showAlert(message: "Not a valid url", title: "Message")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

