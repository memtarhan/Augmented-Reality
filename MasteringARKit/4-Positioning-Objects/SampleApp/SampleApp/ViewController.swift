//
//  ViewController.swift
//  SampleApp
//
//  Created by Mehmet Tarhan on 16.10.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set debug options
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

//    private func showShape() {
//        let sphere = SCNSphere(radius: 0.05)
//        sphere.firstMaterial?.diffuse.contents = UIColor.orange
//
//        let node = SCNNode()
//        node.geometry = sphere
//        node.position = SCNVector3(0.2, 0.1, -0.1)
//
//        sceneView.scene.rootNode.addChildNode(node)
//    }
    
    private func showShape() {
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial?.diffuse.contents = UIColor.orange
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.0)
        box.firstMaterial?.diffuse.contents = UIColor.green
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(-0.4, -0.3, 0.2)
        
        let node = SCNNode()
        node.geometry = sphere
        node.position = SCNVector3(0.2, 0.1, -0.1)
        sceneView.scene.rootNode.addChildNode(node)
        
        node.addChildNode(boxNode)
    }
}
