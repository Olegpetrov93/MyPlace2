//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Алла Даминова on 19.10.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit


struct Place {
    var name : String
    var location : String?
    var type : String?
    var restorentImage: String?
    var image : UIImage?


    static let restarenName = [
    "Burger Heroes", "Kitchen", "Bonsai", "Дастархан", "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes", "Speak Easy", "Morris Pub", "Вкусные истории", "Классик", "Love&Life", "Шок", "Бочка"
    ]


    static func getPlaces() -> [Place] {
        
        var places = [Place]()
        
        for place in restarenName {
            places.append(Place(name: place, location: "Казань", type: "Ресторан", restorentImage: place, image: nil))
        }
        
        
        return places
        
        
    }
}
