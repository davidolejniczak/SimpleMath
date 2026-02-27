import XCTest
@testable import SimpleMath

final class ProblemTests: XCTestCase {

    func testQuestionTextAddition() {
        let p = Problem(operand1: 34, operand2: 27, operation: .addition, answer: 61)
        XCTAssertEqual(p.questionText, "34 + 27")
    }

    func testQuestionTextSubtraction() {
        let p = Problem(operand1: 50, operand2: 13, operation: .subtraction, answer: 37)
        XCTAssertEqual(p.questionText, "50 − 13")
    }

    func testQuestionTextMultiplication() {
        let p = Problem(operand1: 8, operand2: 7, operation: .multiplication, answer: 56)
        XCTAssertEqual(p.questionText, "8 × 7")
    }

    func testQuestionTextDivision() {
        let p = Problem(operand1: 42, operand2: 6, operation: .division, answer: 7)
        XCTAssertEqual(p.questionText, "42 ÷ 6")
    }

    func testStoredProperties() {
        let p = Problem(operand1: 10, operand2: 3, operation: .multiplication, answer: 30)
        XCTAssertEqual(p.operand1, 10)
        XCTAssertEqual(p.operand2, 3)
        XCTAssertEqual(p.operation, .multiplication)
        XCTAssertEqual(p.answer, 30)
    }
}
