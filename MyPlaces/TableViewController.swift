//
//  TableViewController.swift
//  MyPlaces
//
//  Created by Алла Даминова on 19.10.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let restarenName = [
    "Burger Heroes", "Kitchen", "Bonsai", "Дастархан", "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes", "Speak Easy", "Morris Pub", "Вкусные истории", "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restarenName.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = restarenName[indexPath.row]
        cell.imageView?.image = UIImage(named: restarenName[indexPath.row])
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2 //
        cell.imageView?.clipsToBounds = true
        

        return cell
    }
    
     // MARK: - TablView delegat
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
