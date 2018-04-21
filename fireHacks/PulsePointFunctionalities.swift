//
//  PulsePointFunctionalities.swift
//  fireHacks
//
//  Created by Joe Wijoyo on 4/21/18.
//  Copyright © 2018 shelby chen. All rights reserved.
//

import Foundation


class PulsePointFunctionalities {
    var incidentData: Incident?
    
    func getRecentAndActiveIncidents() {
        let username = "slohack18"
        let password = "GBL93bRzSS"
        //let APIKey = "MsfWUGVgFVdVyr85zS5AMRccmj0FOn3pGbqJWwe"
        let urlString = "https://api.pulsepoint.org/v1-sandbox/incidents?apikey=MsfWUGVgFVdVyr85zS5AMRccmj0FOn3pGbqJWwe&agencyid=77001&both=1"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: .utf8)
        let base64LoginString = loginData!.base64EncodedString()
        
        //create request
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let urlSession = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            //let returnString = String.init(data: data!, encoding: String.Encoding.utf8)
            //self.incidentData = Incident(initData: (returnString! as! [String: Any])["incident"] as! [String : Any])
            
            do {
                let incidentData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                self.incidentData = Incident(initData: incidentData["incidents"] as! [String: Any])
            } catch {
                print(error.localizedDescription)
            }
            
            print (self.incidentData)
        }
        urlSession.resume()
    }
    
}


class Incident {
    var recentIncidents: [RecentIncident]?
    //var activeIncidents: [ActiveIncident]?
    //var alertIncidents: [AlertIncident]?
    static let excludedAgencyIncidentCallTypes = ["AA", "MU", "ST", "OA", "FA", "SD", "WFA", "MA", "CMA", "AED", "TRBL", "FL", "LR", "LA", "PS", "PA", "SH", "LO", "CL", "RL", "VL", "ME", "IFT", "MCI", "CA", "TRNG", "TEST", "NO", "STBY", "RES", "CR", "CSR", "RR", "TR", "TNR", "WR", "AR", "ELR", "USAR", "VS"]
    
    init(initData: [String: Any]) {
        if let recentIncidentsData = initData["recent"] as? [[String: Any]] {
            var recentIncidents: [RecentIncident] = []
            for recentIncidentData in recentIncidentsData {
                let recentIncident = RecentIncident(initData: recentIncidentData)
                if !Incident.excludedAgencyIncidentCallTypes.contains(recentIncident.agencyIncidentCallType) {
                    recentIncidents.append(recentIncident)
                }
                
            }
            self.recentIncidents = recentIncidents
        }
    }
    
    
    
}

class RecentIncident {
    var latitude: Double?
    var longitude: Double?
    var agencyIncidentCallType: String
    var fullDisplayAddress: String
    
    init(initData: [String: Any]) {
        self.latitude = Double(initData["Latitude"] as! String)
        self.longitude = Double(initData["Longitude"] as! String)
        self.agencyIncidentCallType = initData["AgencyIncidentCallType"] as? String ?? ""
        self.fullDisplayAddress = initData["FullDisplayAddress"] as? String ?? ""
    }
}
