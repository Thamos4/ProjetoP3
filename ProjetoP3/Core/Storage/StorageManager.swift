//
//  StorageManager.swift
//  ProjetoP3
//
//  Created by user243107 on 1/5/24.
//

import Foundation
import FirebaseStorage

class StoreManager {
    static let shared = StoreManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    func saveImage(data: Data) async throws{
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await storage.child(path).putDataAsync(data, metadata: meta)
    }
}
