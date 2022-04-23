import SwiftUI

struct HumanThreatModal: View {
    
    var closeModal: () -> Void
    
    var body: some View {
        ModalVStack {
            ModalImage(imageName: "plastic-profile")
            Title(text: "The human threat")
            BodyText(text: "In 2018, a plastic bag was found at the bottom of the deepest trench in the ocean, 10,750 meters deep.")
            BodyText(text: "Not even the most inhospitable and unknown environment on the planet is safe from human action.")
            Spacer()
            ModalButton(text: "Back to the surface", clicked: closeModal)
        }
    }
}
