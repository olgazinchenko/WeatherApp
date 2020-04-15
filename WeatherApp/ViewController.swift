//
//  ViewController.swift
//  WeatherApp
//
//  Created by Olga on 10.04.2020.
//  Copyright © 2020 Olga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString = "https://samples.openweathermap.org/data/2.5/weather?q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))&appid=439d4b804bc8187953eb36d2a8c26a02"
        let url = URL(string: urlString)
        
        var currentTemp: Double?
        var errorHasOccured: Bool = false
        
        let task = URLSession.shared.dataTask(with: url!) { [weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let _ = json["error"] {
                    errorHasOccured = true
                }
                
                let cityName = json["name"] as? String
                
                if let main = json["main"] {
                    currentTemp = main["temp"] as? Double
                }
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.cityLabel.text = "Error has occured"
                        self?.temperatureLabel.isHidden = true
                    }
                    else {
                        self?.cityLabel.text = cityName
                        self?.temperatureLabel.text = "\(currentTemp!)"
                        
                        self?.temperatureLabel.isHidden = false
                        
                    }
                    
                }
            }
            catch let jsonError {
                print(jsonError)
            }
       }
        task.resume()
    }
}
