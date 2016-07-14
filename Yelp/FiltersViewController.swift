//
//  FilterViewController.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/14/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum SectionDisplayMode {
        case Expanded, Collapsed
    }
    
    var distanceDisplayMode = SectionDisplayMode.Collapsed
    var distanceChoice = Filter.distance[0]
    var distanceRowData = [Filter.distance[0]]
    var distanceRowStates = [Bool](count: Filter.distance.count, repeatedValue: false)
    
    var sortByDisplayMode = SectionDisplayMode.Collapsed
    
    var categoriesDisplayMode = SectionDisplayMode.Collapsed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        distanceRowStates[0] = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Filter.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return distanceRowData.count
        case 2:
            return 1
        case 3:
            return Filter.categories.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Filter.sections[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            cell.switchToggle.on = false
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CheckmarkCell") as! CheckmarkCell
            cell.checkmarkLabel.text = distanceRowData[indexPath.row]["name"] as? String
            if distanceDisplayMode == .Collapsed {
                cell.state = .Collapsed
            } else {
                cell.state = distanceRowStates[indexPath.row] ? .Checked : .Unchecked
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CheckmarkCell") as! CheckmarkCell
            cell.checkmarkLabel.text = Filter.sortBy[indexPath.row]["name"] as? String
            if sortByDisplayMode == .Collapsed {
                cell.state = .Collapsed
            } else {
                cell.state = .Unchecked
            }
            return cell
        } else {
            if categoriesDisplayMode == .Collapsed && indexPath.row == Filter.categories.count - 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ShowAllCell") as! ShowAllCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
                cell.switchLabel.text = "Offering a Deal"
                cell.switchToggle.on = false
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if distanceDisplayMode == .Collapsed {
                distanceDisplayMode = .Expanded
                distanceRowData = Filter.distance
                var indexPaths = [NSIndexPath]()
                for row in 0..<distanceRowData.count {
                    indexPaths.append(NSIndexPath(forRow: row, inSection: indexPath.section))
                }
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: indexPath.section)], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
    }
}