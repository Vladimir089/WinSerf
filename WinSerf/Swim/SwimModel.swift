//
//  SwimModel.swift
//  WinSerf
//
//  Created by Владимир Кацап on 03.10.2024.
//

import Foundation


class Speed: Codable, Identifiable {
    let id: UUID
    var distance: String
    var speed: String
    var time: String
    var wind: String
    var date: String
    
    init(distance: String, speed: String, time: String, wind: String, date: String) {
        self.id = UUID()
        self.distance = distance
        self.speed = speed
        self.time = time
        self.wind = wind
        self.date = date
    }
}


class Tricks: Codable, Identifiable {
    let id: UUID
    var distance: String
    var time: String
    var wind: String
    var date: String
    var tricks: [NewTrick]
    
    init(distance: String, time: String, wind: String, date: String, tricks: [NewTrick]) {
        self.id = UUID()
        self.distance = distance
        self.time = time
        self.wind = wind
        self.date = date
        self.tricks = tricks
    }
}


class NewTrick: Codable {
    var name: String
    var value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
