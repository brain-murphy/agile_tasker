//
//  TableViewController.swift
//  agile-tasker
//
//  Created by Abhishek Sen on 9/24/16.
//  Copyright © 2016 Brian Murphy. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    var tasks = [Task]()
    var completeTasks = [Task]()
    
    var isEditingTable = false
    
    var doubleTap = false
    
    @IBOutlet var tasksTable: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    func loadSampleTasks() {
        let task1 = Task(name: "hw1", courseName: "CS2110", workLeft: 10, dueDate: "09-27-2016 10:51", details: "", urgencyValue: 0.3)
        let task2 = Task(name: "hw2", courseName: "CS2110", workLeft: 10, dueDate: "09-25-2016 10:51", details: "", urgencyValue: 0.4)
        let task3 = Task(name: "hw3", courseName: "CS2110", workLeft: 10, dueDate: "09-26-2016 10:51", details: "", urgencyValue: 0.5)
        let task4 = Task(name: "hw4", courseName: "CS2110", workLeft: 10, dueDate: "09-30-2016 10:51", details: "", urgencyValue: 0.6)
        let task5 = Task(name: "hw5", courseName: "CS2110", workLeft: 10, dueDate: "09-24-2016 10:51", details: "", urgencyValue: 0.7)
        
    
        tasks += [task1, task2, task3, task4, task5]
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        isEditingTable = !isEditingTable
        tasksTable.setEditing(isEditingTable, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TaskTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskTableViewCell
        
        let task = tasks[indexPath.row]
        
        
        cell.nameLabel.text = task.name
        cell.workLeftLabel.text = String(task.workLeft)
        cell.dateLabel.text = task.dueDate
        
        let priority = task.priority
        
        if priority >= 0.7 && priority < 1000 {
            cell.backgroundColor = UIColor.init(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        } else if priority <= 0.3 && priority > 0 {
            cell.backgroundColor = UIColor.init(displayP3Red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else if priority >= 0.3 && priority <= 0.7 {
            cell.backgroundColor = UIColor.init(displayP3Red: 1.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else {
            cell.backgroundColor = UIColor.init(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath){
        
        let tempTask = tasks[destinationIndexPath.row]
        
        tasks[destinationIndexPath.row] = tasks[sourceIndexPath.row]
        tasks[sourceIndexPath.row] = tempTask
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.tasks.remove(at: index.row)
            
            tableView.deleteRows(at: [index], with: UITableViewRowAnimation.left)
        }
        delete.backgroundColor = UIColor(white: 0.25, alpha: 1.0)
        
        let addWork = UITableViewRowAction(style: .normal , title: " + ") { action, index in
            
            self.setWorkRemaining(taskIndex: index, newHoursRemaining: self.tasks[index.row].workLeft + 1)
        }
        addWork.backgroundColor = UIColor.gray
        
        let removeWork = UITableViewRowAction(style: .normal, title: " - ") { action, index in
            
            self.setWorkRemaining(taskIndex: index, newHoursRemaining: self.tasks[index.row].workLeft - 1)
            
            if (self.tasks[index.row].workLeft == 0) {
                self.tasks.remove(at: index.row)
                
                tableView.deleteRows(at: [index], with: UITableViewRowAnimation.right)
            }
        }
        removeWork.backgroundColor = UIColor(white: 0.75, alpha: 1.0)
        
        return [delete, addWork, removeWork]
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        doubleTap = false
        
        let cell = getTaskTableViewCell(indexPath: indexPath)
        
        let workRemaining = tasks[indexPath.row].workLeft!
        
        setWorkRemaining(taskIndex: indexPath, newHoursRemaining: workRemaining)
        
        UIView.animate(withDuration: 0.25, animations: {
            cell.workRemainingLabel.alpha = 1.0
        })
    }
    
    func getTaskTableViewCell(indexPath: IndexPath?) -> TaskTableViewCell {
        return tableView.cellForRow(at: indexPath!) as! TaskTableViewCell
    }
    
    func setWorkRemaining(taskIndex: IndexPath, newHoursRemaining: Int) {
        let cell = getTaskTableViewCell(indexPath: taskIndex)
        cell.workRemainingLabel.text = "Work Remaining: \(newHoursRemaining)"
        cell.workLeftLabel.text = "Work Remaining: \(newHoursRemaining)hr"
        
        tasks[taskIndex.row].workLeft = newHoursRemaining
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if indexPath != nil && !doubleTap {
            doubleTap = true
            let cell = getTaskTableViewCell(indexPath: indexPath)
            
            let priority = tasks[(indexPath?.row)!].priority
            
            UIView.animate(withDuration: 0.25, animations: {
                cell.workRemainingLabel.alpha = 0.0
                if priority >= 0.7 && priority < 1000 {
                    cell.backgroundColor = UIColor.init(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
                } else if priority <= 0.3 && priority > 0 {
                    cell.backgroundColor = UIColor.init(displayP3Red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
                } else if priority >= 0.3 && priority <= 0.7 {
                    cell.backgroundColor = UIColor.init(displayP3Red: 1.0, green: 1.0, blue: 0.0, alpha: 0.5)
                } else {
                    cell.backgroundColor = UIColor.init(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
                }
                }, completion: {finished in
                    self.reorderRows()
                })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleTasks()
        reorderRows()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func sendToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewTaskViewController, let task = sourceViewController.task {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                //checkComplete(task: task)
            } else {
                let newIndexPath = NSIndexPath(row: tasks.count, section: 0)
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
                //checkComplete(task: task)
                
                reorderRows()
            }
        }
        
    }
    
    func reorderRows() {
        tasks.sort { $0.priority > $1.priority }
        tableView.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let taskDetailViewController = segue.destination as! NewTaskViewController
            if let selectedTaskCell = sender as? TaskTableViewCell {
                let indexPath = tableView.indexPath(for: selectedTaskCell)!
                let selectedTask = tasks[indexPath.row]
                taskDetailViewController.task = selectedTask
            }
        } else if segue.identifier == "AddItem" {
            print("Adding new task.")
        }
    }
    
    
}
