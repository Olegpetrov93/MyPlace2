//
//  StorigeManadger.swift
//  MyPlaces
//
//  Created by 1 on 10/24/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorigeManadger {
    
    static func saveObject(_ place: Place) {
        
        try! realm.write {
            realm.add(place)
        }
    }
    static func deliteObject(_ place: Place) {
        
        try! realm.write {
            
            realm.delete(place)
        }
    }
}
