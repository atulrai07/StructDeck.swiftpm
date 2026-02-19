//
//  Topic.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//
import SwiftUI
struct Topic: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let gradientColors: [Color]
}
