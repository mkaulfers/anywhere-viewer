//
//  CharacterCell.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import UIKit

/// A table view cell for displaying information about a character, including an image, name, and description.
class CharacterCell: UITableViewCell {
    
    /// The data model for the cell, which includes information about the character to be displayed.
    typealias CharInfo = RelatedTopic
    
    /// The character data to be displayed in the cell.
    var listItem: CharInfo? {
        didSet {
            let imageUrlString = listItem?.icon.url
            let (name, description) = APIService.extractNameAndDescription(from: listItem?.text)
            
            if let imageUrlString {
                characterImage.image = UIImage(systemName: "person.circle")
                
                ImageService.downloadImage(from: imageUrlString) { image in
                    DispatchQueue.main.async {
                        self.characterImage.image = image
                    }
                }
            }
            
            if let name { titleLabel.text = name }
            if let description { shortDescriptionLabel.text = description }
        }
    }
    
    /// The image view for displaying the character's image.
    private let characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// The label for displaying the character's name.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name Unknown"
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The label for displaying a short description of the character.
    private let shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.italicSystemFont(ofSize: 8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Initializes a new instance of the cell with the given style and reuse identifier.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(characterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(shortDescriptionLabel)
        
        NSLayoutConstraint.activate([
            characterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterImage.widthAnchor.constraint(equalToConstant: 50),
            characterImage.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, shortDescriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: characterImage.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: characterImage.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
