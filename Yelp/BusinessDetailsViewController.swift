//
//  BusinessDetailsViewController.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/16/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import UIKit

class BusinessDetailsViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let imageLargeURL = business.imageLargeURL {
            imgView.setImageWithURL(imageLargeURL)
        }
        
        let tableHeaderView = BusinessDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 215))
        tableHeaderView.business = business
        tableView.tableHeaderView = tableHeaderView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tableHeaderView = tableView.tableHeaderView as! BusinessDetailsHeaderView
        tableHeaderView.topContainerView.alpha = 1
        blurView.alpha = 0.8
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BusinessDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}