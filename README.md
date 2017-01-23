#Scott Larose - Mobile Devloper Challenge

##Assumptions
- I assumed that the "refreshed no more frequently than every 30 minutes" was a requirement and added a timer within the presenter to update the rates from the backend every 30 minutes.
- I assumed that the provided UI was a suggestion and slightly modified it.
- I assumed that "rates should be persisted locally" meant saving them into a local store, not a file or locally in memory.

##Features
- I used a slimmed down version of the VIPER architecture to implemnt the solution.
- This allowed for easy implementation of SOLID prinicples like dependancy injection and single single responsibility. 
- This also provides a clear seperation between the view logic, the presentation logic and the business logic.
- I used couchbase-lite for the persitance layer within the application.
- I pull the exchange rates from the backend upon initial luanch.  If the user changes the value to convert that rates are fetched locally.  If the user changes to another currency the application checks to see if the rates are stored locally then pulls from the backend if their not.
- Ever 30 minutes the rates displayed for the base currency are refreshed so that the rates do not go stale.
- I used a ExchangeRateGateway interface to isolate the implementation of the presistance/model layer. I.e. its incrediblly easy to swap the couchbase inplementation with anything else, such as an in memory queue or temperary file.  This also allows for easy testing as the interfaces can easily be stubbed or mocked.
- Inside the gateway all asynchronous queries while fetching data locally or from the backend are handled on backend threads through Futures.  This stopped blocking on the main thread but made the gateway implementation a bit more complicated
- The gateways are tested with unit tests that test the two methods and an edge case.  This is just to demonstrate that I know about proper testing practices and while I probably could have written more felt it unnecessary.

#Mobile App Developer Coding Challenge

## Goal:

#### Develop a currency conversion app that allows a user to convert an input value by any of the supplied rates.

- [X] Fork this repo. Keep it public until we have been able to review it.
- [X] Android: _Java/Kotlin_ | iOS: _Swift_
- [X] exchange rates must be fetched from: http://fixer.io/  
- [X] rates should be persisted locally and refreshed no more frequently than every 30 minutes
- [X] user must be able to select the input currency from the list of supplied values

### Evaluation:
- [ ] App operates as asked
- [ ] No crashes or bugs
- [ ] SOLID principles
- [ ] Code is understandable and maintainable

UI Suggestion: Input field with a drop-down currency selector, and a list/grid of converted values below.

![UI Suggested Wireframe](ui_suggestion.png)
