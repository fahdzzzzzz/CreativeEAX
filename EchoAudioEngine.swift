import AVFoundation
import Combine
import Foundation

@MainActor
final class EchoAudioEngine: ObservableObject {
    @Published var isEnabled = false
    @Published var amount: Double = 65
    @Published var delayMs: Double = 240
    @Published var delayFeedback: Double = 28
    @Published var selectedPreset = "Haunted Cavern"
    @Published var status = "جاهز"

    private let engine = AVAudioEngine()
    private let reverb = AVAudioUnitReverb()
    private let delay = AVAudioUnitDelay()
    private var configured = false

    let presets: [String: AVAudioUnitReverbPreset] = [
        "Small Room": .smallRoom,
        "Medium Room": .mediumRoom,
        "Large Room": .largeRoom,
        "Medium Hall": .mediumHall,
        "Large Hall": .largeHall,
        "Cathedral": .cathedral,
        "Plate": .plate,
        "Medium Chamber": .mediumChamber,
        "Large Chamber": .largeChamber
    ]

    func start() {
        guard !isEnabled else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord,
                                    mode: .default,
                                    options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)

            if !configured {
                let input = engine.inputNode
                let format = input.outputFormat(forBus: 0)

                engine.attach(delay)
                engine.attach(reverb)

                // Microphone -> delay -> room reverb -> app output.
                engine.connect(input, to: delay, format: format)
                engine.connect(delay, to: reverb, format: format)
                engine.connect(reverb, to: engine.mainMixerNode, format: format)
                configured = true
            }

            applySettings()
            try engine.start()
            isEnabled = true
            status = "المؤثر يعمل داخل التطبيق"
        } catch {
            status = "تعذر تشغيل الصوت: \(error.localizedDescription)"
        }
    }

    func stop() {
        engine.stop()
        isEnabled = false
        status = "متوقف"
    }

    func choose(_ name: String) {
        guard presets[name] != nil else { return }
        selectedPreset = name
        if isEnabled { applySettings() }
    }

    func setAmount(_ value: Double) {
        amount = min(max(value, 0), 100)
        if isEnabled { applySettings() }
    }

    func setDelay(_ value: Double) {
        delayMs = min(max(value, 0), 800)
        if isEnabled { applySettings() }
    }

    func setFeedback(_ value: Double) {
        delayFeedback = min(max(value, 0), 70)
        if isEnabled { applySettings() }
    }

    private func applySettings() {
        guard let preset = presets[selectedPreset] else { return }
        reverb.loadFactoryPreset(preset)
        reverb.wetDryMix = Float(amount)

        delay.delayTime = delayMs / 1000.0
        delay.feedback = Float(delayFeedback)
        delay.lowPassCutoff = 6500
        delay.wetDryMix = delayMs == 0 ? 0 : 28
    }
}
