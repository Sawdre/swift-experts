import Cocoa

var isBlocked = Int().self

func moveForward() {
    
}
func collectGem() {
    
}
func object() {
    
}
class Object {
    
}
let myObject = Object()
class World {
    func place(_ object: Object, atColumn column: Int, row: Int) {
          
    }
}
class Truck: Object {
    var isBlocked: Bool
    var isOnGem: Bool
    var isBlockedLeft: Bool
    var isBlockedRight: Bool
    override init() {
        self.isBlocked = true
        self.isOnGem = true
        self.isBlockedLeft = true
        self.isBlockedRight = true
        super.init()
        }
    func turnRight() {
        
    }
    func turnLeft() {
        
    }
    func moveForward(){
        
    }
    func collectGem(){
        
    }
}
class Expert: Object {
    var isBlocked: Bool
    override init() {
        self.isBlocked = true
        super.init()
        }
    func turnRight() {
        
    }
    func moveForward() {
        
    }
    func turnLeft() {
        
    }
    func move(distance: Int) {
        for _ in 1...distance {
            moveForward()
        }
    }
}

//Hi
var greeting = "Hello, playground"

//Gems counters
var gemsInTruck = 0
var gemsOnBase = 0

//Lenght of 1st row
var lengthOfRow = 0

//Current truck coordinates
var currentColumn = 0
var currentRow = 0
var currentCoordinates = (column: currentColumn, row: currentRow)

//Saved coordinates when collect 4th gem
var columnCounter = 0
var rowCounter = 0
var savedReturnCoordinates = (column: columnCounter, row: rowCounter)

//Game world
let world = World()

//Base where truck drop gems
let base = (column: 0, row: 0)

//Truck that collect gems and drop them on base
let truck = Truck()

//Scout is here for measure the lenght of row so we can calculate size of the map
let scout = Expert()

//Truck turn on 180 degree
func truckTurnAround() {
    truck.turnRight()
    truck.turnRight()
}

//Scout turn on 180 degree
func scoutTurnAround() {
    scout.turnRight()
    scout.turnRight()
}

//Move a given distance
func move(distance: Int) {
    for _ in 1...distance {
        moveForward()
    }
}

//Drop 4 gems from truck on base
func dropGems() {
    gemsInTruck -= 4
    gemsOnBase += 4
}

//Scout measure row length
func scoutMeasureRowLength() {
    if !scout.isBlocked {
        scout.moveForward()
        lengthOfRow += 1
    } else {
        scoutTurnAround()
        
        // Проверяем, что длина строки больше 0 перед перемещением
        if lengthOfRow > 0 {
            // Сохраняем текущее значение lengthOfRow
            let currentLength = lengthOfRow
            
            print("Moving forward by \(currentLength) steps.")
            scout.move(distance: currentLength)
        } else {
            print("Error: Length of row is 0.")
        }
    }
}

//Turn truck from one row to next trought left turn
func truckTurnAroundLeft() {
    truck.turnLeft()
    truck.moveForward()
    truck.turnLeft()
}

//Turn truck from one row to next one throught right turn
func truckTurnAroundRight() {
    truck.turnRight()
    truck.moveForward()
    truck.turnRight()
}

//Truck pass one Row looking for gems and collecting gems
func truckGoThroughtRow() {
    while !truck.isBlocked {
        truck.moveForward()
        if rowCounter % 2 == 0 {
            columnCounter += 1
            currentColumn += 1
        } else {
            columnCounter -= 1
            currentColumn -= 1
        }
        if truck.isOnGem {
            collectGem()
            gemsInTruck += 1
        }
        if gemsInTruck == 4 {
            truckBackOnBaseAndDropGems()
        }
        if truck.isBlocked && !truck.isBlockedLeft {
            truckTurnAroundLeft()
            rowCounter += 1
            currentRow += 1
        }
        if truck.isBlocked && !truck.isBlockedRight {
            truckTurnAroundRight()
            rowCounter += 1
            currentRow += 1
        }
    }
}

//Turn back to pass one Row on back way to base, decresing kilometresCounter and checking if in corner
func truckGoBackThroughtRow() {
    while !truck.isBlocked {
        truck.moveForward()
        if rowCounter % 2 == 0 {
            currentColumn -= 1
        } else {
            currentColumn += 1
        }
        if truck.isBlocked && !truck.isBlockedLeft {
            truckTurnAroundLeft()
            currentRow -= 1
        }
        if truck.isBlocked && !truck.isBlockedRight {
            truckTurnAroundRight()
            currentRow -= 1
        }
    }
}

//Truck move from current position to base and drop gems on base
func truckBackOnBaseAndDropGems() {
    truckTurnAround()
    while (currentColumn != 0 || currentRow != 0) {
        truckGoBackThroughtRow()
    }
    dropGems()
    if gemsInTruck == 0 {
        returnToSavedCoordinates()
    } else {
        print("gemsInTruck error")
    }
}

//After droping gems on base return to saved coordinates
func returnToSavedCoordinates() {
    while currentCoordinates != savedReturnCoordinates {
        while !truck.isBlocked {
            truck.moveForward()
            if rowCounter % 2 == 0 {
                currentColumn += 1
            } else {
                currentColumn -= 1
            }
            if truck.isBlocked && !truck.isBlockedLeft {
                truckTurnAroundLeft()
                currentRow += 1
            }
            if truck.isBlocked && !truck.isBlockedRight {
                truckTurnAroundRight()
                currentRow += 1
            }
        }
    }
}

//Rabotai, Pozaluista 🥹

world.place(scout, atColumn: base.column, row: base.row)
world.place(truck, atColumn: base.column, row: base.row)

scoutMeasureRowLength()

let mapSize = lengthOfRow * lengthOfRow

let numberOfGems = Int.random(in: 1...mapSize)

while gemsOnBase < numberOfGems {
    truckGoThroughtRow()
}
