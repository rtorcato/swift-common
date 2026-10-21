//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-16.
//

import Foundation
import Network
import SwiftUI

@MainActor
final public class NetworkState: ObservableObject {
    @Published public private(set) var isConnected = false
    @Published public private(set) var isCellular = false
    @Published public private(set) var currentInterface: NWInterface.InterfaceType?
    
    private let nwMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue.global()
    
    public init() {}
    
    public func start() {
        nwMonitor.start(queue: workerQueue)
        nwMonitor.pathUpdateHandler = { [weak self] path in
            // Read the path on the monitor's queue, publish on the main actor.
            let isConnected = path.status == .satisfied
            let isCellular = path.usesInterfaceType(.cellular)
            let interface = NWInterface.InterfaceType.allCases.first { path.usesInterfaceType($0) }
            DispatchQueue.main.async { [weak self] in
                self?.isConnected = isConnected
                self?.isCellular = isCellular
                self?.currentInterface = interface
            }
        }
    }
    
    public func stop() {
        nwMonitor.cancel()
    }
}

extension NWInterface.InterfaceType: CaseIterable {
    public static let allCases: [NWInterface.InterfaceType] = [
        .other, .wifi, .cellular, .loopback, .wiredEthernet
    ]
}

// @StateObject var nw = NetworkState()
//    .onAppear {
//               nw.start()
//           }
//           .onDisappear {
//               nw.stop()
//           }
