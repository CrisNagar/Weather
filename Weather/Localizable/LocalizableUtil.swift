//
//  LocalizableUtil.swift
//  Weather
//
//  Created by Carles on 22/1/22.
//

import Foundation
import SwiftUI

enum LocalizableUtil: String {
    
    case english = "en"
    case spanish = "es"
    
    var semantic: UISemanticContentAttribute {
        switch self {
        case .english, .spanish:
            return .forceLeftToRight
        }
    }
    
    static var language: LocalizableUtil {
        get {
            if let languageCode = UserDefaults.standard.string(forKey: "weather_lang"), let language = LocalizableUtil(rawValue: languageCode) {
                return language
            } else {
                return LocalizableUtil.english
            }
        }
        set {
            guard language != newValue else {
                return
            }
            
            if let _ = try? JSONEncoder().encode(newValue.rawValue) {
                UserDefaults.standard.set(newValue.rawValue, forKey: "weather_lang")
                UserDefaults.standard.synchronize()
                
                UIView.appearance().semanticContentAttribute = newValue.semantic
                UIApplication.shared.windows.first?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MainViewID")
            }
            
            
        }
    }
}

extension String {
    var localized: String {
        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }
}

extension Bundle {
    static var localizedBundle: Bundle {
        let languageCode = LocalizableUtil.language.rawValue
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            return Bundle.main
        }
        return Bundle(path: path)!
    }
}
