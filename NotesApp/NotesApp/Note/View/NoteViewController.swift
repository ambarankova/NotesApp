//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 05.08.2024.
//

import UIKit

final class NoteViewController: UIViewController {
    
    // MARK: - GUI Variables
    private let attachmentView: UIImageView = {
        let view = UIImageView()
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let textView: UITextView = {
        let view = UITextView()
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    // MARK: - Properties
    var viewModel: NoteViewModelProtocol?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Methods
    func set(note: Note) {
        textView.text = note.title + " " + (note.description ?? "")
        guard let imageData = note.image,
                let image = UIImage(data: imageData) else { return }
        attachmentView.image = image
    }
    
    // MARK: - Private Methods
    private func configure() {
        textView.text = viewModel?.text
//        guard let imageData = note.image,
//                let image = UIImage(data: imageData) else { return }
//        attachmentView.image = image
    }
    
    @objc private func saveAction() {
        viewModel?.save(with: textView.text)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteAction() {
        viewModel?.delete()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addImage() {
        
    }

    @objc private func chooseCategory() {

    }
    
    private func setupUI() {
        view.addSubview(attachmentView)
        view.addSubview(textView)
        view.backgroundColor = .white
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
        
        textView.layer.borderWidth = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 1 : 0
        
        setupConstraints()
        setImageHeight()
        setupBars()
    }
    
    private func setupConstraints() {
        attachmentView.snp.makeConstraints { make in
            make.top.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(attachmentView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
    }
    
    private func setImageHeight() {
        let height = attachmentView.image != nil ? 200 : 0
            attachmentView.snp.makeConstraints { make in
                make.height.equalTo(height)
        }
    }
    
    @objc private func hideKeyboard() {
        textView.resignFirstResponder()
    }
    
    private func setupBars() {
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                          target: self,
                                          action: #selector(deleteAction))
        let addImageButton = UIBarButtonItem(title: "Add image",
                                             image: nil,
                                             target: self,
                                             action: #selector(addImage))
        let categoryButton = UIBarButtonItem(title: "Category",
                                             image: nil,
                                             target: self,
                                             action: #selector(chooseCategory))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)

        setToolbarItems([trashButton, spacing, addImageButton, spacing, categoryButton], animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveAction))
    }
}
