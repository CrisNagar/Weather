//
//  SideMenuModel.swift
//  Weather
//
//  Created by Carles on 22/1/22.
//

import Foundation
import UIKit
import FlagKit

struct MenuLanguageModel {
    var icon: UIImage?
    var title: String
    var code: LocalizableUtil
    
    static func getLanguage() {
        
    }
}

struct MenuFavoriteModel: Codable {
    let id: String
    let star: String
    var city: String
    
    init(city: String) {
        self.id = UUID().uuidString
        self.star = "star.fill"
        self.city = city
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case star
        case city
    }
}

struct MenuViewConfig {
    var isExpanded: Bool = false
    var revealOnTop: Bool = true
    var defaultHighlightedCell: Int = 0
    var width: CGFloat = 260
    var padding: CGFloat = 150
    var shadowView: UIView = UIView()
    var trailingConstraint: NSLayoutConstraint?
    var delegate: MenuViewControllerDelegate?
}

enum DefaultLangs: String {
    case English
    case Spanish
    
    static func getCode(_ option: DefaultLangs) -> String {
        switch (option) {
        case .English:
            return "GB"
        case .Spanish:
            return "ES"
        }
    }
}
