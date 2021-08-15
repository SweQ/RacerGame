//
//  SettingsViewController.swift
//  RacingGameApp
//
//  Created by alexKoro on 5/4/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var setNameButton: UIButton!
    @IBOutlet weak var typeEnemyButton: UIButton!
    @IBOutlet weak var typeOfControllerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeLabels()
        setNameButton.setTitle("SET PLAYER NAME".localized(), for: .normal)
        setNameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        settingsLabel.text = "SETTINGS".localized()
        typeEnemyButton.setTitle("TYPE OF ENEMY".localized(), for: .normal)
        typeOfControllerButton.setTitle("Type of controller".localized(), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        GameSettings.saveSettings()
    }
    private func makeLabels() {
        settingsLabel.font = UIFont(name: "SquareOne-Bold", size: 50.0)
    }

    @IBAction func typeOfControllerButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Type of controller".localized(),
            message: "",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Display".localized(), style: .default, handler: { (_) in
            GameSettings.isControllerAcceleration = false
        }))
        alert.addAction(UIAlertAction(title: "Accelerometer".localized(), style: .default, handler: { (_) in
            GameSettings.isControllerAcceleration = true
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func typeOfPlayerCarButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectCarViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func playeNameButtonPressed(_ sender: UIButton) {

        let alert = UIAlertController(title: "SET PLAYER NAME".localized(), message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Set player name length error".localized()
        }
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (_) in
            let newName = alert.textFields?.first?.text ?? GameSettings.playerName
            GameSettings.playerName = String(newName.prefix(10))
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
