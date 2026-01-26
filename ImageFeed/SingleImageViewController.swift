//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 20.01.26.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
