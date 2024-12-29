//
//  BoardView.swift
//  Numbers
//
//  Created by Alex Maggio on 20/12/2024.
//
import SwiftUI

struct BoardView: View {
    enum Configuration {
        static let boardBackground = Color.orange
    }
    @EnvironmentObject var processor: Processor

    @Namespace var animationNamespace

    var body: some View {
        Grid(alignment: .topLeading, horizontalSpacing: 4, verticalSpacing: 4) {
            let maxRows: Int = processor.board.rows
            let maxColumns: Int = processor.board.columns
            ForEach(0 ..< maxRows, id: \.self) { row in
                GridRow {
                    ForEach(0 ..< maxColumns, id: \.self) { column in
                        let position = Position(row: row, column: column)
                        if let tile = processor.board.getTile(at: position) {
                            TileView(tile: tile)
                                .environmentObject(processor)
                                .matchedGeometryEffect(id: tile, in: animationNamespace)
                                .transition(.asymmetric(insertion: .scale, removal: .slide))
                                .onTapGesture {
                                    if tile != .empty {
                                        print("Did tap on tile: \(tile)")
                                        processor.perform(.tapOnTile(tile))
                                        AudioManager.shared.playSound(.tap)
                                    }
                                }

                        } else {
                            TileView(tile: .empty)
                                .environmentObject(processor)
                        }
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: Styles.CornerRadius.medium)
                .fill(Configuration.boardBackground)
        }
        .padding()
    }
}

#Preview {
    let coordinator = AppCoordinator()
    let processor = Processor(coordinator: coordinator)

    BoardView()
        .environmentObject(processor.coordinator)
        .environmentObject(processor)
}
