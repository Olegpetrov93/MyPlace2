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

    @IBOutlet weak var reverstSortingButton: UIBarButtonItem!
    @IBOutlet weak var segmentetControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var places : Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentetControl.setTitle("Date", forSegmentAt: 0)
        segmentetControl.setTitle("Name", forSegmentAt: 1)
        
        
        
        places = realm.objects(Place.self)

    }

    // MARK: - Table view data source

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.isEmpty ? 0 : places.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CutomViewCellTableViewCell

        let place = places[indexPath.row]

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
            let place = places[indexPath.row]
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
        
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date")
        } else {
            places = places.sorted(byKeyPath: "name")
        }
        tableView.reloadData()
    }
    
}
