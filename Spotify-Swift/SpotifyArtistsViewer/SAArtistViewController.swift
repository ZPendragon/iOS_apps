//
//  SAArtistViewController.swift
//  SpotifyArtistsViewer
//
//  Created by Kevin Zeckser on 6/6/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

import UIKit

class SAArtistViewController: UIViewController {
    
    // MARK: - Properties & Outlets
    
    @IBOutlet weak fileprivate var artistImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var detailArtist: SAArtist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        configureView()
    }

    // MARK: - Configure View Functions
    
    fileprivate func loadImage(_ url :String) -> UIImage? {
        guard
            let imgURL = URL(string: url),
            let imgData = try? Data(contentsOf: imgURL)
            else { return nil }
        return UIImage(data: imgData)
    }
    
    fileprivate func configureView() {
        if let detailArtist = detailArtist {
            artistImageView.image = loadImage(detailArtist.image!)
            artistImageView.layer.cornerRadius = artistImageView.bounds.size.width / 2
            artistImageView.clipsToBounds = true
            descriptionLabel.text = detailArtist.description
        }
    }
}
