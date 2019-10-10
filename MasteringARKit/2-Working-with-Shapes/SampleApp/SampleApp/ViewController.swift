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
    @IBOutlet weak var xPositionSlider: UISlider!
    @IBOutlet weak var xPositionLabel: UILabel!
    @IBOutlet weak var yPositionSlider: UISlider!
    @IBOutlet weak var yPositionLabel: UILabel!
    @IBOutlet weak var zPositionSlider: UISlider!
    @IBOutlet weak var zPositionLabel: UILabel!
    
    private var configuration: ARWorldTrackingConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set debug options -> showing world origin
        //                   -> showing feature points
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        resetWorldOrigin()
    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        let position = SCNVector3(xPositionSlider.value, yPositionSlider.value, zPositionSlider.value)
        let node = createShape(with: .pyramid)
        display(node: node, at: position)
    }
    
    @IBAction func slideDidChange(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            // X position
            xPositionLabel.text = "\(sender.value)"
        case 1:
            // Y position
            yPositionLabel.text = "\(sender.value)"
        case 2:
            // Z position
            zPositionLabel.text = "\(sender.value)"
        default:
            break
        }
    }
    
    // MARK: - Resetting the World Origin
    private func resetWorldOrigin() {
        print(#function)

        sceneView.session.pause()
        // Remove nodes named "sphere"
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "displayed" {
                node.removeFromParentNode()
            }
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - Creating a Shape
    private func createShape(with type: ShapeType) -> SCNNode {
        // Create geometry w/ given type
        var geometry: SCNGeometry!
        switch type {
        case .box:
            geometry = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
            // Set looks of the box
            geometry.firstMaterial?.diffuse.contents = UIColor.purple
        case .pyramid:
            geometry = SCNPyramid(width: 0.2, height: 0.5, length: 0.3)
            // Set looks of the box
            geometry.firstMaterial?.diffuse.contents = UIImage(named: "pyramid")
        default:
            geometry = SCNSphere(radius: 0.3)
        }
        
        // Create a node w/ that box
        let node = SCNNode(geometry: geometry)
        // Set name of the node
        node.name = type.name
        
        return node
    }
    
    // MARK: - Creating a Text
    private func createText(with string: String) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.purple
        text.materials = [material]
        
        let node = SCNNode()
        node.geometry = text
        node.scale = SCNVector3(0.01, 0.01, 0.01)
        
        return node
    }
    
    // MARK: - Displaying a Node at Coordinates
    private func display(node: SCNNode, at coordinates: SCNVector3) {
        // Set location of the node
        node.position = coordinates
        // Set name of the node
        node.name = "displayed"
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
