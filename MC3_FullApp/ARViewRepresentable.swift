//
//  ARViewRepresentable.swift
//  MC3_FullApp
//
//  Created by Michael Wijaya Sutrisna on 08/08/23.
//

import ARKit
import SwiftUI
import RealityKit
import Combine

struct ARViewRepresentable: UIViewRepresentable {
    let arDelegate: ARDelegate
    var theItem: Int
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        
        if theItem == 1 {
            CardFlip().startCardFlip(arView)
            arView.enableTapGesture()
            print("Card Flip")
            print(CardFlip().loadedModels)
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

extension ARView {
    func enableTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)
        var tapPosition = 0
        
        if let card = self.entity(at: tapLocation) {
            if card.transform.rotation.angle == .pi {
                var flipDownTransform = card.transform
                flipDownTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
                card.move(to: flipDownTransform, relativeTo: card.parent, duration:0.25, timingFunction: .easeInOut)
                print("Up")
            } else {
                var flipUpTransform = card.transform
                flipUpTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
                card.move(to: flipUpTransform, relativeTo: card.parent, duration:0.25, timingFunction: .easeInOut)
                print("Down")
            }
        }
    }
}

struct ARViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        ARViewRepresentable(arDelegate: ARDelegate(), theItem: 0)
    }
}
