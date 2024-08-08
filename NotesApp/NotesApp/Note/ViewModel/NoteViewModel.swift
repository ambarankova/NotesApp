//
//  NoteViewModel.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 06.08.2024.
//

import Foundation

protocol NoteViewModelProtocol {
    var text: String { get }
    
    func delete()
    func save(with text: String)
}

final class NoteViewModel: NoteViewModelProtocol {
    let note: Note?
    var text: String {
        let text = (note?.title ?? "") + "\n\n" + (note?.description?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(note: Note?) {
        self.note = note
    }
    
    // MARK: - Methods
    func save(with text: String) {
        let date = note?.date ?? Date()
        let (title, description) = createTitleAndDescription(from: text)
        
        let note = Note(title: title,
                        description: description,
                        date: date,
                        imageURL: nil)
        NotePersistant.save(note)
    }
    
    func delete() {
        guard let note = note else { return }
        NotePersistant.delete(note)
    }
    
    // MARK: - Private Methods
    private func createTitleAndDescription(from text: String) -> (String, String?) {
        var description = text
        
        guard let index = description.firstIndex(where: { $0 == "." ||
            $0 == "!" ||
            $0 == "?" ||
            $0 == "\n" })
        else {
            return (text, nil)
        }
        
        let title = String(description[...index])
        description.removeSubrange(...index)
        
        return (title, description)
    }
}
