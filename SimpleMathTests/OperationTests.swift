import XCTest
@testable import SimpleMath

final class OperationTests: XCTestCase {

    func testSymbolAddition() {
        XCTAssertEqual(Operation.addition.symbol, "+")
    }

    func testSymbolSubtraction() {
        XCTAssertEqual(Operation.subtraction.symbol, "−")
    }

    func testSymbolMultiplication() {
        XCTAssertEqual(Operation.multiplication.symbol, "×")
    }

    func testSymbolDivision() {
        XCTAssertEqual(Operation.division.symbol, "÷")
    }

    func testDisplayNameAddition() {
        XCTAssertEqual(Operation.addition.displayName, "Addition")
    }

    func testDisplayNameSubtraction() {
        XCTAssertEqual(Operation.subtraction.displayName, "Subtraction")
    }

    func testDisplayNameMultiplication() {
        XCTAssertEqual(Operation.multiplication.displayName, "Multiplication")
    }

    func testDisplayNameDivision() {
        XCTAssertEqual(Operation.division.displayName, "Division")
    }

    func testIdReturnsRawValue() {
        for op in Operation.allCases {
            XCTAssertEqual(op.id, op.rawValue)
        }
    }

    func testAllCasesContainsFourOperations() {
        XCTAssertEqual(Operation.allCases.count, 4)
    }

    func testRawValueRoundTrip() {
        for op in Operation.allCases {
            XCTAssertEqual(Operation(rawValue: op.rawValue), op)
        }
    }
}
