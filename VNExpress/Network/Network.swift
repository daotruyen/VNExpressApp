//
//  Network.swift
//  VNExpress
//
//  Created by Tuyen on 06/07/2021.
//

import UIKit
func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
        }.resume()
    }
