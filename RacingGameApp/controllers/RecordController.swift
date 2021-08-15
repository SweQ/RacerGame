//
//  RecordController.swift
//  RacingGameApp
//
//  Created by alexKoro on 6/13/21.
//

import Foundation

class RecordController {
    static let shared = RecordController()
    private let userDefault = UserDefaults.standard
    private var records: [Record] = []
    private init() {
    }

    func addRecord(record: Record) {
        loadRecords()
        records.append(record)
        saveRecords()
    }

    private func saveRecords() {
        guard let data = try? JSONEncoder().encode(records) else {return}
        userDefault.setValue(data, forKey: .records)
    }

    func getRecords() -> [Record] {
        loadRecords()
        if records.count > 0 {
            return records.sorted { $0.score > $1.score }
        } else {
            return [Record]()
        }
    }

    private func loadRecords() {
        print("load records")
        let data = userDefault.value(forKey: .records) as? Data
        guard data != nil, let loadRecords = try? JSONDecoder().decode([Record].self, from: data!) else { return }
        self.records = loadRecords

        print("Records: \(records)")
    }

    func getRecordString(record: Record) -> String {
        var result = ""
        let date = Calendar.current.dateComponents([.year, .month, .day], from: record.date)
        result.append(record.playerName)
        result.append(" score: \(record.score)")
        if date.year != nil, date.month != nil, date.day != nil {
            result.append(" \(date.year!)-\(date.month!)-\(date.day!)")
        }
        return result
    }
}
