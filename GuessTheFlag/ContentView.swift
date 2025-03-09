//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Seah Park on 2/22/25.
//

import SwiftUI

struct ImageCapsule: View {
    // ImageCapsule: View!!
    var imageName: String
    
    // var body: some View!!!
    var body: some View {
        Image(imageName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
    }
}
struct Sub: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline.bold()).foregroundStyle(.secondary)
    }
}
struct Footer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2.bold()).foregroundStyle(.white)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    func subStyle() -> some View {
        modifier(Sub())
    }
    func footerStyle() -> some View {
        modifier(Footer())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US", "Korea"]
    @State private var answer = Int.random(in: 0...2)
    @State private var content = ""
    @State private var score = 0
    @State private var showingScore = false
    @State private var gameCount = 0
    var gameEnded: Bool { return gameCount == 8 }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
//            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
//            Text("").frame(maxWidth: .infinity, maxHeight: .infinity).background(.indigo.gradient).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess The Flag").titleStyle().foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of").subStyle()
                        Text(countries[answer]).titleStyle()
                    }
                    
                    ForEach(0..<3){ number in
                        Button {
                            flagTapped(number)
                        } label: {
                            ImageCapsule(imageName: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.regularMaterial)
                .cornerRadius(20)
                
                HStack{
                    Text("Score: \(score)").footerStyle()
                    Spacer()
                    Text("Played: \(gameCount)/8").footerStyle()
                }
                
                Spacer()
            }.padding()
        }
        .alert(content, isPresented: $showingScore) {
            Button(gameEnded ? "Reset" : "Continue", action: gameEnded ? reset : continueGame)
        } message: {
            Text("Score: \(score), Played: \(gameCount)/8")
        }
    }
    
    func flagTapped(_ index: Int) {
        gameCount += 1
        
        if index == answer {
            score += 1
            content = "Correct!"
        } else {
            content = "Wrong! The flag you tapped is for \(countries[index])"
        }
        
        if gameCount == 8 {
            content += " - Game End, "
            if score < 3 {
                content += "Work Hard!"
            } else if score < 6 {
                content += "Good Job!"
            } else {
                content += "Great!!"
            }
        }
        
        showingScore = true
    }
    
    func continueGame() {
        countries.shuffle()
        answer = Int.random(in: 0...2)
    }
    
    func reset() {
        score = 0
        gameCount = 0
        continueGame()
    }
    
}

#Preview {
    ContentView()
}
