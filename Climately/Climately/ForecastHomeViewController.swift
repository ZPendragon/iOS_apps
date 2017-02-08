//
//  ViewController.swift
//  Climately
//
//  Created by Kevin Zeckser on 3/28/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastHomeViewController: UIViewController {
    
    /**
        - Home screen of application (initial VC)
        - Determines location in the event of immediate forecast query
        - Displays bubble menu of saved forecast locations
        - Status bar with hamburger menu and add forceast in the top right
     
     
     */
    
    
    // MARK: - Properties
    
    @IBOutlet weak var cityMenuButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundImageTwo: UIImageView!
    // TODO: Build a loop animation that loops through our image dictionary and displays different backgrounds
    @IBOutlet weak var getWeatherBtn: UIButton!
    fileprivate let locationManager = CLLocationManager()
    fileprivate let testImages: [UIImage] = [UIImage(named: "cityscape_0")!,
                                            UIImage(named: "cityscape_1")!,
                                            UIImage(named: "cityscape_2")!,
                                            UIImage(named: "currentLocation")!]

    fileprivate let testCityState: [cityState] = [("Boston","MA"),
                                                  ("Boston","MA"),
                                                  ("Boston","MA"),
                                                  ("Boston","MA")]
    fileprivate var selectedIndex: Int?
    // MARK: - Setup
    
    fileprivate func setupVC() {
        
        view.backgroundColor = .clear
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func showButton(_ sender: Any) {
        setupBubbleMenu()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let nav = segue.destination as? UINavigationController
            let destinationController = nav?.topViewController as? ForecastFeedViewController
            guard let index = self.selectedIndex else { return }
            destinationController?.searchQuery = testCityState[index]
            
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
                        print("City \(placemark.locality)")
                    }
                    if placemark.administrativeArea != nil {
                        print(placemark.administrativeArea)
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
        print("User has selected bubble index: \(index)")
        selectedIndex = Int(index)
        performSegue(withIdentifier: "showDetail", sender: UIButton.self)
    }
    
    func livBubbleMenuDidHide(_ bubbleMenu: LIVBubbleMenu!) {
        print("LIVBubbleMenu has been hidden")
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
