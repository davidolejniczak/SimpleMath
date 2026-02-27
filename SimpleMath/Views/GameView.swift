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
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Submit") {
                            viewModel.submitAnswer()
                        }
                        .fontWeight(.semibold)
                    }
                }

            if viewModel.showWrongFeedback {
                Text("Wrong — try again!")
                    .font(.headline)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }

            Button(action: { viewModel.submitAnswer() }) {
                Text("Submit")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
        .onAppear {
            inputFocused = true
        }
        .animation(.easeInOut(duration: 0.15), value: viewModel.showWrongFeedback)
    }

}
