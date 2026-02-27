import XCTest
@testable import SimpleMath

final class ProblemGeneratorTests: XCTestCase {

    func testGenerateAddition() {
        var settings = GameSettings()
        settings.selectedOperations = [.addition]
        settings.operand1Min = 1
        settings.operand1Max = 50
        settings.operand2Min = 1
        settings.operand2Max = 50

        for _ in 0..<100 {
            let p = ProblemGenerator.generate(from: settings)
            XCTAssertEqual(p.operation, .addition)
            XCTAssertEqual(p.answer, p.operand1 + p.operand2)
            XCTAssertTrue(settings.operand1Range.contains(p.operand1))
            XCTAssertTrue(settings.operand2Range.contains(p.operand2))
        }
    }

    func testGenerateSubtractionNoSwap() {
        var settings = GameSettings()
        settings.selectedOperations = [.subtraction]
        settings.operand1Min = 50
        settings.operand1Max = 50
        settings.operand2Min = 10
        settings.operand2Max = 10

        let p = ProblemGenerator.generate(from: settings)
        XCTAssertEqual(p.operation, .subtraction)
        XCTAssertEqual(p.operand1, 50)
        XCTAssertEqual(p.operand2, 10)
        XCTAssertEqual(p.answer, 40)
    }

    func testGenerateSubtractionWithSwap() {
        var settings = GameSettings()
        settings.selectedOperations = [.subtraction]
        settings.operand1Min = 3
        settings.operand1Max = 3
        settings.operand2Min = 20
        settings.operand2Max = 20

        let p = ProblemGenerator.generate(from: settings)
        XCTAssertEqual(p.operand1, 20)
        XCTAssertEqual(p.operand2, 3)
        XCTAssertEqual(p.answer, 17)
    }

    func testGenerateSubtractionAlwaysNonNegative() {
        var settings = GameSettings()
        settings.selectedOperations = [.subtraction]
        settings.operand1Min = 1
        settings.operand1Max = 100
        settings.operand2Min = 1
        settings.operand2Max = 100

        for _ in 0..<200 {
            let p = ProblemGenerator.generate(from: settings)
            XCTAssertGreaterThanOrEqual(p.answer, 0)
            XCTAssertGreaterThanOrEqual(p.operand1, p.operand2)
        }
    }

    func testGenerateMultiplication() {
        var settings = GameSettings()
        settings.selectedOperations = [.multiplication]
        settings.operand1Min = 2
        settings.operand1Max = 12
        settings.operand2Min = 2
        settings.operand2Max = 12

        for _ in 0..<100 {
            let p = ProblemGenerator.generate(from: settings)
            XCTAssertEqual(p.operation, .multiplication)
            XCTAssertEqual(p.answer, p.operand1 * p.operand2)
        }
    }

    func testGenerateDivisionIntegerAnswer() {
        var settings = GameSettings()
        settings.selectedOperations = [.division]
        settings.operand1Min = 1
        settings.operand1Max = 12
        settings.operand2Min = 1
        settings.operand2Max = 12

        for _ in 0..<200 {
            let p = ProblemGenerator.generate(from: settings)
            XCTAssertEqual(p.operation, .division)
            XCTAssertEqual(p.operand1 % p.operand2, 0)
            XCTAssertEqual(p.answer, p.operand1 / p.operand2)
            XCTAssertGreaterThanOrEqual(p.operand2, 1)
        }
    }

    func testGenerateDivisionWithZeroInRange() {
        var settings = GameSettings()
        settings.selectedOperations = [.division]
        settings.operand1Min = 1
        settings.operand1Max = 10
        settings.operand2Min = 0
        settings.operand2Max = 0

        for _ in 0..<50 {
            let p = ProblemGenerator.generate(from: settings)
            XCTAssertGreaterThanOrEqual(p.operand2, 1)
        }
    }

    func testGenerateDivisionSafeRange() {
        var settings = GameSettings()
        settings.selectedOperations = [.division]
        settings.operand1Min = 2
        settings.operand1Max = 5
        settings.operand2Min = 3
        settings.operand2Max = 6

        for _ in 0..<100 {
            let p = ProblemGenerator.generate(from: settings)
            XCTAssertTrue((3...6).contains(p.operand2))
        }
    }

    func testGenerateDivisionWithNegativeRange() {
        var settings = GameSettings()
        settings.selectedOperations = [.division]
        settings.operand1Min = 1
        settings.operand1Max = 5
        settings.operand2Min = -5
        settings.operand2Max = -1

        for _ in 0..<50 {
            let p = ProblemGenerator.generate(from: settings)
            XCTAssertGreaterThanOrEqual(p.operand2, 1)
        }
    }

    func testGenerateRoutesToCorrectSingleOperation() {
        for op in Operation.allCases {
            var settings = GameSettings()
            settings.selectedOperations = [op]
            settings.operand1Min = 2
            settings.operand1Max = 10
            settings.operand2Min = 2
            settings.operand2Max = 10
            let p = ProblemGenerator.generate(from: settings)
            XCTAssertEqual(p.operation, op)
        }
    }

    func testGenerateWithMultipleOperations() {
        var settings = GameSettings()
        settings.selectedOperations = [.addition, .subtraction, .multiplication, .division]
        settings.operand1Min = 2
        settings.operand1Max = 10
        settings.operand2Min = 2
        settings.operand2Max = 10

        var seenOps = Set<Operation>()
        for _ in 0..<500 {
            let p = ProblemGenerator.generate(from: settings)
            seenOps.insert(p.operation)
        }
        XCTAssertEqual(seenOps.count, 4, "All 4 operations should appear when all are selected")
    }

    func testGenerateWithEmptyOperationsFallsBackToAddition() {
        var settings = GameSettings()
        settings.selectedOperations = []
        settings.operand1Min = 5
        settings.operand1Max = 5
        settings.operand2Min = 3
        settings.operand2Max = 3

        let p = ProblemGenerator.generate(from: settings)
        XCTAssertEqual(p.operation, .addition)
        XCTAssertEqual(p.answer, 8)
    }
}
