//
//  ModelVNExpress.swift
//  VNExpress
//
//  Created by Tuyen on 05/07/2021.
//

import Foundation
struct channel {
    let title,description: String
    let image: Image
    let pubDate,generator, link: String
    let item: [Item]
    
}
struct Image {
    let url, title, link: String
}
struct Item {
    let title, description, pubDate, link, guid, comments: String
}
