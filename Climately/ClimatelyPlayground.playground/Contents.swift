//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var icon_url = "https://icons8.com/web-app/category/Weather"



func getWeather(sender: UIButton) {
    
    //        //only apply the blur if the user hasn't disabled transparency effects
    //        if !UIAccessibilityIsReduceTransparencyEnabled() {
    //            self.view.backgroundColor = UIColor.clearColor()
    //
    //            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
    //            let blurEffectView = UIVisualEffectView(effect: blurEffect)
    //            //always fill the view
    //            blurEffectView.frame = self.view.bounds
    //            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    //
    //            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
    //        }
    //        else {
    //            self.view.backgroundColor = UIColor.blackColor()
    //        }
    //        
}

func normalTap(){
    
    print("Normal tap")
}

func longTap(sender : UIGestureRecognizer){
    print("Long tap")
    if sender.state == .Ended {
        print("UIGestureRecognizerStateEnded")
        //Do Whatever You want on End of Gesture
    }
    else if sender.state == .Began {
        print("UIGestureRecognizerStateBegan.")
        //Do Whatever You want on Began of Gesture
    }
}

//        let tapGesture = UITapGestureRecognizer(target: self, action: "normalTap")
//        let longGesture = UITapGestureRecognizer(target: self, action: "longTap:")
//        tapGesture.numberOfTapsRequired = 1
//        getWeatherBtn.addGestureRecognizer(tapGesture)
//        getWeatherBtn.addGestureRecognizer(longGesture)