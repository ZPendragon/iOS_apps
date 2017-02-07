//
//  WeatherCityViewController.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/6/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import UIKit
typealias cityState = (String, String)

final class ForecastFeedViewController: UIViewController {
    
    // We have network layer
    /*
        - request
        - data
        - json parse
        - initialize weatherProfile object from JSONDictionary
    */
    
    // MARK: - Properties
    
    fileprivate var forcastFeedViewModel = ForecastFeedViewModel()
    fileprivate var searchQuery: cityState = ("","")
    
    // MARK: - Setup
    
    fileprivate func initiateNetworkRequest() {
        forcastFeedViewModel.requestForNetworkData(searchQuery) {
            self.delegate?.didRecieveNetworkResponse(self)
            self.collectionView.reloaddata()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initiateNetworkRequest()
    }
}
