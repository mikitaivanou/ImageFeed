//
//  ViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 2.01.26.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    let imagesListService = ImagesListService.shared
    
    private var photos: [Photo] = []
    private let urlSession = URLSession.shared
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private weak var tableView: UITableView!
    private let showSingleImageSigueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == showSingleImageSigueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("InvalidSegueDestination")
                return
            }
            let image = photos[indexPath.row]
            viewController.imageURL = URL(string: image.largeImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    @objc
    func updateTableViewAnimated() {
        
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        
        if oldCount != newCount {
            
            tableView.performBatchUpdates {
                
                let indexPaths = (oldCount..<newCount).map {
                    IndexPath(row: $0, section: 0)
                }
                
                tableView.insertRows(at: indexPaths, with: .automatic)
                
            }
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        
        if let url = URL(string: photo.thumbImageURL) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url) { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } else {
            cell.cellImage.image = nil
        }
        
        
        if let date = photo.createdAt {
            cell.cellDataLabel.text = dateFormatter.string(from: date)
        } else {
            cell.cellDataLabel.text = ""
        }
        
        
        cell.setIsLiked(photo.isLiked)
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSigueIdentifier, sender: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
//        let photo = photos[indexPath.row]
//        
//        if let url = URL(string: photo.thumbImageURL) {
//            imageListCell.cellImage.kf.indicatorType = .activity
//            imageListCell.cellImage.kf.setImage(with: url) { [weak self] _ in
//                guard let self = self else { return }
//                tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
//        }
//        
//        if let date = photo.createdAt {
//            imageListCell.cellDataLabel.text = dateFormatter.string(from: date)
//        } else {
//            imageListCell.cellDataLabel.text = ""
//        }
        
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
        
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}



extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert()
            }
        }
    }
    
    
    
}

extension ImagesListViewController {
    func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Отсуствует возможность продолжить работу",
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "окей", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}
