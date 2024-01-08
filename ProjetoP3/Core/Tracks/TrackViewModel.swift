//
//  TrackViewModel.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import Foundation
import SwiftUI


@MainActor
class TrackViewModel: ObservableObject {
    @Published private(set) var tracks: [Track] = []
    
    func createTrack(name: String, description: String) async throws {
        try await TrackManager.shared.createTrack(name: name, description: description)
    }
    
    func getAllTracks() async throws {
        try await tracks = TrackManager.shared.getAllTracks()
    }
    
    func updateTrack(id: String, name: String, description: String) async throws{
        let newTrack = Track(id:id, name: name, description: description)
        try await TrackManager.shared.updateTrack(track: newTrack)
    }
    
    func deleteTrack(id: String) async throws {
        try await TrackManager.shared.deleteTrack(trackId: id)
    }
}
