//
//  CreateView.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 23.12.2021.
//

import SwiftUI

struct CreateView: View {
    
    @State private var isActive = false
    
    var body: some View {
        ScrollView {
            VStack {
                DropdownView()
                DropdownView()
                DropdownView()
                DropdownView()
                Spacer()
                
                NavigationLink(destination: RemindView(), isActive: $isActive) {
                    
                    Button(action: {
                        isActive = true
                    }) {
                        Text("Next")
                            .font(.system(size: 24, weight: .medium))
                    }
                }
            }.navigationTitle("Create")
                .navigationBarHidden(true)
                .padding(.bottom, 15)
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
