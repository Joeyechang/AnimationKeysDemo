

import UIKit

// A delay function
func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
  let tint = CABasicAnimation(keyPath: "backgroundColor")
  tint.fromValue = layer.backgroundColor
  tint.toValue = toColor.cgColor
  tint.duration = 0.5
  layer.add(tint, forKey: nil)
  layer.backgroundColor = toColor.cgColor
}

func roundCorners(layer: CALayer, toRadius: CGFloat) {
  let round = CABasicAnimation(keyPath: "cornerRadius")
  round.fromValue = layer.cornerRadius
  round.toValue = toRadius
  round.duration = 0.5
  layer.add(round, forKey: nil)
  layer.cornerRadius = toRadius
}

class ViewController: UIViewController {

  // MARK: IB outlets

  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!

  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!

  // MARK: further UI
  let info = UILabel()
    
  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]

  var statusPosition = CGPoint.zero

  // MARK: view controller methods

  override func viewDidLoad() {
    super.viewDidLoad()

    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true

    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)

    status.isHidden = true
    status.center = loginButton.center
    view.addSubview(status)

    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    status.addSubview(label)

    statusPosition = status.center
    
    info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0, width: view.frame.size.width, height: 30)
    info.backgroundColor = UIColor.clear
    info.font = UIFont(name: "HelveticaNeue", size: 12.0)
    info.textAlignment = .center
    info.textColor = UIColor.white
    info.text = "Tap on a field and enter username and password"
    view.insertSubview(info, belowSubview: loginButton)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let formGroup = CAAnimationGroup()
    formGroup.duration = 0.5
    formGroup.beginTime = CACurrentMediaTime() + 0.5
    formGroup.fillMode = kCAFillModeBackwards
    formGroup.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseIn)
    
    
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width/2 
    flyRight.toValue = view.bounds.size.width/2
    
    let fadeFieldIn = CABasicAnimation(keyPath: "opacity")
    fadeFieldIn.fromValue = 0.25
    fadeFieldIn.toValue = 1.0
    
    formGroup.animations = [flyRight, fadeFieldIn]
    heading.layer.add(formGroup, forKey: nil)
    
    formGroup.delegate = self
    formGroup.setValue("form", forKey: "name")
    formGroup.setValue(username.layer, forKey: "layer")
    
    formGroup.beginTime = CACurrentMediaTime() + 2.3
    username.layer.add(formGroup, forKey: nil)
    
    formGroup.setValue(password.layer, forKey: "layer")
    formGroup.beginTime = CACurrentMediaTime() + 2.4
    password.layer.add(formGroup, forKey: nil)
    
    
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let fadeIn = CABasicAnimation(keyPath: "opacity")
    fadeIn.fromValue = 0.0
    fadeIn.toValue = 1.0
    fadeIn.duration = 0.5
    fadeIn.fillMode = kCAFillModeBackwards
    fadeIn.beginTime = CACurrentMediaTime() + 0.5
    cloud1.layer.add(fadeIn, forKey: nil)

    fadeIn.beginTime = CACurrentMediaTime() + 0.7
    cloud2.layer.add(fadeIn, forKey: nil)

    fadeIn.beginTime = CACurrentMediaTime() + 0.9
    cloud3.layer.add(fadeIn, forKey: nil)

    fadeIn.beginTime = CACurrentMediaTime() + 1.1
    cloud4.layer.add(fadeIn, forKey: nil)

//    UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5,
//      initialSpringVelocity: 0.0,
//      animations: {
//        self.loginButton.center.y -= 30.0
//        self.loginButton.alpha = 1.0
//      },
//      completion: nil
//    )
    let groupAnimation = CAAnimationGroup()
    groupAnimation.beginTime = CACurrentMediaTime() + 0.5
    groupAnimation.duration = 0.5
    groupAnimation.fillMode = kCAFillModeBackwards
    groupAnimation.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseIn)
    
    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 3.5
    scaleDown.toValue = 1.0
    
    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = .pi / 4.0
    rotate.toValue = 0.0
    
    let fade = CABasicAnimation(keyPath: "opacity")
    fade.fromValue = 0.0
    fade.toValue = 1.0
    
    groupAnimation.animations = [scaleDown, rotate, fade]
    loginButton.layer.add(groupAnimation, forKey: nil)
    
    
//    animateCloud(cloud1)
//    animateCloud(cloud2)
//    animateCloud(cloud3)
//    animateCloud(cloud4)
    
    animateCloud(layer: cloud1.layer)
    animateCloud(layer: cloud2.layer)
    animateCloud(layer: cloud3.layer)
    animateCloud(layer: cloud4.layer)
    
    let flyLeft = CABasicAnimation(keyPath: "position.x")
    flyLeft.fromValue = info.layer.position.x + view.frame.size.width
    flyLeft.toValue = info.layer.position.x
    flyLeft.duration = 5.0
    flyLeft.repeatCount = 2.5
    flyLeft.autoreverses = true
    flyLeft.speed = 2.0
    view.layer.speed = 2.0
    info.layer.add(flyLeft, forKey: "infoappear")
    
    let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
    fadeLabelIn.fromValue = 0.2
    fadeLabelIn.toValue = 1.0
    fadeLabelIn.duration = 4.5
    info.layer.add(fadeLabelIn, forKey: "fadein")
    
    username.delegate = self
    password.delegate = self
    
  }

  func showMessage(index: Int) {
    label.text = messages[index]

    UIView.transition(with: status, duration: 0.33,
      options: [.curveEaseOut, .transitionFlipFromBottom],
      animations: {
        self.status.isHidden = false
      },
      completion: {_ in
        //transition completion
        delay(seconds: 2.0) {
          if index < self.messages.count-1 {
            self.removeMessage(index: index)
          } else {
            //reset form
            self.resetForm()
          }
        }
      }
    )
  }

  func removeMessage(index: Int) {

    UIView.animate(withDuration: 0.33, delay: 0.0,
      animations: {
        self.status.center.x += self.view.frame.size.width
      },
      completion: {_ in
        self.status.isHidden = true
        self.status.center = self.statusPosition

        self.showMessage(index: index+1)
      }
    )
  }

  func resetForm() {
    UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop,
      animations: {
        self.status.isHidden = true
        self.status.center = self.statusPosition
      },
      completion: { _ in
        let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
        tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
        roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
    })

    UIView.animate(withDuration: 0.2, delay: 0.0,
      animations: {
        self.spinner.center = CGPoint(x: -20.0, y: 16.0)
        self.spinner.alpha = 0.0
        self.loginButton.bounds.size.width -= 80.0
        self.loginButton.center.y -= 60.0
      },
      completion: nil
    )
  }

  // MARK: further methods

  @IBAction func login() {
    view.endEditing(true)

    UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2,
      initialSpringVelocity: 0.0,
      animations: {
        self.loginButton.bounds.size.width += 80.0
      },
      completion: {_ in
        self.showMessage(index: 0)
      }
    )

    UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.0,
      animations: {
        self.loginButton.center.y += 60.0
        self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
        self.spinner.alpha = 1.0
      },
      completion: nil
    )

    let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
    tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
    roundCorners(layer: loginButton.layer, toRadius: 25.0)
  }

    // view animate
//  func animateCloud(_ cloud: UIImageView) {
//    let cloudSpeed = 60.0 / view.frame.size.width
//    let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
//    UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear,
//      animations: {
//        cloud.frame.origin.x = self.view.frame.size.width
//      },
//      completion: {_ in
//        cloud.frame.origin.x = -cloud.frame.size.width
//        self.animateCloud(cloud)
//      }
//    )
//  }
    
    // layer animate
    func animateCloud(layer: CALayer) {
        
        //1
        let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
        let duration: TimeInterval = Double(
            view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
        
        //2
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue = self.view.bounds.width + layer.bounds.width/2
        cloudMove.delegate = self
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        layer.add(cloudMove, forKey: nil)
        
    }
  // MARK: UITextFieldDelegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField?.becomeFirstResponder()
    return true
  }

}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animation did finish")
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
        if name == "form" {// form field found
            
            // Note: Remember that value(forKey:) always returns an AnyObject?; therefore you must cast the result to your desired type. Don’t forget that the cast operation can fail, so you must use optionals in the example above to handle error conditions, such as when the name key exists but the layer key does not.
            let layer = anim.value(forKey: "layer") as? CALayer
            anim.setValue(nil, forKey: "layer")// Once that’s done, you set the value of layer to nil to remove the reference to the original layer
            
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.25
            pulse.toValue = 1.0
            pulse.duration = 0.25
            layer?.add(pulse, forKey: nil)// layer? — that means the add(_:forKey:) call will be skipped if there isn’t a layer stored in the animation. And since you set the layer to nil earlier, this pulse animation will only happen the ﬁrst time the form ﬁeld ﬂies in from the right.
        }
        
        if name == "cloud" {
            if let layer = anim.value(forKey: "layer") as? CALayer {
                anim.setValue(nil, forKey: "layer")
                
                layer.position.x = -layer.bounds.width/2
                delay(seconds: 0.5) {
                    self.animateCloud(layer: layer)
                }
            }
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let runningAnimations = info.layer.animationKeys()
            else {
                return
        }
        info.layer.removeAnimation(forKey: "infoappear")
        print(runningAnimations)
    }
}


