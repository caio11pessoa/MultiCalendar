//
//  MultiCalendarViewModel.swift
//  MultiCalendar
//
//  Created by Caio de Almeida Pessoa on 25/08/25.
//

import SwiftUI

@Observable
class MultiCalendarViewModel {
    var currentMonth = Date.now
    var selectedDate = Date.now
    var selectedHour = Date.now
    var days: [Date] = []
}
