import SwiftUI
import SpriteKit

enum ModalTypes {
    case Beginning, EverythingWeCantSee, SongOfTheWhales, WhereLifeHappens, HumanThreat
}

struct ContentView: View, ShowModalDelegate {
    
    @State var showView = false
    @State var currentModalType: ModalTypes?
    @State var currentLevel: Int = 0
    
    mutating func showModal(_ modalType: ModalTypes) {
        self.currentModalType = modalType
        self.showView.toggle()
    }
    
    func closeModal() {
        self.showView.toggle()
    }
    
    func reloadScene(){
        let newScene = SKScene(fileNamed: "OceanScene") as! OceanScene
        newScene.scaleMode = .aspectFill
        newScene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        newScene.showModalDelegate = self
        scene.view?.presentScene(newScene)
    }
    
    var oceanScene = SKScene(fileNamed: "OceanScene") as! OceanScene
    
    var scene: SKScene {
        oceanScene.scaleMode = .aspectFill
        oceanScene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        oceanScene.showModalDelegate = self
        return oceanScene
    }
        
    var body: some View {
        
        let screenWidth  = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        SpriteView(scene: scene)
            .frame(width: screenWidth, height: screenHeight)
            .ignoresSafeArea()
            .sheet(isPresented: $showView) {
                if let currentModal = currentModalType {
                    displayModal(currentModal)
                }
            }
            .onChange(of: currentModalType) { value in currentModalType = value}
    }
    
    @ViewBuilder func displayModal(_ modalType: ModalTypes) -> some View {
        switch modalType {
        case .Beginning:
            BeginningModal(closeModal: closeModal)
        case .EverythingWeCantSee:
            EverythingWeCantSeeModal(closeModal: closeModal)
        case .SongOfTheWhales:
            SongOfTheWhalesModal(closeModal: closeModal)
        case .WhereLifeHappens:
            WhereLifeHappensModal(closeModal: closeModal)
        case .HumanThreat:
            HumanThreatModal(
                backToSurface: {
                    self.oceanScene.submarine.backToSurface()
                    closeModal()
                    self.oceanScene.displayEndingText()
                },
                closeModal: {
                    closeModal()
                    self.oceanScene.displayEndingText()
                }
            )
        }
    }
}
