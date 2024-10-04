//
//  SwimViewModel.swift
//  WinSerf
//
//  Created by Владимир Кацап on 03.10.2024.
//

import Foundation
import Combine
import CombineCocoa


class SwimViewModel {
    
    var cancellable = [AnyCancellable]()
    var updateCollectionPublisher = PassthroughSubject<Any, Never>()
    
    private let loadFile = LoadProfileToFile()

    var speedArr: [Speed] = []
    var tricksArr: [Tricks] = []
    
    init() {
        loadArrs()
    }
    
    
    private func loadArrs() {
        speedArr = loadFile.loadSpeedToFile() ?? []
        tricksArr = loadFile.loadTricksToFile() ?? []
    }
    
    func returnSpeedArrCount() -> Int {
        return speedArr.count
    }
    
    func returnTricksArrCount() -> Int {
        return tricksArr.count
    }
    
    
    func saveSpeed(item: Speed, isNew: Bool, index: Int) {
        if isNew {
            speedArr.append(item)
        } else {
            speedArr[index] = item
        }
        
        saveSpeed()
    }
    
    func saveTrick(item: Tricks, isNew: Bool, index: Int) {
        if isNew {
            tricksArr.append(item)
        } else {
            tricksArr[index] = item
        }
        
        saveTrics()
    }
    
    private func saveSpeed() {
        do {
            let data = try JSONEncoder().encode(speedArr) //тут мкассив конвертируем в дату
            try loadFile.saveSpeedArrToFile(data: data)
            updateCollectionPublisher.send(0)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    private func saveTrics() {
        do {
            let data = try JSONEncoder().encode(tricksArr) //тут мкассив конвертируем в дату
            try loadFile.saveTricksArrToFile(data: data)
            updateCollectionPublisher.send(0)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    func delSpeed(index: Int) {
        speedArr.remove(at: index)
        saveSpeed()
    }
    
    func delTricks(index: Int) {
        tricksArr.remove(at: index)
        saveTrics()
    }
}
