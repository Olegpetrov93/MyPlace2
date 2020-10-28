//
//  TableViewController.swift
//  MyPlaces
//
//  Created by Алла Даминова on 19.10.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import RealmSwift


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var places : Results<Place>!
    private var ascendingSorted = true
    
    private var filtredPlaces: Results<Place>!
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmty
    }
    

    @IBOutlet weak var reverstSortingButton: UIBarButtonItem!
    @IBOutlet weak var segmentetControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentetControl.setTitle("Name", forSegmentAt: 0)
        segmentetControl.setTitle("Date", forSegmentAt: 1)
        
        places = realm.objects(Place.self)
        
        //Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        

    }

    // MARK: - Table view data source

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
        return filtredPlaces.count
        }
        return places.isEmpty ? 0 : places.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CutomViewCellTableViewCell

        var place = Place()
        
        if isFiltering {
            place = filtredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)



        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2 //
        cell.imageOfPlace.clipsToBounds = true


        return cell
    }
    
     // MARK: - Table view delegat
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let place = places[indexPath.row]
        let deliteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            
            StorigeManadger.deliteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deliteAction]
    }

    
    
    
     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            var place = Place()
            if isFiltering {
                place = filtredPlaces[indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {

        guard  let newPlaceVC = segue.source as? NewPlaceViewController else { return }

        newPlaceVC.savePlace()
        tableView.reloadData()
    }

    @IBAction func reverstSorting(_ sender: Any) {
        
        ascendingSorted.toggle()
        
        if ascendingSorted {
            reverstSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reverstSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
        
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
     sorting()
    }
    private func sorting() {
        
        if segmentetControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorted)
        } else {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorted)
        }
        tableView.reloadData()
    }
    
}
extension TableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearChText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearChText(_ searchText: String) {
        
        filtredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
    }
    
    
}
