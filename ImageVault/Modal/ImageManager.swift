//
//  ImageManager.swift
//  ImageVault
//
//  Created by Pushkar Deshmane on 06/09/2020.
//  Copyright © 2020 Pushkar Deshmane. All rights reserved.
//

import Foundation

//Protocol
protocol ImageManagerDelegate {
    func didUpdateImages(_ imageManager:ImageManager, images: [ImageData])
    func didFailWithError(error: Error)
}

struct ImageManager{
    let imageURL = "https://picsum.photos/list"
    
    var delegate: ImageManagerDelegate?
    
    func fetchWeather() {
        performRequest(with: imageURL)
    }
    
    //internal and external parameter names
    func performRequest(with urlString:String){
        //1. Create a URL
        if let url = URL(string: urlString){
            
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            
            //3. Assign Task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //terminate the code if there is as error
                    return
                }
                
                if let safeData = data {
                    //calling method from clouser
                    //optional binding
                    if let images = self.parseJSON(safeData){
                        self.delegate?.didUpdateImages(self, images:images)
                    }
                }
            }
            //4. Start Task
            task.resume()
        }
    }
    
    func parseJSON(_ imageData: Data) -> [ImageData]?{
        let decoder = JSONDecoder()
        do {
            let decodedData : [ImageData] = try decoder.decode([ImageData].self, from: imageData)
            return decodedData
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
