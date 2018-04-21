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
    @IBAction func orgSwitch(_ sender: UISwitch) {
        print("org switched")
    }
    @IBAction func fireSwitch(_ sender: UISwitch) {
        print("fire switched")
    }
    @IBAction func menuButton(_ sender: UIButton) {
        self.menuView.isHidden = !self.menuView.isHidden
    }
    
    var databaseReference: DatabaseReference?
    var organizations: [Organization]?
    var shelters: [Shelter]?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.databaseReference = Database.database().reference()
        
        blurView.layer.cornerRadius = 15
        
        menuView.isHidden = true
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        let SLO = CLLocationCoordinate2D.init(latitude: 35.3, longitude: -120.66)
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion.init(center: SLO, span: span)
        mapView.setRegion(region, animated: true)

        self.getOrganizations()
        self.getShelters()
        
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
            // update annottations
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
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newPin"{
            let destVC = segue.destination as! NewPinViewController
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
