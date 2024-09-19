//
//  ShimmerView.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation
import UIKit

import UIKit

class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
        startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
        startAnimating()
    }
    
    private func setupGradientLayer() {
        // Configure gradient layer
        gradientLayer.frame = bounds
        let lightColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        let darkColor = UIColor(white: 0.75, alpha: 1.0).cgColor
        gradientLayer.colors = [darkColor, lightColor, darkColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
    }
    
    private func startAnimating() {
        // Create and add the animation
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds // Ensure the gradient layer resizes when the view changes
    }
}
