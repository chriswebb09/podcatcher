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
    
    
}

// MARK: - UICollectionViewDelegate

extension SearchResultListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state = .toPlayer
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastResultCell
        
        let model = PodcastResultCellViewModel(podcastTitle: item.episodes[indexPath.row].title)
        cell.configureCell(model: model)
        
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
        menuPop.popView.delegate = self
        menuPop.setupPop()
        showMenu()
    }
    
    func hideMenu() {
        menuActive = .hidden
        menuPop.hideMenu(controller: self)
    }
    
    func showMenu() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        view.addGestureRecognizer(tap)
        collectionView.addGestureRecognizer(tap)
        topView.addGestureRecognizer(tap)
        UIView.animate(withDuration: 0.15) {
            self.menuPop.showPopView(viewController: self)
            self.menuPop.popView.isHidden = false
        }
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
        guard let text = entryPop.popView.entryField.text else { return }
    }
}

// MARK: - MenuDelegate

extension SearchResultListViewController: MenuDelegate {
    
    func optionOneTapped() {
        
    }
    
    func optionTwoTapped() {
        popEntry()
    }
    
    func optionThreeTapped() {
        print("option three")
    }
}
