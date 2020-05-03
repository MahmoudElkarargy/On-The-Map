//
//  TableViewCell.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/3/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var TableLabel: UILabel!
    
    @IBOutlet weak var pinImage: UIImageView!
    
    func setCell(text: String){
        TableLabel.text = text
    }
}
