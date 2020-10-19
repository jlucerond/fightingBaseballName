//
//  ViewController.swift
//  FightingBaseballNameGenerator
//
//  Created by Joe Lucero on 10/18/20.
//  Copyright © 2020 Joe Lucero. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var grassImageView: UIImageView!
    @IBOutlet private weak var baseballImageView: UIImageView!
    @IBOutlet private weak var randomNameButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackgroundImage()
        prepareBaseballImageView()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        grassAnimation { _ in
            self.baseballAnimation { _ in }
        }
    }

    @IBAction private func didTapRandomName(_ sender: Any) {
        print("\nJoe:")
        print("Joe: random!")
        print("Joe:\n")

    }
}

private extension ViewController {
    func prepareBackgroundImage() {
        if let image = UIImage(named: "grass") {
            grassImageView.image = image.pixelated(blockSize: 3)
        }
    }

    func prepareBaseballImageView() {
        baseballImageView.alpha = 0.0
        if let image = UIImage(named: "baseball") {
            baseballImageView.image = image.pixelated(blockSize: 20)
        }
    }

    func grassAnimation(completion: @escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            self.bottomConstraint.constant -= (self.view.frame.height * 0.95)
            self.view.layoutIfNeeded()
        }, completion: completion)
    }

    func baseballAnimation(completion: @escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: 2.0, animations: { [weak self] in
            guard let self = self else { return }
            self.baseballImageView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
}


extension UIImage {
    func pixelated(blockSize: Int) -> UIImage {
        guard let filter = CIFilter(name: "CIPixellate") else { return self }
        let ciImage = CIImage(image: self)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(blockSize, forKey: kCIInputScaleKey)

        guard let outputImage = filter.outputImage else { return self }
        let context = CIContext()
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        return UIImage(cgImage: cgImage!)
    }
}
