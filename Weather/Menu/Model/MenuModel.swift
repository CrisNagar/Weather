//
//  SideMenuModel.swift
//  Weather
//
//  Created by Carles on 22/1/22.
//

import Foundation
import UIKit
import FlagKit

struct MenuModel {
    var icon: UIImage?
    var title: String
}

enum MenuOptions: String {
    case English
    case Spanish
    
    static func getCode(_ option: MenuOptions) -> String {
        switch (option) {
        case .English:
            return "EN-GB"
        case .Spanish:
            return "ES"
        }
    }
}
