import UIKit

extension PodcastListViewController: UICollectionViewDelegate {
    
    func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout.invalidateLayout()
        layout.sectionInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 50, height: 50)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    }
    
    // MARK: - Setup navbar UI
    
    func setupNavigationController() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
}

extension PodcastListViewController: UICollectionViewDataSource {
    
    // MARK: - CollectionViewController method implementations
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let caster = caster {
            return caster.assets.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PodcastCell
        if let caster = caster, let artwork = caster.artwork {
            let model = PocastCellModel(podcastImage: artwork, podcastTitle: caster.assets[indexPath.row].title, item: caster.assets[indexPath.row])
            cell.configureCell(model: model)
        }
        return cell
    }
}

extension PodcastListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 10, right: 0)
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // MARK: - Popvoer view implmented
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state = .toPlayer
        delegate?.didSelectTrackAt(at: indexPath.row, with: caster)
    }
}

extension PodcastListViewController: TopViewDelegate {
    
    func entryPop(pop: Bool) {
        popEntry()
    }
    
    func popBottomMenu(pop: Bool) {
        // guard let model = model else { return }
        switch menuActive {
        case .none:
            showMenu()
            menuActive = .active
        case .active:
            dismissMenu()
            menuActive = .hidden
        case .hidden:
            showMenu()
            menuActive = .active
        }
    }
    
    func showMenu() {
        menuPop.popView.delegate = self
        menuPop.setupPop()
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.menuPop.showPopView(viewController: strongSelf)
            strongSelf.menuPop.popView.isHidden = false
        }
    }
    
    func dismissMenu() {
        menuPop.popView.removeFromSuperview()
        menuPop.hidePopView(viewController: self)
        view.sendSubview(toBack: menuPop)
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
        dataSource.user?.customGenres.append(text)
        collectionView.reloadData()
    }
}

extension PodcastListViewController: MenuDelegate {
    
    func optionOneTapped() {
        print("download")
    }
    
    func optionTwoTapped() {
        print("Option two tapped")
    }
    
    func optionThreeTapped() {
        print("option three")
    }
}
