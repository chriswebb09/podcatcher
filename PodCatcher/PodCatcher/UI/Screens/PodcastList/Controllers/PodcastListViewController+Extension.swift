import UIKit

// MARK: - PodcastCollectionViewProtocol

extension PodcastListViewController: PodcastCollectionViewProtocol {
    
    func configureTopView() {
        topView.frame = PodcastListConstants.topFrame
        topView.podcastImageView.image = dataSource.caster.artwork
        topView.delegate = self
        topView.layoutSubviews()
        view.addSubview(topView)
        view.bringSubview(toFront: topView)
        setupView()
    }
    
    func setupView() {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        collectionView.frame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY + (tabBar.frame.height + 10), width: view.bounds.width, height: view.bounds.height - (topView.frame.height - tabBar.frame.height))
        collectionView.backgroundColor = .clear
        if dataSource.caster.assets.count > 0 {
            view.addSubview(collectionView)
        } else {
            let emptyView = EmptyCastsView(frame: PodcastListConstants.emptyCastViewFrame)
            emptyView.backgroundColor = .white
            emptyView.layoutSubviews()
            view.addSubview(emptyView)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension PodcastListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let updatedTopViewFrame = dataSource.updatedTopViewFrame
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
                self.topView.podcastImageView.image = self.dataSource.caster.artwork
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

extension PodcastListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state = .toPlayer
        delegate?.didSelectPodcastAt(at: indexPath.row, with: dataSource.caster)
    }
}

// MARK: - UICollectionViewDataSource

extension PodcastListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PodcastListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PodcastListViewControllerConstants.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PodcastListViewControllerConstants.space
    }
}

// MARK: - TopViewDelegate

extension PodcastListViewController: TopViewDelegate {
    
    func entryPop(pop: Bool) {
        popEntry()
    }
    
    func popBottomMenu(pop: Bool) {
        menuPop.popView.delegate = self
        menuPop.setupPop()
        showMenu()
    }
    
    func hideMenu() {
        menuActive = .hidden
        menuPop.hideMenu(controller: self)
    }
    
    func showMenu() {
        hideKeyboardWhenTappedAround()
        if dataSource.user != nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
            view.addGestureRecognizer(tap)
            collectionView.addGestureRecognizer(tap)
            topView.addGestureRecognizer(tap)
            UIView.animate(withDuration: 0.15) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.menuPop.showPopView(viewController: strongSelf)
                strongSelf.menuPop.popView.isHidden = false
            }
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
        guard let user = dataSource.user else { return }
        user.customGenres.append(text)
        guard let name = dataSource.caster.name else { return }
        UpdateData.update((name, text))
        user.favoriteCasts[text] = dataSource.caster
        let timeString = String(describing: user.totalTimeListening)
        topView.configure(tags: user.customGenres, timeListen: timeString)
        collectionView.reloadData()
        dataSource.caster.tags.append(text)
    }
}

// MARK: - MenuDelegate

extension PodcastListViewController: MenuDelegate {
    
    func optionOneTapped() {
        guard let user = dataSource.user, let casterName = dataSource.caster.name else { return }
        user.favoriteCasts[casterName] = dataSource.caster
    }
    
    func optionTwoTapped() {
        popEntry()
    }
    
    func optionThreeTapped() {
        print("option three")
    }
}
