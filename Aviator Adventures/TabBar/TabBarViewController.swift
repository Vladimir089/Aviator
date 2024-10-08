import UIKit
import SnapKit // Если используете SnapKit для авторазметки

var buttons: [UIButton] = []

class TabBarViewController: UITabBarController {

    let tabbarView = UIView()
    let tabbarItemBackgroundView = UIView()
    var centerConstraint: NSLayoutConstraint?
    

    override func viewDidLoad() {
        UserDefaults.standard.set("w", forKey: "tab")
        super.viewDidLoad()
        generateControllers()
        setView()
        buttonTapped(sender: buttons[0])
    }

    private func setView() {
        view.addSubview(tabbarView)
        tabbarView.backgroundColor = .white.withAlphaComponent(0.2)
        tabbarView.translatesAutoresizingMaskIntoConstraints = false
        tabbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        tabbarView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        tabbarView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        tabbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tabbarView.layer.cornerRadius = 40

        if buttons.count > 0 {
            for x in 0..<buttons.count {
                view.addSubview(buttons[x])
                buttons[x].tag = x
                buttons[x].layer.cornerRadius = 33
                buttons[x].translatesAutoresizingMaskIntoConstraints = false
                buttons[x].centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor).isActive = true
                buttons[x].widthAnchor.constraint(equalTo: tabbarView.widthAnchor, multiplier: 1 / CGFloat(buttons.count), constant: -15).isActive = true
                buttons[x].heightAnchor.constraint(equalTo: tabbarView.heightAnchor , constant: -15).isActive = true
                buttons[x].addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                if x == 0 {
                    buttons[x].leftAnchor.constraint(equalTo: tabbarView.leftAnchor, constant: 12).isActive = true
                } else {
                    buttons[x].leftAnchor.constraint(equalTo: buttons[x - 1].rightAnchor, constant: 12).isActive = true
                }
            }

            tabbarView.addSubview(tabbarItemBackgroundView)
            tabbarItemBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            tabbarItemBackgroundView.widthAnchor.constraint(equalTo: tabbarView.widthAnchor, multiplier: 1 / CGFloat(buttons.count), constant: -15).isActive = true
            tabbarItemBackgroundView.heightAnchor.constraint(equalTo: tabbarView.heightAnchor, constant: -15).isActive = true
            tabbarItemBackgroundView.centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor).isActive = true
            tabbarItemBackgroundView.layer.cornerRadius = 33
            tabbarItemBackgroundView.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)

            centerConstraint = tabbarItemBackgroundView.centerXAnchor.constraint(equalTo: buttons[0].centerXAnchor)
            centerConstraint?.isActive = true
        }
    }

    private func generateControllers() {
        let home = generateViewControllers(image: UIImage.tab1, vc: HomeViewController())
        let profile = generateViewControllers(image: UIImage.tab2, vc: ExcurseViewController())
        let setting = generateViewControllers(image: UIImage.tab3, vc: OldExcurseViewController())
        let bookmark = generateViewControllers(image: UIImage.tab4, vc: UIViewController())
        viewControllers = [home, profile, setting, bookmark]
    }

    private func generateViewControllers(image: UIImage, vc: UIViewController) -> UIViewController {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black //UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
        button.backgroundColor = .white
        button.layer.cornerRadius = 40
        let resizedImage = image.resize(targetSize: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        button.setImage(resizedImage, for: .normal)
        buttons.append(button)
        return vc
    }
    
    @objc func buttonTapped(sender: UIButton) {
          selectedIndex = sender.tag
            
          for button in buttons {
              button.tintColor = .black
              button.backgroundColor = .white
          }
          
          UIView.animate(withDuration: 0.2, delay: 0 , options: .beginFromCurrentState) {
             
              buttons[sender.tag].tintColor = .white
              buttons[sender.tag].backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
              self.tabbarView.layoutIfNeeded()
           }
       }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
