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
    
    var weatherModel = [dogApiTest]()
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

//    https://api.tomorrow.io/v4/timelines?location=40.75872069597532,-73.98529171943665&fields=temperature&timesteps=1h&units=metric&apikey=fm3FfjFr9iuu6ZQ3PrsBi5NdBkQ700EL
   let urlString = "https://dog.ceo/api/breeds/image/random"
        
//        "https://api.tomorrow.io/v4/timelines?location=40.75872069597532,-73.98529171943665&fields=temperature&timesteps=1h&units=metric&apikey=fm3FfjFr9iuu6ZQ3PrsBi5NdBkQ700EL"
        
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
                let json = try JSONDecoder().decode(dogApiTest.self, from: data)
//                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        dump(json)
                        dump(dogApiTest.self)
                        
                }
            } catch {
                print(error)
            }
        }
            task.resume()
    
//      "https://api.tomorrow.io/v4/timelines?location=\(lat),\(long)&fields=temperature&timesteps=1h&units=metric&apikey=fm3FfjFr9iuu6ZQ3PrsBi5NdBkQ700EL"
//        let urlRequest = URLRequest(url: url!)
    
        
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//
////        }
//
//            guard let weatherData = data, error == nil else {
//                print("Something didn't happen")
//                return
//            }
//
//            do {
//                 let weather = try JSONDecoder().decode( Weather.self, from: weatherData)
//                    DispatchQueue.main.async {
//                        self.weatherModel = [weather]
//    //                    self.table.reloadData()
//                        print("\(weather)")
//                        dump(weather)
//    //                    self!.weatherModel = [weather]
//                    }
////                completionHandler(weather,nil)
//
//            } catch {
//                print("Error: \(error)")
//            }
//
//
//            guard let error = error else {
//                print("Error: \(error)")
//                return
//            }
//
//
//        }.resume()
        
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

struct dogApiTest: Codable{
    let message: String
    let status: String
}



struct Weather: Codable {
    let data: DataClass?
}

struct DataClass: Codable {
    let timelines: [Timeline]?
}

struct Timeline: Codable {
    let timestep: String?
    let endTime: String?
    let startTime: String?
    let intervals: [IntervalsWeather]?
}

struct IntervalsWeather: Codable {
    let startTime: String?
    let values: [TemperatureWeather]?
}

    struct TemperatureWeather: Codable {
    let temperature: Float?
}
