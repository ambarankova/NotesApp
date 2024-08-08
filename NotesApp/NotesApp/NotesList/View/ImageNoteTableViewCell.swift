//
//  ImageNoteTableViewCell.swift
//  NotesApp
//
//  Created by Анастасия Ахановская on 04.08.2024.
//

import UIKit

final class ImageNoteTableViewCell: UITableViewCell {
    
    // MARK: - GUI Variables
    private let containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGreen
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let attachmentView: UIImageView = {
        let view = UIImageView()
        
        view.layer.cornerRadius = 10
        view.image = UIImage(named: "mockImage")
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Title label text"
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func set(note: Note) {
        titleLabel.text = note.title
        setBackgroundColor(note: note)
        guard let imageData = note.image,
                let image = UIImage(data: imageData) else { return }
        attachmentView.image = image
    }
    
    func setBackgroundColor(note: Note) {
        switch note.category {
        case .entertainment: containerView.backgroundColor = .lightYellow
        case .home: containerView.backgroundColor = .lightRed
        case .work: containerView.backgroundColor = .lightBlue
        case .food: containerView.backgroundColor = .lightPink
        case .sport: containerView.backgroundColor = .lightOrange
        case .friends: containerView.backgroundColor = .lightViolet
        case .thoughts: containerView.backgroundColor = .lightGreen
        default: containerView.backgroundColor = .lightGray
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(attachmentView)
        containerView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        attachmentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(attachmentView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
}

