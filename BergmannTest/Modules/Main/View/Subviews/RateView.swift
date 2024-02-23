//
//  RateView.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 22.02.2024.
//

import Foundation
import UIKit

protocol RateViewDelegate: AnyObject {
    func didTapRateView(with type: RateViewType)
}

enum RateViewType {
    case from
    case to
}

final class RateView: UIView {
    
    // MARK: - Public Properties

    weak var delegate: RateViewDelegate?

    // MARK: - Private Properties

    private let type: RateViewType
    
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    
    // MARK: - Init
    
    init(with type: RateViewType) {
        self.type = type

        super.init(frame: .zero)
        
        drawSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Drawnings
    
    private func drawSelf() {
        layer.cornerRadius = 5

        backgroundColor = .gray

        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(didTap)
            )
        )

        titleLabel.textColor = .white

        iconImageView.image = .init(systemName: "arrowtriangle.down.fill")

        addSubview(titleLabel)
        addSubview(iconImageView)

        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)

        iconImageView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        iconImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        iconImageView.autoSetDimensions(to: .init(width: 14, height: 14))
        iconImageView.tintColor = .black
    }

    // MARK: - Public Methods

    func changeRate(to rate: String) {
        titleLabel.text = rate
    }

    // MARK: - Actions

    @objc private func didTap() {
        delegate?.didTapRateView(with: type)
    }
}
