import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: GameViewModel

    private let durations = [30, 60, 120, 180, 300]

    var body: some View {
        NavigationStack {
            Form {
                Section("Operation") {
                    Picker("Operation", selection: $viewModel.settings.operation) {
                        ForEach(Operation.allCases) { op in
                            Text(op.symbol).tag(op)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(viewModel.settings.operation.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section("First Number Range") {
                    HStack {
                        Text("Min")
                        TextField("Min", value: $viewModel.settings.operand1Min, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        Text("Max")
                        TextField("Max", value: $viewModel.settings.operand1Max, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                Section("Second Number Range") {
                    HStack {
                        Text("Min")
                        TextField("Min", value: $viewModel.settings.operand2Min, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        Text("Max")
                        TextField("Max", value: $viewModel.settings.operand2Max, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                Section("Duration") {
                    Picker("Duration", selection: $viewModel.settings.duration) {
                        ForEach(durations, id: \.self) { d in
                            Text(Formatters.durationLabel(d)).tag(d)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Button(action: { viewModel.startGame() }) {
                        Text("Start")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .navigationTitle("SimpleMath")
        }
    }

}
