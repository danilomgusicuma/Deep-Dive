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
        
    var surfaceText = false
    var canYouHearText = false
    var ICantSeeText = false
    var whatsThat = false
    
    var isOnSurface = true
    
    let cam = SKCameraNode()
    var submarine: Submarine!
    var manta: SKSpriteNode!
    var mantaTextures: [SKTexture] = []
    var mantaAnimation: SKAction!
    var underwaterSound: SKAudioNode!
    var wavesSound: SKAudioNode!
    
    var showModalDelegate: ShowModalDelegate? = nil
    var touch1: SKNode?
    var touch2: SKNode?
    var touch3: SKNode?
    var touch4: SKNode?
    var control: UIControl!
    
    var speechLabel: SKLabelNode!
    var background: SKSpriteNode?


    override func sceneDidLoad() {
        
        let deviceRatio = UIScreen.main.bounds.height/UIScreen.main.bounds.width
                
        submarine = childNode(withName: "submarine") as? Submarine
        manta = childNode(withName: "manta") as? SKSpriteNode
        
        underwaterSound = childNode(withName: "underwater") as? SKAudioNode
        underwaterSound.removeFromParent()
        
        wavesSound = childNode(withName: "waves") as? SKAudioNode
        
        // MARK: touches
        
        touch1 = childNode(withName: "touch1") as! SKSpriteNode
        touch2 = childNode(withName: "touch2") as! SKSpriteNode
        touch3 = childNode(withName: "touch3") as! SKSpriteNode
        touch4 = childNode(withName: "touch4") as! SKSpriteNode
        
        
        background = childNode(withName: "background") as? SKSpriteNode
        let backgroundSizeWidth = background!.size.width
        control = UIControl(viewWidth: backgroundSizeWidth, cam: cam)
        
        speechLabel = SKLabelNode(text: "")
        speechLabel.zPosition = 101
        
        
        
        speechLabel.position = convert(CGPoint(x: 0, y: submarine.size.height), to: cam)
        
        speechLabel.preferredMaxLayoutWidth = 200
        speechLabel.lineBreakMode = .byCharWrapping
        speechLabel.numberOfLines = 0
        speechLabel.fontName = "AvenirNext-Bold"
        speechLabel.fontSize = 14
        
        cam.addChild(control)
        cam.addChild(speechLabel)
        
        for i in 1...14 {
            mantaTextures.append(SKTexture(imageNamed: "manta\(i)"))
        }
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        submarine.physicsBody?.affectedByGravity = false
        
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
                    submarine.dive()
                    control.rotateValve1()
                case "valve2":
                    submarine.surface()
                    control.rotateValve2()
                case "light-control":
                    submarine.toggleLights()
                default:
                    break
                }
            }
        }
        
        submarine.removeAction(forKey: "restoreRotation")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        submarine.stop()
        control.stopValve1()
        control.stopValve2()
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
    
    func displayEndingText(){
        speechLabel.text = "Thank you for the company and attention 😉"
        speechLabel.startTyping(0.05){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.speechLabel.text = ""
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        submarine.position.x = 0
        
        triggerText(
            triggerPosition: 1600,
            text: "Wow! We just started and there's so many things here below the surface!",
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
            text: "Wait! That's not supposed to be here!",
            isTextUsed: whatsThat,
            toggleTextIndicator: { whatsThat.toggle() }
        )
        
        if submarine.position.y < -640 && !cam.children.contains(where: {$0.name == "light-control"}){
            control.addLightControl()
        } else if submarine.position.y > -640 && cam.children.contains(where: {$0.name == "light-control"}) {
            control.removeLightControl()
            submarine.turnOffLights()
        }
        
        if submarine.position.y > 1860 && children.contains(where: {$0.name == "underwater"})  {
            underwaterSound.removeFromParent()
            self.addChild(wavesSound)
        } else if submarine.position.y < 1860 && children.contains(where: {$0.name == "waves"}) {
            wavesSound.removeFromParent()
            self.addChild(underwaterSound)
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
