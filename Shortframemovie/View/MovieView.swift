//
//  MovieView.swift
//  ARshortframemovie
//
//  Created by kaito on 2024/06/13.
//

import SwiftUI

struct MovieView: View {
    ///dismiss
    @Environment(\.dismiss) var dismiss
    
    ///画面遷移
    @State private var shouldShowCameraView = false
  
    ///Movie
    @Binding var Movie: MovieModel
    @Binding var MovieList: [MovieModel]
    let SelectMovieIndex: Int
    
    
    ///MovieSpeed
    @State private var MovieSpeed: Double = 0.3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color.gray.opacity(0.2).ignoresSafeArea()
                VStack{
                    PlayView(Coma: $Movie.Coma, MovieSpeed: MovieSpeed)
                }
                VStack{
                    HStack{
                        Button(action: {
                            //保存
                            MovieList[SelectMovieIndex] = Movie
                            
                            //UserDefaultsに保存
                            if let encodedData = try? JSONEncoder().encode(MovieList) {
                                UserDefaults.standard.set(encodedData, forKey: "MovieList_Key")
                            }
                            
                            dismiss()
                        }){
                            Image(systemName: "xmark").frame(width: 60, height: 60).background(Color.white.opacity(0.8)).foregroundColor(Color.black).cornerRadius(50)
                        }.padding()
                        Spacer()
                        Button(action: {
                            shouldShowCameraView = true
                        }){
                            Image(systemName: "camera").frame(width: 60, height: 60).background(Color.white.opacity(0.8)).foregroundColor(Color.black).cornerRadius(50)
                        }.padding()
                    }
                    Spacer()
                    VStack{
                        HStack{
                            Spacer()
                            Text("再生速度").font(.title3).fontWeight(.semibold)
                            Picker("", selection: $MovieSpeed) {
                                Text("0.1秒").tag(0.1)
                                Text("0.2秒").tag(0.2)
                                Text("0.3秒").tag(0.3)
                                Text("0.4秒").tag(0.4)
                                Text("0.5秒").tag(0.5)
                                Text("0.6秒").tag(0.6)
                                Text("0.7秒").tag(0.7)
                                Text("0.8秒").tag(0.8)
                                Text("0.9秒").tag(0.9)
                                Text("1秒").tag(1)
                            }
                        }
                        ScrollView(.horizontal) {
                            HStack{
                                ForEach(0..<Movie.Coma.count, id: \.self) { index in
                                    if let image = Movie.Coma[index] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 75)
                                            .contextMenu {
                                                Button(action: {
                                                    if index >= 0 && index < Movie.Coma.count - 1 {
                                                        let element = Movie.Coma.remove(at: index)
                                                        Movie.Coma.insert(element, at: index + 1)
                                                    }
                                                }){
                                                    Text("画像を1つ前に移動").foregroundColor(Color.red)
                                                }
                                                Button(action: {
                                                    if index > 0 && index < Movie.Coma.count {
                                                        let element = Movie.Coma.remove(at: index)
                                                        Movie.Coma.insert(element, at: index - 1)
                                                    }
                                                }){
                                                    Text("画像を1つ後に移動").foregroundColor(Color.red)
                                                }
                                                Button(action: {
                                                    Movie.Coma.remove(at: index)
                                                }){
                                                    Text("削除").foregroundColor(Color.red)
                                                }
                                            }
                                    }
                                }
                            }
                        }.frame(width: geometry.size.width - 50, height: 90).background(Color.white.opacity(0.7)).cornerRadius(5)
                    }.frame(width: geometry.size.width - 50, height: 140)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $shouldShowCameraView) {
            CameraView(image: $Movie.Coma).ignoresSafeArea()
        }
    }
}
