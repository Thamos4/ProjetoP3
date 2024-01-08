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
    @Published var conferences: [Conference] = [] {
        didSet{ Task { try await setAllConferences() } }
    }
    
    func createConference(name: String, beginDate: String, endDate: String, description: String) async throws {
        try await ConferenceManager.shared.createConference(name: name, beginDate: beginDate, endDate: endDate, description: description)
    }
    
    func setAllConferences() async throws {
        try await conferences = ConferenceManager.shared.getAllConferences()
    }
    
    func deleteConference(id: String) async throws {
        try await ConferenceManager.shared.deleteConference(id: id)
        conferences.removeAll(where: { $0.id == id })
    }
    
//    func updateConference(id: String, trackId: String, author: String, summary: String) async throws{
//        let newConference = Conference(id:id, trackId: trackId, author: author, summary: summary)
//        try await ConferenceManager.shared.updateConference(Conference: newConference)
//    }
//
//
//    func addComment(ConferenceId: String, userId: String, content: String) async throws {
//        try await ConferenceManager.shared.addComment(ConferenceId: ConferenceId, userId: userId, content: content)
//    }
}
