//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

import Foundation
import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewProtocol? { get set }
    var photosCount: Int { get }
    
    func viewDidLoad()
    func photo(at indexPath: IndexPath) -> Photo
    func imageURL(for indexPath: IndexPath) -> URL?
    func formattedDate(for indexPath: IndexPath) -> String?
    func didTapLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void)
    func didScrollToLastCell()
    func heightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat
}
