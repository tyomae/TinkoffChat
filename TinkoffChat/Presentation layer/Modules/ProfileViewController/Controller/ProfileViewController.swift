//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Артем  Емельянов  on 13/02/2020.
//  Copyright © 2020 Artem Emelianov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var userInfoChanged: (name: Bool, description: Bool, photo: Bool) = (false, false, false)
    var imagePicker : UIImagePickerController? = UIImagePickerController()
    var storageManager: StorageManagerProtocol = StorageManager()
    var useDataManager: Bool = true
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.layer.cornerRadius = 8
            editButton.layer.borderWidth = 1
            editButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 8
            saveButton.layer.borderWidth = 1
            saveButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var savingDataActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func SaveButtonToched(_ sender: UIButton) {
        self.view.endEditing(true)
        useDataManager = true
        saveData()
    }
    @IBAction func editButtonToched(_ sender: UIButton) {
        putViewIntoEditingMode()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = addPhotoButton.bounds.size.width / 2
        addPhotoButton.layer.cornerRadius = addPhotoButton.bounds.size.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        buttonsHidden(are: true)
        putViewIntoNotEditingMode()
        
        self.savingDataActivityIndicator.hidesWhenStopped = true
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        imagePicker?.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)        
    }
    
    @IBAction func addPhotoButtonDidTap(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Сделать фото", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        let photo = UIAlertAction(title: "Установить из галлереи", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
        
        print("Выбери изображение профиля")
    }
    
    @IBAction func hideProfileVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    private func printFrame() {
        print(editButton.frame)
    }
    
    func saveData() {
        
        savingDataActivityIndicator.startAnimating()
        buttonsEnabled(are: false)
        addPhotoButton.isEnabled = false
        
        let userInfo = UserInfo()
        
        if (userInfoChanged.name) {
            userInfo.userName = nameTextField.text
        }
        if (userInfoChanged.description) {
            userInfo.userDescription = descriptionTextView.text
        }
        if (userInfoChanged.photo) {
            userInfo.userPhoto = profileImage.image
        }
        
        storageManager.saveAppUser(name: userInfo.userName, info: userInfo.userDescription, photo: userInfo.userPhoto) { errorString in
            DispatchQueue.main.async {
                self.savingDataActivityIndicator.stopAnimating()
                if (errorString != nil) {
                    self.showDataWasNotSavedAlert()
                }
                else {
                    self.showDataSavedAlert()
                }
            }
        }
    }
    
    func processSaving(error: Error?) {
        
        savingDataActivityIndicator.stopAnimating()
        
        if (error != nil) {
            showDataWasNotSavedAlert()
        }
        else {
            showDataSavedAlert()
        }
    }
    
    func loadData() {
        
        savingDataActivityIndicator.startAnimating()
        let appUser = storageManager.loadAppUser()
        
        if let appUser = appUser {
            if let name = appUser.name {
                self.nameTextField.text = name
            }
            if let description = appUser.info {
                self.descriptionTextView.text = description
            }
            if let photo = appUser.photo{
                self.profileImage.image = UIImage(data: photo as Data)
            }
        }
        self.savingDataActivityIndicator.stopAnimating()
    }
    
    func processLoading(userInfo: UserInfo) {
        
        savingDataActivityIndicator.stopAnimating()
        
        if let name = userInfo.userName {
            self.nameTextField.text = name
        }
        if let description = userInfo.userDescription {
            self.descriptionTextView.text = description
        }
        if let photo = userInfo.userPhoto {
            self.profileImage.image = photo
        }
    }
    
    func showDataSavedAlert() {
        
        let dataSavedAlert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.putViewIntoNotEditingMode()
            self.loadData()
        }
        
        dataSavedAlert.addAction(okAction)
        self.present(dataSavedAlert, animated: true, completion: nil)
    }
    
    func showDataWasNotSavedAlert() {
        
        let dataWasNotSavedAlert = UIAlertController(title: "Не удалось сохранить данные", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.putViewIntoNotEditingMode()
            self.loadData()
        }
        
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.saveData()
        }
        
        dataWasNotSavedAlert.addAction(okAction)
        dataWasNotSavedAlert.addAction(repeatAction)
        self.present(dataWasNotSavedAlert, animated: true, completion: nil)
    }
}

extension ProfileViewController {
    
    func putViewIntoEditingMode(){
        userInfoChanged = (false, false, false)
        editButton.isHidden = true
        buttonsHidden(are: false)
        buttonsEnabled(are: false)
        addPhotoButton.isEnabled = true
        
        descriptionTextView.isEditable = true
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.textContainerInset = .init(top: 3, left: 5, bottom: 1, right: 5)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.init(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0).cgColor
        
        nameTextField.isEnabled = true
        nameTextField.borderStyle = .roundedRect
    }
    
    func putViewIntoNotEditingMode(){
        self.view.endEditing(true)
        editButton.isHidden = false
        buttonsHidden(are: true)
        
        
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .init(top: 3, left: 0, bottom: 1, right: 5)
        descriptionTextView.layer.borderWidth = 0
        descriptionTextView.layer.borderColor = UIColor.clear.cgColor
        descriptionTextView.isEditable = false
        
        nameTextField.borderStyle = .none
        nameTextField.isEnabled = false
    }
    
    func buttonsEnabled(are isEnabled: Bool) {
        
        saveButton.isEnabled = isEnabled
        
        let color = isEnabled ? UIColor.black : UIColor.gray
        saveButton.setTitleColor(color, for: .normal)
    }
    
    func buttonsHidden(are isHidden: Bool) {
        
        saveButton.isHidden = isHidden
        addPhotoButton.isHidden = isHidden
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        userInfoChanged.name = true
        buttonsEnabled(are: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        userInfoChanged.description = true
        buttonsEnabled(are: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        if (self.view.frame.origin.y < 0) {
            return
        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.origin.y -= keyboardSize.height
                }, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if (self.view.frame.origin.y >= 0) {
            return
        }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, delay: 0,
                               options: .allowAnimatedContent, animations: {
                                self.view.frame.origin.y += keyboardSize.height
                }, completion: nil)
            }
        }
    }
}

