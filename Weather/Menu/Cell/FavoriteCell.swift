//
//  FavoriteCell.swift
//  Weather
//
//  Created by Carles on 24/1/22.
//

import Foundation
import UIKit

class FavoriteCell: UITableViewCell {
    @IBOutlet var starImg: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    
    private let userDefaults: UserDefaults = .standard
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func saveCityOnFavorites(_ fav: MenuFavoriteModel) {
        if let encode = try? JSONEncoder().encode(fav) {
            userDefaults.set(encode, forKey: "weather_fav_cities")
        }
    }
}
