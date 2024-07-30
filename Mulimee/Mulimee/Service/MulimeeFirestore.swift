//
//  MulimeeFirestore.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/26/24.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Foundation

enum FirestoreError: Error {
    case saveError(Error?)
}

final class MulimeeFirestore: Sendable {
    private enum Constant {
        static let drink = "drink"
        static let water = "water"
    }
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    func documentPublisher(userId: String) -> AnyPublisher<Water, any Error> {
        let collectionPath = "\(Constant.drink)/\(userId)/\(Constant.water)"
        let collectionListner = Firestore.firestore().collection(collectionPath)
        let documentPath = dateFormatter.string(from: .now)
        
        return collectionListner.document(documentPath)
            .snapshotPublisher()
            .tryMap {
                guard $0.exists else {
                    let water = Water(glasses: 0)
                    let _ = collectionListner.document(documentPath).setData(from: water)
                    return water
                }
                return try $0.data(as: Water.self)
            }
            .eraseToAnyPublisher()
    }
    
    func drink(userId: String) async throws {
        let collectionPath = "\(Constant.drink)/\(userId)/\(Constant.water)"
        let collectionListner = Firestore.firestore().collection(collectionPath)
        let documentPath = dateFormatter.string(from: .now)
        
        try await collectionListner.document(documentPath).updateData(["glasses": FieldValue.increment(Int64(1))])
    }
    
    func reset(userId: String) async throws {
        let collectionPath = "\(Constant.drink)/\(userId)/\(Constant.water)"
        let collectionListner = Firestore.firestore().collection(collectionPath)
        let documentPath = dateFormatter.string(from: .now)
        
        try await collectionListner.document(documentPath).updateData(["glasses": 0])
    }
}
