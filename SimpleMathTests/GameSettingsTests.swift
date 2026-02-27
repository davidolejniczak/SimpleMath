import XCTest
@testable import SimpleMath

final class GameSettingsTests: XCTestCase {

    func testDefaultValues() {
        let s = GameSettings()
        XCTAssertEqual(s.selectedOperations, [.addition])
        XCTAssertEqual(s.operand1Min, 1)
        XCTAssertEqual(s.operand1Max, 100)
        XCTAssertEqual(s.operand2Min, 1)
        XCTAssertEqual(s.operand2Max, 100)
        XCTAssertEqual(s.duration, 120)
    }

    func testOperand1RangeNormalOrder() {
        var s = GameSettings()
        s.operand1Min = 5
        s.operand1Max = 20
        XCTAssertEqual(s.operand1Range, 5...20)
    }

    func testOperand1RangeReversedOrder() {
        var s = GameSettings()
        s.operand1Min = 50
        s.operand1Max = 10
        XCTAssertEqual(s.operand1Range, 10...50)
    }

    func testOperand1RangeEqualMinMax() {
        var s = GameSettings()
        s.operand1Min = 7
        s.operand1Max = 7
        XCTAssertEqual(s.operand1Range, 7...7)
    }

    func testOperand2RangeNormalOrder() {
        var s = GameSettings()
        s.operand2Min = 3
        s.operand2Max = 12
        XCTAssertEqual(s.operand2Range, 3...12)
    }

    func testOperand2RangeReversedOrder() {
        var s = GameSettings()
        s.operand2Min = 99
        s.operand2Max = 1
        XCTAssertEqual(s.operand2Range, 1...99)
    }

    func testOperand2RangeEqualMinMax() {
        var s = GameSettings()
        s.operand2Min = 15
        s.operand2Max = 15
        XCTAssertEqual(s.operand2Range, 15...15)
    }

    func testSelectedOperationsCanHoldMultiple() {
        var s = GameSettings()
        s.selectedOperations = [.addition, .subtraction, .multiplication, .division]
        XCTAssertEqual(s.selectedOperations.count, 4)
    }

    func testSelectedOperationsCanBeEmpty() {
        var s = GameSettings()
        s.selectedOperations = []
        XCTAssertTrue(s.selectedOperations.isEmpty)
    }
}
