//
//  NewAndEditExcViewController.swift
//  Aviator Adventures
//
//  Created by Владимир Кацап on 27.08.2024.
//

import UIKit

class NewAndEditExcViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var isNew = true
    var showCountry = true
    weak var delegate: ExcurseViewControllerDelegate?
    var secondDelegate: HomeViewControllerDelegate?
    var threeDelegate: CountryViewControllerDelegate?
    
    //если редактироание
    var excurseEdit: Excursion?
    var index = 0
    
    //interface
    var imageView: UIImageView?
    var countryTextField, nameTextField : UITextField?
    var selectedType: String?
    var costTextField, descriptionTextField: UITextField?
    var saveButton: UIButton?
    
    //other
    var arrButtons: [UIButton] = []
    var countryLabel: UILabel?
    var country: String?
    
    var excurseRedd: [Excursion]?
    var oldIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fillButtons()
        createInterface()
        checkLoad()
    }
    
    func checkLoad() {
        if isNew == false {
            countryTextField?.text = excurseEdit?.country
            imageView?.image = UIImage(data: excurseEdit?.image ?? Data())
            nameTextField?.text = excurseEdit?.name
            selectedType = excurseEdit?.type
            for i in arrButtons {
                if selectedType == i.titleLabel?.text {
                    butTapped(sender: i)
                }
            }
            costTextField?.text = excurseEdit?.cost
            descriptionTextField?.text = excurseEdit?.desc
            
            checkButton()
        }
        
        if showCountry == false {
            countryTextField?.snp.remakeConstraints({ make in
                make.left.right.equalToSuperview()
                make.height.equalTo(0)
                make.top.equalTo(imageView!.snp.bottom)
            })
            countryTextField?.alpha = 0
            countryLabel?.alpha = 0
        }
    }
    
    func createInterface() {
        
        let hideView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
            view.layer.cornerRadius = 2.5
            return view
        }()
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
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
        
        let topLabel: UILabel = {
            let label = UILabel()
            label.text = isNew ? "New" : "Edit"
            label.textColor = .black
            return label
        }()
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeBut)
        }
        
       
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            layout.scrollDirection = .vertical
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .clear
            collection.showsVerticalScrollIndicator = false
            return collection
        }()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topLabel.snp.bottom).inset(-15)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func fillButtons() {
        arrButtons.removeAll()
        let arr = ["Individual", "Group", "Сhildrens", "Tourist", "Urban", "Museum", "Suburban", "Extreme"]
        var tag = 0
        for i in arr {
            let button = UIButton(type: .system)
            button.backgroundColor = .white
            button.layer.cornerRadius = 10
            button.setTitle(i, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            button.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
            button.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
            button.layer.borderWidth = 1
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
            button.tag = tag
            button.addTarget(self, action: #selector(butTapped(sender:)), for: .touchUpInside)
            arrButtons.append(button)
            tag += 1
        }
    }

    
    @objc func butTapped(sender: UIButton) {
        for i in arrButtons {
            i.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
            i.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        }
        selectedType = sender.currentTitle ?? ""
        sender.setTitleColor(UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1), for: .normal)
        sender.layer.borderColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1).cgColor
        checkButton()
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
            imageView?.image = pickedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        checkButton()
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    func createlabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor(red: 239/255, green: 59/255, blue: 51/255, alpha: 1).cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }
    
    func checkButton() {
        if showCountry == false {
            if imageView?.image != .addNewExc, nameTextField?.text?.count ?? 0 > 0 , selectedType != nil, costTextField?.text?.count ?? 0 > 0 , descriptionTextField?.text?.count ?? 0 > 0 {
                saveButton?.isEnabled = true
                saveButton?.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
            } else {
                saveButton?.isEnabled = false
                saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
            }
        } else {
            if imageView?.image != .addNewExc, countryTextField?.text?.count ?? 0 > 0 , nameTextField?.text?.count ?? 0 > 0 , selectedType != nil, costTextField?.text?.count ?? 0 > 0 , descriptionTextField?.text?.count ?? 0 > 0 {
                saveButton?.isEnabled = true
                saveButton?.backgroundColor = UIColor(red: 229/255, green: 25/255, blue: 64/255, alpha: 1)
            } else {
                saveButton?.isEnabled = false
                saveButton?.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
            }
        }
        
    }
    
    
   @objc func save() {
        let imageData: UIImage = imageView?.image ?? UIImage()
        var countryNew: String = countryTextField?.text ?? ""
        let name: String = nameTextField?.text ?? ""
        let type: String = selectedType ?? ""
        let cost: String = costTextField?.text ?? ""
        let description: String = descriptionTextField?.text ?? ""
       
       if country != nil {
           countryNew = country ?? ""
       }

        let excursion = Excursion(image: imageData.jpegData(compressionQuality: 0.5) ?? Data(), country: countryNew, name: name, type: type, cost: cost, desc: description, isActive: true, impressions: [])
        
       if isNew == true {
           excursions.append(excursion)
       } else {
           excursions[index] = excursion
       }
       print(excursion)
       
       if excurseRedd != nil {
           excurseRedd?[oldIndex] = excursion
           threeDelegate?.reload(elements: excurseRedd ?? [])
       }
 
        do {
            let data = try JSONEncoder().encode(excursions) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
            delegate?.reloadData()
            secondDelegate?.reloadData()
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("excu.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
   

}


extension NewAndEditExcViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        
        imageView = {
            let imageView = UIImageView(image: .addNewExc)
            imageView.clipsToBounds  = true
            imageView.layer.cornerRadius = 20
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        cell.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(183)
            make.top.equalToSuperview()
        })
        let gestureSelectPhoto = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView?.addGestureRecognizer(gestureSelectPhoto)
        
        
        countryLabel = createlabel(text: "Country")
        cell.addSubview(countryLabel!)
        countryLabel?.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        }
        countryTextField = createTextField(placeholder: "Armenia")
        cell.addSubview(countryTextField!)
        countryTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(countryLabel!.snp.bottom).inset(-10)
        })
        
        
        let nameLabel = createlabel(text: "Name excursion")
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(countryTextField!.snp.bottom).inset(-15)
            make.left.equalToSuperview()
        }
        nameTextField = createTextField(placeholder: "Amberd, Mount Aragats")
        cell.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(nameLabel.snp.bottom).inset(-10)
        })
        
        
        let typeLabel = createlabel(text: "Type of excursion")
        cell.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
        }
        let stackViewTop: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [arrButtons[0], arrButtons[1], arrButtons[2], arrButtons[3]])
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.distribution = .fillProportionally
            return stackView
        }()
        cell.addSubview(stackViewTop)
        stackViewTop.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(60)
            make.height.equalTo(48)
            make.top.equalTo(typeLabel.snp.bottom).inset(-10)
        }
        let stackViewBot: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [arrButtons[4], arrButtons[5], arrButtons[6], arrButtons[7]])
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.distribution = .fillProportionally
            return stackView
        }()
        cell.addSubview(stackViewBot)
        stackViewBot.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(60)
            make.height.equalTo(48)
            make.top.equalTo(stackViewTop.snp.bottom).inset(-10)
        }
        
        
        let costLabel = createlabel(text: "Cost")
        cell.addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(stackViewBot.snp.bottom).inset(-15)
        }
        costTextField = createTextField(placeholder: "44 $")
        cell.addSubview(costTextField!)
        costTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(costLabel.snp.bottom).inset(-10)
        })
        
        
        let descLabel = createlabel(text: "Description")
        cell.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(costTextField!.snp.bottom).inset(-15)
        }
        descriptionTextField = createTextField(placeholder: "This is amazing")
        cell.addSubview(descriptionTextField!)
        descriptionTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(descLabel.snp.bottom).inset(-10)
        })
        
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.layer.cornerRadius = 25
            button.setTitleColor( .black, for: .normal)
            button.isEnabled = false
            button.backgroundColor = UIColor(red: 6/255, green: 12/255, blue: 38/255, alpha: 0.5)
            return button
        }()
        cell.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(descriptionTextField!.snp.bottom).inset(-15)
        })
        saveButton?.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        checkLoad()
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 850)
    }
    
}


extension NewAndEditExcViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == costTextField || textField == descriptionTextField {
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -400)
                
            }
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkButton()
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
        view.endEditing(true)
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
}
