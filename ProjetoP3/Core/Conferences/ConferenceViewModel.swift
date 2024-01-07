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
    @Published private(set) var conferences: [Conference] = []
    
    func createConference(name: String, beginDate: String, endDate: String, description: String) async throws {
        try await ConferenceManager.shared.createConference(name: name, beginDate: beginDate, endDate: endDate, description: description)
    }
    
    func setAllConferences() async throws {
        try await conferences = ConferenceManager.shared.getAllConferences()
    }
//    func updateConference(id: String, trackId: String, author: String, summary: String) async throws{
//        let newConference = Conference(id:id, trackId: trackId, author: author, summary: summary)
//        try await ConferenceManager.shared.updateConference(Conference: newConference)
//    }
//
//    func deleteConference(id: String) async throws {
//        try await ConferenceManager.shared.deleteConference(ConferenceId: id)
//    }
//
//    func addComment(ConferenceId: String, userId: String, content: String) async throws {
//        try await ConferenceManager.shared.addComment(ConferenceId: ConferenceId, userId: userId, content: content)
//    }
}
