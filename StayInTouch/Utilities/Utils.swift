//
//  utils.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 5/29/23.
//

import Foundation

func getFirstDayOfTheWeek() -> Date {
    let calendar = Calendar.current
    let now = Date()

    var startOfWeekComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
    startOfWeekComponents.hour = 0
    startOfWeekComponents.minute = 0
    return calendar.date(from: startOfWeekComponents) ?? now
}

func getFirstDayOfTheMonth() -> Date {
    let calendar = Calendar.current
    let now = Date()
    var startOfMonthComponents = calendar.dateComponents([.year, .month], from: now)
    startOfMonthComponents.day = 1
    startOfMonthComponents.hour = 0
    startOfMonthComponents.minute = 0
    return calendar.date(from: startOfMonthComponents) ?? now
}

func getFirstDayOfTheYear() -> Date {
    let calendar = Calendar.current
    let now = Date()

    var startOfYearComponents = calendar.dateComponents([.year], from: now)
    startOfYearComponents.month = 1
    startOfYearComponents.day = 1
    startOfYearComponents.hour = 0
    startOfYearComponents.minute = 0
    return calendar.date(from: startOfYearComponents) ?? now
}

func getMinDate() -> Date {
    let now = Date()

    var minDateComponents = DateComponents()
    minDateComponents.year = 1
    minDateComponents.month = 1
    minDateComponents.day = 1
    minDateComponents.hour = 0
    minDateComponents.minute = 0
    minDateComponents.second = 0

    return Calendar.current.date(from: minDateComponents) ?? now
}
