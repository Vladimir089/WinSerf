//
//  ProfileViewModel.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import Foundation
import Combine
import UIKit

class ProfileViewModel {
    
    private var loadFromFile = LoadProfileToFile()
    
    var cancellable = [AnyCancellable]()
    let collectionPublisher = PassthroughSubject<Any, Never>()

    
    lazy var board: Board? = loadFromFile.loadBoardToFile() ?? nil
    lazy var equipmentArr: [Equipment] = loadFromFile.loadEquipmentToFile() ?? []
    
    init() {
        if let newBoard = board  {
            collectionPublisher.send(newBoard)
        }
    }
    
    func setBoard(board: Board) {
        self.board = board
        do {
            let data = try JSONEncoder().encode(board) //тут мкассив конвертируем в дату
            try loadFromFile.saveBoardToFile(data: data)
            collectionPublisher.send(board)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    func deleteEqupment(index: Int) {
        equipmentArr.remove(at: index)
        do {
            let data = try JSONEncoder().encode(equipmentArr) //тут мкассив конвертируем в дату
            try loadFromFile.saveEqupmentToFile(data: data)
            collectionPublisher.send(0)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    func setEquipment(equipment: Equipment, index: Int?) {
        
        let item = equipmentArr.firstIndex(where: {$0.id == equipment.id})
   
        if index != nil {
            equipmentArr[index ?? 0] = equipment
        } else {
            equipmentArr.append(equipment)
        }
        
        do {
            let data = try JSONEncoder().encode(equipmentArr) //тут мкассив конвертируем в дату
            try loadFromFile.saveEqupmentToFile(data: data)
            collectionPublisher.send(0)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    func sendBoard() -> Board {
        return board ?? Board(image: UIImage.standartBoard.jpegData(compressionQuality: 0) ?? Data(), name: "Name", lenght: 0, volume: 0, type: "Type", speed: 0)
    }
    
    func getHeightMainCollection(collectionIsMain: Bool, indexForCollection: Int?) -> CGFloat {
        if collectionIsMain {
            
            let topCell = 231 + 15 + 25
            let botCell = equipmentArr.count > 0 ? (200 * equipmentArr.count) : 230
            
            if indexForCollection == 0 {
                return CGFloat(topCell)
            } else {
                return CGFloat(botCell)
            }

        } else {
            if indexForCollection == equipmentArr.count + 1  {
                return 52
            } else {
                return equipmentArr.count > 0 ? 185 : 130
            }
        }
    }
    
    func returnNumberCellsInEquipmentCollection() -> Int {
        return equipmentArr.count > 0 ? equipmentArr.count  : 2
    }
    
  
}
