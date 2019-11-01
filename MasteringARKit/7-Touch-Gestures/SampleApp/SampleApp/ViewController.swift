//
//  ViewController.swift
//  SampleApp
//
//  Created by Mehmet Tarhan Personal on 1.11.2019.
//  Copyright © 2019 Mehmet Tarhan Personal. All rights reserved.
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
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        registerTapGesture()
        addShapes()
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

    // MARK: - UITapGestureRecognizer
    private func registerTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap(_ sender: UIGestureRecognizer) {
        print(#function)
        
        guard let tappedView = sender.view as? SCNView else { return }
        let tappedCoordinates = sender.location(in: tappedView)
        let hitTestResults = tappedView.hitTest(tappedCoordinates, options: [:])
        
        if let result = hitTestResults.first {
            print("Hit something: \(result.node.name ?? "Something")")
       
        } else {
            print("Hit nothing")
        }
        
    }
    
    private func addShapes() {
        let node = SCNNode(geometry: SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0))
        node.position = SCNVector3(0.1, 0, -0.1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        node.name = "box"
        sceneView.scene.rootNode.addChildNode(node)
        
        let node2 = SCNNode(geometry: SCNPyramid(width: 0.05, height: 0.06, length: 0.05))
        node2.position = SCNVector3(0.1, 0.1, -0.1)
        node2.name = "pyramid"
        sceneView.scene.rootNode.addChildNode(node2)
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
