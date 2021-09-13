# Robot Warehouse

## Scenario
We have a warehouse... and we have a robot! We need to create an API that sends commands to the robot move around the warehouse,
to move around the warehouse and pick up the crates and put them down again in another part 
of the warehouse.

## The Warehouse
The warehouse contains tracks in the ceiling that the robot moves around on. The tracks are East to West
and North-South on a 10x10 grid.

## The Robot
The robot has a grabber, it should move around the warehouse, be able to pick up a crate and move it
to another part of the warehouse.

## The Crates
I mean... they're crates... they sit there containing they're goods of loveliness and wait to be moved
around the warehouse.

## The Requirements
* The app should take a list of commands in form of a space-delimited, single upper-case letter 
commands representing North East South West.
  * eg. The app should accept "N E S W" as a command chain. You user should be able to send as
  many commands as they want.
* The robot should be able to move around the warehouse but not outside the warehouse.
  * If the commands sent to the robot move it out of the warehouse it should stop at the last legal 
  position in the command chain.
* The app should accept a command to grab a crate - "G" - and a command to drop a crate - "D"
* The robot should not attempt to drop a crate on another crate.
* The robot should not attempt to pick a crate up if there isn't one there.
* The robot should not attempt to pick up a crate if the grabber already has one.
* The response should be in the format of <br />
`{ success: true|false, messages: null|String, data: { current_position:, grabber: full|empty } }`


## Things we are looking for
* Using standard OOB and/or functional programming paradigms.
* There doesn't need to be anything else in the application and we are looking for simple, clear and
concise code but extra consideration is given for code that could easily be extended should there be further
requirements in the future.
* Use Git to version the code.
* How and what tests are written is one of the key points we will be looking at.
* A useful README and project setup process.
* Passes linter examination.
* No use of scaffolds.
