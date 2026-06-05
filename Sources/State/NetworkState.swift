//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-16.
//

import Foundation
import Network
import SwiftUI

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
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.isCellular = path.usesInterfaceType(.cellular)
                guard let interface = NWInterface.InterfaceType.allCases.filter({ path.usesInterfaceType($0)}).first else {
                    self?.currentInterface = nil
                    return
                }
                self?.currentInterface = interface
            }
        }
    }
    
    public func stop() {
        nwMonitor.cancel()
    }
}

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
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
