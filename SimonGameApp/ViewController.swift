//
//  ViewController.swift
//  SimonGameApp
//
//  Created by Felix Yu on 2/2/21.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var timer = Timer()
    
    var score = 0
    var bestScore = 0
    var randomColor = 0
    var userSequence: [Int] = []
    var computerSequence: [Int] = []
    var index = 0

    var audioPlayer = AVAudioPlayer()
    let redSound = Bundle.main.path(forResource: "0", ofType: "wav")
    let greenSound = Bundle.main.path(forResource: "1", ofType: "wav")
    let blueSound = Bundle.main.path(forResource: "2", ofType: "wav")
    let yellowSound = Bundle.main.path(forResource: "3", ofType: "wav")
    let startSound = Bundle.main.path(forResource: "start", ofType: "wav")
    let loseSound = Bundle.main.path(forResource: "lose", ofType: "wav")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yellowButton.isEnabled = false
        blueButton.isEnabled = false
        greenButton.isEnabled = false
        redButton.isEnabled = false
        
        currentScoreLabel.text = "Current: \(score)"
        
        let defaults = UserDefaults.standard
        bestScore = defaults.integer(forKey: "BestScore")
        bestScoreLabel.text = "Best Score: " + String(bestScore)
        moveLabel.text = "Computer Move"
        yellowButton.layer.cornerRadius = yellowButton.frame.width/2
        yellowButton.layer.borderWidth = 8
        yellowButton.layer.borderColor = UIColor(red: 0.92, green: 0.59, blue: 0.02, alpha: 1.00).cgColor
        
        greenButton.layer.cornerRadius = greenButton.frame.width/2
        greenButton.layer.borderWidth = 8
        greenButton.layer.borderColor = UIColor(red: 0.02, green: 0.39, blue: 0.03, alpha: 1.00).cgColor
        
        blueButton.layer.cornerRadius = blueButton.frame.width/2
        blueButton.layer.borderWidth = 8
        blueButton.layer.borderColor = UIColor(red: 0.07, green: 0.38, blue: 0.63, alpha: 1.00).cgColor

        redButton.layer.cornerRadius = redButton.frame.width/2
        redButton.layer.borderWidth = 8
        redButton.layer.borderColor = UIColor(red: 0.71, green: 0.22, blue: 0.22, alpha: 1.00).cgColor

       // playButton.layer.borderColor = UIColor.white.cgColor
    //    playButton.layer.borderWidth = 3
        
        // Do any additional setup after loading the view.

    }
    @IBAction func playButtonClicked(_ sender: Any)
    {
        playAudio(sound: startSound!)
        chooseRandomSequence()
        playButton.isHidden = true
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        redButton.showsTouchWhenHighlighted = true
        redButton.blink()
        playAudio(sound: redSound!)
        checkUserPick(Color: 1)
    }
    @IBAction func greenButtonPressed(_ sender: Any) {
        greenButton.showsTouchWhenHighlighted = true
        greenButton.blink()
        playAudio(sound: greenSound!)
        checkUserPick(Color: 2)
    }
    @IBAction func blueButtonPressed(_ sender: Any) {
        blueButton.showsTouchWhenHighlighted = true
        blueButton.blink()
        playAudio(sound: blueSound!)
        checkUserPick(Color: 3)
    }
    @IBAction func yellowButtonPressed(_ sender: Any) {
        yellowButton.showsTouchWhenHighlighted = true
        yellowButton.blink()
        playAudio(sound: yellowSound!)
        checkUserPick(Color: 4)
    }
    func playAudio(sound: String)
    {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    func chooseRandomSequence()
    {
        randomColor = Int.random(in: 1..<5)
        computerSequence.append(randomColor)
        index = 0
        playRandomSequence()
    }
    func playRandomSequence()
    {
        if index == computerSequence.count
        {
            index = 0
            moveLabel.text = "Your Move"
            yellowButton.isEnabled = true
            blueButton.isEnabled = true
            greenButton.isEnabled = true
            redButton.isEnabled = true
            return
        }
        self.moveLabel.text = "Computer Move"
        yellowButton.isEnabled = false
        blueButton.isEnabled = false
        greenButton.isEnabled = false
        redButton.isEnabled = false

        switch computerSequence[index]
        {
        case 1:
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.playAudio(sound: self.redSound!)
                self.redButton.blink()
            }
        case 2:
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.playAudio(sound: self.greenSound!)
                self.greenButton.blink()
            }
        case 3:
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.playAudio(sound: self.blueSound!)
                self.blueButton.blink()
            }

        case 4:
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.playAudio(sound: self.yellowSound!)
                self.yellowButton.blink()
            }

        default:
            print("Error")
        }
        index += 1
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
        self.playRandomSequence()
        }
        
    }
    func checkUserPick(Color: Int)
    {
        if computerSequence[index] == Color
        {
            index += 1
            currentScoreLabel.text = "Current: " + String(score)
            if index == computerSequence.count
            {
                score += 1
                currentScoreLabel.text = "Current: " + String(score)
                if score > bestScore
                {
                    bestScore = score
                    let defaults = UserDefaults.standard
                    defaults.set(bestScore, forKey: "BestScore")
                    bestScoreLabel.text = "Best Score: " + String(bestScore)
                }
                chooseRandomSequence()
            }
        }
        else
        {
            yellowButton.isEnabled = false
            blueButton.isEnabled = false
            greenButton.isEnabled = false
            redButton.isEnabled = false
            playAudio(sound: loseSound!)
            timer.invalidate()
            moveLabel.text = "You Lose"
            userSequence = []
            computerSequence = []
            index = 0
            score = 0
            playButton.setTitle("Play Again", for: .normal)
            playButton.isHidden = false
            currentScoreLabel.text = "Current: " + String(score)
            print("User loses")
        }
    }
}

extension UIView{
     func blink() {
         self.alpha = 0.2
        UIView.animate(withDuration: 0.4, delay: 0.0, animations: {self.alpha = 1.0}, completion: nil)
        //options: [.curveLinear, .autoreverse],
     }
}
