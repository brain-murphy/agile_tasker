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
    
    var isEditingTable = false
    
    @IBOutlet var tasksTable: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    func loadSampleTasks() {
        let task1 = Task(name: "hw1", courseName: "CS2110", workLeft: 10, dueDate: "11.21.1999", details: "")
        let task2 = Task(name: "hw2", courseName: "CS2110", workLeft: 10, dueDate: "11.22.1999", details: "")
        let task3 = Task(name: "hw3", courseName: "CS2110", workLeft: 10, dueDate: "11.23.1999", details: "")
        let task4 = Task(name: "hw4", courseName: "CS2110", workLeft: 10, dueDate: "11.24.1999", details: "")
        let task5 = Task(name: "hw5", courseName: "CS2110", workLeft: 10, dueDate: "11.25.1999", details: "")
    
        tasks += [task1, task2, task3, task4, task5]
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        isEditingTable = !isEditingTable
        tasksTable.setEditing(isEditingTable, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath){
        
        let tempTask = tasks[destinationIndexPath.row]
        
        tasks[destinationIndexPath.row] = tasks[sourceIndexPath.row]
        tasks[sourceIndexPath.row] = tempTask
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleTasks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        return cell
    }
    
    @IBAction func sendToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewTaskViewController, let task = sourceViewController.task {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = NSIndexPath(row: tasks.count, section: 0)
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let taskDetailViewController = segue.destination as! NewTaskViewController
            if let selectedTaskCell = sender as? TaskTableViewCell {
                let indexPath = tableView.indexPath(for: selectedTaskCell)!
                let selectedTask = tasks[indexPath.row]
                taskDetailViewController.task = selectedTask
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new task.")
        }
    }
    
}
