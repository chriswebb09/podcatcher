//
//  BrowseTopCollectionViewController.swift
//  PodCatcher
//
//  Created by Christopher Webb on 5/13/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

import UIKit

class BrowseTopCollectionViewController: UIViewController {
    var maxScale: CGFloat = 1
    private var startingScrollingOffset = CGPoint.zero
    var minScale: CGFloat = 0.6
    
    var scaledPattern: Pattern = .horizontalLeft
    var maxAlpha: CGFloat = 1.3
    var minAlpha: CGFloat = 0.4
    
    var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CarouselFlowLayout())
    
    weak var delegate: BrowseTopCollectionViewControllerDelegate?
    
    var topItems: [Podcast] = []
    
    var onceOnly = false
    var pageControl: UIPageControl! = UIPageControl(frame: CGRect.zero)
    
    let cellId = "Cell"
    
    var focusedItem = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        collectionView.register(BrowseTopViewCell.self, forCellWithReuseIdentifier: BrowseTopViewCell.reuseIdentifier)
    }
    
    func addCollectionView() {
        let layout = CarouselFlowLayout()
        let frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height - 10)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = Style.Color.Highlight.highlight
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.bounds.width / 1.8, height: view.frame.height / 4)
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = collectionView.contentInset
        let value = (view.frame.size.width - (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        collectionView.contentInset = insets
        collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

extension BrowseTopCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if topItems.count > 3 {
            return BrowseCollectionDataSourceConstants.cellCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseTopViewCell.reuseIdentifier, for: indexPath as IndexPath) as! BrowseTopViewCell
        let index = indexPath.row
        if topItems.count > index - 1 {
            let item = topItems[index]
            if let url = URL(string: item.podcastArtUrlString) {
                DispatchQueue.main.async {
                    cell.podcast = item
                    cell.podcastImageView.downloadImage(url: url)
                }
            }
        }
        return cell
    }
    
    func scrollTo() {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: self.topItems.count / 4, section: 0)
            DispatchQueue.main.async {
                if indexToScrollTo.row > self.topItems.count {
                    self.collectionView.reloadData()
                    return
                }
                self.collectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: true)
                let visibleCells = self.collectionView.visibleCells
                self.scaleCellsForHorizontalScroll(visibleCells: visibleCells)
            }
            self.onceOnly = true
        } else {
            return
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellSize = CGSize(width: view.bounds.width / 2, height: view.frame.height / 4)
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.5
        if velocity.x < 0 {
            factor = -factor
        }
        let itemNumber = Int(scrollView.contentOffset.x / cellSize.width + factor)
        if itemNumber >= topItems.count - 2 || itemNumber < 0 {
            return
        } else {
            let indexPath = IndexPath(row: Int(scrollView.contentOffset.x / cellSize.width + factor), section: 0)
            let index = indexPath.row
            
            if topItems.count <= index ||  0 > index  {
                return
            } else {
                collectionView.scrollToItem(at: indexPath, at:  .left, animated: true)
            }
        }
        delegate?.topItems(loaded: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collection = scrollView as! UICollectionView
        let visibleCells = collection.visibleCells
        scaleCellsForHorizontalScroll(visibleCells: visibleCells)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BrowseTopViewCell
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                       animations: {
                        cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }) { finished in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { finished in
                self.delegate?.goToEpisodeList(podcast: cell.podcast, at: indexPath.row, with: cell.podcastImageView!)
            })
        }
    }
    
    private func scaleCells(distanceFromMainPosition: CGFloat, maximumScalingArea: CGFloat, scalingArea: CGFloat) -> [CGFloat] {
        var preferredScale: CGFloat = 0.0
        var preferredAlpha: CGFloat = 0.0
        let maxScale = self.maxScale
        let minScale = self.minScale
        let maxAlpha = self.maxAlpha
        let minAlpha = self.minAlpha
        if distanceFromMainPosition < maximumScalingArea {
            preferredScale = maxScale
            preferredAlpha = maxAlpha
        } else if distanceFromMainPosition < (maximumScalingArea + scalingArea) {
            let multiplier = abs((distanceFromMainPosition - maximumScalingArea) / scalingArea)
            preferredScale = maxScale - multiplier * (maxScale - minScale)
            preferredAlpha = maxAlpha - multiplier * (maxAlpha - minAlpha)
        } else {
            preferredScale = minScale
            preferredAlpha = minAlpha
        }
        return [ preferredScale, preferredAlpha ]
    }
    
    private func scaleCellsForHorizontalScroll(visibleCells: [UICollectionViewCell]) {
        let scalingAreaWidth = collectionView.bounds.width / 2
        let maximumScalingAreaWidth = (collectionView.bounds.width / 2 - scalingAreaWidth) / 2
        for cell in visibleCells  {
            var distanceFromMainPosition: CGFloat = 0
            switch scaledPattern {
            case .horizontalCenter:
                distanceFromMainPosition = horizontalCenter(cell: cell)
                break
            case .horizontalLeft:
                distanceFromMainPosition = abs(cell.frame.midX - collectionView.contentOffset.x - (cell.bounds.width / 2))
                break
            case .horizontalRight:
                distanceFromMainPosition = abs(collectionView.bounds.width / 2 - (cell.frame.midX - collectionView.contentOffset.x) + (cell.bounds.width / 2))
                break
            }
            let preferredAry = scaleCells(distanceFromMainPosition: distanceFromMainPosition, maximumScalingArea: maximumScalingAreaWidth, scalingArea: scalingAreaWidth)
            let preferredScale = preferredAry[0]
            let preferredAlpha = preferredAry[1]
            cell.transform = CGAffineTransform(scaleX: preferredScale, y: preferredScale)
            cell.alpha = preferredAlpha
        }
    }
    
    private func horizontalCenter(cell: UICollectionViewCell)-> CGFloat {
        return abs(collectionView.bounds.width / 2 - (cell.frame.midX - collectionView.contentOffset.x))
    }
}
