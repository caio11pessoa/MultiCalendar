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
            }
        }
        .padding()
        .background(.black)
    }
}

#Preview {
    ContentView()
}
