//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Алла Даминова on 19.10.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import RealmSwift


class  Place: Object {
    @objc dynamic var name = ""
    @objc dynamic var location : String?
    @objc dynamic var type : String?
    @objc dynamic var imageData : Data?


    let restarenName = [
    "Burger Heroes", "Kitchen", "Bonsai", "Дастархан", "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes", "Speak Easy", "Morris Pub", "Вкусные истории", "Классик", "Love&Life", "Шок", "Бочка"
    ]


    func savePlaces() {
        
        for place in restarenName {
            
            let image = UIImage(named: place)
            
            guard let imageData = image?.pngData() else { return }
        
            let newPlace = Place()
            
            newPlace.name = place
            newPlace.location = "Kazan"
            newPlace.type = "Restaurant"
            newPlace.imageData = imageData
            
            
            StorigeManadger.saveObject(newPlace)
        }
    }
}
