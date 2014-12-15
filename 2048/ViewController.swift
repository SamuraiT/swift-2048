//
//  ViewController.swift
//  2048
//
//  Created by tatsuro-y on 2014/12/15.
//  Copyright (c) 2014年 tatsuro. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    var tiles = [0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0]
    var modifiedTils: [Int] = []
    @IBAction func startNewGame(sender: AnyObject) {
        initializeGame()
    }
    @IBOutlet weak var highScoreLable: UILabel!
    @IBOutlet weak var gameStateLabel: UILabel!
    var TotalScore = 0
    @IBOutlet weak var TotalScoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeGame()
        saveOrShowScore()
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "right:")
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "down:")
        swipeDown.numberOfTouchesRequired = 1
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "left:")
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "up:")
        swipeUp.numberOfTouchesRequired = 1
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
    }

    func generateTile(){
        var k:Int = random() % 15
        var tag = view.viewWithTag(k) as UILabel
        if tag.text == ""{
        tag.text = "2"
        tag.backgroundColor = UIColor.yellowColor()
        modifiedTils.append(k)
        tiles[k] = 2
        } else {
            generateTile()
        }
    }
 
   
    
    @objc(right:)
    func moveRight(r: UISwipeGestureRecognizer!){
        var except:[Int] = []
        var terminal = [3, 7, 11, 15]
        for i in reverse(0...15) {
            var score = tiles[i]
            if score == 0 {
                continue
            }
            if contains(terminal, i){
               //dont move. stay
            } else {
                var next = i;
                while true{
                    next++;
                    if next >= 0 && next < 16 && !contains(terminal, next-1){
                        if tiles[next] == 0{
                            moveTile(next-1, nextTile: next)
                        } else if tiles[next-1] == tiles[next] && !contains(except, next-1){
                            multipleTile(next-1, nextTile: next)
                            except.append(next)
                            TotalScore += tiles[next]
                            TotalScoreLabel.text = "Score: \(TotalScore)"
                            break
                        }
                    } else {
                        println("break \(next)")
                        break
                    }
                    
                }
            }
            
        }
        usleep(9000)
        generateTile()
        if isGameOver(){
           gameStateLabel.hidden = false
        }
    }
   
    @objc(left:)
    func moveLeft(r: UISwipeGestureRecognizer!){
        
        var except:[Int] = []
        var terminal = [0, 4, 8, 12]
        for i in (0...15) {
            var score = tiles[i]
            if score == 0 {
                continue
            }
            if contains(terminal, i){
               //dont move. stay
            } else {
                var next = i;
                while true{
                    next--;
                    if next >= 0 && !contains(terminal, next+1){
                        if tiles[next] == 0{
                            moveTile(next+1, nextTile: next)
                        } else if tiles[next+1] == tiles[next] && !contains(except, next+1){
                            multipleTile(next+1, nextTile: next)
                            except.append(next)
                            TotalScore += tiles[next]
                            TotalScoreLabel.text = "Score: \(TotalScore)"
                            break
                        }
                    } else {
                        println("break \(next)")
                        break
                    }
                    
                }
            }
            
        }
       usleep(9000)
       generateTile()
       if isGameOver(){
           gameStateLabel.hidden = false
        }
    }

    func saveOrShowScore(){
        let usrProfile = NSUserDefaults.standardUserDefaults()
        if let score = usrProfile.valueForKey("score"){
            if TotalScore > score as Int{
                usrProfile.setValue(TotalScore, forKey: "score")
                usrProfile.synchronize()
            }
        } else {
            usrProfile.setValue(TotalScore, forKey: "score")
            usrProfile.synchronize()
        }
        var result = usrProfile.stringForKey("score")
        highScoreLable.text = "High Score: \(result)"
    }
    
    func isGameOver() -> Bool{
        for score in tiles{
            if score == 0{
                return false
            }
        }
        saveOrShowScore()
        return true
        
    }
   
    func isAddable(){
        for tile in tiles{
            
        }
    }
    func initializeGame(){
        for i in 0..<tiles.count{
           initializeTile(i)
        }
        generateTile()
        generateTile()
        gameStateLabel.hidden = true
    }
    
    func isGameClear(score: Int, clearScore: Int = 32) -> Bool{
        return score == clearScore
    }
    func initializeTile(tileNum: Int){
        var tag = view.viewWithTag(tileNum) as UILabel
        tag.text = ""
        tiles[tileNum] = 0
        tag.backgroundColor = UIColor.grayColor()
        saveOrShowScore()
    }
    
    func moveTile(currentTile: Int, nextTile: Int){
        var score = tiles[currentTile]
        initializeTile(currentTile)
        var newTag = view.viewWithTag(nextTile) as UILabel
        newTag.text = "\(score)"
        tiles[nextTile] = score
        newTag.backgroundColor = getColor(score)
    }
    
    func multipleTile(currentTile: Int, nextTile: Int){
        var score = tiles[currentTile]*2
        initializeTile(currentTile)
        var newTag = view.viewWithTag(nextTile) as UILabel
        newTag.text = "\(score)"
        tiles[nextTile] = score
        newTag.backgroundColor = getColor(score)
        if isGameClear(score){
            gameStateLabel.text = "Game Clear"
            gameStateLabel.hidden = false
        }
    }
    
  
    func getColor(score: Int) -> UIColor{
        switch score{
        case 2:
            return UIColor.yellowColor()
        case 4:
            return UIColor.blueColor()
        case 8:
            return UIColor.whiteColor()
        case 32:
            return UIColor.greenColor()
        default:
            return UIColor.whiteColor()
        }
    }
    
    @objc(down:)
    func moveDown(r: UISwipeGestureRecognizer!){
        var except:[Int] = []
        var terminal = [12, 13, 14, 15]
        for i in reverse(0...15) {
            var score = tiles[i]
            if score == 0 {
                continue
            }
            if contains(terminal, i){
                //dont move. stay
            } else {
                var next = i;
                while true{
                    next += 4
                    var prev = next - 4
                    if next >= 0 && next < 16 && !contains(terminal, prev){
                        if tiles[next] == 0{
                            moveTile(prev, nextTile: next)
                        } else if tiles[prev] == tiles[next] && !contains(except, prev){
                            multipleTile(prev, nextTile: next)
                            except.append(next)
                            TotalScore += tiles[next]
                            TotalScoreLabel.text = "Score: \(TotalScore)"
                            break
                        }
                    } else {
                        println("break \(next)")
                        break
                    }
                    
                }
            }
            
        }
        usleep(9000)
        generateTile()
        if isGameOver(){
            gameStateLabel.hidden = false
        }
    }
    
    
    @objc(up:)
    func moveUp(r: UISwipeGestureRecognizer!){
        var except:[Int] = []
        var terminal = [0, 1, 2, 3]
        for i in (0...15) {
            var score = tiles[i]
            if score == 0 {
                continue
            }
            if contains(terminal, i){
                //dont move. stay
            } else {
                var next = i;
                while true{
                    next -= 4
                    var prev = next + 4
                    if next >= 0 && !contains(terminal, prev){
                        if tiles[next] == 0{
                            moveTile(prev, nextTile: next)
                        } else if tiles[prev] == tiles[next] && !contains(except, prev){
                            multipleTile(prev, nextTile: next)
                            except.append(next)
                            TotalScore += tiles[next]
                            TotalScoreLabel.text = "Score: \(TotalScore)"
                            break
                        }
                    } else {
                        println("break \(next)")
                        break
                    }
                    
                }
            }
            
        }
        usleep(9000)
        generateTile()
        if isGameOver(){
            gameStateLabel.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func calcNextIndex(operand: Int, addNum: Int) -> Int{
        return operand + addNum
    }
    
    func moveSide(traverseOrder: [Int], terminal : [Int], addPrev: Int, addNext: Int){
        /*
        generaized version of side move
        */
        var except:[Int] = []
        for i in traverseOrder {
            var score = tiles[i]
            if score == 0 {
                continue
            }
            if contains(terminal, i){
                //dont move. stay
            } else {
                var next = i;
                while true{
                    var prev = calcNextIndex(next, addNum: addPrev)
                    next = calcNextIndex(next, addNum: addNext);
                    if next >= 0 && next < 16 && !contains(terminal, prev){
                        if tiles[next] == 0{
                            moveTile(prev, nextTile: next)
                        } else if tiles[prev] == tiles[next] && !contains(except, prev){
                            multipleTile(prev, nextTile: next)
                            except.append(next)
                            TotalScore += tiles[next]
                            TotalScoreLabel.text = "Score: \(TotalScore)"
                            break
                        }
                    } else {
                        println("break \(next)")
                        break
                    }
                    
                }
            }
            
        }
        usleep(9000)
        generateTile()
        if isGameOver(){
            gameStateLabel.hidden = false
        }
    }
}

