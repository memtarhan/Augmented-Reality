# Interacting with Augmented Reality 

### Scaling with the Pinch Touch Gesture 

> The pinch gesture is a common touch gesture for zooming in or out of an image displayed on the screen, such as while looking at a digital photograph. Likewise, this same pinch gesture can be used to scale the virtual plane that appears in the augmented reality view.

Touch gestures consist of three states:

* **.began**: Occurs when the app first detects a specific touch gesture 
* **.changed**: Occurs while the touch gesture is still going on
* **.ended**: Occurs when the app detects that the touch gesture stopped 

```swift
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
```

