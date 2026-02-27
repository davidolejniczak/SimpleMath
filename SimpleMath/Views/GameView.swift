import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @FocusState private var inputFocused: Bool

    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Label(viewModel.formattedTime, systemImage: "timer")
                    .font(.title.monospacedDigit())
                    .foregroundStyle(viewModel.timeRemaining <= 10 ? .red : .primary)

                Spacer()

                Label("\(viewModel.score)", systemImage: "checkmark.circle.fill")
                    .font(.title.monospacedDigit())
                    .foregroundStyle(.green)
            }
            .padding(.horizontal)

            Spacer()

            Text(viewModel.currentProblem.questionText + " = ?")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .accessibilityLabel(Formatters.accessibleQuestion(for: viewModel.currentProblem))

            TextField("Answer", text: $viewModel.userInput)
                .keyboardType(.numberPad)
                .font(.system(size: 36, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
                .focused($inputFocused)
                .onChange(of: viewModel.userInput) {
                    viewModel.checkAnswer()
                }

            Spacer()
        }
        .padding()
        .onAppear {
            inputFocused = true
        }
    }

}
