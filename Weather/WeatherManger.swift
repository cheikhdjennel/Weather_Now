//
//  WeatherManger.swift
//  Clima
//
//  Created by Djennelbaroud Hadj Chikh on 27/05/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//
import Foundation
import CoreLocation
struct  WeatherManger {
   
    var delegate : WeatherProtocol?
    
    var WeatherUrl = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=b715e6e03d87464f96d78c0e0e1e2971"
    
    func fetchWeather (Cityname : String)  {
       
        let urlString = WeatherUrl+"&q=\(Cityname)"
        performUrl(with : urlString)
    }
    
    func fetchWeatherByCordinate(lat : CLLocationDegrees , lon : CLLocationDegrees)  {
        let urlString = WeatherUrl+"&lat=\(lat)&lon=\(lon)"
        performUrl(with: urlString)
        
    }
    
    func performUrl(with urlString:String)  {
        // create Url
        if let url = URL(string: urlString){
            // create session
            let ses = URLSession(configuration: .default)
            // create task
            let task = ses.dataTask(with: url) { (data, urlresponder, error) in
                if error != nil {
                    print(error)
                    return
                }
                if let data = data {
                    if let weather =  self.ParseJson(data) {
                        
                        self.delegate?.updateVC(self,weat: weather)
                        
                        
                    }
                }
            }
            // start of the task
            task.resume()
            
        }
    }
    
    func ParseJson(_ weatherData:Data) -> WeatherModel?{
       
        var wData : WeatherModel?
        let dec = JSONDecoder()
        
        do {
            let decodedData = try dec.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
            let id = decodedData.weather[0].id
            print("\n theeen \n ")
            wData = WeatherModel(temperature: decodedData.main.temp, cityName: decodedData.name, conditionId: id)

            
            
            print(wData!.temperature)
            print(wData!.conditionName)
            
            return wData
        }catch{
            print(error)
            return nil
        }
        
        
        
    }
    
    
    
}
