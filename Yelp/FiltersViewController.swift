//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/14/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    enum SectionDisplayMode {
        case Expanded, Collapsed
    }
    
    var filters = [String: AnyObject]()
    
    var isOfferingADeal = false
    
    var distanceDisplayMode = SectionDisplayMode.Collapsed
    var distanceRowChoice = Filter.distance[0]
    var distanceRowData = [Filter.distance[0]]
    var distanceRowStates = [Bool](count: Filter.distance.count, repeatedValue: false)
    
    var sortByDisplayMode = SectionDisplayMode.Collapsed
    var sortByRowChoice = Filter.sortBy[0]
    var sortByRowData = [Filter.sortBy[0]]
    var sortByRowStates = [Bool](count: Filter.sortBy.count, repeatedValue: false)
    
    var categoriesDisplayMode = SectionDisplayMode.Collapsed
    var categoriesRowData = [Filter.categories[0], Filter.categories[1], Filter.categories[2], ["name": "See All", "code": "see_all"]]
    var categoriesSwitchStates = [Int: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        distanceRowStates[0] = true
        sortByRowStates[0] = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSearchFilters(sender: UIBarButtonItem) {
        filters[Utils.DealsFilter] = isOfferingADeal
        
        filters[Utils.DistanceFilter] = distanceRowChoice["code"] as? Int
        
        filters[Utils.SortByFilter] = sortByRowChoice["code"] as? Int
        
        var selectedCategories = [String]()
        for (row, isSelected) in categoriesSwitchStates {
            if isSelected {
                selectedCategories.append(Filter.categories[row]["code"]!)
            }
        }
        filters[Utils.CategoriesFilter] = selectedCategories.count > 0 ? selectedCategories : nil
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
        Utils.sharedInstance.saveLastSearchFilters(filters)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func onCancelFilters(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
            return sortByRowData.count
        case 3:
            return categoriesRowData.count
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
            cell.delegate = self
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
            cell.checkmarkLabel.text = sortByRowData[indexPath.row]["name"] as? String
            if sortByDisplayMode == .Collapsed {
                cell.state = .Collapsed
            } else {
                cell.state = sortByRowStates[indexPath.row] ? .Checked : .Unchecked
            }
            return cell
        } else {
            if categoriesDisplayMode == .Collapsed && indexPath.row == categoriesRowData.count - 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SeeAllCell") as! SeeAllCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
                cell.delegate = self
                cell.switchLabel.text = Filter.categories[indexPath.row]["name"]
                cell.switchToggle.on = categoriesSwitchStates[indexPath.row] ?? false
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
            } else {
                distanceDisplayMode = .Collapsed
                
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! CheckmarkCell
                cell.state = .Checked
                
                var indexPaths = [NSIndexPath]()
                for row in 0..<distanceRowData.count {
                    distanceRowStates[row] = false
                    indexPaths.append(NSIndexPath(forRow: row, inSection: indexPath.section))
                }
                
                distanceRowStates[indexPath.row] = true
                distanceRowChoice = distanceRowData[indexPath.row]
                distanceRowData = [distanceRowChoice]
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: indexPath.section)], withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
        
        if indexPath.section == 2 {
            if sortByDisplayMode == .Collapsed {
                sortByDisplayMode = .Expanded
                
                sortByRowData = Filter.sortBy
                var indexPaths = [NSIndexPath]()
                for row in 0..<sortByRowData.count {
                    indexPaths.append(NSIndexPath(forRow: row, inSection: indexPath.section))
                }
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: indexPath.section)], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
                tableView.endUpdates()
            } else {
                sortByDisplayMode = .Collapsed
                
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! CheckmarkCell
                cell.state = .Checked
                
                var indexPaths = [NSIndexPath]()
                for row in 0..<sortByRowData.count {
                    sortByRowStates[row] = false
                    indexPaths.append(NSIndexPath(forRow: row, inSection: indexPath.section))
                }
                
                sortByRowStates[indexPath.row] = true
                sortByRowChoice = sortByRowData[indexPath.row]
                sortByRowData = [sortByRowChoice]
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: indexPath.section)], withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
        
        if indexPath.section == 3 && categoriesDisplayMode == .Collapsed && indexPath.row == categoriesRowData.count - 1 {
            categoriesDisplayMode = .Expanded
            
            let startRow = categoriesRowData.count - 1
            categoriesRowData = Filter.categories
            
            var indexPaths = [NSIndexPath]()
            for row in startRow..<categoriesRowData.count {
                indexPaths.append(NSIndexPath(forRow: row, inSection: indexPath.section))
            }
            
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: startRow, inSection: indexPath.section)], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
}

// MARK: - SwitchCellDelegate

extension FiltersViewController: SwitchCellDelegate {
    func switchCell(switchCell: SwitchCell, didValueChanged value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        switch indexPath.section {
        case 0:
            isOfferingADeal = value
        default:
            categoriesSwitchStates[indexPath.row] = value
        }
    }
}