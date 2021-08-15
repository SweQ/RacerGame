//
//  GameViewController.swift
//  RacingGameApp
//
//  Created by alexKoro on 8/8/21.
//

import UIKit
import CoreMotion

class GameViewController: UIViewController {

    private let roadPartOneImageView = UIImageView()
    private let roadPartTwoImageView = UIImageView()
    private let grassPartOneImageView = UIImageView()
    private let grassPartTwoImageView = UIImageView()
    private let scoreLabel = UILabel()
    private var enemyTimer = Timer()
    private let motionManager = CMMotionManager()
    private var startPositionForEnemy: [CGFloat] = []
    private var enemiesCarImages: [UIImage?] = []
    private let controllView = UIView() // for tapGesture
    private lazy var moveStepRoad: CGFloat = self.view.frame.height / 15
    private var playerCar: PlayerCar?
    private let accelerometerSensitivity = 0.25
    private var gameIsPreparedToStart = false
    private var tapGesture = UITapGestureRecognizer()
    private var isGameOver: Bool = false {
        willSet {
            if newValue && newValue != isGameOver {
                self.enemyTimer.invalidate()
                RecordController.shared.addRecord(record: Record(playerName: GameSettings.playerName, score: score))
                showGameOverAlert()
                }
            }
    }

    private var score = 0 {
        didSet {
            scoreLabel.text = "\("SCORE".localized()): \(score)"
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard gameIsPreparedToStart == false else { return }
        prepareToStartGame()
        guard gameIsPreparedToStart else { return }
        startGame()
    }

    // MARK: addSubviews
    private func createScoreLabel() {
        scoreLabel.frame.size.width = self.view.bounds.width
        scoreLabel.frame.size.height = self.view.bounds.height / 20
        scoreLabel.textColor = .black
        scoreLabel.baselineAdjustment = .alignCenters
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.textAlignment = .center
        scoreLabel.text = "\("SCORE".localized()): \(score)"
        view.addSubview(scoreLabel)
    }

    // MARK: alerts
    func showGameOverAlert() {
        let alertController = UIAlertController(
            title: "Game over".localized(),
            message: "\("SCORE".localized()): \(score)",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                    self.score = 0
                }
            )
        )
        present(alertController, animated: true, completion: nil)
    }

    // MARK: track motions
    func startTrackMotions() {
        guard GameSettings.isControllerAcceleration else { return }

        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let data = data else { return }
                let accelerationX = data.acceleration.x

                if accelerationX < -self.accelerometerSensitivity {
                    self.turnPlayerCar(to: .left)
                } else if accelerationX > self.accelerometerSensitivity {
                    self.turnPlayerCar(to: .right)
                }
            }
        }
    }

    // MARK: game controll

    func prepareToStartGame() {
        makeRoad()
        loadEnemyImages()
        addRoadToView()
        createScoreLabel()
        GameSettings.loadSettings()
        guard let playerCar = createPlayerCar() else {
            self.gameIsPreparedToStart = false
            return
        }
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(sender:)))
        roadPartOneImageView.isUserInteractionEnabled = true
        self.controllView.frame = self.view.frame
        self.controllView.backgroundColor = .clear
        self.controllView.addGestureRecognizer(tapGesture)
        self.playerCar = playerCar
        self.view.addSubview(controllView)
        self.gameIsPreparedToStart = true
    }

    func startGame() {
        view.addSubview(self.playerCar!.model) // use "!" after guard in prepareToStartGame
        startToMoveRoad()
        startEnemyCreator()
        startTrackMotions()
    }

    // MARK: create enemy

    func loadEnemyImages() {
        self.enemiesCarImages = [
            UIImage(named: GameImage.enemy1.rawValue),
            UIImage(named: GameImage.enemy2.rawValue),
            UIImage(named: GameImage.enemy3.rawValue),
            UIImage(named: GameImage.enemy4.rawValue)
        ]
    }

    func startEnemyCreator() {
        enemyTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            guard self.isGameOver == false else { return }
            guard let enemyCarSize = self.playerCar?.model.bounds.size
            else {
                return
            }

            guard let image = self.enemiesCarImages.randomElement() else { return }
            let enemyStartPositionX = CGFloat.random(
                in: self.roadPartOneImageView.frame.minX...self.roadPartOneImageView.frame.maxX
            )
            let enemyStartPositionY = self.view.frame.origin.y - enemyCarSize.height
            let enemyStartPosition = CGPoint(x: enemyStartPositionX, y: enemyStartPositionY)
            self.moveEnemy(enemy: EnemyCar(image: image!, size: enemyCarSize, startPosition: enemyStartPosition))
            })
    }

    func moveEnemy(enemy: EnemyCar) {
        guard self.isGameOver == false else { return }

        if self.view != enemy.model.superview {
            // here we setup passing and counter enemies cars
            if enemy.model.frame.origin.x > roadPartOneImageView.center.x {
                enemy.model.transform = CGAffineTransform(rotationAngle: .pi)
                enemy.enemySpeed = 8
            }

            view.addSubview(enemy.model)
        }

        UIView.animate(
            withDuration: 0.01,
            delay: 0,
            options: .curveLinear
        ) {
            enemy.drive(
                to: self.view.frame.maxY + enemy.model.frame.height
            )
        } completion: { (_) in
            guard self.enemyTouchPlayer(enemy: enemy) == false else {
                self.isGameOver = true
                return
            }
            if enemy.isOnRoad {
                self.moveEnemy(enemy: enemy)
            } else {
                self.score += 1
                enemy.model.removeFromSuperview()
            }
        }
    }

    func enemyTouchPlayer(enemy: EnemyCar) -> Bool {
        guard let playerCar = playerCar else { return false }
        // here cut cars bounds
        var playerCarFrame = playerCar.model.frame
        playerCarFrame.size.width -= playerCarFrame.size.width / 5
        playerCarFrame.size.height -= playerCarFrame.size.height / 7

        return enemy.model.frame.intersects(playerCarFrame)
    }

    func stopMoveEnemy() {

    }

    // MARK: tapGesture

    @objc func tapGestureHandler(sender: UITapGestureRecognizer) {
        guard GameSettings.isControllerAcceleration == false else { return }
        let touchPoint = sender.location(in: controllView)
        let directionTouch: TurnDirection = touchPoint.x > controllView.center.x ?  .right : .left
        turnPlayerCar(to: directionTouch)
    }

    // MARK: players car
    private func createPlayerCar() -> PlayerCar? {
        let carImage = GameSettings.playerCarImg
        let carWidth = view.bounds.width / 8
        let carHeight = carWidth * 2
        let size = CGSize(width: carWidth, height: carHeight)
        // create position car in y*1.7 for show car in display's bottom
        let startPosition = CGPoint(x: view.center.x, y: view.center.y * 1.7)
        let turnConstant = roadPartOneImageView.frame.width / 5
        let car = PlayerCar(image: carImage, size: size, startPosition: startPosition, turnConstant: turnConstant)

        return car
    }

    private func turnPlayerCar(to direction: TurnDirection) {
        guard !isGameOver else { return }
        guard let car = playerCar else { return }
        // now car must not turning
        guard !car.carIsTurning else { return }

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            if direction == .left {
                car.turnToLeft()
            } else {
                car.turnToRight()
            }
            car.carIsTurning = true
        } completion: { (_) in
            guard !self.playerCarOutOfRoad() else {
                self.isGameOver = true
                return
            }
            car.cancelTurn()
            car.carIsTurning = false
        }
    }

    private func playerCarOutOfRoad() -> Bool {
        guard let car = playerCar else { return true }
        let carBorderLeft = car.model.frame.minX
        let carBorderRight = car.model.frame.maxX

        if carBorderLeft < roadPartOneImageView.frame.minX || carBorderRight > roadPartOneImageView.frame.maxX {
            self.isGameOver = true
            return true
        } else {
            return false
        }
    }

    // MARK: road

    private func makeRoad() {
        roadPartOneImageView.image = UIImage(
            named: GameImage.road.rawValue
        )
        roadPartTwoImageView.image = UIImage(
            named: GameImage.road.rawValue
        )
        grassPartOneImageView.image = UIImage(
            named: GameImage.grass.rawValue
        )
        grassPartTwoImageView.image = UIImage(
            named: GameImage.grass.rawValue
        )
        roadPartOneImageView.frame = self.view.frame
        roadPartOneImageView.bounds.size.width -= self.view.bounds.size.width / 8
        roadPartTwoImageView.frame = self.view.frame
        roadPartTwoImageView.bounds.size.width -= self.view.bounds.size.width / 8
        grassPartOneImageView.frame = self.view.frame
        grassPartTwoImageView.frame = self.view.frame
        roadPartTwoImageView.frame.origin.y = -roadPartTwoImageView.frame.height
        grassPartTwoImageView.frame.origin.y = -grassPartTwoImageView.frame.height
    }

    private func addRoadToView() {
        view.addSubview(grassPartOneImageView)
        view.addSubview(grassPartTwoImageView)
        view.addSubview(roadPartOneImageView)
        view.addSubview(roadPartTwoImageView)
    }

    private func startToMoveRoad() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.roadPartOneImageView.frame.origin.y += self.moveStepRoad
            self.roadPartTwoImageView.frame.origin.y += self.moveStepRoad
            self.grassPartOneImageView.frame.origin.y += self.moveStepRoad
            self.grassPartTwoImageView.frame.origin.y += self.moveStepRoad
        } completion: { (_) in
            if self.roadPartOneImageView.frame.origin.y >= self.view.frame.maxY {
                self.roadPartOneImageView.frame.origin.y = -self.roadPartOneImageView.frame.height
                self.grassPartOneImageView.frame.origin.y = -self.grassPartOneImageView.frame.height
            }
            if self.roadPartTwoImageView.frame.origin.y >= self.view.frame.maxY {
                self.roadPartTwoImageView.frame.origin.y = -self.roadPartTwoImageView.frame.height
                self.grassPartTwoImageView.frame.origin.y = -self.grassPartTwoImageView.frame.height
            }
            guard !self.isGameOver else { return }
            self.startToMoveRoad()
        }
    }

}
