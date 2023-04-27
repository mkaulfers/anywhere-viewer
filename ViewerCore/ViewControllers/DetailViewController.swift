//
//  DetailViewController.swift
//  AnywhereViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    
    var listItem: RelatedTopic?
    
    override func viewDidLoad() {
        let (name, description) = APIService.extractNameAndDescription(from: listItem?.text)
        let imageUrl = listItem?.icon.url ?? ""
        
        characterNameLabel.text = name
        
        ImageService.downloadImage(from: imageUrl, completion: { image in
            DispatchQueue.main.async {
                self.characterImageView.image = image
            }
        })
        
        characterDescriptionLabel.text = description
    }
}
