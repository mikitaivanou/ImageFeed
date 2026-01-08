//
//  ViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 2.01.26.
//

import UIKit

class ImagesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet private var tableView: UITableView!
    func configCell(for cell: ImagesListCell) { }
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
                
                guard let imageListCell = cell as? ImagesListCell else {
                    return UITableViewCell()
                }
                
                configCell(for: imageListCell)
                return imageListCell
    }
    
    
}
