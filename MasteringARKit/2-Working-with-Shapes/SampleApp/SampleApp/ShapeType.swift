//
//  GeometricShape.swift
//  SampleApp
//
//  Created by Mehmet Tarhan on 6.10.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import Foundation
import ARKit

// MARK: - Geometric Shapes
/*

 SCNFloor
 SCNBox
 SCNCapsule
 SCNCone
 SCNCylinder
 SCNPlane
 SCNPyramid
 SCNTorus
 SCNTube
 
*/

enum ShapeType {
    case floor
    case box
    case capsule
    case cone
    case cylinder
    case plane
    case pyramid
    case torus
    case tube
    
    var name: String {
        switch self {
        case .floor: return "floor"
        case .box: return "box"
        case .capsule: return "capsule"
        case .cone: return "cone"
        case .cylinder: return "cylinder"
        case .plane: return "plane"
        case .pyramid: return "pyramid"
        case .torus: return "torus"
        case .tube: return "tube"
        }
    }
}
