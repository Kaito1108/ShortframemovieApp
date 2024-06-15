//
//  PlayView.swift
//  ARshortframemovie
//
//  Created by kaito on 2024/06/13.
//

import SwiftUI

struct PlayView: View {
    @Binding var Coma: [UIImage?]
    let MovieSpeed: Double
    
    ///Play
    @State var Play = false {
        didSet {
            if Play {
                MoviewPlay()
            } else {
                MovieTimer?.invalidate()
            }
        }
    }
    @State var imageIndex: Int = 0
    @State var MovieTimer: Timer? = nil
    
    var body: some View {
        ZStack{
            Button(action: {
                Play.toggle()
            }){
                VStack{
                    if !Coma.isEmpty {
                        if let image = Coma[imageIndex] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 340, height: 240)
                                .cornerRadius(15)
                        }
                    }
                }.frame(width: 350, height: 250).background(Color.black.opacity(0.4)).cornerRadius(10)
            }
            if !Play {
                Button(action: {
                    Play.toggle()
                }){
                    Image(systemName: "play.fill").frame(width: 80, height: 80).background(Color.white).foregroundColor(Color.black).cornerRadius(50)
                }
            }
        }
        .onDisappear {
            Play = false
        }
    }
    
    func MoviewPlay() {
        MovieTimer = Timer.scheduledTimer(withTimeInterval: MovieSpeed, repeats: true) { _ in
            imageIndex += 1
            //最後の画像が表示されたら最初の画像に戻す
            if imageIndex == Coma.count {
                imageIndex = 0
            }
        }
    }
}
