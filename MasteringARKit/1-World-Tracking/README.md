# World Tracking in ARKit 

### How World Tracking Works in ARKit 

> ARKit uses a coordinate system where the x-axis points left and right, the y-axis points up and down, and the z-axis points toward and away from the camera.



### Resetting the World Origin 

> Each time an AR app is run, world coordinates are defined at the current location of the iOS device. You may want to change those coordinates so ARKit provides a solution for that.



```swift
@IBOutlet var sceneView: ARSCNView!
    
private var configuration: ARWorldTrackingConfiguration!

// MARK: - Resetting the World Origin
private func resetWorldOrigin() {
     sceneView.session.pause()
     sceneView.session.run(configuration, options: [.resetTracking])
}
```



### Displaying Shapes at Coordinates

> - Creating a 3D shape (Sphere, box etc.)
> - Modifing the looks (Changing diffuse etc.)
> - Creating a node with the shape 
> - Setting position of the node 
> - Adding the node to scene view 
>

```swift
override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
        
     let worldOriginCoordinates = SCNVector3(0, 0, 0)
     displayShape(at: worldOriginCoordinates)
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
```

