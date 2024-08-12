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
    
    func isExistDocument(userId: String) async throws -> Bool {
        let collectionPath = "\(Constant.drink)/\(userId)/\(Constant.water)"
        let collectionListner = Firestore.firestore().collection(collectionPath)
        let documentPath = dateFormatter.string(from: .now)
        
        return try await collectionListner.document(documentPath).getDocument().exists
    }
    
    func createDocument(userId: String) async throws {
        let collectionPath = "\(Constant.drink)/\(userId)/\(Constant.water)"
        let collectionListener = Firestore.firestore().collection(collectionPath)
        let documentPath = dateFormatter.string(from: .now)
        
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            do {
                try collectionListener.document(documentPath).setData(from: Water(glasses: 0)) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func documentPublisher(userId: String) -> AnyPublisher<Water, any Error> {
        let collectionPath = "\(Constant.drink)/\(userId)/\(Constant.water)"
        let collectionListner = Firestore.firestore().collection(collectionPath)
        let documentPath = dateFormatter.string(from: .now)
        
        return collectionListner.document(documentPath)
            .snapshotPublisher()
            .tryMap { try $0.data(as: Water.self) }
            .eraseToAnyPublisher()
    }
    
    func fetch(userId: String) async throws -> Water {
        let collectionPath = "\(Constant.drink)/\(userId)/\(Constant.water)"
        let collectionListner = Firestore.firestore().collection(collectionPath)
        let documentPath = dateFormatter.string(from: .now)
        
        return try await collectionListner.document(documentPath).getDocument(as: Water.self)
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
