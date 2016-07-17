//
//  SwitchCell.swift
//  Yelp
//
//  Created by Doan Cong Toan on 7/14/16.
//  Copyright © 2016 Toan Doan. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didValueChanged value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchToggle: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchValueChanged(sender: UISwitch) {
        delegate?.switchCell?(self, didValueChanged: switchToggle.on)
    }
}
