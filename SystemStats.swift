import Foundation
import MachO
import UIKit

/// Shared between the cpuY app and the cpuY widget extension so both read
/// hardware state (RAM, battery) through the same code instead of duplicating
/// the low-level mach calls.
enum SystemStats {
    struct Memory {
        let usedGB: Double
        let freeGB: Double
        let totalGB: Double
        let usedFraction: Double
    }

    struct Battery {
        let level: Float
        let state: UIDevice.BatteryState
    }

    static func currentMemory() -> Memory {
        let totalGB = Double(ProcessInfo.processInfo.physicalMemory) / 1073741824
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        guard result == KERN_SUCCESS else {
            return Memory(usedGB: 0, freeGB: 0, totalGB: totalGB, usedFraction: 0)
        }
        var pageSize: vm_size_t = 0
        host_page_size(mach_host_self(), &pageSize)
        let freeGB = Double(stats.free_count + stats.inactive_count) * Double(pageSize) / 1073741824
        let usedGB = totalGB - freeGB
        return Memory(
            usedGB: usedGB,
            freeGB: freeGB,
            totalGB: totalGB,
            usedFraction: totalGB > 0 ? usedGB / totalGB : 0
        )
    }

    static func currentBattery() -> Battery {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return Battery(level: UIDevice.current.batteryLevel, state: UIDevice.current.batteryState)
    }
}
