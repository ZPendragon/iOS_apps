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
    fileprivate var sampleWeek = ["Wednesday","Thursday","Friday","Saturday","Sunday","Monday","Tuesday"]
    fileprivate var animationType = "RightToLeft"
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
    fileprivate let testImages: [UIImage] = [UIImage(named: "background_0")!,
                                             UIImage(named: "background_1")!,
                                             UIImage(named: "background_2")!,
                                             UIImage(named: "background_4")!,
                                             UIImage(named: "background_3")!,
                                             UIImage(named: "background_5")!,
                                             UIImage(named: "background_7")!,
                                             UIImage(named: "background_9")!,
                                             UIImage(named: "background_10")!]
    // MARK: - TEMP
    func randomInt(max:Int) -> Int {
//        return Int(arc4random_uniform(UInt32(max + 1)))
        return Int(arc4random_uniform(UInt32(max)))
    }
    func setupSamples() {
//        sampleForecast = Forecast(fromDictionary: sampleJSON as [String : AnyObject])
//        sampleForecaseViewModel = ForecastViewModel(forecast: sampleForecast!)
//        forecasts = [sampleForecaseViewModel!,
//                     sampleForecaseViewModel!,
//                     sampleForecaseViewModel!,
//                     sampleForecaseViewModel!,
//                     sampleForecaseViewModel!,
//                     sampleForecaseViewModel!,
//                     sampleForecaseViewModel!]
        var n = 0
        repeat {
            sampleWeek += sampleWeek
            n += 1
        } while n < 5
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
        setupSamples()
    }
    
    
}

// MARK: - CollectionViewDataSource & CollectionViewDelegate
extension ForecastFeedViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleWeek.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        let forcast = forecasts?[indexPath.item]
        cell.forecast = forecasts?[indexPath.item]
        cell.dateLabel.text = sampleWeek[indexPath.row]
        cell.imageView.image = testImages[randomInt(max: 9)]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = collectionViewLayout as! WeeklyvisualLayout
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (animationType == "BottomToTop") {
            let cellContentView: UIView? = cell.contentView
            let rotationAngleDegrees: CGFloat = -30
            let rotationAngleRadians: CGFloat = rotationAngleDegrees * (.pi / 180)
            let offsetPositioning = CGPoint(x: CGFloat(0), y: CGFloat(cell.contentView.frame.size.height * 4))
            var transform: CATransform3D = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngleRadians, -50.0, 0.0, 1.0)
            transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, -50.0)
            cellContentView?.layer.transform = transform
            cellContentView?.layer.opacity = 0.8
            
            UIView.animate(withDuration: 0.65, delay: 0o0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: [], animations: {() -> Void in
                cellContentView?.layer.transform = CATransform3DIdentity
                cellContentView?.layer.opacity = 1
            }, completion: {(_ finished: Bool) -> Void in
            })
        } else if (animationType == "RightToLeft") {
            let cellContentView: UIView? = cell.contentView
            let rotationAngleDegrees: CGFloat = -30
            let rotationAngleRadians: CGFloat = rotationAngleDegrees * (.pi / 180)
            let offsetPositioning = CGPoint(x: CGFloat(500), y: CGFloat(-20.0))
            var transform: CATransform3D = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngleRadians, -50.0, 0.0, 1.0)
            transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, -50.0)
            cellContentView?.layer.transform = transform
            cellContentView?.layer.opacity = 0.8
            UIView.animate(withDuration: 0.65, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: [], animations: {() -> Void in
            cellContentView?.layer.transform = CATransform3DIdentity
            cellContentView?.layer.opacity = 1
            }, completion: {(_ finished: Bool) -> Void in
            })
        }
        
    }
}
