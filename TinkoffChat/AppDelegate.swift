//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 13/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit
import CoreData
import Firebase

let userID = "ArtemEmelianovAppUserID"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var emitterLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterSize = window!.bounds.size
        let emitterCell = CAEmitterCell()
        emitterCell.birthRate = 50
        emitterCell.lifetime = 1
        emitterCell.velocity = 100
        emitterCell.scale = 0.1
        emitterCell.alphaSpeed = 0.1
        emitterCell.emissionRange = CGFloat.pi * 2
        emitterCell.contents = UIImage(named: "TinkoffFlake.png")!.cgImage!
        emitterLayer.emitterCells = [emitterCell]
        return emitterLayer
    }()
    var startPoint: CGPoint?
    lazy var pressGesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(recognizer:)))
    }()
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        pressGesture.minimumPressDuration = 0.5
        window?.addGestureRecognizer(pressGesture)
        return true
    }
    
    @objc func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startPoint = recognizer.location(in: window!)
            emitterLayer.emitterPosition = startPoint!
            window!.layer.addSublayer(emitterLayer)
        case .changed:
            emitterLayer.emitterPosition = recognizer.location(in: window!)
        case .ended:
            emitterLayer.removeFromSuperlayer()
        default:
            break
        }
    }
}
