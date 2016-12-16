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
    static var ref: FIRDatabaseReference!
    static var teamRef: FIRDatabaseReference!
    
    // Branches of the team:
    static var usersRef: FIRDatabaseReference!
    static var pendingUsersRef: FIRDatabaseReference!
    static var daysRef: FIRDatabaseReference!
    static var requestsRef: FIRDatabaseReference!
    static var changesRef: FIRDatabaseReference!
    
    private static var authListenerHandle: FIRAuthStateDidChangeListenerHandle! // @@@@ should probably be optional
    private static var authListenerBlock: FIRAuthStateDidChangeListenerBlock!
    static var authListenerIsListening: Bool = false
    
    // Authentication, login, and settings
    static func setAuthListener(listener: @escaping FIRAuthStateDidChangeListenerBlock) {
        DB.authListenerBlock = listener
    }
    
    static func stopAuthListener() {
        if DB.authListenerIsListening {
            FIRAuth.auth()?.removeStateDidChangeListener(DB.authListenerHandle)
            DB.authListenerIsListening = false
        }
    }
    
    static func startAuthListener() {
        if !DB.authListenerIsListening {
            DB.authListenerHandle = FIRAuth.auth()?.addStateDidChangeListener(DB.authListenerBlock)
            DB.authListenerIsListening = true
        }
    }
    
    static func create(team: String) -> String {
        let ref = DB.ref.child("teams").childByAutoId()
        ref.child("settings").setValue(["teamName": team])
        return ref.key
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
        
        //ref.observeSingleEvent(of: .value, with: { snapshot in
        ref.observe(.value, with: { snap in
            if snap.childrenCount == 0 {
                assert(false, "snapshot childrenCount == 0 for settings")
            } else {
                completion(snap)
            }
        })
    }
    
    static func save(settings: GSSettings) {
        DB.teamRef.child("settings").setValue(settings.toFirebaseObject())
    }
    
    // Schedules
    //
    static func get(day: Date, completion: @escaping (FIRDataSnapshot)->()) {
        let dateString = App.formatter.string(from: day)
        
        //DB.daysRef.child(dateString).observeSingleEvent(of: .value, with: { snap in
        DB.daysRef.child(dateString).observe(.value, with: { snap in
            completion(snap)
        })
    }
    
    static func getSingleEvent(day: Date, completion: @escaping (FIRDataSnapshot)->()) {
        let dateString = App.formatter.string(from: day)
        
        //DB.daysRef.child(dateString).observeSingleEvent(of: .value, with: { snap in
        DB.daysRef.child(dateString).observeSingleEvent(of: .value, with: { snap in
            completion(snap)
        })
    }
    
    static func save(day: GSDay) {
        let dateString = App.formatter.string(from: day.date)
        DB.daysRef.child(dateString).setValue(day.toFirebaseObject())
    }
    
    // Users
    static func createLogin(email: String, password: String, completion: FIRAuthResultCallback?) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            completion?(user, error)
        }
    }
    
    static func save(user: GSUser) {
        let userRef = DB.usersRef.child(user.uid)
        userRef.setValue(user.toFirebaseObject())
    }
    
    static func getUsers(completion: @escaping (FIRDataSnapshot)->()) {
        DB.usersRef.queryOrdered(byChild: "teamid").queryEqual(toValue: DB.teamid).observeSingleEvent(of: .value, with: { snap in
        //DB.usersRef.queryOrdered(byChild: "teamid").queryEqual(toValue: DB.teamid).observe(.value, with: { snap in
            completion(snap)
        })
    }
    
    static func getUsersValue(completion: @escaping (FIRDataSnapshot)->()) {
        //DB.usersRef.queryOrdered(byChild: "teamid").queryEqual(toValue: DB.teamid).observeSingleEvent(of: .value, with: { snap in
        DB.usersRef.queryOrdered(byChild: "teamid").queryEqual(toValue: DB.teamid).observe(.value, with: { snap in
            completion(snap)
        })
    }
    
    static func getUserData(uid: String, completion: @escaping (FIRDataSnapshot)->()) {
        let userDataRef = DB.usersRef.child(uid)
        
        userDataRef.observeSingleEvent(of: .value, with: { snapshot in
            completion(snapshot)
        })
    }
    
    static func getPendingUsers(completion: @escaping (FIRDataSnapshot)->Void) {
        let ref = DB.pendingUsersRef.queryOrdered(byChild: "teamid").queryEqual(toValue: DB.teamid)
        
        ref.observeSingleEvent(of: .value, with: { pendingUsersSnap in
            //ref.observe(.value, with: { pendingUsersSnap in // don't want this, we only want to get a single instance
            completion(pendingUsersSnap)
        })
    }
    
    static func getPendingUsersValue(completion: @escaping (FIRDataSnapshot)->Void) {
        let ref = DB.pendingUsersRef.queryOrdered(byChild: "teamid").queryEqual(toValue: DB.teamid)
        
        //ref.observeSingleEvent(of: .value, with: { pendingUsersSnap in
        ref.observe(.value, with: { pendingUsersSnap in
            completion(pendingUsersSnap)
        })
    }
    
    
    static func createPendingUser(name: String, email: String, teamid: String) -> String {
        let code = String.random(length: 5)
        let pendingUserRef = DB.pendingUsersRef.child(code) // @@@@ check to see if str exists
        
        pendingUserRef.setValue([
            "name": name,
            "email": email,
            "teamid": teamid
        ])
        
        return code
    }
    
    static func getPendingUser(code: String, completion: @escaping (FIRDataSnapshot)->Void) {
        DB.ref.child("pendingUsers").child(code).observeSingleEvent(of: .value, with: { pendingUserSnap in
        //DB.ref.child("pendingUsers").child(code).observe(.value, with: { pendingUserSnap in
            completion(pendingUserSnap)
        })
    }
    
    static func deletePendingUser(code: String) {
        DB.pendingUsersRef.child(code).setValue(nil)
    }
    
    // this logs in user automatically (firebase does when creating a user)
    static func createUser(email: String, password: String, completion: FIRAuthResultCallback?) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: completion)
    }
    
    // MARK: Requests
    // @@@@ add a function to save an individual user day request
    static func get(requests: Date, completion: @escaping (FIRDataSnapshot)->Void) {
        let dateString = App.formatter.string(from: requests)
        
        //DB.requestsRef.child(dateString).observeSingleEvent(of: .value, with: { snap in
        DB.requestsRef.child(dateString).observe(.value, with: { snap in
            completion(snap)
        })
    }
    
    static func save(dayRequests: GSDayRequests) {
        let dateString = App.formatter.string(from: dayRequests.date)
        DB.requestsRef.child(dateString).setValue(dayRequests.toFirebaseObject())
    }
}
