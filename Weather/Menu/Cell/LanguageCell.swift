//
//  SideMenuCell.swift
//  Weather
//
//  Created by Carles on 22/1/22.
//

import Foundation
import UIKit

class LanguageCell: UITableViewCell {
    @IBOutlet var countryImg: UIImageView!
    @IBOutlet var countryLabel: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
