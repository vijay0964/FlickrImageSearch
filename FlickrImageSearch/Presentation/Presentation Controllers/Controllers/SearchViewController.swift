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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = .black // UIColor(hex: 0x1F2024)
    }
    
    func resetCollectionView() {
        photos.removeAll()
        collectionView.reloadData()
    }
}

extension SearchViewController {
    func searchImages(_ query: String) {
        DataService().getPhotos(query) { (result) in
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
        let photo = photos[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        if let url = photo.photoURL() {
            ImageCache.sharedInstance.loadImage(url) { (image) in
                if image != nil {
                    cell.imageView.image = image
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
        
        guard let query = searchBar.text else {
            return
        }
        
        resetCollectionView()
        
        searchImages(query)
    }
}

extension SearchViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            searchImages("kitten")
        }
    }
}
