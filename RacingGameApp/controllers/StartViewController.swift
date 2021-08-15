//
//  StartViewController.swift
//  RacingGameApp
//
//  Created by alexKoro on 5/23/21.
//

import UIKit
import CoreMotion

class StartViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

// for parallax effect
    let motionManager = CMMotionManager()
    private let notificationController = NotificationsController.shared
    private var isParrallaxAnimationInProcess = false
    private var accelerationX: Double = 0
    private var accelerationY: Double = 0
    private lazy var borderX: (max: CGFloat, min: CGFloat) = (max: 0, min: mainImageViewConstraint.constant)
    private lazy var borderY: (max: CGFloat, min: CGFloat) = (max: 0, min: mainImageViewConstraint.constant)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        makeAttributedString()
        GameSettings.loadSettings()
        setButtonsTitle()
        var dateNotification = DateComponents()
        dateNotification.calendar = Calendar.current
        dateNotification.timeZone = .autoupdatingCurrent
        dateNotification.hour = 10
        dateNotification.minute = 30

        notificationController.addNotification(
            identifier: TypeOfNotification.notice,
            title: "Hey!",
            body: "We wait you on roads!",
            date: dateNotification,
            repeats: true
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setShadowsToViews()
        setCornerRadiusToViews()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTrackMotions()
    }

    func setButtonsTitle() {
        playButton.setTitle("PLAY".localized(), for: .normal)
        recordsButton.setTitle("RECORDS TABLE".localized(), for: .normal)
        settingsButton.setTitle("SETTINGS".localized(), for: .normal)
    }

    func makeAttributedString() {
        let titleText = titleLabel.text ?? ""
        let attrString = NSMutableAttributedString(string: titleText)
        attrString.addAttribute(
            .foregroundColor,
            value: UIColor.white,
            range: (titleText as NSString).range(of: "Racing")
        )
        attrString.addAttribute(
            .foregroundColor,
            value: UIColor.systemRed,
            range: (titleText as NSString).range(of: "game")
        )
        attrString.addAttribute(
            .font,
            value: UIFont.init(name: "SquareOne-Bold", size: 80.0) ?? UIFont.systemFont(ofSize: 80.0),
            range: (titleText as NSString).range(of: titleText)
        )
        titleLabel.attributedText = attrString
    }

    func setCornerRadiusToViews() {
        playButton.addCornerRadius(radius: 5.0)
        recordsButton.addCornerRadius(radius: 5.0)
        settingsButton.addCornerRadius(radius: 5.0)
    }

    func setShadowsToViews() {
        playButton.addShadow(color: .systemRed, opacity: 1, offset: .zero, radius: 10.0)
        recordsButton.addShadow(color: .white, opacity: 1, offset: .zero, radius: 3.0)
        settingsButton.addShadow(color: .white, opacity: 0.2, offset: .zero, radius: 3.0)

    }

    // MARK: parallax effect
    func startTrackMotions() {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let data = data else { return }
                self.accelerationX = -data.acceleration.x
                self.accelerationY = -data.acceleration.y
            }
        }

        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates(to: .main) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let data = data else { return }
                let rotationRateX = abs(data.rotationRate.x * 10)
                let rotationRateY = abs(data.rotationRate.y * 10)

                if rotationRateX > 1 || rotationRateY > 1 {
                    self.makeParallaxEffect(pointX: self.accelerationX, pointY: self.accelerationY)
                }
            }
        }
    }

    func makeParallaxEffect(pointX: Double, pointY: Double) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            guard self.isParrallaxAnimationInProcess == false else { return }
            self.isParrallaxAnimationInProcess = true
            let newPositionX = self.mainImageView.frame.minX + CGFloat(self.accelerationX)
            let newPositionY = self.mainImageView.frame.minY + CGFloat(self.accelerationY)

            if newPositionX < self.borderX.max && newPositionX > self.borderX.min {
                self.mainImageView.center.x += CGFloat(self.accelerationX)
            }
            if newPositionY < self.borderY.max && newPositionY > self.borderY.min {
                self.mainImageView.center.y += CGFloat(self.accelerationY)
            }
        } completion: { (_) in
            self.isParrallaxAnimationInProcess = false
        }
    }

    // MARK: actions

    @IBAction func playButtonPressed(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let gameVC = mainStoryboard.instantiateViewController(identifier: "GameViewController")
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(identifier: "SettingsViewController")
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    @IBAction func recordsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let recordsVC = storyboard.instantiateViewController(identifier: "RecordsViewController")
        self.navigationController?.pushViewController(recordsVC, animated: true)
    }
}
