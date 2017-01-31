//
//  SARequestManager.swift
//  SpotifyArtistsViewer
//
//  Created by Kevin Zeckser on 6/6/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//
import Foundation

enum SAResponse {
    case success(artists: [SAArtist])
    case failure(error: Error)
}

final class SARequestManager {
    
    // MARK: - Properties
    
    static let sharedInstance = SARequestManager()
    fileprivate let session: URLSession!
    fileprivate init() {
        let sessionConfig = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfig)
    }
    
    // MARK: - NSURLRequest & JSON Parse
    
    func getArtistsWithQuery(_ query: String, completion: @escaping (SAResponse) -> Void) {
        let path = "https://api.spotify.com/v1/search?q=\(query)&type=track,artist&market=US"
        
        guard let url = URL(string: path) else { return }
        
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            var result: SAResponse
            if let error = error {
                result = SAResponse.failure(error: error)
            } else if let data = data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    var returnedArtists = [SAArtist]()
                    if let artistResponse = jsonResult?["artists"] as? NSDictionary,
                       let artists = artistResponse["items"] as? NSArray {
                        for entry in artists {
                            let artistEntry = entry as? NSDictionary
                            guard let name = artistEntry?["name"] as? String else { continue }
                            guard let images = artistEntry?["images"] as? NSArray else { continue }
                            guard let image = self.fetchImage(images as [AnyObject]) else { continue }
                            returnedArtists.append(SAArtist(name: name, image: image, description: nil))
                        }
                    }
                    result = SAResponse.success(artists: returnedArtists)
                } catch let error as NSError {
                    result = SAResponse.failure(error: error)
                }
            } else {
                result = SAResponse.success(artists: [SAArtist]())
            }
            DispatchQueue.main.async {
                completion(result)
            }
        })
        task.resume()
    }
    
    func fetchImage(_ images: [AnyObject]?) -> String?  {
        guard let images = images else { return nil }
        for image in images {
            guard ((image as? [String:AnyObject]) != nil) else { return nil }
            guard let imageDict = image as? [String:AnyObject] else { return nil }
            let height = imageDict["height"] as? Int
            let width = imageDict["width"] as? Int
            if height == width {
                if let url = image["url"] as? String {
                    return url
                }
            }
        }
        return nil
    }
}
