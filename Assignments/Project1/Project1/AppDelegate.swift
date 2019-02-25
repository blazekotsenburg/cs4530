//
//  AppDelegate.swift
//  Project1
//
//  Created by Blaze Kotsenburg on 1/17/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    struct Vector {
        var x: UISlider?
        var y: UISlider?
        var z: UISlider?
        var valXLabel: UILabel?
        var valYLabel: UILabel?
        var valZLabel: UILabel?
    }
    
    var sliderA: Vector = Vector()
    var sliderB: Vector = Vector()
    
    var additionLabel: UILabel?
    var dotProductLabel: UILabel?
    var crossProductLabel: UILabel?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /***********************************
        *     INITIALIZE WINDOW AND VIEW   *
        ************************************/
        window = UIWindow()
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        let mainView: UIView = window!
        mainView.backgroundColor = UIColor.lightGray
        
        /***********************************
        *     SETUP SLIDERS & LABEL VALS   *
        ************************************/
        sliderA.x = UISlider()
        let sliderAX = sliderA.x!
        sliderAX.frame = CGRect(x: 40.0, y: 60.0, width: 230.0, height: 40.0)
        sliderAX.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        sliderA.valXLabel = UILabel()
        let sliderAXLabelVal = sliderA.valXLabel!
        sliderAXLabelVal.text = "0.00"
        sliderAXLabelVal.font = UIFont(name: "Avenir", size: 14)
        sliderAXLabelVal.frame = CGRect(x: sliderAX.frame.width + 40.0, y: 60.0, width: 50.0, height: 25.0)
        mainView.addSubview(sliderAXLabelVal)
        mainView.addSubview(sliderAX)
        
        sliderA.y = UISlider()
        let sliderAY = sliderA.y!
        sliderAY.frame = CGRect(x: 40.0, y: 110.0, width: 230.0, height: 40.0)
        sliderAY.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        sliderA.valYLabel = UILabel()
        let sliderAYLabelVal = sliderA.valYLabel!
        sliderAYLabelVal.text = "0.00"
        sliderAYLabelVal.font = UIFont(name: "Avenir", size: 14)
        sliderAYLabelVal.frame = CGRect(x: sliderAY.frame.width + 40.0, y: 110.0, width: 50.0, height: 25.0)
        mainView.addSubview(sliderAYLabelVal)
        mainView.addSubview(sliderAY)
        
        sliderA.z = UISlider()
        let sliderAZ = sliderA.z!
        sliderAZ.frame = CGRect(x: 40.0, y: 160.0, width: 230.0, height: 40.0)
        sliderAZ.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        sliderA.valZLabel = UILabel()
        let sliderAZLabelVal = sliderA.valZLabel!
        sliderAZLabelVal.text = "0.00"
        sliderAZLabelVal.font = UIFont(name: "Avenir", size: 14)
        sliderAZLabelVal.frame = CGRect(x: sliderAZ.frame.width + 40.0, y: 160.0, width: 50.0, height: 25.0)
        mainView.addSubview(sliderAZLabelVal)
        mainView.addSubview(sliderAZ)
        
        sliderB.x = UISlider()
        let sliderBX = sliderB.x!
        sliderBX.frame = CGRect(x: 40.0, y: 210.0, width: 230.0, height: 40.0)
        sliderBX.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        sliderB.valXLabel = UILabel()
        let sliderBXLabelVal = sliderB.valXLabel!
        sliderBXLabelVal.text = "0.00"
        sliderBXLabelVal.font = UIFont(name: "Avenir", size: 14)
        sliderBXLabelVal.frame = CGRect(x: sliderBX.frame.width + 40.0, y: 210.0, width: 50.0, height: 25.0)
        mainView.addSubview(sliderBXLabelVal)
        mainView.addSubview(sliderBX)
        
        sliderB.y = UISlider()
        let sliderBY = sliderB.y!
        sliderBY.frame = CGRect(x: 40.0, y: 260.0, width: 230.0, height: 40.0)
        sliderBY.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        sliderB.valYLabel = UILabel()
        let sliderBYLabelVal = sliderB.valYLabel!
        sliderBYLabelVal.text = "0.00"
        sliderBYLabelVal.font = UIFont(name: "Avenir", size: 14)
        sliderBYLabelVal.frame = CGRect(x: sliderBY.frame.width + 40.0, y: 260.0, width: 50.0, height: 25.0)
        mainView.addSubview(sliderBYLabelVal)
        mainView.addSubview(sliderBY)
        
        sliderB.z = UISlider()
        let sliderBZ = sliderB.z!
        sliderBZ.frame = CGRect(x: 40.0, y: 310.0, width: 230.0, height: 40.0)
        sliderBZ.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        sliderB.valZLabel = UILabel()
        let sliderBZLabelVal = sliderB.valZLabel!
        sliderBZLabelVal.text = "0.00"
        sliderBZLabelVal.font = UIFont(name: "Avenir", size: 14)
        sliderBZLabelVal.frame = CGRect(x: sliderBZ.frame.width + 40.0, y: 310.0, width: 50.0, height: 25.0)
        mainView.addSubview(sliderBZLabelVal)
        mainView.addSubview(sliderBZ)
        
        /**********************************
        *   INITIALIZE OPERATION LABELS   *
        ***********************************/
        additionLabel = UILabel()
        additionLabel?.frame = CGRect(x: mainView.frame.width / 4.0, y: 350.0, width: 230.0, height: 25.0)
        additionLabel?.text = "A + B: (x: 0.00, y: 0.00, z: 0.00)"
        additionLabel?.font = UIFont(name: "Avenir", size: 14)
        additionLabel?.textAlignment = NSTextAlignment.center
        mainView.addSubview(additionLabel!)
        
        dotProductLabel = UILabel()
        dotProductLabel?.frame = CGRect(x: mainView.frame.width / 4.0, y: 390.0, width: 230.0, height: 25.0)
        dotProductLabel?.text = "A • B: 0.00"
        dotProductLabel?.font = UIFont(name: "Avenir", size: 14)
        dotProductLabel?.textAlignment = NSTextAlignment.center
        mainView.addSubview(dotProductLabel!)
        
        crossProductLabel = UILabel()
        crossProductLabel?.frame = CGRect(x: mainView.frame.width / 4.0, y: 430.0, width: 230.0, height: 25.0)
        crossProductLabel?.text = "A × B: (x: 0.00, y: 0.00, z: 0.00)"
        crossProductLabel?.font = UIFont(name: "Avenir", size: 14)
        crossProductLabel?.textAlignment = NSTextAlignment.center
        mainView.addSubview(crossProductLabel!)
        
        /***********************************
        *     INITIALIZE VECTOR LABELS     *
        ************************************/
        let title: UILabel = UILabel()
        title.frame = CGRect(x: 60.0, y: 30.0, width: 230.0, height: 25.0)
        title.text = "Vector Operations"
        title.font = UIFont(name: "Avenir", size: 16)
        title.textAlignment = NSTextAlignment.center
        mainView.addSubview(title)
        
        let labelAX: UILabel = UILabel()
        labelAX.frame = CGRect(x: 15.0, y: 60.0, width: 35.0, height: 25.0)
        labelAX.text = "Ax"
        labelAX.font = UIFont(name: "Avenir", size: 16)
        mainView.addSubview(labelAX)
        
        let labelAY: UILabel = UILabel()
        labelAY.frame = CGRect(x: 15.0, y: 110.0, width: 35.0, height: 25.0)
        labelAY.text = "Ay"
        labelAY.font = UIFont(name: "Avenir", size: 16)
        mainView.addSubview(labelAY)
        
        let labelAZ: UILabel = UILabel()
        labelAZ.frame = CGRect(x: 15.0, y: 160.0, width: 35.0, height: 25.0)
        labelAZ.text = "Az"
        labelAZ.font = UIFont(name: "Avenir", size: 16)
        mainView.addSubview(labelAZ)
        
        let labelBX: UILabel = UILabel()
        labelBX.frame = CGRect(x: 15.0, y: 210.0, width: 35.0, height: 25.0)
        labelBX.text = "Bx"
        labelBX.font = UIFont(name: "Avenir", size: 16)
        mainView.addSubview(labelBX)
        
        let labelBY: UILabel = UILabel()
        labelBY.frame = CGRect(x: 15.0, y: 260.0, width: 35.0, height: 25.0)
        labelBY.text = "By"
        labelBY.font = UIFont(name: "Avenir", size: 16)
        mainView.addSubview(labelBY)
        
        let labelBZ: UILabel = UILabel()
        labelBZ.frame = CGRect(x: 15.0, y: 310.0, width: 35.0, height: 25.0)
        labelBZ.text = "Bz"
        labelBZ.font = UIFont(name: "Avenir", size: 16)
        mainView.addSubview(labelBZ)
        
        return true
    }
    
    @objc func sliderValueChanged() {
        updateLabels()
        vectorAddition()
        vectorDotProduct()
        vectorCrossProduct()
    }
    
    func updateLabels() {
        //Update slider value labels for sliderA
        sliderA.valXLabel?.text = String(format: "%.2f", sliderA.x!.value)
        sliderA.valYLabel?.text = String(format: "%.2f", sliderA.y!.value)
        sliderA.valZLabel?.text = String(format: "%.2f", sliderA.z!.value)
        
        //Update slider value labels for sliderB
        sliderB.valXLabel?.text = String(format: "%.2f", sliderB.x!.value)
        sliderB.valYLabel?.text = String(format: "%.2f", sliderB.y!.value)
        sliderB.valZLabel?.text = String(format: "%.2f", sliderB.z!.value)
    }
    
    func vectorAddition() {
        
        if let sliderAx = sliderA.x, let sliderBx = sliderB.x, let sliderAy = sliderA.y, let sliderBy = sliderB.y, let sliderAz = sliderA.z, let sliderBz = sliderB.z {
            let x = decimalPrecisionToString(decimal: sliderAx.value + sliderBx.value)
            let y = decimalPrecisionToString(decimal: sliderAy.value + sliderBy.value)
            let z = decimalPrecisionToString(decimal: sliderAz.value + sliderBz.value)
            
            additionLabel?.text = "A + B: (x: \(x), y: \(y), z: \(z))"
        }
    }
    
    func vectorDotProduct() {
        
        if let sliderAx = sliderA.x, let sliderBx = sliderB.x, let sliderAy = sliderA.y, let sliderBy = sliderB.y, let sliderAz = sliderA.z, let sliderBz = sliderB.z {
            let x = sliderAx.value * sliderBx.value
            let y = sliderAy.value * sliderBy.value
            let z = sliderAz.value * sliderBz.value
            
            let dotProduct = decimalPrecisionToString(decimal: x + y + z)
            dotProductLabel?.text = "A • B: \(dotProduct)"
        }
    }
    
    func vectorCrossProduct() {
        
        if let sliderAx = sliderA.x, let sliderBx = sliderB.x, let sliderAy = sliderA.y, let sliderBy = sliderB.y, let sliderAz = sliderA.z, let sliderBz = sliderB.z {
            let x = decimalPrecisionToString(decimal: (sliderAy.value * sliderBz.value) - (sliderAz.value * sliderBy.value))
            let y = decimalPrecisionToString(decimal: (sliderAz.value * sliderBx.value) - (sliderAx.value * sliderBz.value))
            let z = decimalPrecisionToString(decimal: (sliderAx.value * sliderBy.value) - (sliderAy.value * sliderBx.value))
            
            crossProductLabel?.text = "A × B: (x: \(x), y: \(y), z: \(z))"
        }
    }
    
    func decimalPrecisionToString(decimal: Float) -> String {
        return String(format: "%.2f", decimal)
    }
}

