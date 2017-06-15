import UIKit



// MARK: - PodcastCollectionViewProtocol

extension PodcastListViewController: PodcastCollectionViewProtocol {
    
    func setup() {
        edgesForExtendedLayout = []
        setup(dataSource: self, delegate: self)
    }
    
    func configureTopView() {
        topView.frame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.3)
        if let caster = caster {
              topView.podcastImageView.image = caster.artwork
        }
        topView.delegate = self
        topView.layoutSubviews()
        view.addSubview(topView)
        setupView()
        topSetup()
    }
    
    func setupView() {
        collectionView.frame = CGRect(x: topView.bounds.minX, y: topView.frame.maxY, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight)
        if let caster = caster, caster.assets.count > 0 {
            view.addSubview(collectionView)
        } else {
            let emptyView = EmptyCastsView(frame: CGRect(x: topView.bounds.minX, y: topView.frame.maxY, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight + 10))
            emptyView.backgroundColor = .white
            view.backgroundColor = .white
            emptyView.layoutSubviews()
            view.addSubview(emptyView)
        }
    }
    
    func topSetup() {
        guard let user = dataSource.user else { return }
        var tagviews = [PillView]()
        for item in caster.tags {
            let pill = PillView()
            pill.configure(tag: item)
            tagviews.append(pill)
            DispatchQueue.main.async {
                self.topView.tags.configure(pills: tagviews)
            }
        }
        topView.playCountLabel.text = String(describing: user.totalTimeListening)
    }
}

// MARK: - UIScrollViewDelegate

extension PodcastListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.y > PodcastListConstants.minimumOffset {
            UIView.animate(withDuration: 0.02) {
                self.topView.removeFromSuperview()
                self.collectionView.frame = self.view.bounds
                self.view.updateConstraintsIfNeeded()
                self.collectionView.updateConstraintsIfNeeded()
                self.collectionView.setNeedsLayout()
            }
        } else {
            UIView.animate(withDuration: 0.05) {
                self.topView.frame = CGRect(x: 0, y: 0, width: PodcastListConstants.topFrameWidth, height: PodcastListConstants.topFrameHeight / 1.5)
                self.topView.podcastImageView.image = self.caster.artwork
                self.topView.layoutSubviews()
                self.view.addSubview(self.topView)
                self.collectionView.frame = CGRect(x: self.topView.bounds.minX, y: self.topView.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height)
                self.collectionView.updateConstraintsIfNeeded()
            }
        }
    }
    
    // MARK: - Setup navbar UI
    
//    func setupNavigationController() {
//        navigationController?.navigationBar.titleTextAttributes = PodcastListConstants.navFont
//        navigationController?.navigationBar.barTintColor = UIColor.black
//    }
}

// MARK: - UICollectionViewDelegate

extension PodcastListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state = .toPlayer
        delegate?.didSelectPodcastAt(at: indexPath.row, with: caster)
    }
}

// MARK: - UICollectionViewDataSource

extension PodcastListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let caster = caster {
            return caster.assets.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastCell
        if let caster = caster, let artwork = caster.artwork {
            let model = PodcastCellViewModel(podcastImage: artwork, podcastTitle: caster.assets[indexPath.row].title, item: caster.assets[indexPath.row])
            cell.configureCell(model: model)
        }
        return cell
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
        switch menuActive {
        case .none:
            showMenu()
            menuActive = .active
        case .active:
            menuActive = .hidden
            menuPop.hidePopView(viewController: self)
            menuPop.popView.removeFromSuperview()
        case .hidden:
            showMenu()
            menuActive = .active
        }
    }
    
    func hideMenu() {
        menuActive = .hidden
        menuPop.hidePopView(viewController: self)
        menuPop.popView.removeFromSuperview()
    }
    
    func showMenu() {
        if dataSource.user != nil {
            menuPop.popView.delegate = self
            menuPop.setupPop()
            var tap = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
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
        self.hideKeyboardWhenTappedAround()
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
        dataSource.user?.customGenres.append(text)
        guard let name = caster.name else { return }
        UpdateData.update((name, text))
        topSetup()
        // topView.podcastTitleLabel.text = dataSource.user?.customGenres.last
        collectionView.reloadData()
        caster.tags.append(text)
    }
}

// MARK: - MenuDelegate

extension PodcastListViewController: MenuDelegate {
    
    func optionOneTapped() {
        guard let user = dataSource.user, let casterName = dataSource.casters[index].name else { return }
        user.favoriteCasts[casterName] = caster
        print("download")
    }
    
    func optionTwoTapped() {
        popEntry()
        print("Option two tapped")
    }
    
    func optionThreeTapped() {
        print("option three")
    }
}
