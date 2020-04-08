//
//  main.swift
//  HungryHungryHippos
//
//  Created by Karen Rodriguez on 4/8/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation

class Spoon {
    
    // MARK: - Properties
    
    private var lock = NSLock()
    var index: Int
    // MARK: - Methods
    
    func pickUp() {
        lock.lock()
    }
    
    func putDown() {
        lock.unlock()
    }
    
    // MARK: - Initializer
    
    init(_ id: Int) {
        self.index = id
    }
    
}

class Developer {
    
    // MARK: - Properties
    
    var leftSpoon: Spoon
    var rightSpoon: Spoon
    
    // MARK: - Methods
    
    func think(_ id: Int, _ waiter: DispatchSemaphore) {
        waiter.wait()
        print("Dev\(id) requested the waiter.")
        leftSpoon.pickUp()
        print("Dev\(id) picked up left spoon.")
        rightSpoon.pickUp()
        print("Dev\(id) picked up right spoon.")
    }
    
    func eat(_ id: Int, _ waiter: DispatchSemaphore) {
        print("Dev\(id) about to eat some good stuff.")
        usleep(useconds_t.random(in: 0...1000000))
        rightSpoon.putDown()
        print("Dev\(id) put down left spoon.")
        leftSpoon.putDown()
        print("Dev\(id) put down right spoon.")
        waiter.signal()
        print("Dev\(id) gave the utensils back to the waiter.")
    }
    
    func run(_ id: Int, _ waiter: DispatchSemaphore) {
        while true {
            think(id, waiter)
            eat(id, waiter)
        }
    }
    
    // MARK: - Initializer
    
    init(_ leftSpoon: Spoon, _ rightSpoon: Spoon) {
        self.leftSpoon = leftSpoon
        self.rightSpoon = rightSpoon
    }
    
    // End
}




var spoon1 = Spoon(1)
var spoon2 = Spoon(2)
var spoon3 = Spoon(3)
var spoon4 = Spoon(4)

var dev1 = Developer(spoon1, spoon2)
var dev2 = Developer(spoon2, spoon3)
var dev3 = Developer(spoon3, spoon4)
var dev4 = Developer(spoon4, spoon1)

var developers = [dev1, dev2, dev3, dev4]

let waiter = DispatchSemaphore(value: 4)

DispatchQueue.concurrentPerform(iterations: 4) { i in
    developers[i].run(i+1, waiter)
}

