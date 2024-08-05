//
//  TableViewSection.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 04.08.2024.
//

import Foundation

protocol TableViewItemProtocol { }

struct TableViewSection {
    var title: String?
    var items: [TableViewItemProtocol]
}
