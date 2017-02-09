//
//  WeatherCityViewController.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/6/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import UIKit

final class ForecastFeedViewController: UICollectionViewController {
    
    struct Constants {
        static let reuseIdentifier = "forecastCell"
        static let numberOfRows = 7
        fileprivate static let backgroundImageView = UIImageView(image: UIImage(named: "background_2"))
    }
    
    // MARK: - Properties
    
    fileprivate var forcastFeedViewModel = ForecastFeedViewModel()
    var searchQuery: cityState?
    fileprivate var forecasts: [ForecastViewModel]?
    
    
    
    // MARK: - Sample Values
    fileprivate var sampleForecaseViewModel: ForecastViewModel?
    fileprivate var sampleForecast: Forecast?
    let sampleWeek = ["Wednesday","Thursday","Friday","Saturday","Sunday","Monday","Tuesday"]
    fileprivate let sampleJSON = ["city": "Boston",
                                  "weather": "Partly Cloudy",
                                  "temp_f": 66,
                                  "feelslike_f": "66.3",
                                  "relative_humidity": "65%",
                                  "precip_today_metric": "0",
                                  "wind_dir": "NNW",
                                  "wind_mph": 22.0,
                                  "temp_c": 19,
                                  "feelslike_c": "19.1"] as [String : Any]
    fileprivate let testImages: [UIImage] = [UIImage(named: "weather_dark_cloudy")!,
                                             UIImage(named: "weather_dark_rainy")!,
                                             UIImage(named: "weather_light_clear")!,
                                             UIImage(named: "weather_light_cloudy")!]
    // MARK: - TEMP
    func randomInt(max:Int) -> Int {
        return Int(arc4random_uniform(UInt32(max + 1)))
    }
    func setupSamples() {
        sampleForecast = Forecast(fromDictionary: sampleJSON as [String : AnyObject])
        sampleForecaseViewModel = ForecastViewModel(forecast: sampleForecast!)
        forecasts = [sampleForecaseViewModel!,
                     sampleForecaseViewModel!,
                     sampleForecaseViewModel!,
                     sampleForecaseViewModel!,
                     sampleForecaseViewModel!,
                     sampleForecaseViewModel!,
                     sampleForecaseViewModel!]
    }
    
    
    // MARK: - Setup
    
    fileprivate func initiateNetworkRequest() {
        guard let searchQuery = searchQuery else { return }
        forcastFeedViewModel.requestForNetworkData(searchQuery) {
            //self.delegate?.didRecieveNetworkResponse(self)
            //self.collectionView.reloaddata()
        }
    }
    
    fileprivate func setupVC() {
        if #available(iOS 10.0, *) {
            collectionView!.isPrefetchingEnabled = false
        }
        view.backgroundColor = .clear
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .clear
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    fileprivate func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //initiateNetworkRequest()
        setupVC()
        setupCollectionView()
        setupNavigationBar()
        //setupSamples()
    }
    
    
}

// MARK: - CollectionViewDataSource & CollectionViewDelegate
extension ForecastFeedViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        let forcast = forecasts?[indexPath.item]
        cell.forecast = forecasts?[indexPath.item]
        cell.dateLabel.text = sampleWeek[indexPath.row]
        cell.imageView.image = testImages[randomInt(max: 3)]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = collectionViewLayout as! WeeklyvisualLayout
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
    
}
