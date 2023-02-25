//
//  LocationSearchViewController.swift
//  Edesia
//
//  Created by Kareem Dasilva on 6/8/20.
//  Copyright © 2020 Edesia. All rights reserved.
//


import UIKit
import MapKit

class LocationSearchViewController: UIViewController {

    @IBOutlet var txtSearchbar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var address:String?
    @IBAction func unwindFromLocation(_ sender: UIStoryboardSegue) {

    }
    var searchResults = [MKLocalSearchCompletion]()
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self as! MKLocalSearchCompleterDelegate
        return searchCompleter
    }()
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBAction

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kareem" {
            if let senderVC = segue.destination as? CreateGardenVC {
                    senderVC.locationAddress = address
                }
            
        }
    }
}

extension LocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //UNwind Segue here
        address = searchResults[indexPath.row].title + " " + searchResults[indexPath.row].subtitle
        //performSegue(withIdentifier: "kareem", sender: self)
        print(presentingViewController)
        print()
          if let presenter = presentingViewController as? CreateGardenVC {
        }
    if let navController = self.navigationController, navController.viewControllers.count >= 2 {
         let presenter = navController.viewControllers[navController.viewControllers.count - 2] as! CreateGardenVC
        presenter.locationAddress = address
        self.navigationController?.popViewController(animated: true)

    }
       
        print(address)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = searchResults[indexPath.row].title + " " + searchResults[indexPath.row].subtitle
        return cell!
    }
}

extension LocationSearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }
}
