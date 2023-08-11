//
//  ContentView.swift
//  MC3_FullApp
//
//  Created by Michael Wijaya Sutrisna on 08/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        @ObservedObject var arDelegate = ARDelegate()
        
        NavigationStack {
            VStack {
                Text("Apple Feature Apps")
                    .font(.title)
                    .padding(.bottom)
                
                NavigationLink(destination: {
                    ARViewRepresentable(arDelegate: arDelegate, theItem: 1) // Card Flip Game
                }, label: {
                    Text("Card Flip Feature")
                })
                .padding(.bottom)
                
                NavigationLink(destination: {
                    ARViewRepresentable(arDelegate: arDelegate, theItem: 2) // Card Flip Game
                }, label: {
                    Text("Robot Feature")
                })
                .padding(.bottom)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
