//
//  Model.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 26.08.2024.
//

import Foundation


struct Excursion: Codable {
    var image: Data
    var country: String
    var name: String
    var type: String
    var cost: String
    var desc: String
    
    var isActive: Bool //активная ли экскурсия или пересена в "Уже посещенные"
    
    var impressions: [Impressions] //впечатления и заметки юзера. Стирать когда из неактивапереходит в актив и наоборот 
    
    init(image: Data, country: String, name: String, type: String, cost: String, desc: String, isActive: Bool, impressions: [Impressions]) {
        self.image = image
        self.country = country
        self.name = name
        self.type = type
        self.cost = cost
        self.desc = desc
        self.isActive = isActive
        self.impressions = impressions
    }
}


struct Impressions: Codable {
    var header: String
    var imagies: [Data]
    var text: String
    
    init(header: String, imagies: [Data], text: String) {
        self.header = header
        self.imagies = imagies
        self.text = text
    }
}


//user
struct User: Codable {
    var name: String
    var image: Data
    
    init(name: String, image: Data) {
        self.name = name
        self.image = image
    }
}
