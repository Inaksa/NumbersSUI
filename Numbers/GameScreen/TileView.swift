//
//  TileView.swift
//  Numbers
//
//  Created by Alex Maggio on 20/12/2024.
//

import SwiftUI

struct TileView: View {
    @EnvironmentObject var processor: Processor

    let tile: Tile
    var body: some View {
        ZStack {
            switch tile {
            case .symbol(let symbol):
                Text("\(symbol)")
                    .font(.custom(Styles.fontName, size: 35))
            case .empty:
                EmptyView()
            }
        }
        .padding()
        .frame(
            maxWidth: (UIApplication.shared.keyWindow?.screen.bounds.width ?? 300) * 0.8 / CGFloat(processor.difficulty.gameSize.columns),
            maxHeight: (UIApplication.shared.keyWindow?.screen.bounds.width ?? 300) * 0.8 / CGFloat(processor.difficulty.gameSize.rows)
        )
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1.0, contentMode: .fill)
        .background(tile != .empty ? .white : .clear)
        .overlay(alignment: .bottom, content: {
            if tile != .empty {
                Color.black.opacity(0.5).frame(height: 4)
            }

        })
        .clipShape(RoundedRectangle(cornerRadius: Styles.CornerRadius.small))
        .transition(
            .asymmetric(
                insertion: .scale.animation(.spring()),
                removal: .scale.animation(.spring())
            )
        )

    }
}

#Preview {
    VStack(spacing: 8) {
        TileView(tile: .symbol(1))
            .border(Color.black, width: 2)
        TileView(tile: .empty)
            .border(Color.black, width: 2)
    }
}
