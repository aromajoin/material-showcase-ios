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
  fileprivate let BACKGROUND_ALPHA: CGFloat = 0.96
  fileprivate let TARGET_HOLDER_RADIUS: CGFloat = 44
  fileprivate let TEXT_CENTER_OFFSET: CGFloat = 44 + 20
  fileprivate let PRIMARY_TEXT_SIZE: CGFloat = 20
  fileprivate let SECONDARY_TEXT_SIZE: CGFloat = 15
  fileprivate let LABEL_MARGIN: CGFloat = 40
  
  // Other default properties
  fileprivate let LABEL_DEFAULT_HEIGHT: CGFloat = 50
  fileprivate let PRIMARY_TEXT_COLOR = UIColor.white
  fileprivate let SECONDARY_TEXT_COLOR = UIColor.white.withAlphaComponent(0.87)
  fileprivate let BACKGROUND_DEFAULT_COLOR = UIColor.fromHex(hexString: "#2196F3")
  fileprivate let TARGET_HOLDER_COLOR = UIColor.white
  fileprivate let PRIMARY_DEFAULT_TEXT = "Awesome action"
  fileprivate let SECONDARY_DEFAULT_TEXT = "Tap here to do some awesome thing"
  
  // MARK: Animation properties
  fileprivate var ANI_COMEIN_DURATION: TimeInterval = 0.5 // second
  fileprivate var ANI_GOOUT_DURATION: TimeInterval = 0.5  // second
  fileprivate var ANI_TARGET_HOLDER_SCALE: CGFloat = 2.2
  fileprivate let ANI_RIPPLE_COLOR = UIColor.white
  fileprivate let ANI_RIPPLE_ALPHA: CGFloat = 0.2
  fileprivate let ANI_RIPPLE_SCALE: CGFloat = 1.4
  
  // MARK: Private view properties
  fileprivate var containerView: UIView!
  fileprivate var targetView: UIView!
  fileprivate var backgroundView: UIView!
  fileprivate var targetHolderView: UIView!
  fileprivate var targetRippleView: UIView!
  fileprivate var targetCopyView: UIView!
  fileprivate var primaryLabel: UILabel!
  fileprivate var secondaryLabel: UILabel!
  
  // MARK: Public Properties

  // Background
  public var backgroundPromptColor: UIColor!
  public var backgroundPromptColorAlpha: CGFloat!
  // Target
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
  
  // Sets a general UIView as target
  public func setTargetView(view: UIView) {
    targetView = view
  }
  
  // Sets a UIBarButtonItem as target
  public func setTargetView(barButtonItem: UIBarButtonItem) {
    if let view = barButtonItem.value(forKey: "view") as? UIView {
      targetView = view
    }
  }
  
  // Sets a UITabBar Item as target
  public func setTargetView(tabBar: UITabBar, itemIndex: Int) {
    let tabBarItems = orderedTabBarItemViews(of: tabBar)
    if itemIndex < tabBarItems.count {
      targetView = tabBarItems[itemIndex]
    } else {
      print ("The tab bar item index is out of range")
    }
  }
  
  // Sets a UITableViewCell as target
  public func setTargetView(tableView: UITableView, section: Int, row: Int) {
    let indexPath = IndexPath(row: row, section: section)
    targetView = tableView.cellForRow(at: indexPath)?.contentView
    // for table viewcell, we do not need target holder (circle view)
    // therefore, set its radius = 0
    targetHolderRadius = 0
  }
  
  // Finally, shows it
  public func show(completion handler: (()-> Void)?) {
    alpha = 0.0
    containerView.addSubview(self)
    UIView.animate(withDuration: ANI_COMEIN_DURATION, delay: 0,
                   options: [.curveEaseInOut],
                   animations: { self.alpha = 1.0 },
                   completion: nil)
    
    // Handler user's action after showing.
    if let handler = handler {
      handler()
    }
  }
}

// MARK: - Setup views internally
extension MaterialShowcase {
  
  // Initializes default view properties
  fileprivate func configure() {
    backgroundColor = UIColor.clear
    guard let window = UIApplication.shared.delegate?.window else {
      return
    }
    containerView = window
    setDefaultProperties()
  }
  
  fileprivate func setDefaultProperties() {
    // Background
    backgroundPromptColor = BACKGROUND_DEFAULT_COLOR
    backgroundPromptColorAlpha = BACKGROUND_ALPHA
    // Target view
    targetTintColor = BACKGROUND_DEFAULT_COLOR
    targetHolderColor = TARGET_HOLDER_COLOR
    targetHolderRadius = TARGET_HOLDER_RADIUS
    // Text
    primaryText = PRIMARY_DEFAULT_TEXT
    secondaryText = SECONDARY_DEFAULT_TEXT
    primaryTextColor = PRIMARY_TEXT_COLOR
    secondaryTextColor = SECONDARY_TEXT_COLOR
    primaryTextSize = PRIMARY_TEXT_SIZE
    secondaryTextSize = SECONDARY_TEXT_SIZE
    // Animation
    aniComeInDuration = ANI_COMEIN_DURATION
    aniGoOutDuration = ANI_GOOUT_DURATION
    aniRippleAlpha = ANI_RIPPLE_ALPHA
    aniRippleColor = ANI_RIPPLE_COLOR
    aniRippleScale = ANI_RIPPLE_SCALE
  }
  
  // Overrides this to add subviews. They will be drawn when calling show()
  public override func layoutSubviews() {
    super.layoutSubviews()
    let center = calculateCenter(at: targetView, to: containerView)
    
    addBackground(at: center)
    addTargetRipple(at: center)
    addTargetHolder(at: center)
    addTarget(at: center)
    addPrimaryLabel(at: center)
    addSecondaryLabel(at: center)
    
    // Add gesture recognizer for both container and its subview
    addGestureRecognizer(tapGestureRecoganizer())
    // Disable subview interaction to let users click to general view only
    for subView in subviews {
      subView.isUserInteractionEnabled = false
    }
    
    // Animation while displaying.
    UIView.animate(withDuration: 0.5, delay: aniComeInDuration, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
      self.targetRippleView.alpha = self.ANI_RIPPLE_ALPHA
      self.targetRippleView.transform = CGAffineTransform(scaleX: self.aniRippleScale, y: self.aniRippleScale)
    }, completion: nil)
  }
  
  // Add background which is a big circle
  private func addBackground(at center: CGPoint) {
    let radius: CGFloat!
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      radius = 300.0
    } else {
      radius = containerView.frame.width
    }
    
    backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: radius * 2,height: radius * 2))
    backgroundView.center = center
    backgroundView.backgroundColor = backgroundPromptColor.withAlphaComponent(backgroundPromptColorAlpha)
    backgroundView.asCircle()
    backgroundView.transform = CGAffineTransform(scaleX: 1/ANI_TARGET_HOLDER_SCALE, y: 1/ANI_TARGET_HOLDER_SCALE) // Initial set to support animation
    addSubview(backgroundView)
    UIView.animate(withDuration: aniComeInDuration, delay: 0,
                   options: [.curveLinear],
                   animations: {
                    self.backgroundView.transform = CGAffineTransform(scaleX: 1, y: 1)},
                   completion: nil)
  }
  
  // A background view which add ripple animation when showing target view
  private func addTargetRipple(at center: CGPoint) {
    targetRippleView = UIView(frame: CGRect(x: 0, y: 0, width: targetHolderRadius * 2,height: targetHolderRadius * 2))
    targetRippleView.center = center
    targetRippleView.backgroundColor = aniRippleColor
    targetRippleView.alpha = 0.0 //set it invisible
    targetRippleView.asCircle()
    addSubview(targetRippleView)
    
  }
  
  // A circle-shape background view of target view
  private func addTargetHolder(at center: CGPoint) {
    targetHolderView = UIView(frame: CGRect(x: 0, y: 0, width: targetHolderRadius * 2,height: targetHolderRadius * 2))
    targetHolderView.center = center
    targetHolderView.backgroundColor = targetHolderColor
    targetHolderView.asCircle()
    targetHolderView.transform = CGAffineTransform(scaleX: 1/ANI_TARGET_HOLDER_SCALE, y: 1/ANI_TARGET_HOLDER_SCALE) // Initial set to support animation
    addSubview(targetHolderView)
    UIView.animate(withDuration: aniComeInDuration, delay: 0,
                   options: [.curveLinear],
                   animations: {
                    self.targetHolderView.transform = CGAffineTransform(scaleX: 1, y: 1)
    },
                   completion: {
                    _ in
    })
  }
  
  // Create a copy view of target view
  // It helps us not to affect the original target view
  private func addTarget(at center: CGPoint) {
    targetCopyView = targetView.snapshotView(afterScreenUpdates: true);
    targetCopyView.tintColor = targetTintColor
    
    if targetCopyView is UIButton {
        let button = targetView as! UIButton
        let buttonCopy = targetCopyView as! UIButton
        buttonCopy.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
    } else if targetCopyView is UIImageView {
        let imageView = targetView as! UIImageView
        let imageViewCopy = targetCopyView as! UIImageView
        imageViewCopy.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    let width = targetCopyView.frame.width
    let height = targetCopyView.frame.height
    targetCopyView.frame = CGRect(x: center.x - width/2, y: center.y - height/2, width: width, height: height)
    targetCopyView.translatesAutoresizingMaskIntoConstraints = true
    
    addSubview(targetCopyView)
  }
  
  // Configures and adds primary label view
  private func addPrimaryLabel(at center: CGPoint) {
    primaryLabel = UILabel()
    
    if let font = primaryTextFont {
        primaryLabel.font = font
    } else {
        primaryLabel.font = UIFont.boldSystemFont(ofSize: primaryTextSize)
    }
    primaryLabel.textColor = primaryTextColor
    primaryLabel.textAlignment = .left
    primaryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    primaryLabel.text = primaryText
    
    // Calculate x position
    let xPosition = backgroundView.frame.minX > 0 ?
      backgroundView.frame.minX + LABEL_MARGIN : LABEL_MARGIN
    
    // Calculate y position
    var yPosition: CGFloat!
    
    if getTargetPosition(target: targetView, container: containerView) == .above {
      yPosition = center.y + TEXT_CENTER_OFFSET
    } else {
      yPosition = center.y - TEXT_CENTER_OFFSET - LABEL_DEFAULT_HEIGHT * 2
    }
    
    primaryLabel.frame = CGRect(x: xPosition,
                                y: yPosition,
                                width: containerView.frame.width - xPosition,
                                height: LABEL_DEFAULT_HEIGHT)
    
    addSubview(primaryLabel)
  }
  
  // Configures and adds secondary label view
  private func addSecondaryLabel(at center: CGPoint) {
    secondaryLabel = UILabel()
    if let font = secondaryTextFont {
        secondaryLabel.font = font
    } else {
        secondaryLabel.font = UIFont.systemFont(ofSize: secondaryTextSize)
    }
    secondaryLabel.textColor = secondaryTextColor
    secondaryLabel.textAlignment = .left
    secondaryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    secondaryLabel.text = secondaryText
    secondaryLabel.numberOfLines = 3
    
    // Calculate x position 
    let xPosition = (backgroundView.frame.minX > 0 ?
      backgroundView.frame.minX + LABEL_MARGIN : LABEL_MARGIN)
    
    // Calculate y position based on target position
    var yPosition: CGFloat!
    
    if getTargetPosition(target: targetView, container: containerView) == .above {
      yPosition = center.y + TEXT_CENTER_OFFSET + LABEL_DEFAULT_HEIGHT
    } else {
      yPosition = center.y - TEXT_CENTER_OFFSET - LABEL_DEFAULT_HEIGHT
    }
    
    secondaryLabel.frame = CGRect(x: xPosition,
                                  y: yPosition,
                                  width: containerView.frame.width - xPosition,
                                  height: LABEL_DEFAULT_HEIGHT)
    
    addSubview(secondaryLabel)
  }
  
  // Handles user's tap
  private func tapGestureRecoganizer() -> UIGestureRecognizer {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MaterialShowcase.completeShowcase))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.numberOfTouchesRequired = 1
    return tapGesture
  }
  
  // Default action when dimissing showcase
  // Notifies delegate, removes views, and handles out-going animation
  func completeShowcase() {
    if delegate != nil && delegate?.showCaseDidDismiss != nil {
      delegate?.showCaseWillDismiss?(showcase: self)
    }
    UIView.animate(withDuration: aniGoOutDuration, delay: 0, options: [.curveEaseOut],
                   animations: {
                    self.alpha = 0 },
                   completion: {
                    _ in
                    // Recycle subviews
                    self.recycleSubviews()
                    // Remove it from current screen
                    self.removeFromSuperview()
    })
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

// MARK: - Helper methods
extension MaterialShowcase {
  
  // Defines the position of target view
  // which helps to place texts at suitable positions
  fileprivate enum TARGET_POSITION {
    case above // at upper screen part
    case below // at lower screen part
  }
  
  // Detects the position of target view relative to its container
  fileprivate func getTargetPosition(target: UIView, container: UIView) -> TARGET_POSITION{
    let center = calculateCenter(at: targetView, to: container)
    if center.y < container.frame.height / 2{
      return .above
    } else {
      return .below
    }
  }
  
  // Calculates the center point based on targetview
  fileprivate func calculateCenter(at targetView: UIView, to containerView: UIView) -> CGPoint {
    let targetRect = targetView.convert(targetView.bounds , to: containerView)
    return CGPoint(x: targetRect.origin.x + targetRect.width / 2,
                   y: targetRect.origin.y + targetRect.height / 2)
  }
  
  // Gets all UIView from TabBarItem.
  fileprivate func orderedTabBarItemViews(of tabBar: UITabBar) -> [UIView] {
    let interactionViews = tabBar.subviews.filter({$0.isUserInteractionEnabled})
    return interactionViews.sorted(by: {$0.frame.minX < $1.frame.minX})
  }
}

// MARK: - UIColor extension utility
public extension UIColor {
  
  /// Returns color from its hex string
  ///
  /// - Parameter hexString: the color hex string
  /// - Returns: UIColor
  public static func fromHex(hexString: String) -> UIColor {
    let hex = hexString.trimmingCharacters(
      in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.characters.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      return UIColor.clear
    }
    
    return UIColor(
      red: CGFloat(r) / 255,
      green: CGFloat(g) / 255,
      blue: CGFloat(b) / 255,
      alpha: CGFloat(a) / 255)
  }
}

// MARK: - UIView extension utility
extension UIView{
  
  // Transform a view's shape into circle
  func asCircle(){
    self.layer.cornerRadius = self.frame.width / 2;
    self.layer.masksToBounds = true
  }
}
