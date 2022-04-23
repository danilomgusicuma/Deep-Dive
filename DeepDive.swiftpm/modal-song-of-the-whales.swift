import SwiftUI
import AVKit

struct SongOfTheWhalesModal: View {
    
    var closeModal: () -> Void
    
    var body: some View {
        ModalVStack {
            ModalImage(imageName: "whale-profile")
            Title(text:"Song of the whales")
            BodyText(text: "Sound in water is 4x faster than in air.")
            BodyText(text: "Because of that, many marine mammals use their voice to communicate underwater.")
            BodyText(text: "Listen to the humpback whale's song.")
            AudioComponent(soundName: "Humpbackwhale")
            Spacer()
            ModalButton(text: "Continue", clicked: closeModal)
        }
    }
}
