//
//  Model.swift
//  SwiftUIDragDropDemo
//
//  Created by Tariq Almazyad on 01/09/2022.
//

import Foundation
import SwiftUI

struct FoodItem: Identifiable, Hashable, Equatable {
    let id: String = UUID().uuidString
    let imageName: String
    let title: String
    let description: String
}
