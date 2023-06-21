//
//  CapturedImageView.swift
//  RomaMVVM
//
//  Created by User on 22.03.2023.
//

import Foundation
import UIKit

class CapturedImageView: UIView {
    // MARK: - Vars

    var image: UIImage? {
        didSet {
            guard let image = image else { return }
            imageMain.image = image
        }
    }

    // MARK: - Subviews

    lazy var imageMain: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray4
        image.contentMode = .scaleAspectFill
        return image
    }()

    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.minimumZoomScale = 1
        scroll.maximumZoomScale = 1.5
        scroll.setZoomScale(2, animated: true)
        scroll.bouncesZoom = false
        return scroll
    }()

    lazy var cropView: CropView = {
        let view = CropView()
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)
        scrollView.delegate = self
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        addSubview(containerView) {
            $0.edges.equalToSuperview()
        }

        containerView.addSubview(scrollView) {
            $0.edges.equalToSuperview()
        }

        scrollView.addSubview(imageMain) {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
        }

        cropView.backgroundColor = .clear

        scrollView.addSubview(cropView) {
            $0.trailing.equalTo(containerView.snp.trailing)
            $0.leading.equalTo(containerView.snp.leading)
            $0.center.equalTo(containerView.snp.center)
            $0.height.equalTo(self.snp.width)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension CapturedImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageMain
    }
}

final class CropView: UIView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Draw
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(bounds.width / 2)
        context.setStrokeColor(CGColor(red: 0, green: 0, blue: 0, alpha: 0.6))
        context.setFillColor(UIColor.clear.cgColor)
        context.addArc(center: CGPoint(x: bounds.width / 2, y: bounds.height / 2 ),
                       radius: bounds.width - (bounds.width * 0.25),
                       startAngle: .pi / 2,
                       endAngle: 2 * .pi,
                       clockwise: false)
       
        context.addArc(center: CGPoint(x: bounds.width / 2, y: bounds.height / 2 ),
                       radius: bounds.width - (bounds.width * 0.25),
                       startAngle: 2 * .pi,
                       endAngle: .pi / 2,
                       clockwise: false)
        context.drawPath(using: CGPathDrawingMode.fillStroke)
    }
}
