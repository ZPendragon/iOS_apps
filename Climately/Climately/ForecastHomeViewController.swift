//
//  ViewController.swift
//  Climately
//
//  Created by Kevin Zeckser on 3/28/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

import UIKit
import CoreLocation

protocol PageNavigationDelegate {
    func dismissViewController()
}

final class ForecastHomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var cityMenuButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundImageTwo: UIImageView!
    // TODO: Build a loop animation that loops through our image dictionary and displays different backgrounds
    @IBOutlet weak var getWeatherBtn: UIButton!
    fileprivate let locationManager = CLLocationManager()
    fileprivate var selectedIndex: Int?
    fileprivate var menuButton: HamburgerButton?
    
    // MARK: - Sample Values
    fileprivate let testImages: [UIImage] = [UIImage(named: "cityscape_0")!,
                                             UIImage(named: "cityscape_1")!,
                                             UIImage(named: "cityscape_2")!,
                                             UIImage(named: "currentLocation")!]
    
    fileprivate let testCityState: [cityState] = [("Boston","MA"),
                                                  ("Boston","MA"),
                                                  ("Boston","MA"),
                                                  ("Boston","MA")]
    
    // MARK: - Setup
    
    fileprivate func setupVC() {
        self.backgroundImage = UIImageView(image: UIImage(named: "background_1"))
    }
    
    fileprivate func setupBubbleMenu() {
        let bubbleMenu = LIVBubbleMenu(point: self.cityMenuButton.center, radius: 150, menuItems: self.testImages, in: self.view)
        bubbleMenu?.delegate = self
        bubbleMenu?.easyButtons = false
        bubbleMenu?.bubbleRadius = 40
        bubbleMenu?.bubbleSpringBounciness = 30.0
        bubbleMenu?.menuItemImages = self.testImages as NSArray!
        bubbleMenu?.show()
    }
    
    fileprivate func setupLocationManager() {
        // Set up location for use
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.menuButton = HamburgerButton(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        menuButton?.addTarget(self, action: #selector(ForecastHomeViewController.toggle(_:)), for:.touchUpInside)
        let leftMenuButton: UIBarButtonItem = UIBarButtonItem(customView: self.menuButton!)
        navigationItem.leftBarButtonItem = leftMenuButton
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupVC()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupVC()
    }
    
    // MARK: - Actions
    
    @IBAction func showButton(_ sender: Any) {
        setupBubbleMenu()
    }
    
    func toggle(_ sender: AnyObject!) {
        guard let showsMenu = self.menuButton?.showsMenu else {return}
        self.menuButton?.showsMenu = !showsMenu
        
        if showsMenu {
            self.dismiss(animated: true) {
                
            }
        } else {
            // Modal With enter a city / state
            performSegue(withIdentifier: "showModalForm", sender: UIButton.self)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showForecast" {

            let destinationController = segue.destination as? ForecastFeedViewController
            guard let index = self.selectedIndex else { return }
            destinationController?.navigationItem.title = testCityState[index].0
            destinationController?.searchQuery = testCityState[index]
        } else if segue.identifier == "showModalForm" {
            let vc = segue.destination
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ForecastHomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let userLocation: CLLocation = locations[0]
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error)-> Void in
            
            let placemark:CLPlacemark!
            if error == nil && placemarks!.count > 0 {
                placemark = placemarks![0] as CLPlacemark
                
                if placemark.isoCountryCode == "US" {
                    
                    if placemark.locality != nil {
                        //print("City \(placemark.locality)")
                    }
                    if placemark.administrativeArea != nil {
                        //print(placemark.administrativeArea)
                    }
                }
            }
        })
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - LIVBubbleButtonDelegate

extension ForecastHomeViewController: LIVBubbleButtonDelegate {
    
    func livBubbleMenu(_ bubbleMenu: LIVBubbleMenu!, tappedBubbleWith index: UInt) {
        //print("User has selected bubble index: \(index)")
        selectedIndex = Int(index)
        performSegue(withIdentifier: "showForecast", sender: UIButton.self)
    }
    
    func livBubbleMenuDidHide(_ bubbleMenu: LIVBubbleMenu!) {
        //print("LIVBubbleMenu has been hidden")
    }
}

// MARK: - UITextFieldDelegate
extension ForecastHomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
