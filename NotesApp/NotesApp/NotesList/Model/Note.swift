//
//  Note.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 04.08.2024.
//

import Foundation

struct Note: TableViewItemProtocol {
    let title: String
    let description: String
    let date: Date
    let imageURL: String?
    let image: Data?
}
