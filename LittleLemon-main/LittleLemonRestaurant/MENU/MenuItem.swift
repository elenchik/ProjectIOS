//
//  MenuItem.swift
//  LittleLemonRestaurant
//

import Foundation

struct MenuItem: Decodable, Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let price: String
    let explanation: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case image = "image"
        case price = "price"
        case explanation = "description"
        case category = "category"
    }
}
