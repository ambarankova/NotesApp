//
//  Note.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 04.08.2024.
//

import UIKit

enum Category {
    case home
    case work
    case food
    case entertainment
    case sport
    case friends
    case thoughts
}

struct Note: TableViewItemProtocol {
    let title: String
    let description: String
    let date: Date
    let imageURL: String?
    let image: Data?
    let category: Category?
}
