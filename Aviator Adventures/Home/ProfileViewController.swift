//
//  ProfileViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 26.08.2024.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    weak var delegate: HomeViewControllerDelegate?
    weak var secDel: ExcurseViewControllerDelegate?
    var userProf: User?
    
    var imageView: UIImageView?
    var nameTextField: UITextField?
    
    var saveButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        createInterface()
        checkData()
    }
    

    func createInterface() {
        
        let hideView = UIView()
        hideView.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
        hideView.layer.cornerRadius = 2.5
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.top.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        }
        
        let closeBut  = UIButton(type: .system)
        closeBut.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBut.tintColor = .black.withAlphaComponent(0.12)
        view.addSubview(closeBut)
        closeBut.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.right.top.equalToSuperview().inset(15)
        }
        closeBut.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        
        let profileLabel = UILabel()
        profileLabel.text = "Profile"
        profileLabel.textColor = .black
        view.addSubview(profileLabel)
        profileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeBut)
        }
        
        imageView = UIImageView()
        imageView?.image = UIImage.noImageProfile
        imageView?.isUserInteractionEnabled = true
        imageView?.contentMode = .scaleAspectFit
        imageView?.layer.cornerRadius = 48
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.width.height.equalTo(96)
            make.centerX.equalToSuperview()
            make.top.equalTo(closeBut.snp.bottom).inset(-5)
        })
        let gestureOpenPhoto = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView?.addGestureRecognizer(gestureOpenPhoto)
        
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .black
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        }
        
        
        nameTextField = UITextField()
        nameTextField?.backgroundColor = .white
        nameTextField?.layer.cornerRadius = 12
        nameTextField?.layer.borderColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1).cgColor
        nameTextField?.layer.borderWidth = 1
        nameTextField?.placeholder = "Robert"
        nameTextField?.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: 10))
        nameTextField?.rightView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: 10))
        nameTextField?.rightViewMode = .always
        nameTextField?.leftViewMode = .always
        nameTextField?.textColor = .black
        nameTextField?.delegate = self
        view.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(nameLabel.snp.bottom).inset(-5)
        })
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.layer.cornerRadius = 27
            button.setTitleColor(.black, for: .normal)
            return button
        }()
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
        })
        saveButton?.addTarget(self, action: #selector(saveUser), for: .touchUpInside)
        
        let gestureHideKB = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(gestureHideKB)
    }
    
    @objc func hideKB() {
        view.endEditing(true)
    }
    
    func checkButton() {
        if nameTextField?.text?.count ?? 0 > 0 , imageView?.image != UIImage.noImageProfile {
            UIView.animate(withDuration: 0.2) {
                self.saveButton?.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
                self.saveButton?.isEnabled = true
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
                self.saveButton?.isEnabled = false
            }
        }
    }
    
    func checkData() {
        if user == nil {
            imageView?.image = UIImage.noImageProfile
            saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
            saveButton?.isEnabled = false
        } else {
            nameTextField?.text = user?.name ?? ""
            imageView?.contentMode = .scaleAspectFill
            imageView?.clipsToBounds = true
            imageView?.image = UIImage(data: user?.image ?? Data())
            saveButton?.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
            saveButton?.isEnabled = true
        }
    }
    
    @objc func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView?.contentMode = .scaleAspectFill
            imageView?.clipsToBounds = true
            imageView?.image = pickedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        checkButton()
    }
    
    @objc func saveUser() {
        let name:String = nameTextField?.text ?? "Name"
        let imageData: Data = imageView?.image?.jpegData(compressionQuality: 0.5) ?? Data()
        
        let user = User(name: name, image: imageData)
        
        
         do {
             let data = try JSONEncoder().encode(user) //тут мкассив конвертируем в дату
             try saveAthleteArrToFile(data: data)
             saveGlobal(redUser: user)
             delegate?.reloadProfileButton(userRed: user)
             secDel?.reloadProfile()
             close()
         } catch {
             print("Failed to encode or save athleteArr: \(error)")
         }
    }
    
    func saveGlobal(redUser: User) {
        user = redUser
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("user.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
   
    
    @objc func close() {
        delegate = nil
        self.dismiss(animated: true)
    }

}


extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkButton()
        return true
    }
}
