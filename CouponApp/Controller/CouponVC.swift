//
//  CouponVC.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 08/12/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import UIKit

class CouponVC: UIViewController , UITextViewDelegate,UITextFieldDelegate{

    @IBOutlet weak var brand_nameTxt: UITextField!
    
    @IBOutlet weak var coupon_nameTxt: UITextField!
    
    
    @IBOutlet weak var descriptionTxt: UITextView!
    
    @IBOutlet weak var expireDate: UITextField!
    
    @IBOutlet weak var discount: UITextField!
    
    var viewmodel = CouponModel()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var start_Date : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTxt.text = "Discription"
        descriptionTxt.delegate = self
        descriptionTxt.textColor = UIColor.lightGray
        
     ///   showDatePicker()
        
        let formatter = DateFormatter()
        let currentDate = Date()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        start_Date = formatter.string(from: currentDate)
        
        
        self.descriptionTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.descriptionTxt.layer.borderWidth = 0.5
        
        
        expireDate.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
    
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.expireDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            self.expireDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.expireDate.resignFirstResponder()
    }


    @IBAction func btnGenerateCouponTapped(_ sender: UIButton)
    {
        
        
        
        let response = Validation.shared.validate(values: (ValidationType.brandName, brand_nameTxt.text!, brand_nameTxt.text!), (ValidationType.couponNaame, coupon_nameTxt.text!, coupon_nameTxt.text!),(ValidationType.expireDate, expireDate.text!, expireDate.text!), (ValidationType.discount, discount.text!, discount.text!))
        
        switch response
        {
        case .success:
            
            if descriptionTxt.textColor == UIColor.lightGray
            {
                let alertController = UIAlertController(title: "Alert", message: "Enter Description", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                viewmodel.generateCoupon(brand_name: brand_nameTxt.text!, coupon_code: coupon_nameTxt.text!, description: descriptionTxt.text!, startDate: start_Date, expireDate: self.expireDate.text!, discount: discount.text!, completion: {
                
                print("success")
                
                self.viewmodel.updateCreditValue(completion: {
                print("success")
                self.navigationController?.popViewController(animated: true)
                }, failure: { (error) in
                print(error)
                })
                
                }) { (error) in
                print(error)
                }
            }
        case .failure(_, let message):
        let alertController = UIAlertController(title: "Alert", message: message.localized(), preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        

        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    
    
    @IBAction func datePickerTapped(_ sender: UITextField) {
        
        
        
    }
    
}
extension UITextField {
    
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}
