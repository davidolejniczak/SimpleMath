import Foundation

struct ProblemGenerator {

    static func generate(from settings: GameSettings) -> Problem {
        switch settings.operation {
        case .addition:
            return generateAddition(settings)
        case .subtraction:
            return generateSubtraction(settings)
        case .multiplication:
            return generateMultiplication(settings)
        case .division:
            return generateDivision(settings)
        }
    }

    private static func generateAddition(_ s: GameSettings) -> Problem {
        let a = Int.random(in: s.operand1Range)
        let b = Int.random(in: s.operand2Range)
        return Problem(operand1: a, operand2: b, operation: .addition, answer: a + b)
    }

    private static func generateSubtraction(_ s: GameSettings) -> Problem {
        var a = Int.random(in: s.operand1Range)
        var b = Int.random(in: s.operand2Range)
        if a < b { swap(&a, &b) }
        return Problem(operand1: a, operand2: b, operation: .subtraction, answer: a - b)
    }

    private static func generateMultiplication(_ s: GameSettings) -> Problem {
        let a = Int.random(in: s.operand1Range)
        let b = Int.random(in: s.operand2Range)
        return Problem(operand1: a, operand2: b, operation: .multiplication, answer: a * b)
    }

    /// Picks a divisor and quotient from the ranges, then presents dividend ÷ divisor = ?
    private static func generateDivision(_ s: GameSettings) -> Problem {
        let safeRange2 = max(s.operand2Range.lowerBound, 1)...max(s.operand2Range.upperBound, 1)
        let divisor = Int.random(in: safeRange2)
        let quotient = Int.random(in: s.operand1Range)
        let dividend = divisor * quotient
        return Problem(operand1: dividend, operand2: divisor, operation: .division, answer: quotient)
    }
}
