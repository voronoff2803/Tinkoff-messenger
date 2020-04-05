//
//  ProfileViewController.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 23.02.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var isEdit = false
    var oldDescription = ""
    let gcdDataManager = GCDDataManager()
    let operationDataManager = OperationDataManager()
    var dataManager: DataSavable?
    let titleField = UITextField()
    
    let cornerRadiusConstant: CGFloat = 16.0
    let profilePlaceHolder = #imageLiteral(resourceName: "placeholder-user")
    let cameraIcon = #imageLiteral(resourceName: "camera")
    let buttonBackgroundColor = #colorLiteral(red: 0.2470588235, green: 0.4705882353, blue: 0.9411764706, alpha: 1)
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager = StorageManager()
        
        
        loadData()

        setup()
        
        print(#function ,editButton.frame)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(#function ,editButton.frame)
        
        // Frame отличается из-за того что во viewDidLoad - интерфейс не расчитан autolayout'ом, а в viewDidAppear интерфейс уже расчитан autolayout'ом
    }
    
    func loadData() {
        dataManager?.loadData { (name, description, image) in
            DispatchQueue.main.async {
                self.titleLabel.text = name ?? "Имя Фамилия"
                self.descriptionTextView.text = description ?? "Моя биография"
                self.profileImageView.image = image ?? UIImage(named: "placeholder-user")
            }
        }
    }
    
    func saveData() {
        editButton.loadingIndicator(show: true)
        
        var newName: String?
        var newDescription: String?
        var newImage: UIImage?
        
        newName = titleField.text
        newDescription = descriptionTextView.text
        newImage = profileImageView.image
        
        dataManager?.saveData(name: newName, description: newDescription, image: newImage) { (error) in
            DispatchQueue.main.async {
                self.editButton.loadingIndicator(show: false)
                if let error = error { self.alert(title: "Error", message: error); self.startEditMode()}
            }
        }
    }
    
    func setup() {
        hideKeyboardWhenTappedAround()
        
        profileImageView.image = profilePlaceHolder
        profileImageView.layer.cornerRadius = cornerRadiusConstant
        profileImageView.contentMode = .scaleAspectFill
        
        changeImageButton.setImage(cameraIcon, for: .normal)
        changeImageButton.setTitle("", for: .normal)
        changeImageButton.tintColor = UIColor.white
        changeImageButton.backgroundColor = buttonBackgroundColor
        changeImageButton.addTarget(self, action: #selector(changeImageButtonAction), for: .touchUpInside)
        
        editButton.layer.cornerRadius = cornerRadiusConstant
        editButton.layer.borderWidth = 1.0
        editButton.layer.borderColor = editButton.titleColor(for: .normal)?.cgColor
        editButton.addTarget(self, action: #selector(mainAction), for: .touchUpInside)
        
        descriptionTextView.isEditable = false
    }
    
    @objc func mainAction() {
        if isEdit {
            endEditMode()
        } else {
            startEditMode()
        }
    }
    
    func startEditMode() {
        isEdit = true
        
        oldDescription = descriptionTextView.text
        
        titleField.frame = titleLabel.bounds
        titleField.text = titleLabel.text
        titleField.font = titleLabel.font
        titleField.textColor = titleLabel.textColor
        titleField.isUserInteractionEnabled = true
        titleLabel.isUserInteractionEnabled = true
        titleLabel.textColor = .clear
        titleLabel.addSubview(titleField)
        titleField.delegate = self
        
        descriptionTextView.isEditable = true
        
        editButton.setTitle("Сохранить", for: .normal)
        
        titleField.becomeFirstResponder()
    }
    
    func endEditMode() {
        saveData()
        
        isEdit = false
        
        titleLabel.text = titleField.text
        titleLabel.textColor = titleField.textColor
        titleField.removeFromSuperview()
        
        descriptionTextView.isEditable = false
        
        editButton.setTitle("Редактировать", for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        changeImageButton.layer.cornerRadius = changeImageButton.frame.width / 2
    }
    
    @objc func changeImageButtonAction() {
        print("Выбери изображение профиля")
        
        let alert = UIAlertController()
        let photoFromMediaAction = UIAlertAction(title: "Установить из галлереи", style: .default, handler: { _ in self.createPhoto(sourceType: .photoLibrary)})
        let photoFromCameraAction = UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in self.createPhoto(sourceType: .camera)})
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(photoFromMediaAction)
        alert.addAction(photoFromCameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func createPhoto(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Выберете другой источник фото", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        profileImageView.image = selectedImage
        saveData()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //print(editButton.frame)
        //будет ошибка т.к view еще не была загружена из storyboard
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

     @objc func keyboardWillShow(notification: NSNotification) {
         if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = 20 + keyboardSize.height
         }
     }

     @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 20
     }
}
