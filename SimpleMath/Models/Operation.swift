import Foundation

enum Operation: String, CaseIterable, Identifiable {
    case addition
    case subtraction
    case multiplication
    case division

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .addition:       return "+"
        case .subtraction:    return "−"
        case .multiplication: return "×"
        case .division:       return "÷"
        }
    }

    var displayName: String {
        switch self {
        case .addition:       return "Addition"
        case .subtraction:    return "Subtraction"
        case .multiplication: return "Multiplication"
        case .division:       return "Division"
        }
    }
}
