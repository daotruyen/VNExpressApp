//
//  MainTableViewCell.swift
//  VNExpress
//
//  Created by Tuyen on 05/07/2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var newTitle: UILabel!
    @IBOutlet weak var newDescription: UILabel!
    @IBOutlet weak var newTime: UILabel!
    @IBOutlet weak var section: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 1
        self.layer.borderColor = .init(red: 0.013, green: 0.013, blue: 0.038, alpha: 0.13)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
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

}
