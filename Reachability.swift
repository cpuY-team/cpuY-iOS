//
//  Reachability.swift
//  cpuY
//
//  Created by Nathan  on 30/06/2025.
//


//
//  Reachability.swift
//

import SystemConfiguration

public class Reachability {

    enum Connection {
        case wifi
        case cellular
        case unavailable
    }

    var connection: Connection {
        if !isReachable {
            return .unavailable
        }

        if isReachableViaWiFi {
            return .wifi
        }

        if isReachableViaCellular {
            return .cellular
        }

        return .unavailable
    }

    private var isReachable: Bool {
        return flags.contains(.reachable)
    }

    private var isReachableViaWiFi: Bool {
        return flags.contains(.reachable) && !flags.contains(.isWWAN)
    }

    private var isReachableViaCellular: Bool {
        return flags.contains(.isWWAN)
    }

    private var flags: SCNetworkReachabilityFlags {
        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return flags
        }
        return []
    }

    private let defaultRouteReachability: SCNetworkReachability?

    init?() {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }

        if defaultRouteReachability == nil {
            return nil
        }
    }
}
