//
//  SASearchViewController.swift
//  SpotifyArtistsViewer
//
//  Created by Kevin Zeckser on 6/6/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

import UIKit

class SASearchViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchSegmentControl: UISegmentedControl!
    
    fileprivate var artists = [SAArtist]()
    fileprivate let requestManager = SARequestManager.sharedInstance
    let cellType = "UITableViewCell?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .black
        view.backgroundColor = .black
        textField.textColor = .white
    }
    // MARK: - SARequestManager Callback
    
    fileprivate func updateFilteredArtistsWithResult(_ result: SAResponse) {
        switch result {
        case .failure(let error):
            print("Error fetching artists: \(error)")
        case .success(let returnedArtists):
            print("Success!!!")
            artists = returnedArtists
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    override internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.artists[indexPath.row].name
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    
    @objc internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchQuery = self.textField.text else { return true }
        requestManager.getArtistsWithQuery(searchQuery, completion: updateFilteredArtistsWithResult)
        
        if !artists.isEmpty {
            self.artists.removeAll()
        }
        
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let destinationController = segue.destination as? SAArtistViewController {
                destinationController.detailArtist = self.artists[indexPath.row]
                destinationController.navigationItem.title = artists[indexPath.row].name
            }
        }
    }
}
