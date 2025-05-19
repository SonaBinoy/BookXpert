//
//  ViewController.swift
//  BookXpertProject
//
//  Created by sona on 17/05/25.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import CoreData

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              print("Google sign-in failed: \(error!.localizedDescription)")
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                self.performSegue(withIdentifier: "goToHome", sender: self)
              // At this point, our user is signed in
            }
                
        }
        
    }
    
    @IBAction func signOUTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            print("SignOut Successfully")
            let alert = UIAlertController( title: "", message: "Sign Out Successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
    func saveUserToCoreData(user: GIDGoogleUser) {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           let context = appDelegate.persistentContainer.viewContext

           let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
           let userObject = NSManagedObject(entity: entity, insertInto: context)
           userObject.setValue(user.profile?.name, forKey: "name")
           userObject.setValue(user.profile?.email, forKey: "email")

           do {
               try context.save()
           } catch {
               print("Failed to save user: \(error.localizedDescription)")
           }
       }
    
}
