//
//  QuestionViewController.swift
//  BackgroundSensing
//
//  Created by Lukas Würzburger on 5/27/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit

public enum QuestionType {
    case bodyPosture
    case typingModality
    case test
}

protocol QuestionViewControllerDelegate {
    func questionViewController(viewController: QuestionViewController, didSelect item: String)
}

class QuestionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - IB Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Variables

    var delegate: QuestionViewControllerDelegate?
    var viewModel: QuestionViewModel!
    var question: String!
    var keys: [String] = []
    var type: QuestionType!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    // MARK: - View Helper

    func configureView() {
        viewModel = QuestionViewModel(itemKeys: keys) { [unowned self] state in
            self.titleLabel.text = state.title
            self.collectionView.reloadData()
        }
        viewModel.state.title = question
    }

    // MARK: - Collection View Data Source

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )

        if let questionCell = cell as? QuestionCollectionViewCell {
            configureCell(
                cell: questionCell,
                indexPath: indexPath
            )
        }

        return cell
    }

    // MARK: - Collection View Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let item = keys[indexPath.row]

        delegate?.questionViewController(
            viewController: self,
            didSelect: item
        )
    }

    // MARK: - Collection View Helper

    func configureCell(cell: QuestionCollectionViewCell, indexPath: IndexPath) {
        let index = indexPath.row

        let imageName           = viewModel.state.iconFileNames[index]
        cell.imageView.image    = UIImage(named: imageName)
        cell.label.text         = viewModel.state.itemTitles[index]
    }
}
