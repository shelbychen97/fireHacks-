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



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuView: UIView!
    @IBAction func menuButton(_ sender: UIButton) {
        menuView.isHidden = true
    }
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.isHidden = false
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        let SLO = CLLocationCoordinate2D.init(latitude: 35.3, longitude: -120.66)
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion.init(center: SLO, span: span)
        mapView.setRegion(region, animated: true)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
