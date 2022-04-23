import SwiftUI

struct EverythingWeCantSeeModal: View {
    
    var closeModal: () -> Void
    
    var body: some View {
        ModalVStack {
            ModalImage(imageName: "jellyfish-profile")
            Title(text: "Everything we can't see")
            BodyText(text: "After 1000 meters of depth, there is no more sunlight. The darkness is complete.")
            BodyText(text: "Therefore, various creatures make their own light for camouflage, predation, and communication.")
            BodyText(text: "This is called bioluminescence.")
            Spacer()
            ModalButton(text: "Continue", clicked: closeModal)
        }
    }
}
