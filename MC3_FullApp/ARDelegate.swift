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
    
    func setARView(_ arView: ARView) -> ARView?{
        guard ARWorldTrackingConfiguration.isSupported else { return nil }
        self.arView = arView
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        configuration.isCollaborationEnabled = true
        
        arView.session.run(configuration)
        
        return arView
    }
    
}

