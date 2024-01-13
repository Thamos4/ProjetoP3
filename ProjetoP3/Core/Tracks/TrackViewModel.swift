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
    
    func createTrack(name: String, description: String, conferenceId: String) async throws {
        try await TrackManager.shared.createTrack(name: name, description: description, conferenceId: conferenceId)
    }
    
    func getAllTracks() async throws {
        try await tracks = TrackManager.shared.getAllTracks()
    }
    
    func updateTrack(id: String, name: String, description: String, conferenceId: String) async throws{
        let newTrack = Track(id:id, name: name, description: description, conferenceId: conferenceId)
        try await TrackManager.shared.updateTrack(track: newTrack)
    }
    
    func deleteTrack(id: String) async throws {
        let articles = try await ArticleManager.shared.getAllArticlesForTrackId(trackId: id)
        for article in articles{
            try await ArticleManager.shared.deleteArticle(articleId: article.id)
        }
        try await TrackManager.shared.deleteTrack(trackId: id)
    }
    
    func getTracksByConferenceId(conferenceId: String) async throws{
        try await tracks = TrackManager.shared.getAllTracksForConferenceId(conferenceId: conferenceId)
    }
    
    func trackAlreadyExists(name: String, conferenceId: String) async throws -> Bool{
        return try await TrackManager.shared.trackAlreadyExists(name: name, conferenceId: conferenceId)
    }
    func getTrackNameById(trackId: String) async throws -> String {
        let track = try await TrackManager.shared.getTrack(trackId: trackId)
        return track.name
    }
    
}
