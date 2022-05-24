//
//  ContentView.swift
//  OHD Edutainment Challenge Project
//
//  Created by Philipp Mergener on 5/20/22.
//

import SwiftUI


struct PracticeView: View {
    public var userLevel: Int
    @State private var userAnswer: Int = 0
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("number1")
                    Text("number2")
                }
                Image(systemName: "equal.circle.fill")
                TextField("Answer", value: $userAnswer, format: .number)
                    .keyboardType(.numberPad)
            }
        }
    }
}

struct StartView: View {
    @State private var levelSelection = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    @State private var level = 0
    @State private var showingPracticeView = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Which multiplication level do you want to practice?")
                Picker("dificulty selection", selection: $level) {
                    ForEach(levelSelection, id: \.self) {
                        Text("\($0)")
                    }
                    .labelsHidden()
                }
                Button {
                    showingPracticeView.toggle()
                } label: {
                    Text("Go")
                }
            }
            .navigationTitle("Multi Practice")
            .sheet(isPresented: $showingPracticeView) {
                let practiceView = PracticeView(userLevel: levelSelection[level])
                practiceView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
