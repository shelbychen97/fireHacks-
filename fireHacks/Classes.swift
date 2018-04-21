//
//  orgPin.swift
//  fireHacks
//
//  Created by shelby chen on 4/20/18.
//  Copyright © 2018 shelby chen. All rights reserved.
//

import Foundation
import CoreLocation

class Organization{
    var name: String!
    var locations: [LocationInfo]!
    var neededItems: [NeededItem]?
    var website: String!
    
//    init(name: String, locations: [LocationInfo], neededItems: [NeededItem],website: String) {
//
//    }
}


class LocationInfo {
    var coordinates: CLLocationCoordinate2D!
    var address: String = ""
    var description: String = ""
}

class NeededItem {
    var name: String = ""
    var quantity: Int = 0
}
