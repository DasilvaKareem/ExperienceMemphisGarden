//
//  File.swift
//  MemphisGardens
//
//  Created by Kareem Dasilva on 2/25/23.
//

import Foundation
import CoreLocation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class Garden  {
    
    private var _key:String?
    private var _name:String?
    private var _address:String?
    private var _description:String?
    private var _yearBuilt:Int?
    private var _previewImage:String?
    private var _backGarden:Bool?
    private var _locationLat:Double?
    private var _locationLong:Double?
    
    var description: String?{
        return _description
    }
    
    var name: String? {
        return _name
    }
    var address:String? {
        return _address
    }
    
    var key:String? {
        return _key
    }
    var previewImage:String? {
        return _previewImage
    }
    var yearBuilt:Int? {
        return _yearBuilt
    }
    var backGarden:Bool? {
        return _backGarden
    }
    var longitude:Double? {
        return _locationLong
    }
    var latitude:Double? {
        return _locationLat
    }

    
    init(key:String, data:Dictionary<String,AnyObject>) {
        _key = key
        if let name = data["name"] as? String {
            _name = name
        }
        if let address = data["address"] as? String {
            _address = address
        }
        if let yearBuilt = data["yearBuilt"] as? Int {
            _yearBuilt = yearBuilt
        }
        if let description = data["description"] as? String {
            _description = description
        }
        if let previewImage = data["previewImage"] as? String {
            _previewImage = previewImage
        }
        if let backGarden = data["backGarden"] as? Bool {
            _backGarden = backGarden
        }
        if let Lat = data["latitude"] {
            _locationLat = Lat as? Double
        }
        if let long = data["longitude"] {
            _locationLong = long as? Double
        }
        
    }
    
}
