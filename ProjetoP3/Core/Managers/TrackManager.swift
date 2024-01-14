//
//  TrackManager.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class TrackManager{
    
    static let shared = TrackManager()
    private init() { }
    
    private let tracksCollection = Firestore.firestore().collection("tracks")
    
    private func trackDocument(trackId: String) -> DocumentReference {
        tracksCollection.document(trackId)
    }
    
    func createTrack (name: String, description: String, conferenceId: String) async throws{
        let newTrackRef = tracksCollection.document()
        let id = newTrackRef.documentID
        let newTrack = Track(id: id, name: name, description: description, conferenceId: conferenceId)
        try newTrackRef.setData(from: newTrack)
    }
    
    func getTrack(trackId: String) async throws -> Track{
        try await trackDocument(trackId: trackId).getDocument(as: Track.self)
    }
    
    func updateTrack(track: Track) async throws {
        try trackDocument(trackId: track.id).setData(from: track, merge: true)
    }
    
    func getAllTracks() async throws -> [Track]{
        try await tracksCollection.getDocuments(as: Track.self)
    }
    
    func deleteTrack(trackId: String) async throws -> Void{
        do{
            try await trackDocument(trackId: trackId).delete()
        }catch{
            print("DEBUG: Made an oopsie deleting track u.u")
        }
    }
    
    func getAllTracksForConferenceId(conferenceId: String) async throws -> [Track]{
        try await tracksCollection.whereField("conferenceId", isEqualTo: conferenceId).getDocuments(as: Track.self)
    }
    
    func trackAlreadyExists(name: String, conferenceId: String)async throws -> Bool{
        let trackList = try await getAllTracksForConferenceId(conferenceId: conferenceId).map {$0.name}
        return trackList.contains(name)
    }
}
