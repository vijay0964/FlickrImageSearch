//
//  SearchViewController.swift
//  FlickrImageSearch
//
//  Created by VJ on 12/12/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SearchCell"

class SearchViewController: UICollectionViewController {

    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search Photos"
        sb.showsCancelButton = true
        sb.delegate = self
        sb.sizeToFit()
        return sb
    }()
    
    var photos = [Photo]()
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = .black // UIColor(hex: 0x1F2024)
    }
    
    func resetCollectionView() {
        pageNumber = 0
        photos.removeAll()
        collectionView.reloadData()
    }
}

extension SearchViewController {
    func doSearchImages(_ query: String) {
        DataService().getPhotos(query, page: pageNumber) { (result) in
            switch result {
            case .success(let object):
                if let photo = object as? PhotoClass {
                    self.updateSearchImages(photo.photos.photos)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateSearchImages(_ photos: [Photo]) {
        self.photos.append(contentsOf: photos)
        self.collectionView.reloadData()
    }
}

extension SearchViewController {
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row > photos.count - 2 {
            getQueryAndDoSearch()
        }
        
        let photo = photos[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        cell.tag = indexPath.row
        if let url = photo.photoURL() {
            if let image = ImageCache.sharedInstance.getImage(url) {
                cell.imageView.image = image
            } else {
                ImageCache.sharedInstance.loadImage(url) { (image) in
                    if indexPath.row == cell.tag {
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
}


extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSpace: CGFloat = 2.0
        let width = (collectionView.bounds.width / 3) - cellSpace
        return CGSize(width: width, height: width)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getQueryAndDoSearch(true)
    }
    
    func getQueryAndDoSearch(_ isNewSearch: Bool = false) {
        guard let query = searchBar.text else {
            return
        }
        
        if isNewSearch {
            resetCollectionView()
        }
        
        pageNumber += 1
        
        doSearchImages(query)
    }
}
