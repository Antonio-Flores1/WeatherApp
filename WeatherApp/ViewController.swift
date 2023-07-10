//
//  ViewController.swift
//  WeatherApp
//
//  Created by Antonio on 7/8/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var table: UITableView!
    
    var weatherModel = [Weather]()
    let locationManager = CLLocationManager()
    var currentLocations: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register( HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register( WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
        setupLocation()
         
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocations == nil {
            currentLocations = locations.first
            locationManager.stopUpdatingLocation()
            requestionLocationForWeather()
        }
    }
    
    func requestionLocationForWeather(){
        
        guard let currentLocations = currentLocations else {
            return
        }
        
        let long = currentLocations.coordinate.longitude
        let lat = currentLocations.coordinate.latitude
    }

        
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    


}

struct Weather {
    
}
