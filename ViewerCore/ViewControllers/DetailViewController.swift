//
//  DetailViewController.swift
//  AnywhereViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import UIKit

class DetailViewController: UIViewController, CharacterSelectionDelegate {
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var placeholderView: UIView!
    
    var listItem: RelatedTopic?
    
    override func viewDidLoad() {
        updateDetails()
    }
    
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
    
    func characterSelected(_ character: RelatedTopic) {
        listItem = character
        updateDetails()
    }
}
