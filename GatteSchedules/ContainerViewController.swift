//
//  ContainerViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/8/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    var containerNavigationController: UINavigationController!
    var mainViewController: MainViewController!
    var menuTableViewController: MenuViewController!
    
    var swipeLeftGesturesOn: Bool = false // turn on manually in view controller
    var menuIsShowing: Bool = false
    var isMoving: Bool = false
    var toggleMenuBarButtonItem: UIBarButtonItem!
    
    // Gesture variables
    var xPoints: [Float]!
    var yPoints: [Float]!
    var xVelocity: [Float]!
    var yVelocity: [Float]!
    
    var closeMenuTap: UITapGestureRecognizer!
    var swipeLeftOnContainer: UIPanGestureRecognizer!
    var swipeLeftOnMenu: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainView") as! MainViewController
        menuTableViewController = storyboard?.instantiateViewController(withIdentifier: "MenuView") as! MenuViewController
        
        containerNavigationController = UINavigationController(rootViewController: mainViewController)
        
        view.addSubview(containerNavigationController.view)
        view.addSubview(menuTableViewController.view)
        view.bringSubview(toFront: containerNavigationController.view)
        
        toggleMenuBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(ContainerViewController.toggleMenu))
        
        setupGestures()
    }
    
    func toggleMenu() {
        UIView.animate(withDuration: TimeInterval(0.3), animations: {
            if self.menuIsShowing {
                self.containerNavigationController.view.frame.origin.x = 0
                self.menuIsShowing = false
                
                self.containerNavigationController.view.removeGestureRecognizer(self.closeMenuTap)
            } else {
                self.containerNavigationController.view.frame.origin.x = -310
                self.menuIsShowing = true
                
                self.containerNavigationController.view.addGestureRecognizer(self.closeMenuTap)
            }
        })
    }
    
    func handleSwipeLeft(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        let xOrigin = containerNavigationController.view.frame.origin.x
        
        switch recognizer.state {
        case .began:
            xPoints = []
            yPoints = []
            xVelocity = []
            yVelocity = []
            break;
        case .changed:
            xPoints.append(Float(translation.x))
            yPoints.append(Float(translation.y))
            xVelocity.append(Float(velocity.x))
            yVelocity.append(Float(velocity.y))
            
            if isMoving {
                let moveTo = translation.x + xOrigin
                
                if moveTo > -300 && moveTo < 0 { // bounds
                    containerNavigationController.view.frame.origin.x = moveTo
                    recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
                }
            } else {
                if abs(translation.x) > 4 && abs(yVelocity.average()) < 115 && xPoints.count < 10 {
                    isMoving = true
                }
            }
            
            break;
        case .ended:
            isMoving = false
            if abs(xOrigin) > 200 {
                menuIsShowing = false
                toggleMenu()
            } else {
                menuIsShowing = true
                toggleMenu()
            }
            break;
        default:
            
            break;
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if menuIsShowing {
            toggleMenu()
        }
    }
    
    func setupGestures() {
        closeMenuTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        swipeLeftOnContainer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeLeft(recognizer:)))
        swipeLeftOnContainer.maximumNumberOfTouches = 1
        swipeLeftOnMenu = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeLeft(recognizer:)))
        swipeLeftOnMenu.maximumNumberOfTouches = 1
        
        setSwipeLeftGesture(on: true) // Activate!
    }
    
    func setSwipeLeftGesture(on: Bool) {
        if on && !swipeLeftGesturesOn { // if gestures are off and we want to turn them on, add gestures
            swipeLeftGesturesOn = true
            containerNavigationController.view.addGestureRecognizer(swipeLeftOnContainer)
            menuTableViewController.view.addGestureRecognizer(swipeLeftOnMenu)
        } else if !on && swipeLeftGesturesOn { // if gestures are on and we want to turn them off, remove them
            swipeLeftGesturesOn = false
            containerNavigationController.view.removeGestureRecognizer(swipeLeftOnContainer)
            menuTableViewController.view.removeGestureRecognizer(swipeLeftOnMenu)
        }
    }
}

protocol FloatType {}
extension Float: FloatType {}
extension Array where Element: FloatType {
    func average() -> Float {
        let total = self.count
        var sum: Float = 0
        
        for int in self {
            sum += int as! Float
        }
        
        return sum / Float(total)
    }
}
