import XCTest
@testable import SimpleMath

final class FormattersTests: XCTestCase {

    func testDurationLabelUnderOneMinute() {
        XCTAssertEqual(Formatters.durationLabel(30), "30s")
    }

    func testDurationLabelOneSecond() {
        XCTAssertEqual(Formatters.durationLabel(1), "1s")
    }

    func testDurationLabelZero() {
        XCTAssertEqual(Formatters.durationLabel(0), "0s")
    }

    func testDurationLabelExactMinutes() {
        XCTAssertEqual(Formatters.durationLabel(60), "1m")
        XCTAssertEqual(Formatters.durationLabel(120), "2m")
        XCTAssertEqual(Formatters.durationLabel(300), "5m")
    }

    func testDurationLabelMinutesAndSeconds() {
        XCTAssertEqual(Formatters.durationLabel(90), "1m 30s")
        XCTAssertEqual(Formatters.durationLabel(61), "1m 1s")
    }

    func testAccessibleQuestionAddition() {
        let p = Problem(operand1: 5, operand2: 3, operation: .addition, answer: 8)
        XCTAssertEqual(Formatters.accessibleQuestion(for: p), "5 plus 3 equals?")
    }

    func testAccessibleQuestionSubtraction() {
        let p = Problem(operand1: 10, operand2: 4, operation: .subtraction, answer: 6)
        XCTAssertEqual(Formatters.accessibleQuestion(for: p), "10 minus 4 equals?")
    }

    func testAccessibleQuestionMultiplication() {
        let p = Problem(operand1: 7, operand2: 8, operation: .multiplication, answer: 56)
        XCTAssertEqual(Formatters.accessibleQuestion(for: p), "7 times 8 equals?")
    }

    func testAccessibleQuestionDivision() {
        let p = Problem(operand1: 42, operand2: 6, operation: .division, answer: 7)
        XCTAssertEqual(Formatters.accessibleQuestion(for: p), "42 divided by 6 equals?")
    }
}
