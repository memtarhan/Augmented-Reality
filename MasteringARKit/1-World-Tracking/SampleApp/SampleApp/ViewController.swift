//
//  ViewController.swift
//  SampleApp
//
//  Created by Mehmet Tarhan on 27.09.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    private var configuration: ARWorldTrackingConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set debug options -> showing world origin
        sceneView.debugOptions = [.showWorldOrigin]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        let worldOriginCoordinates = SCNVector3(0, 0, 0)
        displayShape(at: worldOriginCoordinates)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        resetWorldOrigin()
    }
    
    // MARK: - Resetting the World Origin
    private func resetWorldOrigin() {
        print(#function)
        sceneView.session.pause()
        sceneView.session.run(configuration, options: [.resetTracking])
    }
    
    // MARK: - Displaying Shapes at Coordinates
    private func displayShape(at coordinates: SCNVector3) {
        // Create a 3D shape(Sphere)
        let sphere = SCNSphere(radius: 0.06)
        // Set the looks of the shape
        sphere.firstMaterial?.diffuse.contents = UIColor.purple
        // Create a node with the shape
        let node = SCNNode(geometry: sphere)
        // Set location of the node
        node.position = coordinates
        
        // Add the node to sceneView
        sceneView.scene.rootNode.addChildNode(node)
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print(#function)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print(#function)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print(#function)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(#function)
    }
}
