//
//  MaterialShowcase.swift
//  MaterialShowcase
//
//  Created by Quang Nguyen on 5/4/17.
//  Copyright © 2017 Aromajoin. All rights reserved.
//
import UIKit

public class MaterialShowcase: UIView {
  
  // MARK: Material design guideline constant
  fileprivate let BACKGROUND_ALPHA: CGFloat = 0.96
  fileprivate let TARGET_RADIUS: CGFloat = 44
  fileprivate let TEXT_CENTER_OFFSET: CGFloat = 44 + 20
  fileprivate let PRIMARY_TEXT_SIZE: CGFloat = 20
  fileprivate let SECONDARY_TEXT_SIZE: CGFloat = 16
  fileprivate let LABEL_MARGIN: CGFloat = 40
  
  // Other default properties
  fileprivate let LABEL_DEFAULT_HEIGHT: CGFloat = 25
  fileprivate let PRIMARY_TEXT_COLOR = UIColor.white
  fileprivate let SECONDARY_TEXT_COLOR = UIColor.white.withAlphaComponent(0.87)
  fileprivate let BACKGROUND_DEFAULT_COLOR = UIColor.fromHex(hexString: "#2196F3")
  fileprivate let PRIMARY_DEFAULT_TEXT = "Awesome action"
  fileprivate let SECONDARY_DEFAULT_TEXT = "Tap here to do some awesome thing"
  
  // MARK: Animation properties
  fileprivate var ANI_COMEIN_DURATION: TimeInterval = 0.5 // second
  fileprivate var ANI_GOOUT_DURATION: TimeInterval = 0.5 // second
  fileprivate var ANI_TARGET_HOLDER_SCALE: CGFloat = 2.2
  
  // MARK: Public Properties
  
  // Background
  public var backgroundPromptColor: UIColor!
  public var backgroundPromptColorAlpha: CGFloat!
  public var targetTintColor: UIColor!
  // Target
  public var radius: CGFloat!
  // Text
  public var primaryText: String!
  public var secondaryText: String!
  public var primaryTextColor: UIColor!
  public var secondaryTextColor: UIColor!
  public var primaryTextSize: CGFloat!
  public var secondaryTextSize: CGFloat!
  
  // MARK: Private view properties
  fileprivate var containerView: UIView!
  fileprivate var targetView: UIView!
  fileprivate var backgroundView: UIView!
  fileprivate var targetHolderView: UIView!
  fileprivate var targetAniSupportView: UIView!
  fileprivate var targetCopyView: UIView!
  fileprivate var primaryLabel: UILabel!
  fileprivate var secondaryLabel: UILabel!
  
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
    targetView = tableView.cellForRow(at: indexPath)
    // for table viewcell, we do not need target holder (circle view)
    // therefore, set its radius = 0
    radius = 0
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
  
  // Overrides this to add subviews. They will be drawn when calling show()
  public override func layoutSubviews() {
    super.layoutSubviews()
    let center = calculateCenter(at: targetView, to: containerView)
    
    addBackground(at: center)
    addTarget(at: center)
    addPrimaryLabel(at: center)
    addSecondaryLabel(at: center)
    
    // Add gesture recognizer for both container and its subview
    addGestureRecognizer(tapGestureRecoganizer())
    // Disable subview interaction to let users click to general view only
    for subView in subviews {
      subView.isUserInteractionEnabled = false
    }
    
    // Animation here
//    UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
//      self.targetHolderView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//      UIView.animate(withDuration: 0.1, delay: 0, options: [.repeat, .autoreverse, .curveEaseIn], animations: {
//        self.targetAniSupportView.alpha = 0.1
//        self.targetAniSupportView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//      }, completion: nil)
//    }, completion: nil)
  }
  
  // Initializes default view properties
  fileprivate func configure() {
    backgroundColor = UIColor.clear
    guard let window = UIApplication.shared.delegate?.window else {
      return
    }
    containerView = window
    
    // Setup default properties
    backgroundPromptColor = BACKGROUND_DEFAULT_COLOR
    backgroundPromptColorAlpha = BACKGROUND_ALPHA
    targetTintColor = BACKGROUND_DEFAULT_COLOR
    radius = TARGET_RADIUS
    primaryText = PRIMARY_DEFAULT_TEXT
    secondaryText = SECONDARY_DEFAULT_TEXT
    primaryTextColor = PRIMARY_TEXT_COLOR
    secondaryTextColor = SECONDARY_TEXT_COLOR
    primaryTextSize = PRIMARY_TEXT_SIZE
    secondaryTextSize = SECONDARY_TEXT_SIZE
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
    backgroundView.frame.size.width = backgroundView.frame.width / ANI_TARGET_HOLDER_SCALE // Initial set to support animation
    backgroundView.frame.size.height = backgroundView.frame.height / ANI_TARGET_HOLDER_SCALE // Initial set to support animation
    backgroundView.center = center
    backgroundView.backgroundColor = backgroundPromptColor.withAlphaComponent(backgroundPromptColorAlpha)
    backgroundView.asCircle()
    addSubview(backgroundView)
    UIView.animate(withDuration: ANI_COMEIN_DURATION, delay: 0,
                   options: [.curveLinear],
                   animations: {
                    self.backgroundView.transform = CGAffineTransform(scaleX: self.ANI_TARGET_HOLDER_SCALE, y: self.ANI_TARGET_HOLDER_SCALE)},
                   completion: nil)
  }
  
  private func addTarget(at center: CGPoint) {
    // Add target holder which is a circle view
    targetHolderView = UIView(frame: CGRect(x: 0, y: 0, width: radius * 2,height: radius * 2))
    targetHolderView.frame.size.width = targetHolderView.frame.width / ANI_TARGET_HOLDER_SCALE // Initial set to support animation
    targetHolderView.frame.size.height = targetHolderView.frame.height / ANI_TARGET_HOLDER_SCALE // Initial set to support animation
    targetHolderView.center = center
    targetHolderView.backgroundColor = UIColor.white
    targetHolderView.asCircle()
    addSubview(targetHolderView)
    UIView.animate(withDuration: ANI_COMEIN_DURATION, delay: 0,
                   options: [.curveLinear],
                   animations: {
                    self.targetHolderView.transform = CGAffineTransform(scaleX: self.ANI_TARGET_HOLDER_SCALE, y: self.ANI_TARGET_HOLDER_SCALE)
    },
                   completion: {
    _ in
    })
    
    // Add another holder view which supports fadding animation when showing
    targetAniSupportView = UIView(frame: CGRect(x: 0, y: 0, width: radius * 2,height: radius * 2))
    targetAniSupportView.center = center
    targetAniSupportView.backgroundColor = UIColor.white
    targetAniSupportView.alpha = 0.0 //set it invisible
    targetAniSupportView.asCircle()
    addSubview(targetAniSupportView)
    
    // Copy target view to modify its copy but not the original target view
    targetCopyView = targetView.copyView() as! UIView
    targetCopyView.tintColor = targetTintColor
    let width = targetCopyView.frame.width
    let height = targetCopyView.frame.height
    targetCopyView.frame = CGRect(x: center.x - width/2, y: center.y - height/2, width: width, height: height)
    addSubview(targetCopyView)
  }
  
  // Configures and adds primary label view
  private func addPrimaryLabel(at center: CGPoint) {
    primaryLabel = UILabel()
    primaryLabel.font = UIFont.boldSystemFont(ofSize: primaryTextSize)
    primaryLabel.textColor = primaryTextColor
    primaryLabel.textAlignment = .left
    primaryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    primaryLabel.text = primaryText
    
    // Calculate y position
    var yPosition: CGFloat!
    
    if getTargetPosition(target: targetView, container: containerView) == .above {
      yPosition = center.y + TEXT_CENTER_OFFSET
    } else {
      yPosition = center.y - TEXT_CENTER_OFFSET - LABEL_DEFAULT_HEIGHT * 2
    }
    
    primaryLabel.frame = CGRect(x: (backgroundView.frame.minX > 0 ?
      backgroundView.frame.minX + LABEL_MARGIN : LABEL_MARGIN),
                                y: yPosition,
                                width: containerView.frame.width,
                                height: LABEL_DEFAULT_HEIGHT)
    
    addSubview(primaryLabel)
  }
  
  // Configures and adds secondary label view
  private func addSecondaryLabel(at center: CGPoint) {
    secondaryLabel = UILabel()
    secondaryLabel.font = UIFont.systemFont(ofSize: secondaryTextSize)
    secondaryLabel.textColor = secondaryTextColor
    secondaryLabel.textAlignment = .left
    secondaryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    secondaryLabel.text = secondaryText
    
    // Calculate y position based on target position
    var yPosition: CGFloat!
    
    if getTargetPosition(target: targetView, container: containerView) == .above {
      yPosition = center.y + TEXT_CENTER_OFFSET + LABEL_DEFAULT_HEIGHT
    } else {
      yPosition = center.y - TEXT_CENTER_OFFSET - LABEL_DEFAULT_HEIGHT
    }
    
    secondaryLabel.frame = CGRect(x: (backgroundView.frame.minX > 0 ?
      backgroundView.frame.minX + LABEL_MARGIN : LABEL_MARGIN),
                                  y: yPosition,
                                  width: containerView.frame.width,
                                  height: LABEL_DEFAULT_HEIGHT)
    
    addSubview(secondaryLabel)
  }
  
  // Handles user's tap
  private func tapGestureRecoganizer() -> UIGestureRecognizer {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(completeShowcase))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.numberOfTouchesRequired = 1
    return tapGesture
  }
  
  // Default action when dimissing showcase
  func completeShowcase() {
    UIView.animate(withDuration: ANI_GOOUT_DURATION, delay: 0, options: [.curveEaseOut],
                   animations: {
                    self.alpha = 0 },
                   completion: {
                    _ in
                    // Recycle subviews
                    self.recycleSubviews()
                    // Remove it from current screen
                    self.removeFromSuperview()})
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
  
  // Create a view's copy
  func copyView() -> AnyObject{
    return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as AnyObject
  }
  
  // Transform a view's shape into circle
  func asCircle(){
    self.layer.cornerRadius = self.frame.width / 2;
    self.layer.masksToBounds = true
  }
}
