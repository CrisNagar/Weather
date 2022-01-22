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

protocol SideMenuViewControllerDelegate {
    func menuState(expanded: Bool)
    func animatedMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ())
}

class MenuViewController: UIViewController {
    @IBOutlet var logoImg: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var footerLabel: UILabel!
    
    var defaultHighlightedCell: Int = 0
    var delegate: SideMenuViewControllerDelegate?
    
    private var options: [MenuModel] = [
        MenuModel(icon: UIImage(named: MenuOptions.getCode(.English), in: FlagKit.assetBundle, compatibleWith: nil), title: MenuOptions.English.rawValue),
        MenuModel(icon: UIImage(named: MenuOptions.getCode(.Spanish), in: FlagKit.assetBundle, compatibleWith: nil), title: MenuOptions.Spanish.rawValue)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogo()
        configureTableView()        
    }
    
    private func setLogo() {
        self.logoImg.image = UIImage(named: "logo_white_cropped")
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        /*DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.tableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }*/
        
        self.tableView.register(CustomMenuCell.nib, forCellReuseIdentifier: CustomMenuCell.identifier)
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate && UITableViewDataSource

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomMenuCell.identifier, for: indexPath) as? CustomMenuCell
        else {
            return UITableViewCell()
        }
        
        cell.countryImg.image = self.options[indexPath.row].icon
        cell.countryLabel.text = self.options[indexPath.row].title
        
        let customSelectionView = UIView()
        customSelectionView.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)
        cell.selectedBackgroundView = customSelectionView
        
        return cell
    }
}
