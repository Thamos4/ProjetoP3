//
//  ConferenceViewModel.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import Foundation

import SwiftUI

@MainActor
class ConferenceViewModel: ObservableObject{
    @Published var conferences: [Conference] = []{
        didSet{ Task { try await setAllConferences()}}
    }

    func createConference(name: String, beginDate: String, endDate: String, description: String) async throws {
        try await ConferenceManager.shared.createConference(name: name, beginDate: beginDate, endDate: endDate, description: description)
    }

    func setAllConferences() async throws {
        try await conferences = ConferenceManager.shared.getAllConferences()
    }

    func updateConference(id: String, name: String, beginDate: String, endDate: String, description: String) async throws{
        let newConference = Conference(id:id, name: name, beginDate: beginDate, endDate: endDate, description: description)
        try await ConferenceManager.shared.updateConference(conference: newConference)
    }

    func deleteConference(id: String) async throws {
        let tracks = try await TrackManager.shared.getAllTracksForConferenceId(conferenceId: id)
        for track in tracks{
            try await TrackManager.shared.deleteTrack(trackId: track.id)
        }
        try await ConferenceManager.shared.deleteConference(conferenceId: id)
        conferences.removeAll(where: {$0.id == id})
    }
}
