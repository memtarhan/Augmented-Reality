# Working with Shapes in ARKit

### Showing Feature Points inARKit

#### Debug options 

> - **World Origin**: Showing x-, y- and z-axes based on the iOS device's current location 
> - **Feature Points**: Showing feature points (i.e objects, planes)  



#### Session run options 

> * **removeExistingAnchors**: Removing any invisible anchors defining the position of virtual objects 
> * **resetTracking**: Resetting world tracking 



```swift
@IBOutlet var sceneView: ARSCNView!
    
private var configuration: ARWorldTrackingConfiguration!

 override func viewDidLoad() {
      super.viewDidLoad()
   
      sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
 }
// MARK: - Resetting the World Origin
private func resetWorldOrigin() {
     sceneView.session.pause()
     sceneView.session.run(configuration, options: [.resetTracking])
}
```

