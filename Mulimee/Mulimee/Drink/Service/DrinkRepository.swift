//
//  Repository.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import Combine
import Foundation
import WidgetKit

protocol DrinkRepository: Sendable {
    var glassPublisher: AnyPublisher<Water, Error> { get }
    var isExistDocument: Bool { get async }
    
    func createDocument() async throws
    func fetchDrink() async throws -> Water
    func setDrink() async throws
    func reset() async throws
}
 
