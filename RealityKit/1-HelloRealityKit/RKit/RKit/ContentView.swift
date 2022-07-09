//
//  ContentView.swift
//  RKit
//
//  Created by Mehmet Tarhan on 09/07/2022.
//

import RealityKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let anchor = AnchorEntity(plane: .horizontal)

        let material = SimpleMaterial(color: .blue, isMetallic: true)
        let meshResource = MeshResource.generateBox(size: 0.1)
        let box = ModelEntity(mesh: meshResource, materials: [material])

        anchor.addChild(box)
        
        let sphere = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.1), materials: [SimpleMaterial(color: .yellow, isMetallic: true)])
        sphere.position = simd_make_float3(0, 0.3, 0)
        anchor.addChild(sphere)
        
        let plane = ModelEntity(mesh: MeshResource.generatePlane(width: 0.5, depth: 0.3), materials: [SimpleMaterial(color: .black, isMetallic: true)])
        anchor.addChild(plane)
        
        arView.scene.anchors.append(anchor)
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

#if DEBUG
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
#endif
