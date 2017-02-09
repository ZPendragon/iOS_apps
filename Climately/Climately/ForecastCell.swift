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
    @IBOutlet weak var imageCoverView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    
    
    
    
    
    
    var forecast: ForecastViewModel? {
        didSet {
            if let forecast = forecast {
                
//                imageView.image = testImages[randomInt(max: 4)]
               // imageView.image = testImages[1]
                
                dateLabel.text = forecast.currentObservation
                
                 /*
                titleLabel.text = inspiration.title
                timeAndRoomLabel.text = inspiration.roomAndTime
                speakerLabel.text = inspiration.speaker
                */
            }
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        // 1
        let standardHeight = WeeklyvisualLayoutConstants.Cell.standardHeight
        let featuredHeight = WeeklyvisualLayoutConstants.Cell.featuredHeight
        
        // 2
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        // 3
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
//        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
//        timeAndRoomLabel.alpha = delta
//        speakerLabel.alpha = delta
    }
}
