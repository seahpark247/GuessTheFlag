//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Seah Park on 2/22/25.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

struct SubTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline.bold())
            .foregroundColor(.secondary)
    }
}

struct AnswerTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
    }
}

struct MainWrapper: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .cornerRadius(20)
    }
}

struct StatusText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2.bold())
            .foregroundColor(.white)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    
    func subtitleStyle() -> some View {
        modifier(SubTitle())
    }
    
    func answerTitleStyle() -> some View {
        modifier(AnswerTitle())
    }
    
    func mainWrapperStyle() -> some View {
        modifier(MainWrapper())
    }
    
    func statusStyle() -> some View {
        modifier(StatusText())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US", "Korea"].shuffled()
    @State private var answer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var showingScore = false
    @State private var content: String = ""
    @State private var played = 0

    var body: some View {
        ZStack {
            Text("").frame(maxWidth: .infinity, maxHeight: .infinity).background(.indigo.gradient)
            
//            RadialGradient(stops: [
//                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
//                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
//            ], center: .top, startRadius: 200, endRadius: 700)
//            .ignoresSafeArea()
//
//            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack {
                Text("Guess The Flag").titleStyle()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of").subtitleStyle()
                        Text(countries[answer]).answerTitleStyle()
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                    }
                }.mainWrapperStyle()
                
                HStack {
                    Text("Score: \(score)")
                    Spacer()
                    Text("Played: \(played)/8")
                }.statusStyle()
            }.padding()
        }.alert(content, isPresented: $showingScore) {
            Button(played == 8 ? "Restart" : "Continue", action: played == 8 ? resetGame : continueGame)
        } message: {
            Text("Your score is: \(score), played: \(played)/8")
        }
    }

    func flagTapped(_ number: Int) {
        played += 1
        
        if number == answer {
            score += 1
            content = "Correct!"
        } else {
            content = "Wrong! The flag you tapped was for \"\(countries[number])\""
        }
        
        if played == 8 {
            content += " -And Game Over."
            
            if score < 4 {
                content += " Work Hard!"
            } else if score < 7 {
                content += " Good Job!"
            } else {
                content += " Excellent!"
            }
        }
        
        showingScore = true
    }
    
    func continueGame() {
        // countries.shuffle()!!!
        countries.shuffle()
        answer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        score = 0
        played = 0
        continueGame()
    }
    
}
   
#Preview {
    ContentView()
}
