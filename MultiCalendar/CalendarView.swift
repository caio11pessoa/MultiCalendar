//
//  CalendarView.swift
//  MultiCalendar
//
//  Created by Caio de Almeida Pessoa on 25/08/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentMonth = Date.now
    @State private var selectedDate = Date.now
    @State private var selectedHour = Date.now
    @State private var days: [Date] = []
    
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var onDateSelected: (Date, Date) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Month navigation
            HStack {
                Text(currentMonth.formatted(.dateTime.year().month()))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
                    updateDays()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                Button {
                    currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
                    updateDays()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
            }
            
            // Days of the week row
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Grid of days
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(days, id: \.self) { day in
                    Button {
                        if day >= Date.now.startOfDay && day.monthInt == currentMonth.monthInt {
                            selectedDate = day
                            onDateSelected(selectedDate, selectedHour)
                        }
                    } label: {
                        Text(day.formatted(.dateTime.day()))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(foregroundStyle(for: day))
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        day.formattedDate == selectedDate.formattedDate
                                        ? .blue
                                        : .clear
                                    )
                            )
                    }
                    .disabled(day < Date.now.startOfDay || day.monthInt != currentMonth.monthInt)
                }
            }
            
            // Time picker
            DatePicker(
                "",
                selection: $selectedHour,
                displayedComponents: [.hourAndMinute]
            )
            .onChange(of: selectedHour) {
                onDateSelected(selectedDate, selectedHour)
            }
            .datePickerStyle(.compact)
            .datePickerStyle(GraphicalDatePickerStyle())
            .colorMultiply(.white)
            .environment(\.colorScheme, .dark)
        }
        .padding()
        .onAppear {
            updateDays()
            onDateSelected(selectedDate, selectedHour)
        }
    }
    
    private func updateDays() {
        days = currentMonth.calendarDisplayDays
    }
    
    private func foregroundStyle(for day: Date) -> Color {
        let isDifferentMonth = day.monthInt != currentMonth.monthInt
        let isSelectedDate = day.formattedDate == selectedDate.formattedDate
        let isPastDate = day < Date.now.startOfDay
        
        if isDifferentMonth {
            return isSelectedDate ? .black : .white.opacity(0.3)
        } else if isPastDate {
            return .white.opacity(0.3)
        } else {
            return isSelectedDate ? .black : .white
        }
    }
}

import Foundation

extension Date {
    static var firstDayOfWeek = Calendar.current.firstWeekday
    
    static var capitalizedFirstLettersOfWeekdays: [String] {
        let calendar = Calendar.current
        // Adjusted for the different weekday starts
        var weekdays = calendar.shortWeekdaySymbols
        if firstDayOfWeek > 1 {
            for _ in 1..<firstDayOfWeek {
                if let first = weekdays.first {
                    weekdays.append(first)
                    weekdays.removeFirst()
                }
            }
        }
        return weekdays.map { $0.capitalized }
    }
    
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }
    
    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
    var firstWeekDayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        var numberFromPreviousMonth = startOfMonthWeekday - Self.firstDayOfWeek
        if numberFromPreviousMonth < 0 {
            numberFromPreviousMonth += 7 // Adjust to a 0-6 range if negative
        }
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }
    
    var calendarDisplayDays: [Date] {
        var days: [Date] = []
        // Start with days from the previous month to fill the grid
        let firstDisplayDay = firstWeekDayBeforeStart
        var day = firstDisplayDay
        while day < startOfMonth {
            days.append(day)
            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
        }
        // Add days of the current month
        for dayOffset in 0..<numberOfDaysInMonth {
            if let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth) {
                days.append(newDay)
            }
        }
        return days
    }
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var hourInt: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minuteInt: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: self)
    }
    
    var formattedDateHourCombined: String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
}
