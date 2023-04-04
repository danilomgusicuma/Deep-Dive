import SwiftUI

struct WhereLifeHappensModal: View {
    
    var closeModal: () -> Void
    
    var body: some View {
        ModalVStack {
            ModalImage(imageName: "turtle-profile")
            Title(text: "Where life happens")
            BodyText(text: "90% of all ocean biomass is concentrated in the first 200 meters closest to the surface, even though it is less than 2% of how deep the ocean can be.")
            BodyText(text: "This is where most photosynthesis takes place in the oceans.")
            BodyText(text: "At greater depths, light can hardly reach.")
            Spacer()
            ModalButton(text: "Continue", clicked: closeModal)
        }
    }
}
