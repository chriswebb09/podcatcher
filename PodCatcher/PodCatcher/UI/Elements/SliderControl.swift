//
//  SliderControl.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/16/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class SliderControl: UIControl {
    
    static let height: CGFloat = Constants.height + Constants.topBottomMargin * 2
    
    var offsetter: CGFloat = 0
    
    private struct Constants {
        static let height: CGFloat = 40
        static let topBottomMargin: CGFloat = 10
        static let leadingTrailingMargin: CGFloat = 0
    }
    
    weak var delegate: SliderControlDelegate?
    
    var highlightTextColor: UIColor = UIColor.white {
        didSet {
            updateLabelsColor(with: highlightTextColor, selected: true)
        }
    }
    
    var sliderBackgroundColor: UIColor = UIColor(red:0.38, green:0.63, blue:0.80, alpha:1.0) {
        didSet {
            selectedContainerView.backgroundColor = sliderBackgroundColor
            if !isSliderShadowHidden {
                selectedContainerView.layer.setShadow(for: sliderBackgroundColor)
                
            }
        }
    }
    
    var isSliderShadowHidden: Bool = false {
        didSet {
            updateShadow(with: sliderBackgroundColor, hidden: isSliderShadowHidden)
        }
    }
    
    private(set) open var selectedSegmentIndex: Int = 0
    
    private var segments: [String] = []
    
    private var numberOfSegments: Int {
        return segments.count
    }
    
    private var segmentWidth: CGFloat {
        return self.backgroundView.frame.width / CGFloat(numberOfSegments)
    }
    
    private var correction: CGFloat = 2
    
    private lazy var containerView: UIView = UIView()
    private lazy var backgroundView: UIView = UIView()
    private lazy var selectedContainerView: UIView = UIView()
    private lazy var sliderView: SliderView = SliderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        updateLabelsFont(with: UIFont(name: "AvenirNext-Regular", size: 15)!)
        backgroundView.backgroundColor = UIColor.colorFromRGB(237, green: 242, blue: 247, alpha: 0.7)
        
        updateLabelsColor(with: UIColor.gray, selected: false)
        addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedContainerView)
        //containerView.layer.borderWidth = 1
        //containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.addSubview(sliderView)
        
        selectedContainerView.layer.mask = sliderView.sliderMaskView.layer
        addTapGesture()
        addDragGesture()
    }
    
    func setSegmentItems(_ segments: [String]) {
        guard !segments.isEmpty else { fatalError("Segments array cannot be empty") }
        
        self.segments = segments
        configureViews()
        
        clearLabels()
        
        for (index, title) in segments.enumerated() {
            let baseLabel = createLabel(with: title, at: index, selected: false)
            let selectedLabel = createLabel(with: title, at: index, selected: true)
            backgroundView.addSubview(baseLabel)
            selectedContainerView.addSubview(selectedLabel)
        }
        
        setupAutoresizingMasks()
        
    }
    
    private func configureViews() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
            case 1136:
                print("1136")
                containerView.frame = CGRect(x: Constants.leadingTrailingMargin,
                                             y: Constants.height / 10,
                                             width: bounds.width - Constants.leadingTrailingMargin * 3,
                                             height: Constants.height)
            case 1334:
                print("1334")
                containerView.frame = CGRect(x: Constants.leadingTrailingMargin,
                                             y: Constants.height / 40,
                                             width: bounds.width - Constants.leadingTrailingMargin * 3,
                                             height: Constants.height)
                
            case 2208:
                print("2208")
                containerView.frame = CGRect(x: Constants.leadingTrailingMargin,
                                             y: Constants.height / 4,
                                             width: bounds.width - Constants.leadingTrailingMargin * 3,
                                             height: Constants.height)
            default:
                print("default")
                containerView.frame = CGRect(x: Constants.leadingTrailingMargin,
                                             y: Constants.height / 4,
                                             width: bounds.width - Constants.leadingTrailingMargin * 3,
                                             height: Constants.height)
            }
        }
        
        let frame = containerView.bounds
        backgroundView.frame = frame
        
        selectedContainerView.frame = frame
        sliderView.frame = CGRect(x: 2, y: 3, width: segmentWidth, height: backgroundView.frame.height - 6)
        
        let cornerRadius = backgroundView.frame.height / 2.2
            //CGFloat(10)
            //backgroundView.frame.height / 2
        
        sliderView.cornerRadius = cornerRadius
        
        backgroundColor = UIColor.colorFromRGB(237, green: 242, blue: 247, alpha: 0.7)
        
        backgroundView.backgroundColor = UIColor.colorFromRGB(237, green: 242, blue: 247, alpha: 0.7)
        selectedContainerView.backgroundColor = sliderBackgroundColor
        
        if !isSliderShadowHidden {
            selectedContainerView.layer.setShadow(for: sliderBackgroundColor)
        }
        
    }
    
    private func setupAutoresizingMasks() {
        containerView.autoresizingMask = [.flexibleWidth]
        backgroundView.autoresizingMask = [.flexibleWidth]
        selectedContainerView.autoresizingMask = [.flexibleWidth]
        sliderView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
    }
    
    private func updateShadow(with color: UIColor, hidden: Bool) {
        if hidden {
            selectedContainerView.layer.removeShadow()
            sliderView.sliderMaskView.layer.removeShadow()
        } else {
            selectedContainerView.layer.setShadow(for: sliderBackgroundColor)
            sliderView.layer.setShadow(for: .black)
        }
    }
    
    // MARK: Labels
    
    private func clearLabels() {
        backgroundView.subviews.forEach { $0.removeFromSuperview() }
        selectedContainerView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func createLabel(with text: String, at index: Int, selected: Bool) -> UILabel {
        let rect = CGRect(x: CGFloat(index) * segmentWidth, y: 0, width: segmentWidth, height: backgroundView.frame.height)
        let label = UILabel(frame: rect)
        label.text = text
        label.textAlignment = .center
        label.textColor = selected ? highlightTextColor : UIColor.gray
        label.font = UIFont(name: "AvenirNext-Regular", size: 15)!
        label.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        return label
    }
    
    private func updateLabelsColor(with color: UIColor, selected: Bool) {
        let containerView = selected ? selectedContainerView : backgroundView
        containerView.subviews.forEach { ($0 as? UILabel)?.textColor = color }
    }
    
    private func updateLabelsFont(with font: UIFont) {
        selectedContainerView.subviews.forEach { ($0 as? UILabel)?.font = font }
        backgroundView.subviews.forEach { ($0 as? UILabel)?.font = font }
    }
    
    // MARK: Tap gestures
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }
    
    private func addDragGesture() {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        sliderView.addGestureRecognizer(drag)
    }
    
    @objc private func didTap(tapGesture: UITapGestureRecognizer) {
        moveToNearestPoint(basedOn: tapGesture)
    }
    
    @objc private func didPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .cancelled, .ended, .failed:
            moveToNearestPoint(basedOn: panGesture, velocity: panGesture.velocity(in: sliderView))
        case .began:
            correction = panGesture.location(in: sliderView).x - sliderView.frame.width/2
        case .changed:
            let location = panGesture.location(in: self)
            sliderView.center.x = location.x - correction
        case .possible: ()
        }
    }
    
    // MARK: Slider position
    
    private func moveToNearestPoint(basedOn gesture: UIGestureRecognizer, velocity: CGPoint? = nil) {
        var location = gesture.location(in: self)
        if let velocity = velocity {
            let offset = velocity.x / 12
            location.x += offset
        }
        let index = segmentIndex(for: location)
        move(to: index)
        delegate?.didSelect(index)
    }
    
    func move(to index: Int) {
        let correctOffset = center(at: index)
        animate(to: correctOffset)
        
        selectedSegmentIndex = index
    }
    
    private func segmentIndex(for point: CGPoint) -> Int {
        var index = Int(point.x / sliderView.frame.width)
        if index < 0 { index = 0 }
        if index > numberOfSegments - 1 { index = numberOfSegments - 1 }
        if index == numberOfSegments - 1  {
            self.offsetter = -2
        } else if index == 0 {
            self.offsetter = 2
        } else {
            self.offsetter = 0
        }
        return index
    }
    
    private func center(at index: Int) -> CGFloat {
        let xOffset = CGFloat(index) * sliderView.frame.width + sliderView.frame.width / 2
        return xOffset
    }
    
    private func animate(to position: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.sliderView.center.x = position + self.offsetter
        }
    }
}


