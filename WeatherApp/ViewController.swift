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
        dump(Weather.self)
         
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

        
        let url = "https://api.tomorrow.io/v4/timelines?location=40.75872069597532,-73.98529171943665&fields=temperature&timesteps=1h&units=metric&apikey=fm3FfjFr9iuu6ZQ3PrsBi5NdBkQ700EL"
        
        
//        "https://api.tomorrow.io/v4/timelines?location=\(lat),\(long)&fields=temperature&timesteps=1h&units=metric&apikey=fm3FfjFr9iuu6ZQ3PrsBi5NdBkQ700EL"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data else {
                print("Something didn't happen")
                return
            }
            
            var json: Weather?
            do {
                json = try JSONDecoder().decode(Weather.self, from: data)
                
            } catch {
                print("Error: \(error)")
            }
            
            
            guard let error = error else {
                print("Error: \(error)")
                return
            }
            
            guard let result = json else {
                print("Results \(json)")
                return
            }
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
          
        }).resume()
        
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

struct Weather: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let timelines: [Timeline]
}

struct Timeline: Codable {
    let timestep: String
    let endTime: String
    let startTime: String
    let intervals: [IntervalsWeather]
}

struct IntervalsWeather: Codable {
    let startTime: String
    let values: [TemperatureWeather]
}

    struct TemperatureWeather: Codable {
    let temperature: Float
}
