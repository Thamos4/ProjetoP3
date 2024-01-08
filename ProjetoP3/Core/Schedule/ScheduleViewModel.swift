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

    func createSchedule(name: String, beginDate: String, endDate: String, description: String) async throws {
        try await ScheduleManager.shared.createSchedule()
    }

    func setAllSchedules() async throws {
        try await schedules = ScheduleManager.shared.getAllSchedules()
    }

    func updateSchedule(id: String, name: String, beginDate: String, endDate: String, description: String) async throws{
        let newSchedule = Schedule()
        try await ScheduleManager.shared.updateSchedule(schedule: newSchedule)
    }

    func deleteSchedule(id: String) async throws {
        try await ScheduleManager.shared.deleteSchedule(scheduleId: id)
        schedules.removeAll(where: {$0.id == id})
    }
}
