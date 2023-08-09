//
//  ARDelegate.swift
//  MC3_FullApp
//
//  Created by Michael Wijaya Sutrisna on 08/08/23.
//

import Foundation
import ARKit
import RealityKit

class ARDelegate: NSObject, ObservableObject, ARCoachingOverlayViewDelegate {
    private var arView: ARView?
    let configuration = ARWorldTrackingConfiguration()
    
    func setARView(_ arView: ARView) {
        guard ARWorldTrackingConfiguration.isSupported else { return }
        self.arView = arView
        configuration.planeDetection = [.horizontal, .vertical]
        
        arView.session.run(configuration)
    }
    
}

