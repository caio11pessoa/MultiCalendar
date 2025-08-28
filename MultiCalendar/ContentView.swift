//
//  ContentView.swift
//  MultiCalendar
//
//  Created by Caio de Almeida Pessoa on 20/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ScheduleView { arg in
                print(arg)
                // Abrir modal dos eventos da data
            }
        }
        .padding()
        .background(.black)
    }
}

#Preview {
    ContentView()
}
