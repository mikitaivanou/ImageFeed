//
//  ImagesListViewProtocol.swift
//  ImageFeed
//
//  Created by Mikita Ivanou on 25/03/2026.
//

import Foundation

protocol ImagesListViewProtocol: AnyObject {
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func reloadRow(at indexPath: IndexPath)
    func showErrorAlert()
}
