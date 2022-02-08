//
//  GardenViewController.swift
//  guessVocabularies
//
//  Created by 方仕賢 on 2022/2/5.
//

import UIKit

var weatherImageNames = ["sun-", "rain-", "clouds-", "moon-"]
var flowerNums = [Int]()
var whiteViews = [UIView]()
var weatherIndex = 0
var duration:Float = 1

func addWhiteView(){
    let whiteView = UIView(frame: CGRect(x: 0, y: 650, width: 414, height: 120))
    whiteViews.append(whiteView)
}

func addFlower(x: CGFloat, flowerOrder: Int) -> UIImageView {
   let flowerImageView = UIImageView()
   flowerImageView.frame = CGRect(x: x, y: 5, width: 50, height: 100)
   flowerImageView.image = UIImage(named: "flower-\(flowerNums[flowerOrder])")
   return flowerImageView
}

func addPot(x:CGFloat, flowerOrder: Int) -> UIImageView {
    let potImageView = UIImageView()
    potImageView.frame = CGRect(x: x, y: 100, width: 50, height: 50)
    potImageView.image = UIImage(named: "flower pot.jpeg")
    return potImageView
}


class GardenViewController: UIViewController {

    @IBOutlet weak var broomButton: UIButton!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addWhiteView()
        view.addSubview(whiteViews[0])
        print(whiteViews.count)
        
        weather()
    }
    
    func weather(){
        
        if weatherIndex == 1 {
            duration = 0.3
        } else if weatherIndex == 0 {
            duration = 1
        } else {
            duration = 5
        }
        
        let animateImage = UIImage.animatedImageNamed(weatherImageNames[weatherIndex], duration: TimeInterval(duration))
        weatherImageView.image = animateImage
    }
    
    
    @IBAction func changeWeather(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            weatherIndex = (weatherIndex+weatherImageNames.count-1)%weatherImageNames.count
            
        } else if sender.direction == .left {
            weatherIndex = (weatherIndex+1)%weatherImageNames.count
        }
        weather()
    }
    
    
    @IBAction func cleanTheFlower(_ sender: UIButton) {
        
        let controller = UIAlertController(title: "Clean A Flower", message: "Sure you want to remove the last flower?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { action in
            
            if !flowerNums.isEmpty {
                
                if let whiteView = whiteViews.first {
                    whiteView.removeFromSuperview()
                    whiteViews.removeFirst()
                    flowerNums.removeLast()
                }
                
                
                if !flowerNums.isEmpty {
                    addWhiteView()
                    for i in 0...flowerNums.count-1{
                        whiteViews[0].addSubview(addFlower(x: CGFloat(i*50+15), flowerOrder: i))
                        whiteViews[0].addSubview(addPot(x: CGFloat(i*50+15), flowerOrder: i))
                        self.view.addSubview(whiteViews[0])
                    }
                } else {
                    addWhiteView()
                    self.view.addSubview(whiteViews[0])
                }
            }
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        controller.addAction(action)
        controller.addAction(action2)
        present(controller, animated: true, completion: nil)
        print("ispressed")
    }
   
  
}
