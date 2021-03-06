//
//  NewTaskViewController.swift
//  agile-tasker
//
//  Created by Abhishek Sen on 9/24/16.
//  Copyright © 2016 Brian Murphy. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var workTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextView!
    @IBOutlet weak var urgencySlider: UISlider!
    @IBOutlet weak var completeToggle: UISwitch!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var task : Task?
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    func checkValidName() -> Bool {
        
        let text = nameTextField.text ?? ""
        return !text.isEmpty
    }
    
    func checkValidDate() -> Bool {
        
        let text = dateTextField.text ?? ""
        return !text.isEmpty
    }
    
    func checkValidWork() -> Bool {
        
        let text = workTextField.text ?? ""
        if Int(text) != nil {
            if Int(text)! <= 0 {
                completeToggle.setOn(true, animated: true)
                task?.isComplete = true;
            } else {
                completeToggle.setOn(false, animated: true)
                task?.isComplete = false
            }
            return !text.isEmpty
        } else {
            return false
        }
    }
    
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        if completeToggle.isOn {
            workTextField.text = "0"
            task?.isComplete = true
            checkValues()
        } else {
            workTextField.text = nil
            task?.isComplete = false
            saveButton.isEnabled = false
        }
    }
    
    func checkValues() {
        saveButton.isEnabled = checkValidName() && checkValidDate() && checkValidWork()
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(NewTaskViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let myDate = dateFormatter.string(from: sender.date)
        dateTextField.text = myDate
        
    }
    
    @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
        checkValues()
        
    }
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        checkValues()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as AnyObject? === saveButton {
            let name = nameTextField.text
            let courseName = courseTextField.text ?? ""
            let workLeft = Int(workTextField.text!)
            let dueDate = dateTextField.text
            let details = detailsTextField.text ?? ""
            let urgencyValue = urgencySlider.value
            
            task = Task(name: name!, courseName: courseName, workLeft: workLeft!, dueDate: dueDate!, details: details, urgencyValue: urgencyValue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        if let task = task {
            navigationItem.title = "Edit Task"
            nameTextField.text   = task.name
            courseTextField.text = task.courseName
            dateTextField.text = task.dueDate
            workTextField.text = String(task.workLeft)
            detailsTextField.text = task.details
            urgencySlider.value = task.urgencyValue
            
        }
        
        checkValues()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
