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
    @IBOutlet weak var drawSwitch: UISwitch!
    @IBOutlet weak var clearButton: UIButton!
    
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

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        print(#function)
        // Retrieve the camera's information
        guard let pointOfView = sceneView.pointOfView else { return }
        
        // Transform this to 4x4 matrix that contains various information about the camera
        let transform = pointOfView.transform
        // The 3rd row contains x, y abd z rotation of the camera
        let rotation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        // The 4th row contains camera's location
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        
        let currentPosition = SCNVector3(rotation.x + location.x,
                                         rotation.y + location.y,
                                         rotation.z + location.z)
        
        DispatchQueue.main.async {
            if self.drawSwitch.isOn {
                // Draw a line
                let line = SCNSphere(radius: 0.01)
                line.firstMaterial?.diffuse.contents = UIColor.green
                
                let node = SCNNode()
                node.geometry = line
                node.position = currentPosition
                
                self.sceneView.scene.rootNode.addChildNode(node)
                
            } else {
                // Display a pointer
                let pointer = SCNSphere(radius: 0.005)
                pointer.firstMaterial?.diffuse.contents = UIColor.red
                
                let node = SCNNode()
                node.geometry = pointer
                node.position = currentPosition
                node.name = "pointer"
                
                self.sceneView.scene.rootNode.enumerateChildNodes { (n, _) in
                    if n.name == "pointer" {
                        n.removeFromParentNode()
                    }
                }
                
                self.sceneView.scene.rootNode.addChildNode(node)
                
                if self.clearButton.isHighlighted {
                    self.sceneView.scene.rootNode.enumerateChildNodes { (n, _) in
                        n.removeFromParentNode()
                    }
                }
            }
        }
    }
    
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
