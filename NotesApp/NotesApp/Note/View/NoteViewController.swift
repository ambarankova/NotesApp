//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 05.08.2024.
//

import UIKit

final class NoteViewController: UIViewController, UITextViewDelegate {
    
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
    private let imageHeight = 200
    private var imageName: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
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
        attachmentView.image = viewModel?.image
    }
    
    @objc private func saveAction() {
        viewModel?.save(with: textView.text, and: attachmentView.image, imageName: imageName)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteAction() {
        viewModel?.delete()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
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
        setupBars()
    }
    
    private func setupConstraints() {
        attachmentView.snp.makeConstraints { make in
            let height = attachmentView.image != nil ? imageHeight : 0
            make.height.equalTo(height)
            make.top.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(attachmentView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
    }
    
    private func updateImageHeight() {
        attachmentView.snp.updateConstraints { make in
            make.height.equalTo(imageHeight)
        }
    }
    
    @objc private func hideKeyboard() {
        textView.resignFirstResponder()
    }
    
    private func setupBars() {
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                          target: self,
                                          action: #selector(deleteAction))
        let photoButton = UIBarButtonItem(barButtonSystemItem: .camera,
                                             target: self,
                                             action: #selector(addImage))
        let categoryButton = UIBarButtonItem(title: "Category",
                                             image: nil,
                                             target: self,
                                             action: #selector(chooseCategory))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        guard let vm = viewModel else { return }
        if vm.text.isEmpty {
            setToolbarItems([photoButton, spacing, categoryButton], animated: true)
        } else {
            setToolbarItems([trashButton, spacing, photoButton, spacing, categoryButton], animated: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(saveAction))
    }
}

// MARK: - UIImagePickerControllerDelegate
extension NoteViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage,
              let url = info[.imageURL] as? URL else { return }
        imageName = url.lastPathComponent
        attachmentView.image = selectedImage
        updateImageHeight()
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
