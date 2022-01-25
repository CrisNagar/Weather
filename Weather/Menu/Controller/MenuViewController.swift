//
//  SideMenuViewController.swift
//  Weather
//
//  Created by Carles on 22/1/22.
//

import Foundation
import UIKit
import FlagKit
import SwiftUI

protocol MenuViewControllerDelegate {
    func selected(lang: LocalizableUtil)
    func selected(city: String)
    func menuState(expanded: Bool)
    func animatedMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ())
}

class MenuViewController: UIViewController {
    @IBOutlet var logoImg: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var footerLabel: UILabel!
    
    var delegate: MenuViewControllerDelegate?
    var config = MenuViewConfig()
    
    private let apiController = WeatherController()
    
    private var favorites: [MenuFavoriteModel] = [
        MenuFavoriteModel(city: "london_city".localized),
        MenuFavoriteModel(city: "toronto_city".localized),
        MenuFavoriteModel(city: "singapur_city".localized)
    ]
    private var langOptions: [MenuLanguageModel] = [
        MenuLanguageModel(icon: UIImage(named: DefaultLangs.getCode(.English), in: FlagKit.assetBundle, compatibleWith: nil), title: "english_lang".localized, code: LocalizableUtil.english),
        MenuLanguageModel(icon: UIImage(named: DefaultLangs.getCode(.Spanish), in: FlagKit.assetBundle, compatibleWith: nil), title: "spanish_lang".localized, code: LocalizableUtil.spanish)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogo()
        configureTableView()
    }
    
    public func addShadowView(thisView: UIView, _ inViewController: UIViewController) {
        var menuShadowView: UIView = UIView()
        menuShadowView = UIView(frame: inViewController.view.bounds)
        menuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        menuShadowView.backgroundColor = .black
        menuShadowView.alpha = 0.0
        
        if (config.revealOnTop) {
            self.view.insertSubview(menuShadowView, at: 1)
        }
    }
    
    public func configureTrailing() {
        if config.revealOnTop {
            config.trailingConstraint = self.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -config.width - config.padding)
            config.trailingConstraint?.isActive = true
        }
    }
    
    private func setLogo() {
        self.logoImg.image = UIImage(named: "logo_white_cropped")
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(LanguageCell.nib, forCellReuseIdentifier: LanguageCell.identifier)
        self.tableView.register(FavoriteCell.nib, forCellReuseIdentifier: FavoriteCell.identifier)
        
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate && UITableViewDataSource

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return langOptions.count
        } else {
            return favorites.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if(indexPath.section == 0) {
            if let langCell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as? LanguageCell {
                langCell.countryImg.image = self.langOptions[indexPath.row].icon
                langCell.countryLabel.text = self.langOptions[indexPath.row].title.localized
                
                return langCell
            }
        }
        
        if(indexPath.section == 1) {
            if let favCell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell {
                favCell.cityLabel.text = self.favorites[indexPath.row].city.localized
                
                return favCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if let _ = tableView.dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as? LanguageCell {                
                delegate?.menuState(expanded: false)
                delegate?.selected(lang: langOptions[indexPath.row].code)
            }
        }
        
        if (indexPath.section == 1) {
            if let _ = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell {
                delegate?.menuState(expanded: false)
                delegate?.selected(city: favorites[indexPath.row].city)
            }
        }
    }
}
