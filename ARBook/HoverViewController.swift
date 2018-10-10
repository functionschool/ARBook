//
//  HoverViewController.swift
//  ARBook
//
//  Created by Юрий Истомин on 10/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class HoverViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  
  var sceneController = HoverScene()
  var didInitializeScene = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sceneView.delegate = self
    
    if let scene = sceneController.scene {
      sceneView.scene = scene
    }
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
    view.addGestureRecognizer(tapRecognizer)
  }
  
  @objc
  func didTapScreen(recognizer: UITapGestureRecognizer) {
    if didInitializeScene {
      if let camera = sceneView.session.currentFrame?.camera {
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.0
        let transform = camera.transform * translation
        let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        sceneController.addMonkey(position: position)
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let configuration = ARWorldTrackingConfiguration()
    
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    sceneView.session.pause()
  }
  
  // MARK: - ARSCNViewDelegate
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    if !didInitializeScene {
      if let camera = sceneView.session.currentFrame?.camera {
        didInitializeScene = true
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.0
        let transform = camera.transform * translation
        let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        sceneController.addMonkey(position: position)
      }
    }
  }
}

extension SCNNode {
  public class func allNodes(from file: String) -> [SCNNode] {
    var nodesInFile = [SCNNode]()
    
    do {
      guard let sceneURL = Bundle.main.url(forResource: file, withExtension: nil) else {
        print("Could not find scene file \(file)")
        return nodesInFile
      }
      
      let objScene = try SCNScene(url: sceneURL as URL, options: [SCNSceneSource.LoadingOption.animationImportPolicy: SCNSceneSource.AnimationImportPolicy.doNotPlay])
      objScene.rootNode.enumerateChildNodes { (node, _) in
        nodesInFile.append(node)
      }
    } catch {}
    return nodesInFile
  }
}
