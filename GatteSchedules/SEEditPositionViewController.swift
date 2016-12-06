//
//  SEEditPositionViewController.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 12/5/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class SEEditPositionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var schedule: GSSchedule!
    var day: GSDay!
    var position: GSPosition!
    
    var workers: [String: GSUser]!
    var workeruids: [String]!
    var alluids: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        workers = [:]
        workeruids = []
        alluids = []
        
        let workersObject = position.workers
        for worker in workersObject! {
            workers[worker.uid] = worker
        }
        workeruids = Array(workers.keys)
        
        alluids = App.team.allUids
    }
}

extension SEEditPositionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alluids.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = alluids[indexPath.row]
        position.add(worker: App.team.get(user: uid)!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let uid = alluids[indexPath.row]
        position.remove(worker: App.team.get(user: uid)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let uid = alluids[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = App.team.get(user: uid)?.name
        
        if workeruids.contains(uid) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
}
