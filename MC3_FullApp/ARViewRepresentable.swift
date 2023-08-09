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
            CardFlip(arView)
            print("Card Flip")
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

struct ARViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        ARViewRepresentable(arDelegate: ARDelegate(), theItem: 0)
    }
}
