//
//  ChallengeItemView.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 10.01.2022.
//

import SwiftUI

struct ChallengeItemView: View {
    private let viewModel: ChallengeItemViewModel
    init(_ viewModel: ChallengeItemViewModel) {
        self.viewModel = viewModel
    }
    
    var titleRow: some View {
        HStack {
        Text(viewModel.title)
            .font(.system(size: 24, weight: .bold))
            Spacer()
            Image(systemName: "trash").onTapGesture {
                viewModel.send(action: .delete)
            }
        }
    }
    
    var dailyIncreaseRow: some View
    {
        HStack {
            Text(viewModel.dailyIncreaseText)
                .font(.system(size: 24, weight: .bold))
            Spacer()
        }
    }
    
    var todayView: some View {
        Group {
            Divider()
            Text(viewModel.todayTitle)
                .font(.title3)
                .fontWeight(.medium)
            Text(viewModel.todayRepTitle)
                .font(.system(size: 24, weight: .bold))
            Button(action: {
                viewModel.send(action: .toggleComplete)
            }) {
                Text(viewModel.isDayComplete || viewModel.isComplete ? "Завершено" : "Выполнено")
            }
            .disabled(viewModel.isComplete)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .font(Font.caption.weight(.semibold))
            .background(viewModel.isDayComplete ? Color.circleTrack : Color.primaryButton)
            .cornerRadius(8)
        }
    }
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing:25) {
                titleRow
                ProgressCircleView(viewModel: viewModel.progressCircleViewModel)
                dailyIncreaseRow
                todayView
            }.padding(.vertical, 10)
            Spacer()
        }.background(Rectangle().fill(Color.primaryButton).cornerRadius(5))
    }
}
