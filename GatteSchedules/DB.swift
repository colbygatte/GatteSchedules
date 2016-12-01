//
//  DB.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class DB {
    static var teamid: String!
    static var loggedInUser: GSUser!
    static var loggedIn: Bool = false
    static var teamRef: FIRDatabaseReference!
    static var usersRef: FIRDatabaseReference!
    
    // Authentication, login, and settings
    static func authListener(listener: @escaping FIRAuthStateDidChangeListenerBlock) {
        FIRAuth.auth()?.addStateDidChangeListener(listener)
    }
    
    static func signIn(username: String, password: String, completion: @escaping FirebaseAuth.FIRAuthResultCallback) {
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: completion)
    }
    
    static func signOut(completion: (()->())? = nil) {
        try! FIRAuth.auth()?.signOut() // @@@@ handle the throw better
        
        if completion != nil {
            completion!()
        }
    }
    
    static func getSettings(completion: @escaping (FIRDataSnapshot)->()) {
        let ref = DB.teamRef.child("settings")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.childrenCount == 0 {
                assert(true, "snapshot childrenCount == 0 for settings")
            } else {
                completion(snapshot)
            }
        })
    }
    
    // Schedules
    static func getSchedules(completion: @escaping (FIRDataSnapshot)->()) {
        DB.teamRef.child("schedules").observeSingleEvent(of: .value, with: { schedulesSnapshot in
            completion(schedulesSnapshot)
        })
    }
    
    static func getSchedule(schedule: String, completion: @escaping (FIRDataSnapshot)->()) {
        let ref = DB.teamRef.child("schedules").child(schedule)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.childrenCount == 0 {
                assert(true, "snapshot.childrenCount == 0")
            } else {
                completion(snapshot)
            }
        })
    }
    
    static func newSchedule(date: Date) -> FIRDatabaseReference {
        let dateString = App.formatter.string(from: date)
        let ref = DB.teamRef.child("schedules").child(dateString)
        return ref
    }
    
    // Users
    static func getUsers(completion: @escaping (FIRDataSnapshot)->()) {
        DB.usersRef.queryOrdered(byChild: "teamid").queryEqual(toValue: DB.teamid).observeSingleEvent(of: .value, with: { snapshot in
            completion(snapshot)
        })
    }
    
    static func getUserData(uid: String, completion: @escaping (FIRDataSnapshot)->()) {
        let userDataRef = DB.usersRef.child(uid)
        
        userDataRef.observeSingleEvent(of: .value, with: { snapshot in
            completion(snapshot)
        })
    }
}
