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

        let urlString = "https://api.tomorrow.io/v4/weather/forecast?location=40.75872069597532,-73.98529171943665&fields=temperature&timesteps=1h&units=metric&apikey=fm3FfjFr9iuu6ZQ3PrsBi5NdBkQ700EL"
        
        guard let url = URL(string: urlString) else {
            print("Issues with URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "unsure of error description")
                return
            }

            do {
                let json = try JSONDecoder().decode(Weather.self, from: data)
                    DispatchQueue.main.async {
                        dump(json.timelines)
                        dump(Weather.self)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
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
    let timelines: Weatherhourly?
}

struct Weatherhourly: Codable {
    let hourly: [WeatherData]?
}

struct WeatherData: Codable {
    let time: String?
    let values: String?
}
