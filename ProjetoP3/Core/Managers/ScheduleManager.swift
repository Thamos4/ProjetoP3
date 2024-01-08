//
//  ScheduleManager.swift
//  ProjetoP3
//
//  Created by Aluno ISTEC on 08/01/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class ScheduleManager{
    
    static let shared = ScheduleManager()
    private init() { }
    
    private let schedulesCollection = Firestore.firestore().collection("schedules")
    
    private func scheduleDocument(scheduleId: String) -> DocumentReference {
        schedulesCollection.document(scheduleId)
    }
    
    func createSchedule (trackId: String, articleId: String, roomId: String, time: String) async throws{
        let newScheduleRef = schedulesCollection.document()
        let id = newScheduleRef.documentID
        let newSchedule = Schedule(id: id, trackId: trackId, articleId: articleId, roomId: roomId, time: time)
        try newScheduleRef.setData(from: newSchedule)
    }
    
    func getSchedule(scheduleId: String) async throws -> Schedule{
        try await scheduleDocument(scheduleId: scheduleId).getDocument(as: Schedule.self)
    }
    
    func updateSchedule(schedule: Schedule) async throws {
        try scheduleDocument(scheduleId: schedule.id).setData(from: schedule, merge: true)
    }
    
    func getAllSchedules() async throws -> [Schedule]{
        try await schedulesCollection.getDocuments(as: Schedule.self)
    }
    
    func deleteSchedule(scheduleId: String) async throws -> Void{
        do{
            try await scheduleDocument(scheduleId: scheduleId).delete()
        }catch{
            print("DEBUG: Made an oopsie deleting schedule u.u")
        }
    }
    
    func getAllSchedulesForConferenceId(conferenceId: String) async throws -> [Schedule]{
        try await schedulesCollection.whereField("conferenceId", isEqualTo: conferenceId).getDocuments(as: Schedule.self)
    }
}
