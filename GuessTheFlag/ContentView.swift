//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by  Golnar Ghavami on 7/17/20.
//  Copyright © 2020 Arshya Ghavami. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let labels = [
        "Estonia": "Flag with three stripes of equal size. Top Stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of eqaul size. Left stripe blue, middle stripe white, right stripe red."
        // more flag descriptions here
    ]
   @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
  @State  var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var usersScore = 0
    @State private var spin = 0.0
    @State private var opacity = 1.0
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            usersScore += 1
            withAnimation {
                self.spin += 360
                self.opacity = 0.25
            }
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[correctAnswer])"
            usersScore -= 1
            self.opacity = 0
        }
        showingScore = true
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer =  Int.random(in: 0...2)
        self.opacity = 1.0
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                
                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                        //self.opacity = 0.25
                    }) {
                        FlagImage(countryName: self.countries[number])
                    }
                        .opacity(number == self.correctAnswer ? 1 : self.opacity)
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.spin : 0), axis: (x: 0, y: 1, z: 0))
                    .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                }
                
                
                
                Text("\(usersScore)").foregroundColor(.white)
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(usersScore)"), dismissButton: .default(Text("Continue")){
                self.askQuestion()
                })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FlagImage: View {
    var countryName: String
   var body: some View {
        Image(countryName).renderingMode(.original)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
        .shadow(color: .black, radius:  2)
    
        
    }
}
