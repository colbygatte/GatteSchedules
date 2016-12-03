//
//  DB.swift
//  GatteSchedules
//
//  Created by Colby Gatte on 11/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase

class DB {
    static var teamid: String!
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
    
    static func save(settings: GSSettings) {
        DB.teamRef.child("settings").setValue(settings.toFirebaseObject())
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
    
    static func save(schedule: GSSchedule) {
        schedule.ref.setValue(schedule.toFirebaseObject())
    }
    
    // Users
    static func addUser(email: String, password: String, completion: FIRAuthResultCallback?) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            completion?(user, error)
        }
    }
    
    static func save(user: GSUser) {
        let userRef = DB.usersRef.child(user.uid)
        userRef.setValue(user.toFirebaseObject())
    }
    
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
