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

