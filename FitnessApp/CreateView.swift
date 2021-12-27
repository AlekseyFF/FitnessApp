//
//  CreateView.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 23.12.2021.
//

import SwiftUI

struct CreateView: View {
    
    @StateObject var viewModel = CreateChallengeViewModel()
    
    var dropdownList: some View {
        Group {
            DropdownView(viewModel: $viewModel.exerciseDropdown)
            DropdownView(viewModel: $viewModel.startAmountDropdown)
            DropdownView(viewModel: $viewModel.increaseDropdown)
            DropdownView(viewModel: $viewModel.lengthDropdown)
        }
//        ForEach(viewModel.dropdowns.indices, id: \.self) { index in
//            DropdownView(viewModel: $viewModel.dropdowns[index])
//        }
    }
    
    
    
    var body: some View {
        ScrollView {
            VStack {
                dropdownList
                Spacer()
                
                Button(action: {
                    viewModel.send(.createChallenge)
                }) {
                    Text("Create")
                        .font(.system(size: 24, weight: .medium))
                }
                
            }
            .navigationTitle("Create")
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
