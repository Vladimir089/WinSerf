//
//  SwimModels.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import Foundation


struct Board: Codable {
    let image: Data
    let name: String
    let lenght: Double
    let volume: Int
    let type: String
    let speed: Int
    
    init(image: Data, name: String, lenght: Double, volume: Int, type: String, speed: Int) {
        self.image = image
        self.name = name
        self.lenght = lenght
        self.volume = volume
        self.type = type
        self.speed = speed
    }
}


struct Equipment: Codable, Identifiable {
    var id: UUID
    var image: Data
    var name: String
    var description: String
    var characteristics: [Character]
    
    init(image: Data, name: String, description: String, characteristics: [Character]) {
        self.id = UUID()
        self.image = image
        self.name = name
        self.description = description
        self.characteristics = characteristics
    }
}

struct Character: Codable {
    var name: String
    var value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
