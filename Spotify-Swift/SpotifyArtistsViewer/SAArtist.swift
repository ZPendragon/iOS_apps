//
//  SAArtist.swift
//  SpotifyArtistsViewer
//
//  Created by Kevin Zeckser on 6/6/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

import UIKit

struct SAArtist {
    
    var name : String
    var image : String?
    var description: String?
    
    init(name: String, image: String?, description: String?) {
        self.name = name
        self.image = image ?? "NoImageDefault"
        self.description = description ?? "This band is awesome!"
    }
    
}
 