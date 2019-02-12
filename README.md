# Pursuit-Core-iOS-RaceReviews
RaceReviews uses the Firebase Auth,  Cloud Firestore database to create users. Users are able to add an annotations on a MapView with a race review.

## Lessons Links

- Creating a .xib file [lesson link](https://github.com/joinpursuit/Pursuit-Core-iOS/tree/master/units/unit05/lesson-06-xibs) 
- Cocoapods [lesson link](https://github.com/joinpursuit/Pursuit-Core-iOS/tree/master/units/unit05/lesson-07-cocoapods) 
- Firebase Intro [lesson link](https://github.com/joinpursuit/Pursuit-Core-iOS/tree/master/units/unit05/lesson-08-intro-to-firebase-baas)  

## Installation Procedures for this app

- clone this repo 
- all Pods are included 
- open up the RaceReviews.xcworkspace project and run the app on your simulator or device

## Firebase Cocoapods used 

```
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Storage'
```

**Checklist**  
- [x] create the Xcode project
- [x] create firebase console project 
- [x] add google service plist file to xcode
- [x] add firebase sdk to the xcode project using cocoapods (firebase/core, /auth, /firestore, /storage)
- [ ] confirm firebase installation after importing firebase into the Xcode project
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
import Foundation
import CoreLocation

enum RaceType {
  case swimming
  case biking
  case running
  case obstacle
  case other
}

struct Race {
  let name: String
  let review: String
  let type: RaceType
  let lat: Double
  let lon: Double
  let reviewerId: String
  
  init(name: String, review: String, type: RaceType, lat: Double, lon: Double, reviewerId: String) {
    self.name = name
    self.review = review
    self.type = type
    self.lat = lat
    self.lon = lon
    self.reviewerId = reviewerId
  }
  
  init(dict: [String: Any]) {
    self.name = dict["name"] as? String ?? "no race name"
    self.review = dict["review"] as? String ?? "no race review"
    self.type = dict["type"] as? RaceType ?? .other
    self.lat = dict["lat"] as? Double ?? 0
    self.lon = dict["lon"] as? Double ?? 0
    self.reviewerId = dict["reviewerId"] as? String ?? "no reviewerId"
  }
  
  public var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(lat, lon)
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
