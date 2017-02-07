//
//  ViewController.swift
//  Climately
//
//  Created by Kevin Zeckser on 3/28/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherHomeViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
// ------------------------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundImageTwo: UIImageView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var getWeatherBtn: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var feelsLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    let apiKey = "715c8dedd9cb08be"
    var isAnimated = false
    var backgroundImageDictionary = ["Rain":UIImage(named: "weather_light_rainy.jpg"),
                                     "Light Rain":UIImage(named: "weather_light_rainy.jpg"),
                                     "Rain Mist":UIImage(named: "weather_light_rainy.jpg"),
                                     "Light Drizzle":UIImage(named: "weather_light_rainy.jpg"),
                                     "Drizzle":UIImage(named: "weather_light_rainy.jpg"),        
                                     "Light Rain Mist":UIImage(named: "weather_light_rainy.jpg"),
                                     "Light Thunderstorm Rain":UIImage(named: "weather_dark_rainy.jpg"),
                                     "Light Thunderstorm Drizzle":UIImage(named: "weather_dark_rainy.jpg"),
                                     "Thunderstorm":UIImage(named: "weather_dark_rainy.jpg"),
                                     "Heavy Thunderstorm Rain":UIImage(named: "weather_dark_rainy.jpg"),
                                     "Thunderstorms and Rain":UIImage(named: "weather_dark_rainy.jpg"),
                                     "Heavy Thunderstorms and Rain":UIImage(named: "weather_dark_rainy.jpg"),        
                                     "Thunderstorm Rain":UIImage(named: "weather_dark_rainy.jpg"),
                                     "Clear":UIImage(named: "weather_light_clear.jpg"),
                                     "Partly Cloudy":UIImage(named: "weather_light_cloudy.jpg"),
                                     "Haze":UIImage(named: "weather_light_cloudy.jpg"),
                                     "Scattered Clouds":UIImage(named: "weather_light_cloudy.jpg"),
                                     "Mostly Cloudy":UIImage(named: "weather_dark_cloudy.jpg"),
                                     "Overcast":UIImage(named: "weather_overcast.jpg"),
                                     "Fog":UIImage(named: "weather_fog.jpg"),
                                     "Light Snow":UIImage(named: "weather_light_snowy.jpg"),
                                     "Always Cloudy":UIImage(named: "weather_mordor.jpg"),
                                     "Not Found":UIImage(named: "weather_not_found.jpg")]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up location for use
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        // Handle the text field’s user input through delegate callbacks.
        cityTextField.delegate = self
        
        // Add actions to UIButton
        getWeatherBtn.addTarget(self, action: #selector(WeatherHomeViewController.buttonDown(_:)), for: .touchDown)
        getWeatherBtn.addTarget(self, action: #selector(WeatherHomeViewController.buttonUp(_:)), for: [UIControlEvents.touchUpInside, UIControlEvents.touchUpOutside])
        
        // Disable UIButton on load
        let text = cityTextField.text ?? ""
        getWeatherBtn.isEnabled = !text.isEmpty
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if isAnimated == true {
            
            self.summaryLabel.center = CGPoint(x: self.summaryLabel.center.x, y: self.summaryLabel.center.y)
            self.tempLabel.center = CGPoint(x: self.tempLabel.center.x, y: self.tempLabel.center.y)
            self.humidityLabel.center = CGPoint(x: self.humidityLabel.center.x, y: self.humidityLabel.center.y)
            self.precipitationLabel.center = CGPoint(x: self.precipitationLabel.center.x, y: self.precipitationLabel.center.y)
            self.windLabel.center = CGPoint(x: self.windLabel.center.x, y: self.windLabel.center.y)
            self.feelsLabel.center = CGPoint(x: self.feelsLabel.center.x, y: self.feelsLabel.center.y)
            
        } else {
            
            summaryLabel.center = CGPoint(x: summaryLabel.center.x, y: summaryLabel.center.y - 75)
            tempLabel.center = CGPoint(x: tempLabel.center.x, y: tempLabel.center.y - 75)
            humidityLabel.center = CGPoint(x: humidityLabel.center.x, y: humidityLabel.center.y - 75)
            precipitationLabel.center = CGPoint(x: precipitationLabel.center.x, y: precipitationLabel.center.y - 75)
            windLabel.center = CGPoint(x: windLabel.center.x, y: windLabel.center.y - 75)
            feelsLabel.center = CGPoint(x: feelsLabel.center.x, y: feelsLabel.center.y - 75)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidCityName()
        
    }
    
    func checkValidCityName() {
        let text = cityTextField.text ?? ""
        getWeatherBtn.isEnabled = !text.isEmpty
        if cityTextField.text == "" {
            getWeatherBtn.setTitle("", for: UIControlState())
//            getWeatherBtn.backgroundColor = UIColor.clearColor()
//            getWeatherBtn.layer.cornerRadius = 5
//            getWeatherBtn.layer.borderWidth = 4
//            getWeatherBtn.layer.borderColor = UIColor.whiteColor().CGColor
        } else {
            getWeatherBtn.setTitle("Hold For \nWeather", for: UIControlState())
            getWeatherBtn.titleLabel?.textAlignment = NSTextAlignment.center
//            getWeatherBtn.backgroundColor = UIColor.clearColor()
//            getWeatherBtn.layer.cornerRadius = 5
//            getWeatherBtn.layer.borderWidth = 4
//            getWeatherBtn.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    func weatherRequest() -> Bool {
        
            self.tempLabel.text = ""
            //var wasSuccessful = false
        
        var cityState = cityTextField.text
        cityState = cityState?.replacingOccurrences(of: "-", with: " ")
        if let fullLocation = cityState!.components(separatedBy: ",") as? [String] {
            if fullLocation.count == 2 {
                let city = fullLocation[0]
                let state = fullLocation[1].replacingOccurrences(of: " ", with: "")
        
        if fullLocation[0] == "Mordor" {
            summaryLabel.text = "Always Cloudy"
            tempLabel.text = "400º"
            humidityLabel.text = "Shadow and flame."
            precipitationLabel.text = "Chance of lava 100%"
            windLabel.text = "One does not simply"
            feelsLabel.text = "walk into Mordor."
            self.backgroundImageTwo.image = self.backgroundImageDictionary["Always Cloudy"]!
            
        } else {
        
            if city != "" && state != "" {
    
                let attemptedURL = URL(string: "http://api.wunderground.com/api/\(apiKey)/conditions/q/" + state + "/" + city.replacingOccurrences(of: " ", with: "_") + ".json")
    
                if let url = attemptedURL {
    
                   let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error -> Void in
    
                        //print(data)
    
                        if (error != nil) {
                            print(error)
                        } else {
    
                            let jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            
                            if let weatherData = jsonResult as? [String: AnyObject] {
                              
                                if weatherData["current_observation"] != nil {
                                
                                let summary = weatherData["current_observation"]!["weather"] as? String
                                print(summary)
                                guard let temp = weatherData["current_observation"]?["temp_f"] as? Int else { return }
                                let feelsTemp = weatherData["current_observation"]?["feelslike_f"] as? String
                                let humidity = weatherData["current_observation"]?["relative_humidity"] as? String
                                var precipitation = weatherData["current_observation"]?["precip_today_metric"] as? String
                                let windDir = weatherData["current_observation"]?["wind_dir"] as? String
                                let windSpeed = weatherData["current_observation"]?["wind_mph"] as? Float
                                
                                //print(precipitation)
                                //print(windSpeed)
                                //print(windDir)
                                //let windDirString = String(windDir)
                                
                                if precipitation == "0" {
                                    precipitation = "0"
                                } else {
                                    precipitation = "100"
                                }
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    print(precipitation)
                                    self.summaryLabel.text = summary
                                    let mainTempString = String(temp)
                                    self.tempLabel.text = mainTempString + "º"
                                    self.humidityLabel.text = "Humidity  " + humidity!
                                    self.precipitationLabel.text = "Chance of rain \(precipitation!)%"
                                    self.windLabel.text = "Wind \(windDir!) \(windSpeed!) mph"
                                    self.feelsLabel.text = "Feels Like " + feelsTemp! + "º"
                                    
                                    
                                    self.backgroundImageTwo.image = self.backgroundImageDictionary[summary!]!
                                    
                                })
                                } else {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.summaryLabel.text = "Oops!"
                                    self.tempLabel.text = "No matches."
                                    self.humidityLabel.text = ""
                                    self.precipitationLabel.text = ""
                                    self.windLabel.text = ""
                                    self.feelsLabel.text = "We're bummed too."
                                    
                                    
                                    self.backgroundImageTwo.image = self.backgroundImageDictionary["Not Found"]!
                                })
                                }
                            }
                       // Catch invalid json here
                            
                        }
                })
                 task.resume()
           }
            } else {
                getWeatherBtn.setTitle("Please enter a city and state", for: UIControlState())
        }
        }
            } else {
                print("Invalid String")
                DispatchQueue.main.async(execute: { () -> Void in
                    self.summaryLabel.text = "Oops!"
                    self.tempLabel.text = "No matches."
                    self.humidityLabel.text = ""
                    self.precipitationLabel.text = ""
                    self.windLabel.text = ""
                    self.feelsLabel.text = "We're bummed too."
                    
                    
                    self.backgroundImageTwo.image = self.backgroundImageDictionary["Not Found"]!
                })
            }
        }
        
    // End weather req
        return true
    }
    
    func buttonDown(_ sender: AnyObject) {
        getWeatherBtn.setTitle("", for: UIControlState())
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
        let returned = self.weatherRequest()
        
    }
        if isAnimated == false {
            isAnimated = true
            UIView.animate(withDuration: 1.5, animations: { () -> Void in
                
                self.backgroundImageTwo.alpha = 1
                
                self.summaryLabel.alpha = 1
                self.tempLabel.alpha = 1
                self.humidityLabel.alpha = 1
                self.precipitationLabel.alpha = 1
                self.windLabel.alpha = 1
                self.feelsLabel.alpha = 1
                
                self.summaryLabel.center = CGPoint(x: self.summaryLabel.center.x, y: self.summaryLabel.center.y + 75)
                self.tempLabel.center = CGPoint(x: self.tempLabel.center.x, y: self.tempLabel.center.y + 75)
                self.humidityLabel.center = CGPoint(x: self.humidityLabel.center.x, y: self.humidityLabel.center.y + 75)
                self.precipitationLabel.center = CGPoint(x: self.precipitationLabel.center.x, y: self.precipitationLabel.center.y + 75)
                self.windLabel.center = CGPoint(x: self.windLabel.center.x, y: self.windLabel.center.y + 75)
                self.feelsLabel.center = CGPoint(x: self.feelsLabel.center.x, y: self.feelsLabel.center.y + 75)
                
            })
        }
        
    }
    
    func buttonUp(_ sender: AnyObject) {
       checkValidCityName()
        if isAnimated == true {
            isAnimated = false
            
            UIView.animate(withDuration: 2, animations: { () -> Void in
                
                self.backgroundImageTwo.alpha = 0
                
            })
            backgroundImageTwo.image = nil
            summaryLabel.text = ""
            summaryLabel.alpha = 0
            summaryLabel.center = CGPoint(x: summaryLabel.center.x, y: summaryLabel.center.y - 75)
            
            tempLabel.text = ""
            tempLabel.alpha = 0
            tempLabel.center = CGPoint(x: tempLabel.center.x, y: tempLabel.center.y - 75)
            
            humidityLabel.text = ""
            humidityLabel.alpha = 0
            humidityLabel.center = CGPoint(x: humidityLabel.center.x, y: humidityLabel.center.y - 75)
            
            precipitationLabel.text = ""
            precipitationLabel.alpha = 0
            precipitationLabel.center = CGPoint(x: precipitationLabel.center.x, y: precipitationLabel.center.y - 75)
            
            windLabel.text = ""
            windLabel.alpha = 0
            windLabel.center = CGPoint(x: windLabel.center.x, y: windLabel.center.y - 75)
            
            
            feelsLabel.text = ""
            feelsLabel.alpha = 0
            feelsLabel.center = CGPoint(x: feelsLabel.center.x, y: feelsLabel.center.y - 75)
            
            
            
            
        }
    }
    
    // MARK: GeoLocation
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print(locations)
        self.cityTextField.alpha = 0
        self.getWeatherBtn.alpha = 0
        
        let userLocation: CLLocation = locations[0]
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error)-> Void in
            
            let placemark:CLPlacemark!
            if error == nil && placemarks!.count > 0 {
                placemark = placemarks![0] as CLPlacemark
                
                if placemark.isoCountryCode == "US" {
                    
                    if placemark.locality != nil {
                        print("City \(placemark.locality)")
                        self.cityTextField.text = placemark.locality!
                    }
                    if placemark.administrativeArea != nil {
                        print(placemark.administrativeArea)
                        self.cityTextField.text = self.cityTextField.text! + "," + placemark.administrativeArea!
                    }
                    
                    self.checkValidCityName()
                    
                    UIView.animate(withDuration: 1.5, animations: { () -> Void in
                    
                    self.cityTextField.alpha = 1
                    self.getWeatherBtn.alpha = 1
                        
                    })
                    
                }
            }
        })
        locationManager.stopUpdatingLocation()
    }
    // MARK: actions
}
