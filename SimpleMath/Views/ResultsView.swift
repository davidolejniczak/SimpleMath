import SwiftUI

struct ResultsView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "trophy.fill")
                .font(.system(size: 72))
                .foregroundStyle(.yellow)

            Text("Time's Up!")
                .font(.largeTitle.bold())

            Text("\(viewModel.score)")
                .font(.system(size: 80, weight: .heavy, design: .rounded))
                .foregroundStyle(.primary)

            Text("correct answers")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("Duration: \(Formatters.durationLabel(viewModel.settings.duration))")
                .font(.headline)
                .foregroundStyle(.secondary)

            Spacer()

            Button(action: { viewModel.resetGame() }) {
                Text("Play Again")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }

}
