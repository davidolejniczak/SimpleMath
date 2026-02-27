import Foundation

enum Formatters {

    static func durationLabel(_ seconds: Int) -> String {
        if seconds < 60 { return "\(seconds)s" }
        let m = seconds / 60
        let s = seconds % 60
        return s == 0 ? "\(m)m" : "\(m)m \(s)s"
    }

    static func accessibleQuestion(for problem: Problem) -> String {
        let opWord: String
        switch problem.operation {
        case .addition:       opWord = "plus"
        case .subtraction:    opWord = "minus"
        case .multiplication: opWord = "times"
        case .division:       opWord = "divided by"
        }
        return "\(problem.operand1) \(opWord) \(problem.operand2) equals?"
    }
}
