# Positioning Object 

> Virtual objects appear in an augmented reality view when x, y and z coordinates are specified. Such virtual objects remain fixed in place unless world origin is reset so they appear based on the new world origin's location.



#### Showing a shape at a specific coordinate

```swift
private func showShape() {
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial?.diffuse.contents = UIColor.orange
        
        let node = SCNNode()
        node.geometry = sphere
        node.position = SCNVector3(0.2, 0.1, -0.1)
        
        sceneView.scene.rootNode.addChildNode(node)
}
```



#### Showing shapes with relative positions 

```swift
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
```



### Combinig geometric shapes 

```swift
// MARK: - Showing snowman
    private func showShape() {
        let sphere = SCNSphere(radius: 0.04)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        
        let node = SCNNode()
        node.geometry = sphere
        node.position = SCNVector3(0.05, 0.05, -0.05)
        sceneView.scene.rootNode.addChildNode(node)
        
        let middleSphere = SCNSphere(radius: 0.03)
        middleSphere.firstMaterial?.diffuse.contents = UIColor.blue
        
        let middleNode = SCNNode()
        middleNode.geometry = middleSphere
        middleNode.position = SCNVector3(0, 0.06, 0)
        node.addChildNode(middleNode)
        
        let topSphere = SCNSphere(radius: 0.02)
        topSphere.firstMaterial?.diffuse.contents = UIColor.white
        
        let topNode = SCNNode()
        topNode.geometry = topSphere
        topNode.position = SCNVector3(0, 0.04, 0)
        middleNode.addChildNode(topNode)
        
        // Creating hat
        let hatRim = SCNCylinder(radius: 0.03, height: 0.002)
        hatRim.firstMaterial?.diffuse.contents = UIColor.blue
        
        let rimNode = SCNNode()
        rimNode.geometry = hatRim
        rimNode.position = SCNVector3(0, 0.016, 0)
        topNode.addChildNode(rimNode)
        
        let hatTop = SCNCylinder(radius: 0.015, height: 0.025)
        hatTop.firstMaterial?.diffuse.contents = UIColor.black
        
        let hatNode = SCNNode()
        hatNode.geometry = hatTop
        hatNode.position = SCNVector3(0, 0.01, 0)
        rimNode.addChildNode(hatNode)
    }
```

