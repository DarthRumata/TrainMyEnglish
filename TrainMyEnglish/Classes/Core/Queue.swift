//
//  Queue.swift
//  TrainMyEnglish
//
//  Created by Stanislav on 31.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class QNode<T> {
    var key: T?
    var next: QNode?
}

public class Queue<T> {
    private var top: QNode<T>! = QNode<T>()
    
    //enqueue the specified object
    func enQueue(var key: T) {
        if (top == nil) {
            top = QNode<T>()
        }
        
        //establish the top node
        if (top.key == nil) {
            top.key = key
            return
        }
        
        var child = QNode<T>()
        var current = top
        //cycle through the list of items to get to the end.
        while (top.next != nil) {
            current = current.next!
        }
        //append a new item
        child.key = key
        current.next = child
    }
    
    func deQueue() -> T? {
        //determine if the key or instance exists
        let topitem: T? = self.top?.key
        if (topitem == nil) {
            return nil
        }
        //retrieve and queue the next item
        var queueitem: T? = top.key!
        //use optional binding
        if let nextitem = top.next {
            top = nextitem
        } else {
            top = nil
        }
        
        return queueitem
    }
    
    func clear() {
        self.top = nil
    }
}