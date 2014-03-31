# TLDataManager

[![Version](http://cocoapod-badges.herokuapp.com/v/TLDataManager/badge.png)](http://cocoadocs.org/docsets/TLDataManager)
[![Platform](http://cocoapod-badges.herokuapp.com/p/TLDataManager/badge.png)](http://cocoadocs.org/docsets/TLDataManager)

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

#### Static Singleton

The singleton is useful for managing a single CoreData stack for your application. For most applications, one CoreData stack is sufficient.
    
```Objective-C:
[TLDataManager setDatabaseName:@"MY_DB_NAME" linkedToModel:@"MY_MODEL_NAME"];
[TLDataManager sharedManager];
```

#### Initialization

For applications that require multiple CoreData stacks, you can initalize your own TLDataManager instance.
    
```Objective-C:
// create the manager
TLDataManager *manager = [[TLDataManager alloc] initWithDatabaseName:@"MY_DB_NAME" 
                                                       linkedToModel:@"MY_MODEL_NAME"];g

// do something with the main context
[manager.mainContext ...]
```

#### Import Data

Importing data on a background thread is easy if you follow a few simple rules.

```Objective-C:
// reference the manager
TLDataManager *manager = [TLDataManager sharedManager];

// import data and pass in block to be executed on abackground thread
// there is a reference to a background context that should be used for importing data
[manager importData:^(NSManagedObjectContext *context){
    
    // perform long import
    NSCustomManagedObject *object = [NSCustomManagedObject longImportInContext:context];

    // return block to be called on main thread
    return ^{
        // reference main context
        NSManagedObjectContext *mainContext = manager.mainContext;
        // reference imported object(s) on main thread
        NSCustomManagedObject *newObject = [context objectWithID:object.objectID];
        // ... callback with newObject on main thread ...
    }
}];
```

## Requirements

iOS 6.1 or later

## Installation

TLDataManager is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "TLDataManager"

## Author

Andrew Barba, andrew@tablelistapp.com

## License

TLDataManager is available under the MIT license. See the LICENSE file for more info.

