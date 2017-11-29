//
//  MaterialShowcase.swift
//  MaterialShowcase
//
//  Created by Quang Nguyen on 5/4/17.
//  Copyright © 2017 Aromajoin. All rights reserved.
//
import UIKit

@objc public protocol MaterialShowcaseDelegate: class {
  @objc optional func showCaseWillDismiss(showcase: MaterialShowcase)
  @objc optional func showCaseDidDismiss(showcase: MaterialShowcase)
}

public class MaterialShowcase: UIView {
  
  // MARK: Material design guideline constant
  let BACKGROUND_ALPHA: CGFloat = 0.96
  let TARGET_HOLDER_RADIUS: CGFloat = 44
  let TEXT_CENTER_OFFSET: CGFloat = 44 + 20
  let INSTRUCTIONS_CENTER_OFFSET: CGFloat = 20
  let LABEL_MARGIN: CGFloat = 40
  let TARGET_PADDING: CGFloat = 20
  
  // Other default properties
  let LABEL_DEFAULT_HEIGHT: CGFloat = 50
  let BACKGROUND_DEFAULT_COLOR = UIColor.fromHex(hexString: "#2196F3")
  let TARGET_HOLDER_COLOR = UIColor.white
  
  // MARK: Animation properties
  var ANI_COMEIN_DURATION: TimeInterval = 0.5 // second
  var ANI_GOOUT_DURATION: TimeInterval = 0.5  // second
  var ANI_TARGET_HOLDER_SCALE: CGFloat = 2.2
  let ANI_RIPPLE_COLOR = UIColor.white
  let ANI_RIPPLE_ALPHA: CGFloat = 0.5
  let ANI_RIPPLE_SCALE: CGFloat = 1.6
  
  var offsetThreshold: CGFloat = 88
  
  // MARK: Private view properties
  var containerView: UIView!
  var targetView: UIView!
  var backgroundView: UIView!
  var targetHolderView: UIView!
  var hiddenTargetHolderView: UIView!
  var targetRippleView: UIView!
  var targetCopyView: UIView!
  var instructionView: MaterialShowcaseInstructionView!
  
  // MARK: Public Properties
  
  // Background
  public var backgroundPromptColor: UIColor!
  public var backgroundPromptColorAlpha: CGFloat!
  // Target
  public var shouldSetTintColor: Bool = true
  public var targetTintColor: UIColor!
  public var targetHolderRadius: CGFloat!
  public var targetHolderColor: UIColor!
  // Text
  public var primaryText: String!
  public var secondaryText: String!
  public var primaryTextColor: UIColor!
  public var secondaryTextColor: UIColor!
  public var primaryTextSize: CGFloat!
  public var secondaryTextSize: CGFloat!
  public var primaryTextFont: UIFont?
  public var secondaryTextFont: UIFont?
  // Animation
  public var aniComeInDuration: TimeInterval!
  public var aniGoOutDuration: TimeInterval!
  public var aniRippleScale: CGFloat!
  public var aniRippleColor: UIColor!
  public var aniRippleAlpha: CGFloat!
  // Delegate
  public weak var delegate: MaterialShowcaseDelegate?
  
  public init() {
    // Create frame
    let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    super.init(frame: frame)
    
    configure()
  }
  
  // No supported initilization method
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public APIs
extension MaterialShowcase {
  
  /// Sets a general UIView as target
  public func setTargetView(view: UIView) {
    targetView = view
    if let label = targetView as? UILabel {
      targetTintColor = label.textColor
      backgroundPromptColor = label.textColor
    } else if let button = targetView as? UIButton {
      let tintColor = button.titleColor(for: .normal)
      targetTintColor = tintColor
      backgroundPromptColor = tintColor
    } else {
      targetTintColor = targetView.tintColor
      backgroundPromptColor = targetView.tintColor
    }
  }
  
  /// Sets a UIBarButtonItem as target
  public func setTargetView(barButtonItem: UIBarButtonItem) {
    if let view = (barButtonItem.value(forKey: "view") as? UIView)?.subviews.first {
      targetView = view
    }
  }
  
  /// Sets a UITabBar Item as target
  public func setTargetView(tabBar: UITabBar, itemIndex: Int) {
    let tabBarItems = orderedTabBarItemViews(of: tabBar)
    if itemIndex < tabBarItems.count {
      targetView = tabBarItems[itemIndex]
      targetTintColor = tabBar.tintColor
      backgroundPromptColor = tabBar.tintColor
    } else {
      print ("The tab bar item index is out of range")
    }
  }
  
  /// Sets a UITableViewCell as target
  public func setTargetView(tableView: UITableView, section: Int, row: Int) {
    let indexPath = IndexPath(row: row, section: section)
    targetView = tableView.cellForRow(at: indexPath)?.contentView
    // for table viewcell, we do not need target holder (circle view)
    // therefore, set its radius = 0
    targetHolderRadius = 0
  }
  
  /// Shows it over current screen after completing setup process
  public func show(animated: Bool = true, completion handler: (()-> Void)?) {
    initViews()
    alpha = 0.0
    containerView.addSubview(self)
    self.layoutIfNeeded()
    
    let scale = TARGET_HOLDER_RADIUS / (backgroundView.frame.width / 2)
    let center = backgroundView.center
    
    backgroundView.transform = CGAffineTransform(scaleX: scale, y: scale) // Initial set to support animation
    self.backgroundView.center = self.targetHolderView.center
    if animated {
      UIView.animate(withDuration: aniComeInDuration, animations: {
        self.targetHolderView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.backgroundView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.backgroundView.center = center
        self.alpha = 1.0
      }, completion: { _ in
        self.startAnimations()
      })
    } else {
      self.alpha = 1.0
    }
    // Handler user's action after showing.
    if let handler = handler {
      handler()
    }
  }
}

// MARK: - Utility API
extension MaterialShowcase {
  /// Returns the current showcases displayed on screen.
  /// It will return null if no showcase exists.
  public static func presentedShowcases() -> [MaterialShowcase]? {
    guard let window = UIApplication.shared.delegate?.window else {
      return nil
    }
    return window?.subviews.filter({ (view) -> Bool in
      return view is MaterialShowcase
    }) as? [MaterialShowcase]
  }
}

// MARK: - Setup views internally
extension MaterialShowcase {
  
  /// Initializes default view properties
  func configure() {
    backgroundColor = UIColor.clear
    guard let window = UIApplication.shared.delegate?.window else {
      return
    }
    containerView = window
    setDefaultProperties()
  }
  
  func setDefaultProperties() {
    // Background
    backgroundPromptColor = BACKGROUND_DEFAULT_COLOR
    backgroundPromptColorAlpha = BACKGROUND_ALPHA
    // Target view
    targetTintColor = BACKGROUND_DEFAULT_COLOR
    targetHolderColor = TARGET_HOLDER_COLOR
    targetHolderRadius = TARGET_HOLDER_RADIUS
    // Text
    primaryText = MaterialShowcaseInstructionView.PRIMARY_DEFAULT_TEXT
    secondaryText = MaterialShowcaseInstructionView.SECONDARY_DEFAULT_TEXT
    primaryTextColor = MaterialShowcaseInstructionView.PRIMARY_TEXT_COLOR
    secondaryTextColor = MaterialShowcaseInstructionView.SECONDARY_TEXT_COLOR
    primaryTextSize = MaterialShowcaseInstructionView.PRIMARY_TEXT_SIZE
    secondaryTextSize = MaterialShowcaseInstructionView.SECONDARY_TEXT_SIZE
    // Animation
    aniComeInDuration = ANI_COMEIN_DURATION
    aniGoOutDuration = ANI_GOOUT_DURATION
    aniRippleAlpha = ANI_RIPPLE_ALPHA
    aniRippleColor = ANI_RIPPLE_COLOR
    aniRippleScale = ANI_RIPPLE_SCALE
  }
  
  func startAnimations() {
    let options: UIViewKeyframeAnimationOptions = [.curveEaseInOut, .repeat]
    UIView.animateKeyframes(withDuration: 1, delay: 0, options: options, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
        self.targetRippleView.alpha = self.ANI_RIPPLE_ALPHA
        self.targetHolderView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.targetRippleView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      })
      
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
        self.targetHolderView.transform = CGAffineTransform.identity
        self.targetRippleView.alpha = 0
        self.targetRippleView.transform = CGAffineTransform(scaleX: self.aniRippleScale, y: self.aniRippleScale)
      })
      
    }, completion: nil)
  }
  
  func initViews() {
    let center = calculateCenter(at: targetView, to: containerView)
    
    addTargetRipple(at: center)
    addTargetHolder(at: center)
    addTarget(at: center)
    addInstructionView(at: center)
    instructionView.layoutIfNeeded()
    addBackground()

    // Add gesture recognizer for both container and its subview
    addGestureRecognizer(tapGestureRecoganizer())
    // Disable subview interaction to let users click to general view only
    for subView in subviews {
      subView.isUserInteractionEnabled = false
    }
  }
  
  /// Add background which is a big circle
  private func addBackground() {
    let radius: CGFloat!
    
    let center = getOuterCircleCenterPoint(for: targetCopyView)
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      radius = 300.0
    } else {
      radius = getOuterCircleRadius(center: center, textBounds: instructionView.frame, targetBounds: targetCopyView.frame)
    }
    
    backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: radius * 2,height: radius * 2))
    backgroundView.center = center
    backgroundView.backgroundColor = backgroundPromptColor.withAlphaComponent(backgroundPromptColorAlpha)
    backgroundView.asCircle()
    insertSubview(backgroundView, belowSubview: targetRippleView)
  }
  
  /// A background view which add ripple animation when showing target view
  private func addTargetRipple(at center: CGPoint) {
    targetRippleView = UIView(frame: CGRect(x: 0, y: 0, width: targetHolderRadius * 2,height: targetHolderRadius * 2))
    targetRippleView.center = center
    targetRippleView.backgroundColor = aniRippleColor
    targetRippleView.alpha = 0.0 //set it invisible
    targetRippleView.asCircle()
    addSubview(targetRippleView)
    
  }
  
  /// A circle-shape background view of target view
  private func addTargetHolder(at center: CGPoint) {
    hiddenTargetHolderView = UIView()
    hiddenTargetHolderView.isHidden = true
    targetHolderView = UIView(frame: CGRect(x: 0, y: 0, width: targetHolderRadius * 2,height: targetHolderRadius * 2))
    targetHolderView.center = center
    targetHolderView.backgroundColor = targetHolderColor
    targetHolderView.asCircle()
    hiddenTargetHolderView.frame = targetHolderView.frame
    targetHolderView.transform = CGAffineTransform(scaleX: 1/ANI_TARGET_HOLDER_SCALE, y: 1/ANI_TARGET_HOLDER_SCALE) // Initial set to support animation
    addSubview(hiddenTargetHolderView)
    addSubview(targetHolderView)
  }
  
  /// Create a copy view of target view
  /// It helps us not to affect the original target view
  private func addTarget(at center: CGPoint) {
//    targetCopyView = targetView.copyView()
    targetCopyView = targetView.snapshotView(afterScreenUpdates: true)
    
    if shouldSetTintColor {
      targetCopyView.setTintColor(targetTintColor, recursive: true)
      
      if targetCopyView is UIButton {
        let button = targetView as! UIButton
        let buttonCopy = targetCopyView as! UIButton
        buttonCopy.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonCopy.setTitleColor(targetTintColor, for: .normal)
        buttonCopy.isEnabled = true
      } else if targetCopyView is UIImageView {
        let imageView = targetView as! UIImageView
        let imageViewCopy = targetCopyView as! UIImageView
        imageViewCopy.image = imageView.image?.withRenderingMode(.alwaysTemplate)
      } else if let imageViewCopy = targetCopyView.subviews.first as? UIImageView,
        let labelCopy = targetCopyView.subviews.last as? UILabel {
        let imageView = targetView.subviews.first as! UIImageView
        imageViewCopy.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        labelCopy.textColor = targetTintColor
      } else if let label = targetCopyView as? UILabel {
        label.textColor = targetTintColor
      }
    }
    
    let width = targetCopyView.frame.width
    let height = targetCopyView.frame.height
    targetCopyView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    targetCopyView.center = center
    targetCopyView.translatesAutoresizingMaskIntoConstraints = true
    
    addSubview(targetCopyView)
  }
  
  /// Configures and adds primary label view
  private func addInstructionView(at center: CGPoint) {
    instructionView = MaterialShowcaseInstructionView()
    
    instructionView.primaryTextFont = primaryTextFont
    instructionView.primaryTextSize = primaryTextSize
    instructionView.primaryTextColor = primaryTextColor
    instructionView.primaryText = primaryText
    
    instructionView.secondaryTextFont = secondaryTextFont
    instructionView.secondaryTextSize = secondaryTextSize
    instructionView.secondaryTextColor = secondaryTextColor
    instructionView.secondaryText = secondaryText
    
    // Calculate x position
    let xPosition = LABEL_MARGIN
    
    // Calculate y position
    var yPosition: CGFloat!
    
    if getTargetPosition(target: targetView, container: containerView) == .above {
      yPosition = center.y + TEXT_CENTER_OFFSET
    } else {
      yPosition = center.y - TEXT_CENTER_OFFSET - LABEL_DEFAULT_HEIGHT * 2
    }
    
    instructionView.frame = CGRect(x: xPosition,
                                y: yPosition,
                                width: containerView.frame.width - (xPosition + xPosition),
                                height: 0)
    addSubview(instructionView)
  }
  
  /// Handles user's tap
  private func tapGestureRecoganizer() -> UIGestureRecognizer {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MaterialShowcase.tapGestureSelector))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.numberOfTouchesRequired = 1
    return tapGesture
  }
  
  @objc private func tapGestureSelector() {
    completeShowcase()
  }
  
  /// Default action when dimissing showcase
  /// Notifies delegate, removes views, and handles out-going animation
  @objc public func completeShowcase(animated: Bool = true) {
    if delegate != nil && delegate?.showCaseDidDismiss != nil {
      delegate?.showCaseWillDismiss?(showcase: self)
    }
    if animated {
      targetRippleView.removeFromSuperview()
      UIView.animateKeyframes(withDuration: aniGoOutDuration, delay: 0, options: [.calculationModeLinear], animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 3/5, animations: {
          self.targetHolderView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
          self.backgroundView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
          self.backgroundView.alpha = 0
        })
        UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 2/5, animations: {
          self.alpha = 0
        })
      }, completion: { (success) in
        // Recycle subviews
        self.recycleSubviews()
        // Remove it from current screen
        self.removeFromSuperview()
      })
    } else {
      // Recycle subviews
      self.recycleSubviews()
      // Remove it from current screen
      self.removeFromSuperview()
    }
    if delegate != nil && delegate?.showCaseDidDismiss != nil {
      delegate?.showCaseDidDismiss?(showcase: self)
    }
  }
  
  private func recycleSubviews() {
    for subview in subviews {
      subview.removeFromSuperview()
    }
  }
}

// MARK: - Private helper methods
extension MaterialShowcase {
  
  /// Defines the position of target view
  /// which helps to place texts at suitable positions
  enum TargetPosition {
    case above // at upper screen part
    case below // at lower screen part
  }
  
  /// Detects the position of target view relative to its container
  func getTargetPosition(target: UIView, container: UIView) -> TargetPosition {
    let center = calculateCenter(at: targetView, to: container)
    if center.y < container.frame.height / 2{
      return .above
    } else {
      return .below
    }
  }
  
  // Calculates the center point based on targetview
  func calculateCenter(at targetView: UIView, to containerView: UIView) -> CGPoint {
    let targetRect = targetView.convert(targetView.bounds , to: containerView)
    return targetRect.center
  }
  
  // Gets all UIView from TabBarItem.
  func orderedTabBarItemViews(of tabBar: UITabBar) -> [UIView] {
    let interactionViews = tabBar.subviews.filter({$0.isUserInteractionEnabled})
    return interactionViews.sorted(by: {$0.frame.minX < $1.frame.minX})
  }
}


