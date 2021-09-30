/*
 in colors init {
 extension UIColor {
     
     static let mainBackGroundColor = {
         UIColor { traitCollection in
             // 2
             switch traitCollection.userInterfaceStyle {
             case .dark:
                 // 3
                 return UIColor.red
             default:
                 // 4
                 return UIColor.yellow
             }
         }
     }()
 }
}
 in view Did load Add {
 startObserving(&UserInterfaceStyleManager.shared)
 }
 
 in toggleScreen {
 let currentStatus = UserInterfaceStyleManager.shared.currentStyle == .dark
 
 @IBAction func darkModeSwitchValueChanged(_ sender: UISwitch) {
     
     let darkModeOn = sender.isOn
     
     // Store in UserDefaults
     UserDefaults.standard.set(darkModeOn, forKey: UserInterfaceStyleManager.userInterfaceStyleDarkModeOn)
     
     // Update interface style
     UserInterfaceStyleManager.shared.updateUserInterfaceStyle(darkModeOn)
 }
 }
 */
//extension UIColor {
//    public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
//         if #available(iOS 13.0, *) {
//            return UIColor {
//               switch $0.userInterfaceStyle {
//               case .dark:
//                  return dark
//               default:
//                  return light
//               }
//            }
//         } else {
//            return light
//         }
//      }
//}
