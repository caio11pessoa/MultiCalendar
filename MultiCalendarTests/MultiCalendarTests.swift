//
//  MultiCalendarTests.swift
//  MultiCalendarTests
//
//  Created by Caio de Almeida Pessoa on 20/08/25.
//

import XCTest
@testable import MultiCalendar

final class MultiCalendarTests: XCTestCase {
    
    var viewModel: MultiCalendarViewModel!


    override func setUpWithError() throws {
        viewModel = MultiCalendarViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testInitialValues() throws {
        XCTAssertNotNil(viewModel.currentMonth)
        XCTAssertNotNil(viewModel.selectedDate)
        XCTAssertNotNil(viewModel.selectedHour)
        XCTAssertTrue(viewModel.days.isEmpty, "Days array should be empty on initialization")
    }

    func testUpdateDaysPopulatesDaysArray() throws {
        XCTAssertTrue(viewModel.days.isEmpty, "Days array should start empty")
        viewModel.updateDays()
        XCTAssertFalse(viewModel.days.isEmpty, "Days array should be populated after updateDays()")
    }

}
