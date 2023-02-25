//
//  GardenMapVC.swift
//  MemphisGardens
//
//  Created by Kareem Dasilva on 2/25/23.
//

import UIKit
import FirebaseCore
import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import GoogleMaps
import MapKit

class GardenMapVC: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var oopsLabe: UILabel!
    @IBOutlet weak var pleaseLabel: UILabel!
    @IBOutlet weak var gpsImage: UIImageView!
    @IBOutlet weak var customMapView: UIView!
    @IBOutlet weak var mapCollectionView: UICollectionView!
    
    
  
    let manager = CLLocationManager()
    var userLocation:CLLocation?
    var gMapView:GMSMapView?
    var gardens = [Garden]()
    var nearYoufoodtrucks = [Garden]()
    var userLocations = [CLLocation]()
    var route: MKRoute!
    
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    var marker: GMSMarker!
    var markers = [GMSMarker]()
    var userLoggedIn = false
    var isDetailView = false
    var detailFoodTruckId:String?
    var detailGarden:Garden?
    
    override func viewDidDisappear(_ animated: Bool) {
        print("released")
        gMapView?.clear()
        gMapView?.delegate = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        gardens.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gMapView?.isMyLocationEnabled = true
        gMapView?.settings.myLocationButton = true
        
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .denied {
            
            } else {
            self.gMapView?.delegate = self
    
                    queryGardens()
                
            oopsLabe.isHidden = true
            pleaseLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 22))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 22))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "Full Logo Red")
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
        
        if let current = Auth.auth().currentUser {
            userLoggedIn = true
        }
        
        self.gMapView?.delegate = self
        gMapView?.isMyLocationEnabled = true
        gMapView?.settings.myLocationButton = true
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        //------------------------------- NAIM MAPVIEW TESTING
        //gMapView?.mapType = .normal
        //-------------------------------
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
       
        manager.distanceFilter = kCLDistanceFilterNone
        GMSServices.provideAPIKey("AIzaSyDd0xBjN5EQdfYKPPlDVHXLXlMwJ0rr7fg")
        guard let currentLocation = manager.location?.coordinate else {
            manager.requestWhenInUseAuthorization()
            let alert = UIAlertController(title: "Location Services Disabled!", message: "Make sure to turn on Location services in settings to view nearby food trucks.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title:"Ok", style: .cancel, handler:nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            return
        }
        let camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 15)
        gMapView = GMSMapView.map(withFrame: CGRect(x: 0, y: -100, width: view.frame.width, height: view.frame.height), camera: camera)
        self.customMapView.addSubview(gMapView!)
    }
 
    func applyGardenMap(map:GMSMapView){
        print("Marker was called")
        self.gMapView?.clear()
        self.markers = []
        for garden in gardens {
            print(gardens.count)
            let currentLocation = CLLocationCoordinate2D(latitude: (garden.latitude)!, longitude: garden.longitude!)
                print("sdded a marker")
                let marker = GMSMarker(position: currentLocation)
            marker.position.latitude = currentLocation.latitude
            marker.position.longitude = currentLocation.longitude
                marker.map = map
                markers.append(marker)
       
        }
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        print("Did you see how this works")
        print(location.distance(from: userLocation!))
        return location.distance(from: userLocation!)
    }
    
   
    func queryGardens()  {
        print("querying Garden")
        var db = Firestore.firestore()
        //    .whereField("utcStartTime", isGreaterThanOrEqualTo: Date().timeIntervalSince1970)
        db.collection("Gardens").getDocuments { querySnapshot, error in
                  guard let documents = querySnapshot?.documents else {
                      print("Error fetching documents: \(error!)")
                      return
                  }
                  for garden in documents {
                      let selectedGarden = Garden(key:garden.documentID, data:(garden.data() as Dictionary<String,AnyObject>))
                      guard let gardenId = selectedGarden.key else {return}
                    guard let latitude = selectedGarden.latitude, let longitude = selectedGarden.longitude else {return}
                        if self.distance(to: CLLocation(latitude: latitude, longitude: longitude)) < 10000.0 {

                                self.gardens.append(selectedGarden)
                                print("was Succesful")
                              DispatchQueue.main.async{
                              self.mapCollectionView.reloadData()
                              }
                            print("gardens Information")
                            self.applyGardenMap(map: self.gMapView!)
                }
            }
        }
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         userLocation = locations[0]
        
        marker = GMSMarker(position: userLocation!.coordinate)
        //marker.icon = UIImage(named: "marker_truck")
        //london.icon = UIImage(named: "house")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let index = markers.index(of: marker) {
            print(index)
            print(gardens.count)
            let gardenName = gardens[index].name
            let gardenCategory = gardens[index].yearBuilt
            let gardenImage = gardens[index].previewImage
            let gardenDescription = gardens[index].description
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popup") as? PopUpDetail else {return false}
            
            vc.garden = gardens[index]
            vc.gardenNameReceived = gardens[index].name
            vc.gardenImageReceived = gardens[index].previewImage
            self.present(vc, animated: true, completion: nil)
          
            let size = CGSize(width: 100, height: 100)
            var point:CGPoint = mapView.projection.point(for: marker.position)
            point.y = point.y + 30
            
            let camera:GMSCameraUpdate = GMSCameraUpdate.setTarget(mapView.projection.coordinate(for: point))
            mapView.animate(with: camera)
            print("Pressed")
        }
        return true
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return
            }
        }
    }
}

extension GardenMapVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gardens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    let garden = gardens[indexPath.row]
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GardenCollectionViewCell
        if let gardenImageUrl = garden.previewImage {
            cell?.previewImage.loadImageUsingCacheWithUrlString(urlString: gardenImageUrl)
                    }
                    print("looking for detail")
        cell?.configureCell(gardenData: garden)
                    cell?.distance.text = ""

                    if userLocation == nil {
                        print("user Locations is empty")
                    } else {
                        let userLocation2D = CLLocationCoordinate2D(latitude:userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
                        
                        
                        let currentLocation = CLLocationCoordinate2D(latitude: (gardens[indexPath.row].latitude)!, longitude: gardens[indexPath.row].longitude!)
                
                    let start = MKMapItem(placemark: MKPlacemark(coordinate: userLocation2D))
                    let end = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation))
                    let request = MKDirections.Request() //create a direction request object
                    request.source = start//this is the source location mapItem object
                    request.destination = end //this is the destination location mapItem object
                        request.transportType = MKDirectionsTransportType.automobile //define the transportation method
                    
                    let directions = MKDirections(request: request) //request directions
                        
                    directions.calculate { (response, error) in
                        guard let response = response else {
                            print(error.debugDescription)
                            print("error in location")
                            return
                        }
                        self.route = response.routes[0]
                        let newRoute = self.route.distance / 1609.0
                        print("route information")
                        print(newRoute)
                       // cell?.distance.text = String(newRoute.truncate(places: 2))
                    }
                    }
                    cell?.layer.cornerRadius = 10
                    cell?.layer.borderWidth = 1
                    cell?.layer.borderColor = UIColor.lightGray.cgColor
   
                return cell!
                
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !gardens.isEmpty {
            let currentLocation = CLLocationCoordinate2D(latitude: (gardens[indexPath.row].latitude)!, longitude: gardens[indexPath.row].longitude!)
        let camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 15)
        gMapView?.camera = camera
        }
          
    }
}
