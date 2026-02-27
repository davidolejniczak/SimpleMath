import XCTest
import Combine
@testable import SimpleMath

final class GameViewModelTests: XCTestCase {

    private var vm: GameViewModel!

    override func setUp() {
        super.setUp()
        vm = GameViewModel()
        vm.settings.selectedOperations = [.addition]
        vm.settings.operand1Min = 5
        vm.settings.operand1Max = 5
        vm.settings.operand2Min = 3
        vm.settings.operand2Max = 3
        vm.settings.duration = 60
    }

    override func tearDown() {
        vm = nil
        super.tearDown()
    }

    // MARK: - startGame

    func testStartGameResetsState() {
        vm.score = 99
        vm.userInput = "old"
        vm.showWrongFeedback = true
        vm.startGame()

        XCTAssertEqual(vm.score, 0)
        XCTAssertEqual(vm.userInput, "")
        XCTAssertFalse(vm.showWrongFeedback)
        XCTAssertEqual(vm.timeRemaining, 60)
        XCTAssertEqual(vm.screen, .game)
    }

    func testStartGameGeneratesProblem() {
        vm.startGame()
        XCTAssertEqual(vm.currentProblem.operation, .addition)
        XCTAssertEqual(vm.currentProblem.answer, 8)
    }

    func testStartGameBlockedWhenNoOperationsSelected() {
        vm.settings.selectedOperations = []
        vm.startGame()
        XCTAssertEqual(vm.screen, .settings, "Should not start with no operations")
    }

    // MARK: - canStart

    func testCanStartTrueWithOperations() {
        vm.settings.selectedOperations = [.addition]
        XCTAssertTrue(vm.canStart)
    }

    func testCanStartFalseWithoutOperations() {
        vm.settings.selectedOperations = []
        XCTAssertFalse(vm.canStart)
    }

    // MARK: - submitAnswer — correct

    func testSubmitCorrectAnswer() {
        vm.startGame()
        vm.userInput = "8"
        vm.submitAnswer()

        XCTAssertEqual(vm.score, 1)
        XCTAssertFalse(vm.showWrongFeedback)
        XCTAssertEqual(vm.userInput, "")
    }

    func testSubmitCorrectAnswerGeneratesNewProblem() {
        vm.startGame()
        vm.userInput = "8"
        vm.submitAnswer()
        XCTAssertEqual(vm.score, 1)
    }

    // MARK: - submitAnswer — wrong

    func testSubmitWrongAnswer() {
        vm.startGame()
        vm.userInput = "999"
        vm.submitAnswer()

        XCTAssertEqual(vm.score, 0)
        XCTAssertTrue(vm.showWrongFeedback)
        XCTAssertEqual(vm.userInput, "")
    }

    func testSubmitWrongAnswerKeepsSameProblem() {
        vm.startGame()
        let before = vm.currentProblem.questionText
        vm.userInput = "0"
        vm.submitAnswer()
        XCTAssertEqual(vm.currentProblem.questionText, before)
    }

    // MARK: - submitAnswer — empty

    func testSubmitEmptyInput() {
        vm.startGame()
        vm.userInput = ""
        vm.submitAnswer()

        XCTAssertEqual(vm.score, 0)
        XCTAssertFalse(vm.showWrongFeedback)
    }

    func testSubmitWhitespaceOnly() {
        vm.startGame()
        vm.userInput = "   "
        vm.submitAnswer()

        XCTAssertEqual(vm.score, 0)
        XCTAssertFalse(vm.showWrongFeedback)
    }

    // MARK: - submitAnswer — non-numeric

    func testSubmitNonNumeric() {
        vm.startGame()
        vm.userInput = "abc"
        vm.submitAnswer()

        XCTAssertEqual(vm.score, 0)
        XCTAssertTrue(vm.showWrongFeedback)
    }

    // MARK: - submitAnswer — feedback clearing

    func testCorrectAnswerClearsPreviousWrongFeedback() {
        vm.startGame()
        vm.userInput = "999"
        vm.submitAnswer()
        XCTAssertTrue(vm.showWrongFeedback)

        vm.userInput = "8"
        vm.submitAnswer()
        XCTAssertFalse(vm.showWrongFeedback)
    }

    func testSubmitCorrectAnswerWithWhitespace() {
        vm.startGame()
        vm.userInput = "  8  "
        vm.submitAnswer()
        XCTAssertEqual(vm.score, 1)
    }

    // MARK: - tick

    func testTickDecrementsTime() {
        vm.startGame()
        let before = vm.timeRemaining
        vm.tick()
        XCTAssertEqual(vm.timeRemaining, before - 1)
        XCTAssertEqual(vm.screen, .game)
    }

    func testTickAtOneTransitionsToResults() {
        vm.startGame()
        vm.timeRemaining = 1
        vm.tick()
        XCTAssertEqual(vm.timeRemaining, 0)
        XCTAssertEqual(vm.screen, .results)
    }

    func testTickAtZeroDoesNothing() {
        vm.startGame()
        vm.timeRemaining = 0
        vm.screen = .game
        vm.tick()
        XCTAssertEqual(vm.timeRemaining, 0)
        XCTAssertEqual(vm.screen, .game)
    }

    func testMultipleTicksCountDown() {
        vm.settings.duration = 5
        vm.startGame()

        for expected in stride(from: 4, through: 1, by: -1) {
            vm.tick()
            XCTAssertEqual(vm.timeRemaining, expected)
        }
        vm.tick()
        XCTAssertEqual(vm.timeRemaining, 0)
        XCTAssertEqual(vm.screen, .results)
    }

    // MARK: - formattedTime

    func testFormattedTimeFullMinutes() {
        vm.timeRemaining = 120
        XCTAssertEqual(vm.formattedTime, "2:00")
    }

    func testFormattedTimeMinutesAndSeconds() {
        vm.timeRemaining = 65
        XCTAssertEqual(vm.formattedTime, "1:05")
    }

    func testFormattedTimeSecondsOnly() {
        vm.timeRemaining = 9
        XCTAssertEqual(vm.formattedTime, "0:09")
    }

    func testFormattedTimeZero() {
        vm.timeRemaining = 0
        XCTAssertEqual(vm.formattedTime, "0:00")
    }

    // MARK: - resetGame

    func testResetGameGoesBackToSettings() {
        vm.startGame()
        vm.resetGame()
        XCTAssertEqual(vm.screen, .settings)
    }

    func testResetGameStopsTimer() {
        vm.settings.duration = 10
        vm.startGame()
        vm.resetGame()

        let timeBefore = vm.timeRemaining
        let expectation = expectation(description: "Timer should not fire")
        expectation.isInverted = true
        waitForExpectations(timeout: 1.5)
        XCTAssertEqual(vm.timeRemaining, timeBefore)
    }

    // MARK: - Full lifecycle

    func testFullGameLifecycle() {
        XCTAssertEqual(vm.screen, .settings)

        vm.startGame()
        XCTAssertEqual(vm.screen, .game)

        vm.timeRemaining = 1
        vm.tick()
        XCTAssertEqual(vm.screen, .results)

        vm.resetGame()
        XCTAssertEqual(vm.screen, .settings)
    }

    func testInitialState() {
        let freshVM = GameViewModel()
        XCTAssertEqual(freshVM.screen, .settings)
        XCTAssertEqual(freshVM.score, 0)
        XCTAssertEqual(freshVM.timeRemaining, 0)
        XCTAssertEqual(freshVM.userInput, "")
        XCTAssertFalse(freshVM.showWrongFeedback)
    }

    // MARK: - Each operation

    func testSubmitCorrectSubtraction() {
        vm.settings.selectedOperations = [.subtraction]
        vm.startGame()
        vm.userInput = "2"
        vm.submitAnswer()
        XCTAssertEqual(vm.score, 1)
    }

    func testSubmitCorrectMultiplication() {
        vm.settings.selectedOperations = [.multiplication]
        vm.startGame()
        vm.userInput = "15"
        vm.submitAnswer()
        XCTAssertEqual(vm.score, 1)
    }

    func testSubmitCorrectDivision() {
        vm.settings.selectedOperations = [.division]
        vm.settings.operand1Min = 4
        vm.settings.operand1Max = 4
        vm.settings.operand2Min = 2
        vm.settings.operand2Max = 2
        vm.startGame()
        vm.userInput = "4"
        vm.submitAnswer()
        XCTAssertEqual(vm.score, 1)
    }

    func testMultipleCorrectAnswersAccumulate() {
        vm.startGame()
        for i in 1...5 {
            vm.userInput = "8"
            vm.submitAnswer()
            XCTAssertEqual(vm.score, i)
        }
    }
}
