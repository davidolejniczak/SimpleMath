import Foundation

struct GameSettings {
    var selectedOperations: Set<Operation> = [.addition]
    var operand1Min: Int = 1
    var operand1Max: Int = 100
    var operand2Min: Int = 1
    var operand2Max: Int = 15
    var duration: Int = 120

    var operand1Range: ClosedRange<Int> {
        min(operand1Min, operand1Max)...max(operand1Min, operand1Max)
    }

    var operand2Range: ClosedRange<Int> {
        min(operand2Min, operand2Max)...max(operand2Min, operand2Max)
    }
}
