import SwiftUI

struct ContentView: View {
    @StateObject private var audio = EchoAudioEngine()

    private let presetNames = [
        "Small Room", "Medium Room", "Large Room", "Medium Hall",
        "Large Hall", "Cathedral", "Plate", "Medium Chamber", "Large Chamber"
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(white: 0.91), Color(white: 0.72)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                header

                Text("✧  Effects")
                    .font(.system(size: 22, weight: .semibold))
                    .padding(.top, 4)

                Text("Audio Effects • Room Environment")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)

                Toggle("Enable Audio Effects", isOn: Binding(
                    get: { audio.isEnabled },
                    set: { $0 ? audio.start() : audio.stop() }
                ))
                .font(.system(size: 17, weight: .medium))
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Environment").font(.headline)
                            Text("Active Preset").font(.subheadline)
                            Picker("Environment", selection: Binding(
                                get: { audio.selectedPreset },
                                set: { audio.choose($0) }
                            )) {
                                ForEach(presetNames, id: \.self) { name in
                                    Text(name).tag(name)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 190)
                            .clipped()
                        }
                        .frame(maxWidth: .infinity)

                        VStack(alignment: .leading, spacing: 18) {
                            valueSlider("Effects Amount", value: Binding(
                                get: { audio.amount },
                                set: { audio.setAmount($0) }
                            ), range: 0...100, suffix: "%")

                            valueSlider("Delay", value: Binding(
                                get: { audio.delayMs },
                                set: { audio.setDelay($0) }
                            ), range: 0...800, suffix: " ms")

                            valueSlider("Feedback", value: Binding(
                                get: { audio.delayFeedback },
                                set: { audio.setFeedback($0) }
                            ), range: 0...70, suffix: "%")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                    }
                }
                .padding(16)
                .background(Color.white.opacity(0.55),
                            in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 12)

                HStack {
                    Button("Default") {
                        audio.choose("Large Chamber")
                        audio.setAmount(65)
                        audio.setDelay(240)
                        audio.setFeedback(28)
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()

                    Text("CREATIVE • EAX STYLE")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 20)

                Text(audio.status)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Text("هذا نموذج مستقل: يعالج المايك داخل التطبيق فقط، ولا يرسل الصوت إلى Discord.")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }
            .padding(.top, 8)
        }
        .preferredColorScheme(.light)
    }

    private func valueSlider(_ title: String, value: Binding<Double>,
                             range: ClosedRange<Double>, suffix: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title).font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(Int(value.wrappedValue))\(suffix)")
                    .font(.caption.monospacedDigit())
            }
            Slider(value: value, in: range)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("EAX")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.blue)
                Text("ADVANCED HD")
                    .font(.system(size: 10, weight: .bold))
            }
            Spacer()
            Text("Settings")
                .font(.system(size: 23, weight: .bold))
            Spacer()
            Text("iPad Audio")
                .font(.system(size: 14, weight: .medium))
                .padding(8)
                .background(.white.opacity(0.7),
                            in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(LinearGradient(colors: [.white, Color.gray.opacity(0.25)],
                                   startPoint: .top, endPoint: .bottom))
    }
}
