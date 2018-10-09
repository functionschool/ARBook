//
//  ViewController.swift
//  ARBook
//
//  Created by Юрий Истомин on 09/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sceneView.delegate = self
    
    let scene = SCNScene(named: "art.scnassets/BookDescriptionScene.scn")!
    
    sceneView.scene = scene
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = ARImageTrackingConfiguration()
    
    guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else {
      print("No images available")
      return
    }
    
    configuration.trackingImages = trackedImages
    configuration.maximumNumberOfTrackedImages = 1
    
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    sceneView.session.pause()
  }
  
  // MARK: - ARSCNViewDelegate
  
  func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    let node = SCNNode()
    
    if let imageAnchor = anchor as? ARImageAnchor {
      let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
      
      plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
      
      let planeNode = SCNNode(geometry: plane)
      planeNode.eulerAngles.x = -.pi / 2
      
      let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
      let shipNode = shipScene.rootNode.childNodes.first!
      shipNode.position = SCNVector3Zero
      shipNode.position.z = 0.15
      
      planeNode.addChildNode(shipNode)
      
      node.addChildNode(planeNode)
    }
    
    return node
  }
}
