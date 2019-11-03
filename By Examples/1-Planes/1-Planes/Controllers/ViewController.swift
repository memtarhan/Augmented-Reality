//
//  ViewController.swift
//  1-Planes
//
//  Created by Mehmet Tarhan on 19.05.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var planeDetectedLabel: UILabel!
    
    var detectedPlanes = [OverlayPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set debug options:
        //      - Show Feature Points: To see detected surfaces
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Set planeDetected properties
        planeDetectedLabel.layer.cornerRadius = 5
        planeDetectedLabel.clipsToBounds = true
        
        setGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Set plane detections
        configuration.planeDetection = [.horizontal, .vertical]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    private func setGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        sceneView.addGestureRecognizer(tap)
    }
    
    @objc private func didTap(_ sender: UIGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        
        let touchedLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(touchedLocation, types: .existingPlaneUsingExtent)
        
        if let hitTestResult = hitTestResults.first {
            addBox(onHitTest: hitTestResult)
        }
    }
    
    private func addBox(onHitTest test: ARHitTestResult) {
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.yellow
        
        let node = SCNNode(geometry: box)
        
        let x = test.worldTransform.columns.3.x
        let y = test.worldTransform.columns.3.y + Float(box.height/2)
        let z = test.worldTransform.columns.3.z
        
        node.position = SCNVector3(x, y, z)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        dlog(self, "renderer didAdd")
        // Plane detected
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2, animations: {
                self.planeDetectedLabel.alpha = 1
            }, completion: { (_) in
                UIView.animate(withDuration: 1, animations: {
                    self.planeDetectedLabel.alpha = 0
                })
            })
        }
        
        if anchor is ARPlaneAnchor {
            let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
            node.addChildNode(plane)
            detectedPlanes.append(plane)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        dlog(self, "renderer didUpdate")
        // Plane updated
        let plane = detectedPlanes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
        }.first
        
        if plane != nil {
            plane?.update(anchor: anchor as! ARPlaneAnchor)
        }
    }
    
}
