import UIKit

// MARK: - PodcastCollectionViewProtocol

extension SearchResultListViewController: PodcastCollectionViewProtocol {
    
    func configureTopView() {
        topView.frame = PodcastListConstants.topFrame
        guard let urlString = item.podcastArtUrlString, let url = URL(string: urlString) else { return }
        topView.podcastImageView.downloadImage(url: url)
        topView.delegate = self
        topView.layoutSubviews()
        view.addSubview(topView)
        view.bringSubview(toFront: topView)
        setupView()
        topView.delegate = self
    }
    
    func setupView() {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        collectionView.frame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY + (tabBar.frame.height + 10), width: view.bounds.width, height: view.bounds.height - (topView.frame.height - tabBar.frame.height))
        collectionView.backgroundColor = .clear
    }
}

// MARK: - UIScrollViewDelegate

extension SearchResultListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let updatedTopViewFrame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.2)
        if offset.y > PodcastListConstants.minimumOffset {
            UIView.animate(withDuration: 0.5) {
                self.topView.removeFromSuperview()
                self.topView.alpha = 0
                self.collectionView.frame = self.view.bounds
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                self.topView.frame = updatedTopViewFrame
                self.topView.alpha = 1
                self.topView.layoutSubviews()
                self.view.addSubview(self.topView)
                self.collectionView.frame = CGRect(x: self.topView.bounds.minX,
                                                   y: self.topView.frame.maxY,
                                                   width: self.view.bounds.width,
                                                   height: self.view.bounds.height)
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension SearchResultListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state = .toPlayer
        var caster = Caster()
        caster.artwork = topView.podcastImageView.image
        guard let artist = item.podcastArtist else { return }
        delegate?.didSelectPodcastAt(at: indexPath.row, podcast: item, with: episodes)
        
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastResultCell
        DispatchQueue.main.async {
            if let playTime = self.episodes[indexPath.row].stringDuration {
                let model = PodcastResultCellViewModel(podcastTitle: self.episodes[indexPath.row].title, playtimeLabel: playTime)
                cell.configureCell(model: model)
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchResultListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PodcastListViewControllerConstants.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PodcastListViewControllerConstants.space
    }
}

// MARK: - TopViewDelegate

extension SearchResultListViewController: TopViewDelegate {
    
    func entryPop(popped: Bool) {
        popEntry()
    }
    
    func popBottomMenu(popped: Bool) {
        //print(popped)
        let height = view.bounds.height * 0.5
        let width = view.bounds.width
        let size = CGSize(width: width, height: height)
        let originX = view.bounds.width * 0.001
        let originY = view.bounds.height * 0.45
        let origin = CGPoint(x: originX, y: originY)
        bottomMenu.menu.delegate = self
        bottomMenu.setMenu(size)
        bottomMenu.setMenu(origin)
        bottomMenu.setupMenu()
        bottomMenu.setMenu(color: .mainColor, borderColor: .darkGray, textColor: .white)
        showPopMenu()
    }
    
    func showPopMenu() {
        UIView.animate(withDuration: 0.25) {
            self.bottomMenu.showOn(self.view)
            self.bottomMenu.menu.alpha = 1
        }
    }
    
    func hidePopMenu() {
        bottomMenu.menu.alpha = 0
        bottomMenu.hideFrom(self.view)
    }
    
    func popEntry() {
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.entryPop.showPopView(viewController: strongSelf)
            strongSelf.entryPop.popView.isHidden = false
        }
        entryPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        entryPop.hidePopView(viewController: self)
        guard entryPop.popView.entryField.text != nil else { return }
    }
}

// MARK: - MenuDelegate

extension SearchResultListViewController: MenuDelegate {
    
    func optionOne(tapped: Bool) {
        //
    }
    
    func optionTwo(tapped: Bool) {
        //
    }
    
    func optionThree(tapped: Bool) {
        //
    }
    
    func cancel(tapped: Bool) {
        hidePopMenu()
    }
}
