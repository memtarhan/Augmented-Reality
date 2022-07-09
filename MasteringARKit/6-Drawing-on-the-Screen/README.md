# Drawing on the Screen

```swift
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
            }
        }
    }
```

