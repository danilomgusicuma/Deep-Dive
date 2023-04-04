import SwiftUI

struct BeginningModal: View {
    
    var closeModal: () -> Void
    
    var body: some View {
        ModalVStack {
            ModalImage(imageName: "surface-profile")
            Title(text: "The Beginning of the Adventure")
            BodyText(text: "Oceans cover more than two thirds of the Earth's surface, and around 80% of them still remain unexplored.")
            BodyText(text: "Let's see what awaits us on this adventure!")
            BodyText(text: "Click and hold the valves to dive or surface.")
            BodyText(text: "Remember that everytime you see a '!' symbol above something, click on it to learn more about.")
            Spacer()
            ModalButton(text: "Let's dive!", clicked: closeModal)
        }
    }
}
