//
//  UIControl.swift
//  DeepDive
//
//  Created by Danilo Miranda Gusicuma on 23/04/22.
//

import SpriteKit

class UIControl: SKSpriteNode {
    
    var lightControl: SKSpriteNode!
    var valve1: SKSpriteNode!
    var valve2: SKSpriteNode!
    var cam: SKCameraNode!
    
    init(viewWidth: CGFloat, cam: SKCameraNode) {
        let texture = SKTexture(imageNamed: "control")
        
        let controlSizeWidth = UIScreen.main.bounds.width < 500 ? viewWidth : viewWidth * 0.75
        let controlSizeHeight = 0.28 * controlSizeWidth
        let controlSize = CGSize(
            width: controlSizeWidth,
            height: controlSizeHeight
        )
        super.init(texture: texture, color: UIColor(), size: controlSize)
        
        let deviceRatio = UIScreen.main.bounds.height/UIScreen.main.bounds.width
        let controlYPosition = size.height/2 - (viewWidth * deviceRatio)/2
        let valveInset = controlSizeWidth * 0.27
        let valveYInset = controlSizeWidth * 0.05
        
        zPosition = 100
        position = convert(CGPoint(x: 0, y: controlYPosition), to: cam)
        
        let lightControlSize = CGSize(width: controlSizeWidth * 0.16, height: controlSizeWidth * 0.16)
        lightControl = SKSpriteNode(imageNamed: "light-control")
        lightControl.name = "light-control"
        lightControl.zPosition = 101
        lightControl.size = lightControlSize
        lightControl.position = convert(CGPoint(x: 0, y: 0), to: cam)
        
        let valveWidth = controlSizeWidth * 0.18
        let valveSize = CGSize(
            width: valveWidth,
            height: valveWidth
        )
        
        valve1 = SKSpriteNode(imageNamed: "valve")
        valve1.name = "valve1"
        valve1.zPosition = 101
        valve1.position = convert(CGPoint(x: valveInset, y: valveYInset), to: cam)
        valve1.size = valveSize
        cam.addChild(valve1)
        
        valve2 = SKSpriteNode(imageNamed: "valve")
        valve2.name = "valve2"
        valve2.zPosition = 101
        valve2.position = convert(CGPoint(x: -valveInset, y: valveYInset), to: cam)
        valve2.size = valveSize
        cam.addChild(valve2)
        
        self.cam = cam

    }
    
    func rotateValve1(){
        let valveRotation = SKAction.rotate(byAngle: -1, duration: 1)
        let repValve = SKAction.repeatForever(valveRotation)
        valve1.run(repValve, withKey: "valveRotation")
    }
    
    func stopValve1(){
        valve1.removeAllActions()
    }
    
    func rotateValve2(){
        let valveRotation = SKAction.rotate(byAngle: 1, duration: 1)
        let repValve = SKAction.repeatForever(valveRotation)
        valve2.run(repValve, withKey: "valveRotation")
    }
    
    func stopValve2(){
        valve2.removeAllActions()
    }
    
    func addLightControl(){
        cam.addChild(lightControl)
    }
    
    func removeLightControl(){
        lightControl.removeFromParent()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
