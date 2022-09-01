//
//  ContentView.swift
//  SwiftUIDragDropDemo
//
//  Created by Tariq Almazyad on 01/09/2022.
//

import SwiftUI
import UniformTypeIdentifiers
final class DraggableGridViewModel: ObservableObject {
    @Published var foods: [FoodItem]
    @Published var selectedDraggingItem: FoodItem?
    @Published var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 160, maximum: 200),
                                                                spacing: 20, alignment: .top), count: 2)
    init(){
        foods = [
            .init(imageName: "Blazed Croissant", title: "Blazed Croissant", description: ""),
            .init(imageName: "Blazed Donouts", title: "Blazed Donouts", description: ""),
            .init(imageName: "Chocolate Croissant", title: "Chocolate Croissant", description: ""),
            .init(imageName: "Creamy Donouts", title: "Creamy Donouts", description: ""),
            .init(imageName: "Croissant with Nuts", title: "Croissant with Nuts", description: ""),
            .init(imageName: "Donouts with sparkles", title: "Donouts with sparkles", description: ""),
            .init(imageName: "Machhiato Espresso", title: "Machhiato Espresso", description: ""),
            .init(imageName: "Mocha Espresso", title: "Mocha Espresso", description: ""),
        ]
    }
    
}

struct ContentView: View {
    @StateObject var viewModel = DraggableGridViewModel()
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: viewModel.columns, spacing: 30) {
                    ForEach($viewModel.foods) { $foodItem in
                        VStack{
                            Image(foodItem.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(foodItem.title)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.6)
                            Spacer()
                        }
                        .onDrag {
                            self.viewModel.selectedDraggingItem = foodItem
                            return NSItemProvider(object: String(foodItem.id) as NSString)
                        }
                        .onDrop(of: [UTType.text],
                                delegate: OnDragDelegate(foodItem: foodItem,foods: $viewModel.foods, currentSelectedItem: $viewModel.selectedDraggingItem))
                        
                    }
                }.animation(.spring(), value: viewModel.foods)
                    .padding(.top, 34)
            }.onDrop(of: [UTType.text], delegate: OnDropDelegate(currentItem: $viewModel.selectedDraggingItem))
                .navigationTitle("Draggable View")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct OnDropDelegate: DropDelegate {
    @Binding var currentItem: FoodItem?
    func performDrop(info: DropInfo) -> Bool {
        currentItem = nil
        return true
    }
}

struct OnDragDelegate: DropDelegate {
    let foodItem: FoodItem
    @Binding var foods: [FoodItem]
    @Binding var currentSelectedItem: FoodItem?

    func dropEntered(info: DropInfo) {
        if foodItem != currentSelectedItem {
            if let currentSelectedItem = currentSelectedItem {
                guard let fromIndex = foods.firstIndex(of: currentSelectedItem) else {return}
                guard let to = foods.firstIndex(of: foodItem) else {return}
                if foods[to].id != currentSelectedItem.id {
                    foods.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: to > fromIndex ? to + 1 : to)
                }
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.currentSelectedItem = nil
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
