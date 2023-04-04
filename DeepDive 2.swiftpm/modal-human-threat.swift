import SwiftUI

struct HumanThreatModal: View {
    
    var backToSurface: () -> Void
    var closeModal: () -> Void
    
    var body: some View {
        ModalVStack {
            ModalImage(imageName: "plastic-profile")
            Title(text: "The human threat")
            BodyText(text: "In 2018, a plastic bag was found at the bottom of the deepest trench in the ocean, 10,750 meters deep.")
            BodyText(text: "Not even the most inhospitable and unknown environment on the planet is safe from human action.")
            BodyText(text: "But learning more about the ocean is the first step towards preserving it. You are in the right path!")
            Spacer()
            ModalButton(text: "Back to the surface", clicked: backToSurface)
            SecondaryModalButton(text: "Stay here awhile longer", clicked: closeModal)
        }
    }
}
