//
//  HapticService.swift
//  Shapely
//
//  Created by Andrew on 28.03.2023.
//

import CoreHaptics

final class HapticService {
    private var engine: CHHapticEngine?

    init() {
        do {
            // Create a haptic engine
            engine = try CHHapticEngine()

            // Start the engine
            try engine?.start()
        } catch {
            print("Error creating haptic engine: \(error.localizedDescription)")
        }
    }

    func playHaptic(intensity: Float, sharpness: Float) {
        // Create a haptic pattern
        guard let pattern = createHapticPattern(intensity: intensity, sharpness: sharpness) else { return }

        do {
            // Create a haptic player
            let player = try engine?.makePlayer(with: pattern)

            // Start playing the haptic pattern
            try player?.start(atTime: 0)
        } catch {
            print("Error playing haptic pattern: \(error.localizedDescription)")
        }
    }

    private func createHapticPattern(intensity: Float, sharpness: Float) -> CHHapticPattern? {
        // Create a continuous haptic event with the specified intensity and sharpness
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        ], relativeTime: 0, duration: 1)

        // Create a haptic pattern with the event
        return try? CHHapticPattern(events: [event], parameters: [])
    }
}
