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
        let meshResource = MeshResource.generateBox(size: 0.3)
        let box = ModelEntity(mesh: meshResource, materials: [material])

        anchor.addChild(box)
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
