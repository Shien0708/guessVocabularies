//
//  ViewController.swift
//  guessVocabularies
//
//  Created by 方仕賢 on 2022/2/3.
//

import UIKit

var flowerNum = 0
class ViewController: UIViewController {
    
    @IBOutlet weak var beeImageView: UIImageView!
    
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var closeHintButton: UIButton!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var seedImageView: UIImageView!
    @IBOutlet weak var flowerImageView: UIImageView!
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var buttonImages: [UIImageView]!
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    
    var isCorrect = false
    
    var seedIsGrown = false
    var flowerIsGrown = false
    var grownIndex = 0
    var seedNum = 0
    
    var timer: Timer?
    
    var answerChar = [String]()
    var charIndex = 0
    
    var random = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayQuestion()
        
        beeImageView.image = UIImage.animatedImageNamed("bee-", duration: 0.1)
        
        if weatherIndex == 1 {
            duration = 0.3
           
        } else if weatherIndex == 0 {
            duration = 1
        } else {
            duration = 5
        }
        weatherImageView.image = UIImage.animatedImageNamed(weatherImageNames[weatherIndex], duration: TimeInterval(duration))
    }
    
    func displayQuestion(){
        seedImageView.alpha = 1
        flowerImageView.alpha = 0
        resultView.alpha = 0
        isCorrect = false
        seedIsGrown = false
        flowerIsGrown = false
        grownIndex = 0
        seedNum = 0
        flowerNum = 0
        charIndex = 0
        answerChar = [String]()
        
        seedImageView.image = UIImage(named: "seed-0")
        
        random = Int.random(in: 0...questionOne.count-1)
        questionLabel.text = ""
        
        for _ in 1...questionOne[random].answer.count{
            questionLabel.text! += "_ "
            answerChar.append("_ ")
        }
        
        for i in 0...buttons.count-1{
            buttons[i].isHidden = false
            buttonImages[i].isHidden = false
        }
    }
    
    func displayResult(){
        if !answerChar.contains("_ ") {
            
            let animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                self.resultView.alpha = 1
            }
            animator.startAnimation()
            
            if grownIndex > 5 {
                resultImageView.image = flowerImageView.image
                
                if flowerNum >= 3 {
                    resultLabel.text = "Congradulations!\n You get a flower."
                    flowerNums.append(flowerNum-1)
                } else {
                    resultLabel.text = "Keep it up!\n You will get a flower."
                }
                
            } else {
                resultImageView.image = seedImageView.image
                resultLabel.text = "Keep it up!\n You will get a flower."
            }
            
            if !flowerNums.isEmpty {
                print(whiteViews.count)
                print(flowerNums)
                
                for i in 0...flowerNums.count-1 {
                    whiteViews[0].addSubview(addFlower(x: CGFloat(i*50+15), flowerOrder: i))
                    whiteViews[0].addSubview(addPot(x: CGFloat(i*50+15), flowerOrder: i))
                }
                print(whiteViews.count)
            }
        }
    }
    
    @objc func growFlower(){
        if flowerImageView.alpha == 1 {
            flowerImageView.alpha = 0
        }
        
        let animator = UIViewPropertyAnimator(duration: 2, curve: .linear) {
            if self.grownIndex <= 5 && self.seedImageView.alpha == 0 {
                self.seedImageView.alpha = 1
                self.flowerIsGrown = false
            } else {
                self.flowerImageView.alpha = 1
                self.seedImageView.alpha = 0
            }
        }
        animator.startAnimation()
    }
    
    
    @objc func growTheSeed(){
       
        if isCorrect == true {
           if grownIndex <= 5 && seedIsGrown == false {
                seedImageView.image = UIImage(named: "seed-\(seedNum+1)")
                grownIndex += 1
                seedNum += 1
                if grownIndex == 5 {
                    seedIsGrown = true
                    timer?.invalidate()
                }
            } else if grownIndex < 13 && seedIsGrown == true {
                grownIndex += 1
                flowerNum += 1
                flowerImageView.image = UIImage(named: "flower-\(flowerNum-1)")
                growFlower()
            }
            
        } else {
            
            if grownIndex <= 5 && grownIndex > 0 && seedIsGrown == true {
                seedImageView.image = UIImage(named: "seed-\(seedNum-1)")
                grownIndex -= 1
                seedNum -= 1
                if grownIndex == 0 {
                    timer?.invalidate()
                    seedIsGrown = false
                }
            } else if grownIndex > 5 && flowerIsGrown == true {
                grownIndex -= 1
                flowerNum -= 1
                flowerImageView.image = UIImage(named: "flower-\(flowerNum-1)")
                growFlower()
            } else if grownIndex == 0 {
                timer?.invalidate()
            }
        }
        
        displayResult()
        
    }
    
    @IBAction func grow(_ sender: UIButton) {
        
        var buttonIndex = 0
        
        while sender != buttons[buttonIndex] {
            buttonIndex += 1
        }
        
        if questionOne[random].answer.contains(buttons[buttonIndex].titleLabel?.text ?? "") {
            isCorrect = true
            
            if seedIsGrown == true {
                flowerIsGrown = true
            }
            
            for char in questionOne[random].answer {
                if char == Character((buttons[buttonIndex].titleLabel?.text!)!) {
                    answerChar.remove(at: charIndex)
                    answerChar.insert(String(char), at: charIndex)
                }
                charIndex += 1
            }
            charIndex = 0
            questionLabel.text = ""
            for i in 0...answerChar.count-1{
                    questionLabel.text! += answerChar[i]
                }
            
            
        } else {
            isCorrect = false
        }
       
        
        buttons[buttonIndex].isHidden = true
        buttonImages[buttonIndex].isHidden = true
        
        if grownIndex <= 5 && flowerIsGrown == false {
            timer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(growTheSeed), userInfo: nil, repeats: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(growTheSeed), userInfo: nil, repeats: false)
        }
        
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        displayQuestion()
    }
    
    @IBAction func getHint(_ sender: UIButton) {
        
        hintLabel.text = questionOne[random].explanation
        
        if sender == closeHintButton {
            hintView.isHidden = true
        } else {
            hintView.isHidden = false
        }
    }
    
    
}

