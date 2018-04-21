//
//  FirebaseFunctions.swift
//  fireHacks
//
//  Created by Joe Wijoyo on 4/21/18.
//  Copyright © 2018 shelby chen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseFunctionalities {
    var databaseReference: DatabaseReference?
    var organizations: [Organization]?
    var shelters: [Shelter]?
    
    init() {
        self.databaseReference = Database.database().reference()
    }
    
    
    
    func getOrganizations() {
        self.databaseReference?.child("Donation Center").observeSingleEvent(of: .value, with: { (snapshot) in
            let organizationsData = snapshot.value as! [String: Any]
            var organizations: [Organization] = []
            for organizationData in organizationsData {
                
                let organization = Organization(initDict: organizationData.value as! [String : Any])
                organizations.append(organization)
            }
            self.organizations = organizations
        })
    }
    
    func getShelters() {
        self.databaseReference?.child("Shelter").observeSingleEvent(of: .value, with: { (snapshot) in
            let sheltersData = snapshot.value as! [String: Any]
            var shelters: [Shelter] = []
            for shelterData in sheltersData {
                
                let shelter = Shelter(name: shelterData.key, initDict: shelterData.value as! [String : Any])
                shelters.append(shelter)
            }
            self.shelters = shelters
        })
    }
}
