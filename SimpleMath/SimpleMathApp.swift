import SwiftUI

@main
struct SimpleMathApp: App {
    @StateObject private var viewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                switch viewModel.screen {
                case .settings:
                    SettingsView(viewModel: viewModel)
                case .game:
                    GameView(viewModel: viewModel)
                case .results:
                    ResultsView(viewModel: viewModel)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: viewModel.screen)
        }
    }
}
