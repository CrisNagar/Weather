//
//  ViewController.swift
//  Weather
//
//  Created by Carles on 22/1/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var citySearch: UISearchBar!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var maxTempImg: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    @IBOutlet weak var minTempImg: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var humidityImg: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var sunriseImg: UIImageView!
    @IBOutlet weak var sunriseLabel: UILabel!
    
    @IBOutlet weak var sunsetImg: UIImageView!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    private let apiController = WeatherController()
    private var menuViewController: MenuViewController?
    private var menuShadowView: UIView = UIView()
    private var menuWidth: CGFloat = 260
    private var padding: CGFloat = 150
    private var isExpanded: Bool = false
    private var menuTrailingConstraint: NSLayoutConstraint?
    private var revealMenuOnTop: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citySearch.delegate = self
        
        Task{
            await apiController.getWeatherr(city: "elche")
            insertShadowView()
            insertMenu()
            loadInfo()
            loadDefaultImages()
            setGradientBackground()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction open func revealMenu() {
        menuState(expanded: !isExpanded)
        
        
    }
    
    private func insertShadowView() {
        menuShadowView = UIView(frame: self.view.bounds)
        menuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        menuShadowView.backgroundColor = .black
        menuShadowView.alpha = 0.0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        if (revealMenuOnTop) {
            self.view.insertSubview(self.menuShadowView, at: 1)
        }
    }
    
    private func insertMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        menuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuID") as? MenuViewController
        menuViewController?.defaultHighlightedCell = 0
        menuViewController?.delegate = self
        
        if let menuView = menuViewController?.view {
            self.view.insertSubview(menuView, at: 9)
            
            menuView.translatesAutoresizingMaskIntoConstraints = false
            if revealMenuOnTop {
                menuTrailingConstraint = menuViewController?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -menuWidth - padding)
                menuTrailingConstraint?.isActive = true
                
                NSLayoutConstraint.activate([
                    menuView.widthAnchor.constraint(equalToConstant: menuWidth),
                    menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    menuView.topAnchor.constraint(equalTo: view.topAnchor)
                ])
            }
        }
        
        addChild(menuViewController ?? UIViewController())
        menuViewController?.didMove(toParent: self)
        
        
    }
    
    private func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func loadDefaultImages() {
        maxTempImg.image = UIImage(systemName: "thermometer.sun.fill")?.applyingSymbolConfiguration(.preferringMulticolor())
        minTempImg.image = UIImage(systemName: "thermometer.snowflake")?.applyingSymbolConfiguration(.preferringMulticolor())
        humidityImg.image = UIImage(systemName: "humidity.fill")?.applyingSymbolConfiguration(.preferringMulticolor())
        sunriseImg.image = UIImage(systemName: "sunrise.fill")?.applyingSymbolConfiguration(.preferringMulticolor())
        sunsetImg.image = UIImage(systemName: "sunset.fill")?.applyingSymbolConfiguration(.preferringMulticolor())
    }
    
    private func loadInfo() {
        cityLabel.text = apiController.info.city.capitalized
        descriptionLabel.text = apiController.info.description.uppercased()
        maxTempLabel.text = apiController.info.maxTemperature
        minTempLabel.text = apiController.info.minTemperature
        humidityLabel.text = apiController.info.humidity
        sunriseLabel.text = WeatherModel.getSunsetSunriseFormatted(apiController.info.sunrise)
        sunsetLabel.text = WeatherModel.getSunsetSunriseFormatted(apiController.info.sunset)
    }
    
    private func showMainViewController() -> ViewController? {
        var viewController: UIViewController? = self
        
        if let vc = viewController as? ViewController {
            return vc
        }
        
        while (!(viewController is ViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent as? ViewController
        }
        
        if (viewController is ViewController) {
            return viewController as? ViewController
        }
        
        return nil
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        Task {
            await apiController.getWeatherr(city: searchBar.text ?? "")
            loadInfo()
        }
    }
}

extension ViewController: SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        // TODO
    }
    
    func menuState(expanded: Bool) {
        if expanded {
            animatedMenu(targetPosition: self.revealMenuOnTop ? 0 : self.menuWidth) {
                _ in self.isExpanded = true
            }
            
            UIView.animate(withDuration: 0.5) {
                self.menuShadowView.alpha = 0.6
            }
            
            
        } else {
            self.animatedMenu(targetPosition: self.revealMenuOnTop ? (-menuWidth - padding) : 0) {
                _ in self.isExpanded = false
            }
            
            UIView.animate(withDuration: 0.5) {
                self.menuShadowView.alpha = 0.0
            }
            
            
        }
        
        
    }
    
    func animatedMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0,
                       options: .layoutSubviews,
                       animations: {
            if self.revealMenuOnTop {
                self.menuTrailingConstraint?.constant = targetPosition
                self.view.layoutIfNeeded()
            } else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        },
                       completion: completion)
        
        
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            menuState(expanded: false)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let v = touch.view, let mvcv = menuViewController?.view {
            if(v.isDescendant(of: mvcv)) {
                return false
            }
        }
        
        return true
    }
}
