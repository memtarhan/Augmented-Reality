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

        let text = ModelEntity(mesh: MeshResource.generateText("RealityKit", extrusionDepth: 0.1, font: .systemFont(ofSize: 0.2, weight: .bold), containerFrame: .zero, alignment: .center, lineBreakMode: .byClipping), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
        anchor.addChild(text)
        
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
