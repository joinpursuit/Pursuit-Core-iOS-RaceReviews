# Pursuit-Core-iOS-RaceReviews
RaceReviews uses the Firebase Auth,  Cloud Firestore database to create users. Users are able to add an annotations on a MapView with a race review.

## Installation Procedures for this app

- clone this repo 
- all Pods are included 
- open up the RaceReviews.xcworkspace project and run the app on your simulator or device

**Checklist**  
- [x] create the Xcode project
- [x] create firebase console project 
- [x] add google service plist file to xcode
- [x] add firebase sdk to the xcode project using cocoapods (firebase/core, /auth, /firestore, /storage)
- [ ] add email/password authentication to firebase project
- [x] create .xib login view
- [ ] user can create an authenticated account using their email and password
- [ ] user is created in cloudstore database
- [ ] present the race reviews tab controller if login is successful
- [ ] architect login flow in the app delegate base on current user sign in status
- [ ] user can sign out
- [ ] present the login view controller when the user signs out
- [ ] existing user can sign in 
- [ ] race review creation UI (firebase database)
- [ ] user can create a review (create)
- [ ] user can see an annotation on a MapView of their created review (read)
- [ ] user can udpate a review (update) (only if userId == reviewerId)
- [ ] user can delete a review (delete) (only if userId == reviewerId)

## Race Model 

```swift 
// raceId: String
// name: String
// type: String
// price: Double
// reviewerId: String // userId
// review: String
// lat: Double
// lon: Double

struct Race {
  let name: String
  let lat: Double
  let lon: Double
  
  init(name: String, lat: Double, lon: Double) {
    self.name = name
    self.lat = lat
    self.lon = lon
  }
  
  init(dict: [String: Any]) {
    self.name = dict["name"] as? String ?? "no race name"
    self.lat = dict["lat"] as? Double ?? 0
    self.lon = dict["lon"] as? Double ?? 0
  }
}
```

## Cloud Firestore Security Rules 

**Test Mode: anyone with the Database Reference can read and write**   
```javascript
// Allow read/write access to all users under any conditions
// Warning: **NEVER** use this rule set in production; it allows
// anyone to overwrite your entire database.
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**Locked Mode**  
```javascript 
// Deny read/write access to all users under any conditions
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

**Only signed in users can read, write**   
```javascript 
// Allow read/write access on all documents to any user signed in to the application
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth.uid != null;
    }
  }
}
```

**Another common pattern is to make sure users can only read and write their own data:**   
```javascript 
service cloud.firestore {
  match /databases/{database}/documents {
    // Make sure the uid of the requesting user matches name of the user
    // document. The wildcard expression {userId} makes the userId variable
    // available in rules.
    match /users/{userId} {
      allow read, update, delete: if request.auth.uid == userId;
      allow create: if request.auth.uid != null;
    }
  }
}
