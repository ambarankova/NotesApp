//
//  NotesListViewController.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 04.08.2024.
//

import UIKit

class NotesListViewController: UITableViewController {
    // MARK: - Properties
    var viewModel: NotesListViewModelProtocol?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        
        setupTableView()
        setupToolBar()
        registerObserver()
        
        viewModel?.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(SimpleNoteTableViewCell.self,
                           forCellReuseIdentifier: "SimpleNoteTableViewCell")
        tableView.register(ImageNoteTableViewCell.self,
                           forCellReuseIdentifier: "ImageNoteTableViewCell")
        
        tableView.separatorStyle = .none
    }
    
    private func setupToolBar() {
        let addButton = UIBarButtonItem(title: "Add note",
                                        style: .done,
                                        target: self,
                                        action: #selector(addAction))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        setToolbarItems([spacing, addButton], animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    @objc private func addAction() {
        let noteViewController = NoteViewController()
        let viewModel = NoteViewModel(note: nil)
        noteViewController.viewModel = viewModel
        navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NSNotification.Name("Update"), object: nil)
    }
    
    @objc private func updateData() {
        viewModel?.getNotes()
    }
}

// MARK: - UITableViewDataSourse
extension NotesListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.section.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.section[section].title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.section[section].items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let note = viewModel?.section[indexPath.section].items[indexPath.row] as? Note
        else { return UITableViewCell() }
        
        if let imageUrl = note.imageURL,
           let cell = tableView.dequeueReusableCell(withIdentifier: "ImageNoteTableViewCell",
                                                    for: indexPath) as? ImageNoteTableViewCell,
           let image = viewModel?.getImage(for: imageUrl) {
            cell.set(note: note, image: image)
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleNoteTableViewCell",
                                                           for: indexPath) as? SimpleNoteTableViewCell {
            cell.set(note: note)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension NotesListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = viewModel?.section[indexPath.section].items[indexPath.row] as? Note
        else { return }
        
        let noteViewController = NoteViewController()
        let viewModel = NoteViewModel(note: note)
        noteViewController.set(note: note)
        noteViewController.viewModel = viewModel
        navigationController?.pushViewController(noteViewController, animated: true)
    }
}
