//
//  OceanScene.swift
//  DeepDive
//
//  Created by Danilo Miranda Gusicuma on 13/04/22.
//

import Foundation
import SpriteKit

protocol ShowModalDelegate {
    mutating func showModal(_ modalType: ModalTypes) -> Void
}

class OceanScene: SKScene {
    
    var isLightOn = false
    
    var surfaceText = false
    var canYouHearText = false
    var ICantSeeText = false
    var whatsThat = false
    
    let cam = SKCameraNode()
    var submarine: SKSpriteNode!
    var manta: SKSpriteNode!
    var mantaTextures: [SKTexture] = []
    var mantaAnimation: SKAction!
    var light: SKSpriteNode!
    var helix: SKNode!
    var bubbles: SKEmitterNode!
    var helixTextures: [SKTexture] = []
    var helixAnimation: SKAction!
    var showModalDelegate: ShowModalDelegate? = nil
    var touch1: SKNode?
    var touch2: SKNode?
    var touch3: SKNode?
    var touch4: SKNode?
    var control: SKSpriteNode!
    var lightControl: SKSpriteNode!
    var speechLabel: SKLabelNode!
    var background: SKSpriteNode?
    var valve1: SKSpriteNode!
    var valve2: SKSpriteNode!

    override func sceneDidLoad() {
        
        //MARK: Submarine setup
        
        submarine = childNode(withName: "submarine") as? SKSpriteNode
        //submarine.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        manta = childNode(withName: "manta") as? SKSpriteNode
        bubbles = submarine.childNode(withName: "bubbles") as? SKEmitterNode
        helix = submarine.childNode(withName: "helix") as! SKSpriteNode
        light = submarine.childNode(withName: "light") as? SKSpriteNode
        
        // MARK: touches
        
        touch1 = childNode(withName: "touch1") as! SKSpriteNode
        touch2 = childNode(withName: "touch2") as! SKSpriteNode
        touch3 = childNode(withName: "touch3") as! SKSpriteNode
        touch4 = childNode(withName: "touch4") as! SKSpriteNode
        
        //MARK: Control
        
        background = childNode(withName: "background") as? SKSpriteNode
        control = SKSpriteNode(imageNamed: "control")
        lightControl = SKSpriteNode(imageNamed: "light-control")
        light.isHidden = true
        valve1 = SKSpriteNode(imageNamed: "valve")
        valve1.name = "valve1"
        valve2 = SKSpriteNode(imageNamed: "valve")
        valve2.name = "valve2"
        speechLabel = SKLabelNode(text: "")
        
        speechLabel.zPosition = 101
        lightControl.zPosition = 101
        valve1.zPosition = 101
        valve2.zPosition = 101
        control.zPosition = 100
        
        let deviceRatio = UIScreen.main.bounds.height/UIScreen.main.bounds.width
                
        let backgroundSizeWidth = background!.size.width
        
        let controlSizeWidth = UIScreen.main.bounds.width < 500 ? backgroundSizeWidth : backgroundSizeWidth * 0.75
        let controlSizeHeight = 0.28 * controlSizeWidth

        lightControl.size = CGSize(
            width: controlSizeWidth * 0.16,
            height: controlSizeWidth * 0.16
        )
        
        control.size = CGSize(
            width: controlSizeWidth,
            height: controlSizeHeight
        )
        
        let controlYPosition = control.size.height/2 - (background!.size.width * deviceRatio)/2
        let valveInset = controlSizeWidth * 0.27
        let valveYInset = controlSizeWidth * 0.05
        
        speechLabel.position = convert(CGPoint(x: 0, y: submarine.size.height), to: cam)
        control.position = convert(CGPoint(x: 0, y: controlYPosition), to: cam)
        lightControl.position = convert(CGPoint(x: 0, y: controlYPosition), to: cam)
        valve1.position = convert(CGPoint(x: valveInset, y: controlYPosition + valveYInset), to: cam)
        valve2.position = convert(CGPoint(x: -valveInset, y: controlYPosition + valveYInset), to: cam)
        
        let valveWidth = controlSizeWidth * 0.18
        let valveSize = CGSize(
            width: valveWidth,
            height: valveWidth
        )
        
        valve1.size = valveSize
        valve2.size = valveSize
        
        speechLabel.preferredMaxLayoutWidth = 200
        speechLabel.horizontalAlignmentMode = .center
        speechLabel.lineBreakMode = .byCharWrapping
        speechLabel.numberOfLines = 0
        speechLabel.fontName = "AvenirNext-Bold"
        speechLabel.fontSize = 14
        
        lightControl.name = "light-control"
        
        cam.addChild(valve1)
        cam.addChild(valve2)
        cam.addChild(control)
        cam.addChild(speechLabel)
        
        
        for i in 1...6 {
            helixTextures.append(SKTexture(imageNamed: "helix\(i)"))
        }
        
        for i in 1...14 {
            mantaTextures.append(SKTexture(imageNamed: "manta\(i)"))
        }
        
        helixAnimation = SKAction.animate(with: helixTextures, timePerFrame: 0.05)
        helixAnimation = SKAction.repeatForever(helixAnimation)
        helixAnimation.timingMode = .easeInEaseOut
        
        let mantaMove = SKAction.move(to: CGPoint(x: 200, y: manta.position.y), duration: 10)
        
        mantaAnimation = SKAction.animate(with: mantaTextures, timePerFrame: 0.2)
        mantaAnimation = SKAction.repeatForever(mantaAnimation)
        mantaAnimation.timingMode = .easeInEaseOut
        
        manta.run(mantaAnimation)
        
        func runMantaMove(){
            manta.run(mantaMove) {
                self.manta.position.x = -200
                runMantaMove()
            }
        }
        
        runMantaMove()
        
        let zeroRange = SKRange(constantValue: 0)
        let submarineLocationConstraint = SKConstraint.distance(zeroRange, to: submarine)

        let xRange = SKRange(lowerLimit: -150, upperLimit: 150)
        let yInset = (background!.size.width * deviceRatio)/2
        let yRange = SKRange(lowerLimit: -2000 + yInset, upperLimit: 2000 - yInset)
        let oceanEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        cam.constraints = [submarineLocationConstraint, oceanEdgeConstraint]
        
        addChild(cam)
        
        self.camera = cam
        
    }
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        showModal(.Beginning)
        speechLabel.startTyping(0.2, completion: nil)
    }
    
    func turnOnLights(){
        let lightTexture = SKTexture(imageNamed: "lights-on")
        submarine.texture = lightTexture
        submarine.zPosition = 20
        helix.zPosition = -19
        bubbles.isHidden = true
        light.isHidden = false
        isLightOn = true
    }

    func turnOffLights(){
        let submarineTexture = SKTexture(imageNamed: "submarine")
        submarine.texture = submarineTexture
        submarine.zPosition = 2
        helix.zPosition = -1
        bubbles.isHidden = false
        light.isHidden = true
        isLightOn = false
    }
    
    func backToSurface(){
        if isLightOn {
            turnOffLights()
        }
        submarine.position.y = 1891
        submarine.zPosition = 2
        helix.zPosition = -1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        submarine.physicsBody?.affectedByGravity = false
        var rep: SKAction?
        var repValve: SKAction?
        var group: SKAction?
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            let isTouchInValve = touchedNode.first(where: {$0.name == "valve1" || $0.name == "valve2"}) != nil
            for node in touchedNode {
                let nodeName: String? = node.name
                switch nodeName {
                case "touch1":
                    if !isTouchInValve {
                        showModal(.WhereLifeHappens)
                    }
                case "touch2":
                    if !isTouchInValve {
                        showModal(.SongOfTheWhales)
                    }
                case "touch3":
                    if !isTouchInValve {
                        showModal(.EverythingWeCantSee)
                    }
                case "touch4":
                    if !isTouchInValve {
                        showModal(.HumanThreat)
                    }
                case "valve1":
                    let move = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 1)
                    let rotate = SKAction.rotate(toAngle: 0.25, duration: 1)
                    let valveRotation = SKAction.rotate(byAngle: -1, duration: 1)
                    rep = SKAction.repeatForever(move)
                    repValve = SKAction.repeatForever(valveRotation)
                    group = SKAction.group([rep!, rotate])
                    submarine.run(group!, withKey: "diving")
                    valve1.run(repValve!, withKey: "valveRotation")
                    helix.run(helixAnimation, withKey: "helix")
                    bubbles.particleBirthRate = 5
                case "valve2":
                    let move = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 1)
                    let rotate = SKAction.rotate(toAngle: -0.17, duration: 1)
                    let valveRotation = SKAction.rotate(byAngle: 1, duration: 1)
                    rep = SKAction.repeatForever(move)
                    repValve = SKAction.repeatForever(valveRotation)
                    group = SKAction.group([rep!, rotate])
                    submarine.run(group!, withKey: "diving")
                    valve2.run(repValve!, withKey: "valveRotation")
                    helix.run(helixAnimation, withKey: "helix")
                    bubbles.particleBirthRate = 5
                case "light-control":
                    if isLightOn {
                        turnOffLights()
                    } else {
                        turnOnLights()
                    }
                default:
                    break
                }
            }
        }
        
        submarine.removeAction(forKey: "restoreRotation")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let restore_rotation = SKAction.rotate(toAngle: 0, duration: 1)
        submarine.physicsBody?.affectedByGravity = true
        submarine.removeAction(forKey: "diving")
        helix.removeAction(forKey: "helix")
        submarine.run(restore_rotation, withKey: "restoreRotation")
        valve1.removeAllActions()
        valve2.removeAllActions()
        bubbles.particleBirthRate = 0
    }
    
    func triggerText(triggerPosition: CGFloat, text: String, isTextUsed: Bool, toggleTextIndicator: ()-> Void) {
        
        let yPosition = submarine.position.y
        let typeDuration = 0.05
        
        if yPosition > triggerPosition + 50 && isTextUsed {
            toggleTextIndicator()
        }
        if yPosition < triggerPosition && !isTextUsed {
            toggleTextIndicator()
            speechLabel.text = text
            speechLabel.startTyping(typeDuration){
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.speechLabel.text = ""
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        submarine.position.x = 0
        
        triggerText(
            triggerPosition: 1600,
            text: "Wow! We just started and there's so much things here close to the surface!",
            isTextUsed: surfaceText,
            toggleTextIndicator: { surfaceText.toggle() }
        )
        
        triggerText(
            triggerPosition: 880,
            text: "Hey listen! Looks like someone is singing.",
            isTextUsed: canYouHearText,
            toggleTextIndicator: { canYouHearText.toggle() }
        )
        
        triggerText(
            triggerPosition: -640,
            text: "I can't see anything! Try to turn on the lights.",
            isTextUsed: ICantSeeText,
            toggleTextIndicator: { ICantSeeText.toggle() }
        )
        
        triggerText(
            triggerPosition: -1700,
            text: "Wait! It's not supposed to be here!",
            isTextUsed: whatsThat,
            toggleTextIndicator: { whatsThat.toggle() }
        )
        
        if submarine.position.y < -640 && !cam.children.contains(where: {$0.name == "light-control"}){
            cam.addChild(lightControl)
        } else if submarine.position.y > -640 && cam.children.contains(where: {$0.name == "light-control"}) {
            lightControl.removeFromParent()
            turnOffLights()
        }
    }
}

extension OceanScene {
    private func showModal(_ modalType: ModalTypes) {
        if var showModalDelegate = self.showModalDelegate {
            showModalDelegate.showModal(modalType)
        }
    }
}
