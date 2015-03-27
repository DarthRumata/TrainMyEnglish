//
// Created by Stanislav on 26.03.15.
// Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

extension CGRect {
    var square: CGFloat {
         return self.height * self.width
    }
    
    var center: CGPoint {
        return CGPointMake(self.midX, self.midY)
    }
    
    var topRight: CGPoint {
        return CGPointMake(self.origin.x + self.width, self.origin.y)
    }
    
    var bottomLeft: CGPoint {
        return CGPointMake(self.origin.x, self.origin.y + self.height)
    }
    
    var bottomRight: CGPoint {
        return CGPointMake(self.origin.x + self.width, self.origin.y + self.height)
    }
    
    var allVertexes: [CGPoint] {
        return [self.origin, self.topRight, self.bottomLeft, self.bottomRight]
    }
    
    func mostFarVertexFrom(point: CGPoint) -> CGPoint {
        var maxDistance: CGFloat = 0
        return self.allVertexes.reduce(self.allVertexes[0], combine: { (mostFar, current) -> CGPoint in
            let currentDistance = current.distanceFrom(point)
            if (currentDistance > maxDistance) {
                maxDistance = currentDistance
                return current
            }
            return mostFar
        })
    }
    
    func mostCloseVertexTo(point: CGPoint) -> CGPoint {
        var minDistance: CGFloat = CGFloat(MAXFLOAT)
        return self.allVertexes.reduce(self.allVertexes[0], combine: { (mostClose, current) -> CGPoint in
            let currentDistance = current.distanceFrom(point)
            if (currentDistance < minDistance) {
                minDistance = currentDistance
                return current
            }
            return mostClose
        })
    }
    
    func makeCoverRectCloserToPoint(point: CGPoint, size: CGSize) -> CGRect {
        let perfectRect = CGRectMake(point.x - size.width / 2, point.y - size.height / 2, size.width, size.height)
        if (perfectRect.contains(self)) {
            return perfectRect
        }
        let farVertex = self.mostFarVertexFrom(point)
        let nearCoveredVertex = perfectRect.mostCloseVertexTo(farVertex)
        let xOffset = farVertex.x - nearCoveredVertex.x
        let yOffset = farVertex.y - nearCoveredVertex.y
        return CGRectOffset(perfectRect, xOffset, yOffset)
    }
    
}

extension CGPoint {
    func distanceFrom(point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
}
