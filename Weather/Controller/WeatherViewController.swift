//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
  
   
 
    
    var weatherM = WeatherManger()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
   
  

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherM.delegate = self
        searchTF.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        

        // after showing the permission dialog, the program will continue executing the next line before the user has tap 'Allow' or 'Disallow'
        
        // if previously user has allowed the location permission, then request location
       
        
        
    }
    
  
    @IBAction func searchbyLocationButtPressed(_ sender: UIButton) {
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
                   locationManager.requestLocation()
               }
    }
    
}

//MARK: - PART_OF_WVC_for_TFD

extension WeatherViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           searchTF.endEditing(true)
           return true
       }
    
    @IBAction func searchPressed(_ sender: UIButton) {
            searchTF.endEditing(true)
            
        }
       
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if textField.text != "" {
               textField.endEditing(true)
               return true
           }else{
               
               textField.placeholder = "Type Something"
               return false
           }
        
       }
  
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           
           weatherM.fetchWeather(Cityname: searchTF.text!)

           
           searchTF.text = ""
          }
    
    
}

//MARK: -part for WeatherProtocol

extension WeatherViewController : WeatherProtocol {
    
    
    
    func updateVC(_ weathermanager:WeatherManger ,weat : WeatherModel) {
          DispatchQueue.main.async {
              self.temperatureLabel.text = String(format: "%.1f", weat.temperature)
              self.conditionImageView.image = UIImage(systemName: weat.conditionName)
            self.cityLabel.text = weat.cityName
          }
        
      }

}

//MARK: -part Of WVC  for LocationD


extension WeatherViewController : CLLocationManagerDelegate {
    
    
    
    
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("finally dataaa has been retreived")
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lot = location.coordinate.longitude
            print(lat)
            print(lot)
            weatherM.fetchWeatherByCordinate(lat: lat, lon: lot)
            
            
            
        }

    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       
        print("Your location can't be reached")
    }
    
}
