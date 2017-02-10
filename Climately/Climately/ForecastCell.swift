//
//  ForecastCellCollectionViewCell.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/8/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet private weak var imageIconView: UIImageView!
    @IBOutlet private weak var imagePrecipitationIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var precipitationLabel: UILabel!

    var forecast: ForecastViewModel? {
        didSet {
            if let forecast = forecast {
                //dateLabel.text = forecast.date
                temperatureLabel.text = forecast.currentTemperature
                windLabel.text = forecast.windSpeed
                descriptionLabel.text = forecast.currentObservation
            }
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let standardHeight = WeeklyvisualLayoutConstants.Cell.standardHeight
        let featuredHeight = WeeklyvisualLayoutConstants.Cell.featuredHeight
        
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        let minAlpha: CGFloat = 0.4
        let maxAlpha: CGFloat = 0.80
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))

        
        let scale = max(delta, 0.4)
        dateLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        dateLabel.alpha = delta
        
        temperatureLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        windLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        windLabel.alpha = delta
        
        descriptionLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        descriptionLabel.alpha = delta
        
        precipitationLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        precipitationLabel.alpha = delta
    }
}
