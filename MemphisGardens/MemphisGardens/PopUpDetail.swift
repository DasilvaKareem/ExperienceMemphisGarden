//
//  PopUpDetail.swift
//  Edesia
//
//  Created by Umer on 8/28/18.
//  Copyright © 2018 Edesia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import MapKit

class PopUpDetail: UIViewController, CLLocationManagerDelegate {
    
    var garden: Garden!
    var gardenNameReceived: String?
    var gardenImageReceived: String?
    
    @IBOutlet weak var ftImage: UIImageView!
    @IBOutlet weak var ftName: UILabel!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismiss2(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ftName.text = gardenNameReceived
        if let foodTruckImageUrl = gardenImageReceived {
            ftImage.image = nil
            ftImage.loadImageUsingCacheWithUrlString(urlString: foodTruckImageUrl)
        }
    }
    
    @IBAction func getDirectionsPressed(_ sender: Any) {
        let coordinate = CLLocationCoordinate2DMake((garden.latitude)!,(garden.longitude)!)
        print(coordinate)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = ftName.text
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    
    @IBAction func viewDetailsPressed(_ sender: Any) {
       // let vc = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "intro") as? DetailViewController
      //  vc?.foodTruckData = foodTruck.foodTruck
     //   present(vc!, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     /*   if segue.identifier == "toDetails" {
            if let detailVC = segue.destination as? DetailContainerVC {
                detailVC.foodTruck = foodTruck.foodTruck
                detailVC.fromMap = true
            }
        }*/
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }    
}
