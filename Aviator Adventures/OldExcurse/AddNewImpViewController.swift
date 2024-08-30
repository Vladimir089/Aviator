//
//  AddNewImpViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 30.08.2024.
//

import UIKit

class AddNewImpViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    weak var delegate: OldDetailExViewControllerDelegate?
    var item: Excursion?
    var index = 0
    
    
    var imageView: UIImageView?
    
    
    var imageArr: [Data] = []
    var headingTextField: UITextField?
    var mainTextView: UITextView?
    var saveButton: UIButton?
    
    
    //othre
    var pluseImageView: UIImageView?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.realodData(item: item!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
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
        
        let nameLabel = UILabel()
        nameLabel.text = item?.name
        nameLabel.font = .systemFont(ofSize: 15, weight: .regular)
        nameLabel.textColor = .black
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-5)
        }
        
        let hideButton = UIButton()
        hideButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        hideButton.clipsToBounds = true
        hideButton.tintColor = .black.withAlphaComponent(0.12)
        view.addSubview(hideButton)
        hideButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(nameLabel)
            make.height.width.equalTo(27)
        }
        hideButton.addTarget(self, action: #selector(closeNoSave), for: .touchUpInside)
        
        let addNewImButton: UIButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 20
            button.backgroundColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1)
            button.setTitle("Add impressions", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            return button
        }()
        view.addSubview(addNewImButton)
        addNewImButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(hideButton.snp.bottom).inset(-10)
            make.width.equalTo(166)
        }
        addNewImButton.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        
        
        imageView = {
            let imageView = UIImageView(image: .addNewExc)
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = 20
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(addNewImButton.snp.bottom).inset(-15)
            make.height.equalTo(183)
        })
        let gesture = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView?.addGestureRecognizer(gesture)
        
        pluseImageView = UIImageView(image: .pluserAdd)
        pluseImageView?.alpha = 0
        imageView?.addSubview(pluseImageView!)
        pluseImageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(61)
            make.right.bottom.equalToSuperview().inset(15)
        })
        
        let headLabel: UILabel = {
            let label = UILabel()
            label.text = "Heading"
            label.textColor = .black
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            return label
        }()
        view.addSubview(headLabel)
        headLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        }
        
        headingTextField = {
            let textField = UITextField()
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 12
            textField.borderStyle = .none
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            textField.rightViewMode = .always
            textField.leftViewMode = .always
            textField.delegate = self
            textField.layer.borderWidth = 1
            textField.placeholder = "Tsakhkadzor:"
            textField.layer.borderColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1).cgColor
            return textField
        }()
        view.addSubview(headingTextField!)
        headingTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(headLabel.snp.bottom).inset(-10)
        })
        
        let deskLabel: UILabel = {
            let label = UILabel()
            label.text = "Description"
            label.textColor = .black
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            return label
        }()
        view.addSubview(deskLabel)
        deskLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(headingTextField!.snp.bottom).inset(-15)
        }
        
        mainTextView = {
            let textView = UITextView()
            textView.font = .systemFont(ofSize: 17, weight: .regular)
            textView.textColor = .black
            textView.isScrollEnabled = false
            textView.isEditable = true
            textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            textView.layer.cornerRadius = 12
            textView.delegate = self
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1).cgColor
            return textView
        }()
        view.addSubview(mainTextView!)
        mainTextView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(deskLabel.snp.bottom).inset(-10)
            make.height.equalTo(230)
        })
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.layer.cornerRadius = 25
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
            button.isEnabled = false
            return button
        }()
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        saveButton?.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        
        let hideKBGesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(hideKBGesture)
    }
    
    
    @objc func saveItem() {
        let head:String = headingTextField?.text ?? ""
        let desk: String = mainTextView?.text ?? ""
        
        let newImpression = Impressions(header: head, imagies: imageArr, text: desk)
        item?.impressions.append(newImpression)
        oldExcursions[index] = item!
        
        
       //передача в фунцию save
        do {
            let data = try JSONEncoder().encode(oldExcursions) //тут мкассив конвертируем в дату
            try saveoldArrToFile(data: data)
           
            clearAll()
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
    }
    
    func saveoldArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("oldExcu.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
    @objc func clearAll() {
        imageArr.removeAll()
        headingTextField?.text = ""
        mainTextView?.text = ""
        checkButton()
        imageView?.image = .addNewExc
        view.endEditing(true)
    }
    
    @objc func hideKB() {
        view.endEditing(true)
    }
    
    
    func checkButton() {
        if imageArr.count > 0, headingTextField?.text?.count ?? 0 > 0, mainTextView?.text.count ?? 0 > 0 {
            saveButton?.isEnabled = true
            saveButton?.backgroundColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1)
        } else {
            saveButton?.isEnabled = false
            saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
        }
    }
    
    
    @objc func closeNoSave() {
        delegate?.realodData(item: item!)
        self.dismiss(animated: true)
    }
    
    
    @objc func setImage() {
        if imageArr.count != 3 {
            pluseImageView?.alpha = 1
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        }
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView?.image = pickedImage
            imageArr.append(pickedImage.jpegData(compressionQuality:1) ?? Data())
            checkButton()
            if imageArr.count == 3 {
                pluseImageView?.alpha = 0
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}


extension AddNewImpViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkButton()
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
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
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        checkButton()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        checkButton()
        return true
    }
    

}
