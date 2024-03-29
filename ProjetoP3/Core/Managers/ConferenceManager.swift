//
//  ConferenceManager.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class ConferenceManager {
    static let shared = ConferenceManager()
    private init() { }

    private let conferencesCollection = Firestore.firestore().collection("conferences")
    
    private func conferenceDocument(conferenceId: String) -> DocumentReference {
        conferencesCollection.document(conferenceId)
    }
    
    func createConference (name: String, beginDate: String, endDate: String, description: String) async throws{
        let newConferenceRef = conferencesCollection.document()
        let id = newConferenceRef.documentID
        let newConference = Conference(id: id, name: name, beginDate: beginDate, endDate: endDate, description: description)
        try newConferenceRef.setData(from: newConference)
    }
    
    func updateConference(conference: Conference) async throws {
        try conferenceDocument(conferenceId: conference.id).setData(from: conference, merge: true)
    }
    
    func getAllConferences() async throws -> [Conference]{
        try await conferencesCollection.getDocuments(as: Conference.self)
    }
    
    func deleteConference(conferenceId: String) async throws{
        do{
            try await conferenceDocument(conferenceId: conferenceId).delete()
        }catch{
            print("DEBUG: Made an oopsie deleting conference u.u")
        }
    }
}


