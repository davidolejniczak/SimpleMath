import Foundation

struct Problem {
    let operand1: Int
    let operand2: Int
    let operation: Operation
    let answer: Int

    var questionText: String {
        "\(operand1) \(operation.symbol) \(operand2)"
    }
}
