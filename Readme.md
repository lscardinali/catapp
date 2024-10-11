# Cat App

## Used Frameworks

 - SwiftLint
 - Composable Architecture
 
## Description

### TCA

The app was developed using The Composable Architecture to Manage the app overall State
The **Breeds** Reducer uses two **Dependencies**, one for fetching data from the CatAPI and another for persisting data
with SwiftData.
The CatApi Dependency has a Live implementation that overriden in the tests. it also provides a preview implementation.
The DataPersistance Dependency receives a ModelContext from that may be persisted only in memory for testing purposes.
For simplicity I've opted to use a unique model for both mapping responses from the API as to storing of SwiftUI.
(Hence it's a Class that has the @Model macro)
There are two derived values in the state which are used to show only the favorites and the filtered breeds.
Some basic error handling is done if something happens during the requests and is shown as an alert.

### Views

I've divided the app in two "Screens" that both use the configurable BreedGridView to show the breeds. Each Breed is
show in a BreedTileView, which uses AsyncImage with an placeholder.
Also used some Bindings for the Alert display and the search text connecting the View with the Store State

### Testing

Wrote unit tests that test each change to the Store and tried covering most cases

- Loading Data
- Pagination
- Favoriting
- Filtering
- Data Persistency
- Errors

Also wrote a suite of UI Tests that covers the basic flows of the app.
