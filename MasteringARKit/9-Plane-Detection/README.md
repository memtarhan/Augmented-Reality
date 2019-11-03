# Plane Detection

Each time ARKit detects a plane, it places an anchor in that augmented reality view. This anchor, one per plane, contains information about the plane’s:

- Orientation
- Position
- Size

> Detecting a horizontal plane requires ARKit identifying enough feature points (those tiny yellow dots) on a flat, horizontal surface. To increase the odds that ARKit will detect a horizontal plane, aim your iOS device’s camera at a flat surface with plenty of texture or color variation such as a bed, a rug or carpet, or a table. In comparison, a solid white floor will be much harder to identify since there will be much less detail for ARKit to identify.



### Detecting Planes

* _This function runs each time ARKit identifies a horizontal plane and identifies it as a plane anchor called ARPlaneAnchor, which defines the position an orientation of the flat surface._

```swift
// MARK: - ARSCNViewDelegate
func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    print("\(#function) detected plane: \(planeAnchor)")
}
```

> The first time ARKit identifies a horizontal plane, it assumes the horizontal plane is only as large as what it sees through the iOS device’s camera. As you move the iOS device’s camera around, ARKit will spot additional points of the horizontal plane. When that occurs, it updates its floor anchor information so it stores a larger dimension of the horizontal plane.

* _Each time ARKit updates its ARPlaneAnchor information by realizing a horizontal plane may be larger, it runs an didUpdate renderer function_

```swift
// MARK: - ARSCNViewDelegate
func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    print("\(#function) updating plane: \(planeAnchor)")
}
```

