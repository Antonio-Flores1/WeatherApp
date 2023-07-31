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

        let urlString = "https://api.tomorrow.io/v4/weather/forecast?location=\(lat),\(long)&fields=temperature&timesteps=1h&units=metric&apikey=fm3FfjFr9iuu6ZQ3PrsBi5NdBkQ700EL"
        
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
                let jsonData = try JSONDecoder().decode(Weather.self, from: data)
                    DispatchQueue.main.async {
                        self?.weatherModel = [jsonData]
                        self?.table.reloadData()
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath)
        return cell
    }
    



}



struct Weather: Codable {
    var timelines: Weatherhourly?
}

struct Weatherhourly: Codable {
    var hourly: [WeatherData]?
}

struct WeatherData: Codable {
    var time: String?
    var values: Valuesdata
}

struct Valuesdata: Codable {
    var cloudBase: Float?
    var cloudCeiling: Float?
    var cloudCover: Float
    var dewPoint: Float
    var evapotranspiration: Float
    var freezingRainIntensity: Int
    var humidity: Float
    var iceAccumulation: Int?
    var iceAccumulationLwe: Float?
    var precipitationProbability: Int
    var pressureSurfaceLevel: Float
    var rainAccumulation: Float
    var rainAccumulationLwe: Float?
    var rainIntensity: Float
}
