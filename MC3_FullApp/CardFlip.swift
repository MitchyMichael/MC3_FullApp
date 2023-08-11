//
//  CardFlip.swift
//  MC3_FullApp
//
//  Created by Michael Wijaya Sutrisna on 08/08/23.
//

import ARKit
import SwiftUI
import RealityKit
import Combine

class CardFlip: NSObject, ObservableObject, ARCoachingOverlayViewDelegate {
    var loadedModels: [ModelEntity] = []
    var modelNameItems: [String] = ["sneaker_pegasustrail", "toy_biplane_idle", "toy_drummer_idle", "pie_lemon_meringue", "tv_retro", "fender_stratocaster", "gramophone", "flower_tulip"]
    var objectId: [String] = [String]()
    
    func startCardFlip(_ arView: ARView) {
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
        arView.scene.addAnchor(anchor)
        
        var cards: [Entity] = []
        for _ in 1...16 {
            let box = MeshResource.generateBox(width: 0.04, height: 0.002, depth: 0.04)
            let metalMaterial = SimpleMaterial(color: .gray, isMetallic: true)
            let model = ModelEntity(mesh: box, materials: [metalMaterial])
            
            model.generateCollisionShapes(recursive: true)
            
            cards.append(model)
        }
        
        for (index, card) in cards.enumerated() {
            let x = Float(index % 4)
            let z = Float(index / 4)
            
            card.position = [x*0.1, 0, z*0.1]
            anchor.addChild(card)
        }
        
        let boxSize: Float = 0.9
        let occlusionBoxMesh = MeshResource.generateBox(size: boxSize)
        let occlusionBox = ModelEntity(mesh: occlusionBoxMesh, materials: [OcclusionMaterial()])
        occlusionBox.position.y = -boxSize / 2
        anchor.addChild(occlusionBox)
        
        var cancellable : AnyCancellable? = nil
        
        var loadedModels: [ModelEntity] = []
        var modelNames: [String] = []
        
        cancellable = ModelEntity.loadModelAsync(named: modelNameItems[0])
            .append(ModelEntity.loadModelAsync(named: modelNameItems[1]))
            .append(ModelEntity.loadModelAsync(named: modelNameItems[2]))
            .append(ModelEntity.loadModelAsync(named: modelNameItems[3]))
            .append(ModelEntity.loadModelAsync(named: modelNameItems[4]))
            .append(ModelEntity.loadModelAsync(named: modelNameItems[5]))
            .append(ModelEntity.loadModelAsync(named: modelNameItems[6]))
            .append(ModelEntity.loadModelAsync(named: modelNameItems[7]))
            .collect()
            .sink(receiveCompletion: { error in
                print ("Error: \(error)")
                cancellable?.cancel()
            }, receiveValue: { entities in
                var objects : [ModelEntity] = []
                var counter = 0
                for entity in entities {
                    entity.setScale(SIMD3<Float>(0.001, 0.001, 0.001), relativeTo: anchor)
                    entity.generateCollisionShapes(recursive: true)
                    entity.name = "\(counter)"
                    counter += 1
                    for _ in 1...2 {
                        objects.append(entity.clone(recursive: true))
                    }
                    print("Objects: \(cancellable)")
                }
                objects.shuffle()
               
                loadedModels = objects
                
                for object in objects {
                    print("Object Name:\(object.name)")
                    self.objectId.append(object.name)
                }
                
                for (index, object) in objects.enumerated() {
                    cards[index].addChild(object)
                    cards[index].transform.rotation = simd_quatf(angle: .pi, axis: [1,0,0])
                }
                
                cancellable?.cancel()
                
                for modelEntity in loadedModels {
                    modelNames.append(modelEntity.name)
                }
                print("Model Names: \(loadedModels[0])")
                
            })
    }
}

