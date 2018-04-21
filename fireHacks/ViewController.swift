//
//  ViewController.swift
//  fireHacks
//
//  Created by shelby chen on 4/20/18.
//  Copyright © 2018 shelby chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import Firebase



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
   
    @IBAction func donationSwitch(_ sender: UISwitch) {
        showOrg = !showOrg
        updatePins()
    }
    @IBAction func shelterSwitch(_ sender: UISwitch) {
        showShelter = !showShelter
        updatePins()
    }
    @IBAction func hazardSwitch(_ sender: UISwitch) {
        showHazard = !showHazard
        updatePins()
    }
    @IBAction func menuButton(_ sender: UIButton) {
        self.menuView.isHidden = !self.menuView.isHidden
    }
    var showOrg : Bool = true
    var showShelter : Bool = true
    var showHazard : Bool = true
    
    var orgArray : [MKAnnotation]!
    var shelterArray : [MKAnnotation]!
    //var hazardArray : []
    
    var databaseReference: DatabaseReference?
    var organizations: [Organization]?
    var shelters: [Shelter]?
    var incidentData: Incident?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.databaseReference = Database.database().reference()
        
        blurView.layer.cornerRadius = 15
        
        menuView.isHidden = true
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        let SLO = CLLocationCoordinate2D.init(latitude: 41.0814, longitude: -81.5190)
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion.init(center: SLO, span: span)
        mapView.setRegion(region, animated: true)

        showOrg = true
        showShelter = true
        showHazard = true
        
        updatePins()
        
    }
    
    func updatePins(){
        mapView.removeAnnotations(mapView.annotations)
        if (showOrg == true){
            self.getOrganizations()
        }
        if(showShelter == true){
            self.getShelters()
        }
        if(showHazard == true){
            self.getRecentAndActiveIncidents()
        }
    }
    
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
        
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            //let returnString = String.init(data: data!, encoding: String.Encoding.utf8)
            //self.incidentData = Incident(initData: (returnString! as! [String: Any])["incident"] as! [String : Any])
            
            do {
                let incidentData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                self.incidentData = Incident(initData: incidentData["incidents"] as! [String: Any])
            } catch {
                print(error.localizedDescription)
            }
        }
        urlSession.resume()
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
            
            
            
            for org in organizations{
                //print(org.name)
                
//                let location = CLLocationCoordinate2D.init(latitude: org.locationInfo.latitude, longitude: org.locationInfo.longitude)
//
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = location
//                annotation.title = org.name
//                annotation.subtitle = ""
                
//                let annotationView = MKPinAnnotationView()
//                annotationView.pinTintColor = .blue
//                annotationView.annotation = annotation
                
               // self.orgArray.append(annotation)
                self.mapView.addAnnotation(org)
            }
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
            // update annotations
            

//
            for s in self.shelters!{
//                //print(org.name)
//                let location = CLLocationCoordinate2D.init(latitude: s.latitude, longitude: s.longitude)
//
//                let annotation = MKPointAnnotation()
//
//                annotation.coordinate = location
//                annotation.title = s.name
//                annotation.subtitle = ""
//
//                let annotationView = MKPinAnnotationView()
//                annotationView.pinTintColor = .red
//                annotationView.annotation = annotation
                
                //self.shelterArray.append(annotation)
                self.mapView.addAnnotation(s)
                
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newPin"{
           // let destVC = segue.destination as! NewPinViewController
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "newPin", sender: nil)
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        let locCoord = self.mapView.convert(location,toCoordinateFrom: self.mapView)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locCoord
        annotation.title = "Store"
        annotation.subtitle = "Location of store"
        
        self.mapView.addAnnotation(annotation)
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.performSegue(withIdentifier: "newPin", sender: nil)
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Organization {
            let annotationView = MKPinAnnotationView()
            annotationView.pinTintColor = .red
            annotationView.pinTintColor = UIColor(colorWithHexValue: 0xFF6F59)
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.animatesDrop = true
            
            //annotationView.image = UIImage.init(named: "blah.png")
            

            return annotationView
        }
        if annotation is Shelter {
            let annotationView = MKPinAnnotationView()
            annotationView.pinTintColor = UIColor(colorWithHexValue: 0x43AAB8)
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.animatesDrop = true
            //annotationView.image = UIImage.init(named: "blah.png")
            return annotationView
        }
        return nil
    }
    
}

extension UISegmentedControl {
    func goVertical() {
        self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        for segment in self.subviews {
            for segmentSubview in segment.subviews {
                if segmentSubview is UILabel {
                    (segmentSubview as! UILabel).transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
                }
            }
        }
    }
}

extension UIColor{
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
}
