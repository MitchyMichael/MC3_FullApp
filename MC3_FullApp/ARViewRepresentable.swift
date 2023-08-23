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
    @ObservedObject var arDelegate: ARDelegate
    @StateObject var cardFlip = CardFlip()
    var theItem: Int
    
    
    func makeUIView(context: Context) -> some SapimanARView {
        let arView = SapimanARView(frame: .zero)
        
        arDelegate.setARView(arView)
        
        // Start card flip game
        if theItem == 1 {
            cardFlip.startCardFlip(arView)
            arView.enableTapGesture()
            
            MultipeerSetup(arView: arView).setupMultipeerSession()
            arView.session.delegate
            
            print("Card Flip")
            print("DEBUG: \(cardFlip.loadedModels)")
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

// Counter for cards
class SapimanARView: ARView {
    var counter = 0
    var checkCondition = false
    var arrayCheckCard:[String] = []
}

extension SapimanARView {
    // Enable tap gesture for cards
    func enableTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Tap gesture for cards
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        let tapLocation = recognizer.location(in: self)
        if let card = self.entity(at: tapLocation) {
            
            if card.name == ""{
                parentCardFlip()
            } else {
                childCardFlip()
            }
            
            func checkCard() {
                if arrayCheckCard[0] == arrayCheckCard [1] {
                    checkCondition = true
                    print(arrayCheckCard[0])
                    print(arrayCheckCard[1])
                    print("checkCondition = true")
                } else {
                    checkCondition = false
                    print(arrayCheckCard[0])
                    print(arrayCheckCard[1])
                    print("checkCondition = false")
                }
            }
            
            func parentCardFlip() {
                if card.transform.rotation.angle == .pi {
                    // Function that only 2 cards can be open
                    if counter < 2 {
                        print("Card Name:\(card.children.first!.name)")
                        var flipDownTransform = card.transform
                        flipDownTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
                        card.move(to: flipDownTransform, relativeTo: card.parent, duration:0.25, timingFunction: .easeInOut)
                        print("Up")
                        counter = counter + 1
                        arrayCheckCard.append(card.children.first!.name)
                        
                    } else if counter <= 0 {
                        counter = 0
                    }
                    if counter == 2 {
                        checkCard()
                        
                        //print(arrayCheckCard[counter])
                        
                        // Check if card is the same
                        if checkCondition == true {
                            // Nambah skor
                            
                        }
                    }
                    
                    
                    
                } else {
                    var flipUpTransform = card.transform
                    flipUpTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
                    card.move(to: flipUpTransform, relativeTo: card.parent, duration:0.25, timingFunction: .easeInOut)
                    counter = counter - 1
                    checkCondition = false
                    print("Down")
                    
                    arrayCheckCard.removeAll(where: {$0 == card.children.first!.name})
                    //                    let _ = print(arrayCheckCard[counter])
                }
            }
            
            func childCardFlip() {
                if let parent = card.parent{
                    if parent.transform.rotation.angle == .pi {
                        
                        // Function that only 2 cards can be open
                        if counter < 2 {
                            var flipDownTransform = parent.transform
                            flipDownTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
                            parent.move(to: flipDownTransform, relativeTo: parent.parent, duration:0.25, timingFunction: .easeInOut)
                            print("Up")
                            counter = counter + 1
                        } else if counter <= 0 {
                            counter = 0
                        }
                        
                        if counter == 2 {
                            checkCard()
                            
                            //print(arrayCheckCard[counter])
                            
                            // Check if card is the same
                            if checkCondition == true {
                                // Nambah skor
                                
                            }
                        }
                    } else {
                        var flipUpTransform = parent.transform
                        flipUpTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
                        parent.move(to: flipUpTransform, relativeTo: parent.parent, duration:0.25, timingFunction: .easeInOut)
                        print("Down")
                        counter = counter - 1
                        
                    }
                }
            }
        }
        print("Counter: \(counter)")
    }
    
    
}

struct ARViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        ARViewRepresentable(arDelegate: ARDelegate(), theItem: 0)
    }
}
