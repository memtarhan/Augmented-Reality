//
//  ViewController.swift
//  SampleApp
//
//  Created by Mehmet Tarhan Personal on 2.11.2019.
//  Copyright © 2019 Mehmet Tarhan Personal. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    private var newAngleZ: Float = 0.0
    private var currentAngleZ: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set debug options
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
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
    
    @IBAction func didPinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            guard let pinchedView = sender.view as? ARSCNView else { return }
            let pinchedCoordinates = sender.location(in: pinchedView)
            let hitTestResults = sceneView.hitTest(pinchedCoordinates, options: nil)
            
            if let result = hitTestResults.first {
                print("\(#function) pinched a virtual object")
                let plane = result.node
                
                let scaleX = Float(sender.scale) * plane.scale.x
                let scaleY = Float(sender.scale) * plane.scale.y
                let scaleZ = Float(sender.scale) * plane.scale.z
                
                plane.scale = SCNVector3(scaleX, scaleY, scaleZ)
                
                sender.scale = 1
            }
        }
    }
    
    @IBAction func didRotate(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .changed {
            guard let touchedView = sender.view as? ARSCNView else { return }
            let touchedCoordinates = sender.location(in: touchedView)
            let hitTestResults = sceneView.hitTest(touchedCoordinates, options: nil)
            if let result = hitTestResults.first {
                print("\(#function) rotated a virtual object")
                let plane = result.node
                
                newAngleZ = Float(-sender.rotation)
                newAngleZ += currentAngleZ
                
                plane.eulerAngles.z = newAngleZ
            }
            
        } else if sender.state == .ended {
            currentAngleZ = newAngleZ
        }
    }
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        guard let pannedView = sender.view as? ARSCNView else { return }
        let pannedCoordinates = sender.location(in: pannedView)
        let hitTestResults = sceneView.hitTest(pannedCoordinates, options: nil)
        if let result = hitTestResults.first {
            print("\(#function) panned a virtual object")
            if let plane = result.node.parent {
                if sender.state == .changed {
                    let translation = sender.translation(in: pannedView)
                    plane.localTranslate(by: SCNVector3(translation.x/10000, -translation.y/10000, 0.0))
                }
            }
        }
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
