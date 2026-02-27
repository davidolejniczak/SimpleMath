import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: GameViewModel

    private let durations = [30, 60, 120, 180, 300]

    var body: some View {
        NavigationStack {
            Form {
                Section("Operations") {
                    ForEach(Operation.allCases) { op in
                        Toggle(isOn: Binding(
                            get: { viewModel.settings.selectedOperations.contains(op) },
                            set: { isOn in
                                if isOn {
                                    viewModel.settings.selectedOperations.insert(op)
                                } else if viewModel.settings.selectedOperations.count > 1 {
                                    viewModel.settings.selectedOperations.remove(op)
                                }
                            }
                        )) {
                            Label(op.displayName, systemImage: "number")
                        }
                    }
                }

                Section("First Number Range") {
                    HStack {
                        Text("Min")
                            .frame(width: 40, alignment: .leading)
                        TextField("Min", value: $viewModel.settings.operand1Min, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("Max")
                            .frame(width: 40, alignment: .leading)
                        TextField("Max", value: $viewModel.settings.operand1Max, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                Section("Second Number Range") {
                    HStack {
                        Text("Min")
                            .frame(width: 40, alignment: .leading)
                        TextField("Min", value: $viewModel.settings.operand2Min, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("Max")
                            .frame(width: 40, alignment: .leading)
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
            .scrollDismissesKeyboard(.interactively)
        }
    }

}
