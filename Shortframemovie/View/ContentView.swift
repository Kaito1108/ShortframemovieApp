//
//  ContentView.swift
//  ARshortframemovie
//
//  Created by kaito on 2024/06/13.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    ///Thema
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    ///画面遷移
    @State private var shouldShowMovieView: Bool = false
    
    ///NewMovieCreatealert
    @State private var NewMovieCreatealert: Bool = false
    @State var NewMovieTitle: String = ""
    
    ///MovieList
    @State var SelectMovie: MovieModel = MovieModel(Title: "", Coma: [])
    @State var SelectMovieIndex: Int = 0
    @State var MovieList: [MovieModel] = []
                    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: MovieView(Movie: $SelectMovie, MovieList: $MovieList, SelectMovieIndex: SelectMovieIndex), isActive: $shouldShowMovieView) {}
                
                HStack{
                    Button(action: {
                        NewMovieCreatealert = true
                    }){
                        Image(systemName: "photo.badge.plus")
                            .frame(width: 60, height: 60).background(Color.gray.opacity(0.4)).foregroundColor(colorScheme == .dark ? Color.white : Color.black).cornerRadius(50)
                    }.padding()
                    Spacer()
                }
                HStack{
                    Text("Your Create Movie📽️").font(.title).fontWeight(.bold).padding()
                    Spacer()
                }
                ScrollView {
                    ForEach(0..<MovieList.count, id: \.self) { index in
                        Button(action: {
                            SelectMovie = MovieModel(Title: MovieList[index].Title, Coma: MovieList[index].Coma)
                            SelectMovieIndex = index
                            shouldShowMovieView = true
                        }){
                            VStack{
                                Text(MovieList[index].Title).font(.title2).fontWeight(.bold).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            }.frame(width: 300, height: 60).background(Color.gray.opacity(0.5)).cornerRadius(10)
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            if let MovieListData = UserDefaults.standard.data(forKey: "MovieList_Key"),
               let decodedMovie = try? JSONDecoder().decode([MovieModel].self, from: MovieListData) {
                MovieList = decodedMovie
            }
        }
        .alert("新しいムービーを作る", isPresented: $NewMovieCreatealert) {
            TextField("ムービー名", text: $NewMovieTitle).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            
            HStack{
                Button(action: {
                    //ムービーを作成
                    MovieList.append( MovieModel(Title: NewMovieTitle, Coma: []) )
                    
                    //UserDefaultsに保存
                    if let encodedData = try? JSONEncoder().encode(MovieList) {
                        UserDefaults.standard.set(encodedData, forKey: "MovieList_Key")
                    }
                    
                    print(MovieList)
                }){
                    Text("作成")
                }
                Button(action: {
                    //Cancel
                }){
                    Text("キャンセル")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
