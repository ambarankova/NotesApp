//
//  NotesListViewModel.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 04.08.2024.
//

import Foundation

protocol NotesListViewModelProtocol {
    var section: [TableViewSection] { get }
}

final class NotesListViewModel: NotesListViewModelProtocol {
    private(set) var section: [TableViewSection] = []
    
    init() {
        getNotes()
        setMocks()
    }
    
    private func getNotes() {
        
    }
    
    private func setMocks() {
        let section = TableViewSection(title: "04 Aug 2024",
                                       items: [Note(title: "First note",
                                                    description: "First note description",
                                                    date: Date(),
                                                    imageURL: nil,
                                                    image: nil,
                                                    category: nil),
                                               Note(title: "Second note",
                                                            description: "Second note description",
                                                            date: Date(),
                                                            imageURL: nil,
                                                            image: nil,
                                                            category: .friends)
                                       ])
        self.section = [section]
    }
}
