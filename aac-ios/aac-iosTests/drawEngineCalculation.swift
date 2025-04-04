//
//  drawEngineCalculation.swift
//  aac-iosTests
//
//  Created by Joannaye on 2023/12/3.
//

import XCTest
@testable import aac_ios

final class drawEngineCalculation: XCTestCase {

    func testSuccessfulMidPointCalculation() {
        // Given (arrange)
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 2, y: 2)
        let expectedMidPoint = CGPoint(x: 1, y: 1)

        // When (act)
        let engine = DrawingEngine()
        let midPoint = engine.calculateMidPoint(point1, point2)

        // Then (assert)
        XCTAssertEqual(expectedMidPoint, midPoint, "The midpoint calculation is incorrect.")
    }

}
