import SwiftUI
import CoreMotion

struct SensorsView: View {
    @State private var motionManager = CMMotionManager()

    @State private var accel = CMAcceleration(x: 0, y: 0, z: 0)
    @State private var gyro = CMRotationRate(x: 0, y: 0, z: 0)
    @State private var magnetic = CMMagneticField(x: 0, y: 0, z: 0)

    @State private var accelAvailable = false
    @State private var gyroAvailable = false
    @State private var magnetAvailable = false

    var body: some View {
        List {
            Section {
                Text("Live readings from the device's motion sensors, updated 10 times per second.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Accelerometer") {
                if accelAvailable {
                    axisRows(x: accel.x, y: accel.y, z: accel.z, unit: "g", color: .blue)
                } else {
                    Text("Unavailable").foregroundStyle(.secondary)
                }
            }

            Section("Gyroscope") {
                if gyroAvailable {
                    axisRows(x: gyro.x, y: gyro.y, z: gyro.z, unit: "rad/s", color: .green)
                } else {
                    Text("Unavailable").foregroundStyle(.secondary)
                }
            }

            Section("Magnetometer") {
                if magnetAvailable {
                    axisRows(x: magnetic.x, y: magnetic.y, z: magnetic.z, unit: "µT", color: .orange)
                } else {
                    Text("Unavailable").foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Sensors")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { start() }
        .onDisappear { stop() }
    }

    @ViewBuilder
    private func axisRows(x: Double, y: Double, z: Double, unit: String, color: Color) -> some View {
        InfoRow(label: "X", value: "\(String(format: "%.2f", x)) \(unit)", icon: "arrow.left.and.right", iconColor: color)
        InfoRow(label: "Y", value: "\(String(format: "%.2f", y)) \(unit)", icon: "arrow.up.and.down", iconColor: color)
        InfoRow(label: "Z", value: "\(String(format: "%.2f", z)) \(unit)", icon: "arrow.up.left.and.down.right", iconColor: color)
    }

    private func start() {
        if motionManager.isAccelerometerAvailable {
            accelAvailable = true
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { data, _ in
                guard let data else { return }
                accel = data.acceleration
            }
        }
        if motionManager.isGyroAvailable {
            gyroAvailable = true
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: .main) { data, _ in
                guard let data else { return }
                gyro = data.rotationRate
            }
        }
        if motionManager.isMagnetometerAvailable {
            magnetAvailable = true
            motionManager.magnetometerUpdateInterval = 0.1
            motionManager.startMagnetometerUpdates(to: .main) { data, _ in
                guard let data else { return }
                magnetic = data.magneticField
            }
        }
    }

    private func stop() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopMagnetometerUpdates()
    }
}
