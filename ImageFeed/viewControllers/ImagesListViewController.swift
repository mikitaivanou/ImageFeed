//
//  ViewController.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 2.01.26.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var presenter: ImagesListPresenterProtocol!
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("InvalidSegueDestination")
                return
            }
            
            let image = presenter.photo(at: indexPath)
            viewController.imageURL = URL(string: image.largeImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let url = presenter.imageURL(for: indexPath) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url) { [weak self] _ in
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } else {
            cell.cellImage.image = nil
        }
        
        cell.cellDataLabel.text = presenter.formattedDate(for: indexPath) ?? ""
        cell.setIsLiked(presenter.photo(at: indexPath).isLiked)
    }
}

extension ImagesListViewController: ImagesListViewProtocol {
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        guard oldCount != newCount else { return }
        
        let indexPaths = (oldCount..<newCount).map {
            IndexPath(row: $0, section: 0)
        }
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Отсуствует возможность продолжить работу",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: "Окей", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter.heightForRow(at: indexPath, tableViewWidth: tableView.bounds.width)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.photosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if ProcessInfo.processInfo.arguments.contains("FIRST_PAGE_ONLY") {
                return
            }
        if indexPath.row == presenter.photosCount - 1 {
            presenter.didScrollToLastCell()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        presenter.didTapLike(at: indexPath) { [weak self] isSuccess in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            if isSuccess {
                let updatedPhoto = self.presenter.photo(at: indexPath)
                cell.setIsLiked(updatedPhoto.isLiked)
            }
        }
    }
}
