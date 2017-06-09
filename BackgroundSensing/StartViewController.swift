//
//  StartViewController.swift
//  BackgroundSensing
//
//  Created by Lukas Würzburger on 5/27/17.
//  Copyright © 2017 Emanuel Schmitt. All rights reserved.
//

import UIKit
import PromiseKit

class StartViewController: UIViewController, QuestionViewControllerDelegate {
    
    let networkController = NetworkController.shared
    
    // MARK: - IB Outlet

    @IBOutlet weak var startTrailButton: UIButton!
    
    // MARK: - IB Actions

    @IBAction func startTrailButtonPressed(_ sender: Any) {
        // show pageview
    }
    
    @IBAction func startGridViewButtonPressed(_ sender: Any) {
        presentGrid()
    }
    
    @IBAction func startQuestionButtonPressed(_ sender: Any) {
        presentQuestions()
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSessionAndSetButton()
    }

    
    // MARK: - Helper

    func questionViewController(title: String, keys: [String]) -> QuestionViewController {

        let questionViewController = storyboard!.instantiateViewController(withIdentifier: "questionView") as! QuestionViewController
        questionViewController.question     = title
        questionViewController.keys         = keys
        questionViewController.delegate     = self
        return questionViewController
    }
    
    func checkSessionAndSetButton() {
        let _ = networkController.checkSessionExists()
            .then { data -> () in
                if let exists: Bool = data["exists"] as? Bool {
                    print("Checked Session for today, response: \(exists)")
                    self.startTrailButton.isEnabled = !exists
                }
            }.catch { error in
                // TODO: display error
                print(error)
            }
    }

    // MARK: - Segues

    func presentGrid() {
        performSegue(withIdentifier: "showGridView", sender: nil)
    }

    func presentQuestions() {

        let viewController = firstQuestionViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }

    // MARK: - View Controller

    func firstQuestionViewController() -> QuestionViewController {
        let vc = questionViewController(
            title: "Erste Frage",
            keys: BodyPosture.allValues.map({ $0.rawValue })
        )
        vc.type = .bodyPosture
        return vc
    }

    func secondQuestionViewController() -> QuestionViewController {
        let vc = questionViewController(
            title: "Zweite Frage",
            keys: TypingModality.allValues.map({ $0.rawValue })
        )
        vc.type = .typingModality
        return vc
    }

    func thirdQuestionViewController() -> QuestionViewController {
        let vc = questionViewController(
            title: "Dritte Frage",
            keys: TypingModality.allValues.map({ $0.rawValue })
        )
        vc.type = .test
        return vc
    }

    func nextViewController(_ currentViewController: QuestionViewController) -> QuestionViewController? {
        var nextViewController: QuestionViewController?
        switch currentViewController.type! {
        case .bodyPosture:
            nextViewController = secondQuestionViewController()
        case .typingModality:
            nextViewController = thirdQuestionViewController()
        case .test:
            break
        }
        return nextViewController
    }

    // MARK: - Question View Controller Delegate

    func questionViewController(_ questionViewController: QuestionViewController, didSelect item: String) {
        if let nextViewController = nextViewController(questionViewController) {
            questionViewController.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
