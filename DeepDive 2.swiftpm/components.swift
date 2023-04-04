//
//  components.swift
//  DeepDive
//
//  Created by Danilo Miranda Gusicuma on 20/04/22.
//
import SwiftUI
import AVKit

struct Title: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            .foregroundColor(Color("TextColor"))
            .multilineTextAlignment(.center)
            .lineLimit(nil)
    }
}

struct BodyText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(.body, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
            .foregroundColor(Color("TextColor"))
    }
}

protocol ContainerView: View {
    associatedtype Content
    init(content: @escaping () -> Content)
}

extension ContainerView {
    init(@ViewBuilder _ content: @escaping () -> Content){
        self.init(content: content)
    }
}

struct ModalVStack<Content: View>: ContainerView {
    var content: () -> Content
    var body: some View {
        ScrollView{
            VStack(content: content)
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
        }
    }
}

struct ModalImage: View {
    var imageName: String
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 150, height: 150)
            .padding(EdgeInsets(top: 80, leading: 0, bottom: 16, trailing: 0))
    }
}

struct ModalButton: View {
    var text: String
    var clicked: () -> Void
    var body: some View {
        VStack{
            Button(action: clicked) {
                Text(text)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
            .background(Color.accentColor)
            .cornerRadius(32)
        }
        .padding(EdgeInsets(top: 40, leading: 0, bottom: 40, trailing: 0))
    }
}

struct SecondaryModalButton: View {
    var text: String
    var clicked: () -> Void
    var body: some View {
        VStack{
            Button(action: clicked) {
                Text(text)
                    .fontWeight(.semibold)
            }
            .foregroundColor(Color.accentColor)
            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
            .background(.white)
            .cornerRadius(32)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
    }
}

struct AudioComponent: View {
    
    var soundName: String
    
    @State var isPlaying: Bool = false
    @State var audio: AVAudioPlayer!
    
    var body: some View {
        VStack {
            Button(action: {
                if isPlaying {
                    self.audio.pause()
                    isPlaying.toggle()
                } else {
                    self.audio.play()
                    isPlaying.toggle()
                }
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill").resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear {
            if let path = Bundle.main.url(forResource: soundName, withExtension: "mp3"){
                self.audio = try! AVAudioPlayer(contentsOf: path)
            }
        }
    }
}
