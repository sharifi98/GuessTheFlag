//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Hossein Sharifi on 06/03/2023.
//

import SwiftUI

// Custom view modifier for flag images
struct FlagImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

// View extension for applying the flag image modifier
extension View {
    func flagImage() -> some View {
        modifier(FlagImageModifier())
    }
}

struct ContentView: View {
    // State variables
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var correctCount = 0
    @State private var spinningFlagIndex: Int?
    
    var body: some View {
        ZStack {
            // Background gradient
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            
            // Main content
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    // Display the flags
                    ForEach(0..<3) { index in
                        Button {
                            flagTapped(index)
                            withAnimation {
                                spinningFlagIndex = index
                            }
                        } label: {
                            Image(countries[index])
                                .flagImage()
                        }
                        .rotation3DEffect(.degrees(spinningFlagIndex == index ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                // Display the score
                Text("Score \(correctCount)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(correctCount)")
        }
    }
    
    // Function to handle flag tap
    func flagTapped(_ index: Int) {
        if index == correctAnswer {
            scoreTitle = "Correct"
            correctCount += 1
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    // Function to present
    
    // Function to present the next question
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        // Reset the spinning flag index so that all flags have full opacity
        spinningFlagIndex = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
