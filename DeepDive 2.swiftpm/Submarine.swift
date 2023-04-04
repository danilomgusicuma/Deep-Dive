//
//  File.swift
//  DeepDive
//
//  Created by Danilo Miranda Gusicuma on 23/04/22.
//

import SpriteKit

class Submarine: SKSpriteNode {
    
    var light: SKSpriteNode!
    var helix: SKNode!
    var bubbles: SKEmitterNode!
    var helixTextures: [SKTexture] = []
    var helixAnimation: SKAction!
    var isLightOn = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bubbles = self.childNode(withName: "bubbles") as? SKEmitterNode
        helix = self.childNode(withName: "helix") as! SKSpriteNode
        light = self.childNode(withName: "light") as? SKSpriteNode
        light.isHidden = true
        
        for i in 1...6 {
            helixTextures.append(SKTexture(imageNamed: "helix\(i)"))
        }
        
        helixAnimation = SKAction.animate(with: helixTextures, timePerFrame: 0.05)
        helixAnimation = SKAction.repeatForever(helixAnimation)
        helixAnimation.timingMode = .easeInEaseOut
        
    }
    
    func dive() {

        let move = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 1)
        let rotate = SKAction.rotate(toAngle: 0.25, duration: 1)
        let rep = SKAction.repeatForever(move)
        let group = SKAction.group([rep, rotate])
        
        run(group, withKey: "diving")
        helix.run(helixAnimation, withKey: "helix")
        bubbles.particleBirthRate = 5
    }
    
    func surface() {
        let move = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 1)
        let rotate = SKAction.rotate(toAngle: -0.17, duration: 1)
        let rep = SKAction.repeatForever(move)
        let group = SKAction.group([rep, rotate])
        
        run(group, withKey: "diving")
        helix.run(helixAnimation, withKey: "helix")
        bubbles.particleBirthRate = 5
    }
    
    func stop() {
        let restore_rotation = SKAction.rotate(toAngle: 0, duration: 1)
        removeAction(forKey: "diving")
        run(restore_rotation, withKey: "restoreRotation")
        helix.removeAction(forKey: "helix")
        bubbles.particleBirthRate = 0
    }
    
    func toggleLights() {
        if isLightOn {
            turnOffLights()
        } else {
            turnOnLights()
        }
    }
    
    func turnOnLights(){
        let lightTexture = SKTexture(imageNamed: "lights-on")
        texture = lightTexture
        zPosition = 20
        helix.zPosition = -19
        bubbles.isHidden = true
        light.isHidden = false
        isLightOn = true
    }

    func turnOffLights(){
        let submarineTexture = SKTexture(imageNamed: "submarine")
        texture = submarineTexture
        zPosition = 2
        helix.zPosition = -1
        bubbles.isHidden = false
        light.isHidden = true
        isLightOn = false
    }
    
    func backToSurface(){
        if isLightOn {
            turnOffLights()
        }
        position.y = 1891
        zPosition = 2
        helix.zPosition = -1
    }
    
}
