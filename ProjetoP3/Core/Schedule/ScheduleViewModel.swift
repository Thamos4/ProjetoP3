//
//  ScheduleViewModel.swift
//  ProjetoP3
//
//  Created by Aluno ISTEC on 08/01/2024.
//

import SwiftUI

import Foundation

@MainActor
class ScheduleViewModel: ObservableObject{
    @Published var schedules: [Schedule] = []{
        didSet{ Task { try await setAllSchedules()}}
    }

    func createSchedule(name: String, trackId: String, articleId: String, roomId: String, time: String) async throws {
        try await ScheduleManager.shared.createSchedule(trackId: trackId, articleId: articleId, roomId: roomId, time: time)
    }

    func setAllSchedules() async throws {
        try await schedules = ScheduleManager.shared.getAllSchedules()
    }

    func updateSchedule(id: String, trackId: String, articleId: String, roomId: String, time: String) async throws{
        let newSchedule = Schedule(id: id, trackId: trackId, articleId: articleId, roomId: roomId, time: time)
        try await ScheduleManager.shared.updateSchedule(schedule: newSchedule)
    }

    func deleteSchedule(id: String) async throws {
        try await ScheduleManager.shared.deleteSchedule(scheduleId: id)
        schedules.removeAll(where: {$0.id == id})
    }
}
