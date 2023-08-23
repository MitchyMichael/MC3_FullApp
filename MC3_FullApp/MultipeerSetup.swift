//
//  MultipeerSetup.swift
//  MC3_FullApp
//
//  Created by Michael Wijaya Sutrisna on 16/08/23.
//

import Foundation
import MultipeerSession
import ARKit
import MultipeerConnectivity
import RealityKit

class MultipeerSetup: NSObject, ObservableObject, ARCoachingOverlayViewDelegate {
   
    @objc var arView :SapimanARView
    var multipeerSession: MultipeerSession?
    var sessionIDObservation: NSKeyValueObservation?
    init(arView:SapimanARView) {
        self.arView = arView
        super.init()
        
    }
    
    func setupMultipeerSession() {
        print(self.arView.session.identifier)
        sessionIDObservation = observe(\.arView.session.identifier, options: [.new]) { object, change in
            print("SessionID changed to \(change.newValue!)")
            
            guard let multipeerSession = self.multipeerSession else { return }
            self.sendARSessionIDTo(peers: multipeerSession.connectedPeers)
        }
        
        do {
            let x = try JSONEncoder().encode("Testing Masuk")
            multipeerSession?.sendToAllPeers(x, reliably: true)
        } catch {
            
        }
        
        multipeerSession = MultipeerSession(
            serviceName: "multiuser-ar",
            receivedDataHandler: self.receivedData,
            peerJoinedHandler: self.peerJoined,
            peerLeftHandler: self.peerLeft,
            peerDiscoveredHandler: self.peerDiscovered
        )
    }
}

// MARK: - MultipeerSession
extension MultipeerSetup {
    private func sendARSessionIDTo(peers: [PeerID]) {
        guard let multipeerSession = multipeerSession else { return }
        let idString = arView.session.identifier.uuidString
        let command = "SessionID:" + idString
        if let commandData = command.data(using: .utf8) {
            multipeerSession.sendToPeers(commandData, reliably: true, peers: peers)
        }
    }
    
    func receivedData(_ data: Data, from peer: PeerID) {
        guard let multipeerSession = multipeerSession else { return }
        
        if let collaborationData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARSession.CollaborationData.self, from: data) {
            arView.session.update(with: collaborationData)
            return
        }
        
        let sessionIDCommandString = "SessionID:"
        if let commandString = String(data: data, encoding: .utf8), commandString.starts(with: sessionIDCommandString) {
            let newSessionID = String(commandString[commandString.index(commandString.startIndex, offsetBy: sessionIDCommandString.count)...])
            
            if let oldSessionID = multipeerSession.peerSessionIDs[peer] {
                removeAllAnchorsOriginatingFromARSessionWithID(oldSessionID)
            }
            
            multipeerSession.peerSessionIDs[peer] = newSessionID
        }
    }
    
    func peerDiscovered(_ peer: PeerID) -> Bool {
        guard let multipeerSession = multipeerSession else { return false }
        
        if multipeerSession.connectedPeers.count > 4 {
            print("A fifth player wants to join.\nThe game is currently limited to four players.")
            return false
        } else {
            return true
        }
    }
    
    func peerJoined(_ peer: PeerID) {
        print("""
            A player wants to join the game.
            Hold the devices next to each other.
            """)
        print("Joining: \(peer)")
        
        sendARSessionIDTo(peers: [peer])
    }
    
    func peerLeft(_ peer: PeerID) {
        guard let multipeerSession = multipeerSession else { return }
        
        print("Left: \(peer)")
        print("A player has left the game.")
        
        if let sessionID = multipeerSession.peerSessionIDs[peer] {
            removeAllAnchorsOriginatingFromARSessionWithID(sessionID)
            multipeerSession.peerSessionIDs.removeValue(forKey: peer)
        }
    }
    
    private func removeAllAnchorsOriginatingFromARSessionWithID(_ identifier: String) {
        guard let frame = arView.session.currentFrame else { return }
        for anchor in frame.anchors {
            guard let anchorSessionID = anchor.sessionIdentifier else { continue }
            if anchorSessionID.uuidString == identifier {
                arView.session.remove(anchor: anchor)
            }
        }
    }
    
    func session(_ session: ARSession, didOutputCollaborationData data: ARSession.CollaborationData) {
        guard let multipeerSession = multipeerSession else { return }
        if !multipeerSession.connectedPeers.isEmpty {
            guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            else { fatalError("Unexpectedly failed to encode collaboration data.")}
            
            let dataIsCritical = data.priority == .critical
            multipeerSession.sendToAllPeers(encodedData, reliably: dataIsCritical)
            
        } else {
            print("Deferred sending collaboration to later because there are no peers.")
        }
    }
}
