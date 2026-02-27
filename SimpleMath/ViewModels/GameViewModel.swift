import Foundation
import Combine

enum Screen {
    case settings
    case game
    case results
}

class GameViewModel: ObservableObject {

    // MARK: - Navigation

    @Published var screen: Screen = .settings

    // MARK: - Settings (bound from SettingsView)

    @Published var settings = GameSettings()

    // MARK: - Game state

    @Published var currentProblem: Problem = Problem(operand1: 0, operand2: 0, operation: .addition, answer: 0)
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var userInput: String = ""

    private var timerCancellable: AnyCancellable?

    // MARK: - Actions

    func startGame() {
        score = 0
        timeRemaining = settings.duration
        userInput = ""
        currentProblem = ProblemGenerator.generate(from: settings)
        screen = .game
        startTimer()
    }

    func checkAnswer() {
        guard screen == .game else { return }
        let trimmed = userInput.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let value = Int(trimmed) else { return }

        if value == currentProblem.answer {
            score += 1
            currentProblem = ProblemGenerator.generate(from: settings)
            userInput = ""
        }
    }

    func resetGame() {
        stopTimer()
        screen = .settings
    }

    // MARK: - Timer

    func tick() {
        guard timeRemaining > 0 else { return }
        timeRemaining -= 1
        if timeRemaining == 0 {
            stopTimer()
            screen = .results
        }
    }

    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
