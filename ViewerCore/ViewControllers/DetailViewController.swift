//
//  DetailViewController.swift
//  AnywhereViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import UIKit

/**
 `DetailViewController` is a `UIViewController` subclass that displays details of a character and adopts the `CharacterSelectionDelegate` protocol for handling character selection events.
 */
class DetailViewController: UIViewController, CharacterSelectionDelegate {
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var placeholderView: UIView!
    
    /// The `RelatedTopic` item to display details for.
    var listItem: RelatedTopic?
    
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        updateDetails()
    }
    
    /**
     Private method to update the view with details of the character. Extracts the character name and description from the text property of the `listItem`, loads the character image from the `icon.url` property of the `listItem`, and updates the view labels and image view with the loaded data.
     */
    private func updateDetails() {
        placeholderView.isHidden = listItem != nil
        let (name, description) = APIService.extractNameAndDescription(from: listItem?.text)
        let imageUrl = listItem?.icon.url ?? ""
        
        DispatchQueue.main.async {
            self.characterNameLabel.text = name
            self.characterDescriptionLabel.text = description
        }
        
        ImageService.downloadImage(from: imageUrl, completion: { image in
            DispatchQueue.main.async {
                self.characterImageView.image = image
            }
        })
        
        characterDescriptionLabel.text = description
    }
    
    /**
     Conformance to the `CharacterSelectionDelegate` protocol. Called when a character is selected, updates the `listItem` property and updates the view details.
     - Parameters:
        - character: The `RelatedTopic` item representing the selected character.
     */
    func characterSelected(_ character: RelatedTopic) {
        listItem = character
        updateDetails()
    }
}
