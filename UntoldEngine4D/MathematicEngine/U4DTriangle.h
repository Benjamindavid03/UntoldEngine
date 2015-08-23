//
//  U4DTriangle.h
//  UntoldEngine
//
//  Created by Harold Serrano on 8/2/15.
//  Copyright (c) 2015 Untold Game Studio. All rights reserved.
//

#ifndef __UntoldEngine__U4DTriangle__
#define __UntoldEngine__U4DTriangle__

#include <stdio.h>
#include "U4DPoint3n.h"

namespace U4DEngine {
    
class U4DTriangle{
    
private:
    
public:
    U4DPoint3n pointA;
    U4DPoint3n pointB;
    U4DPoint3n pointC;
    
    U4DTriangle(U4DPoint3n& uPointA, U4DPoint3n& uPointB, U4DPoint3n& uPointC);
    ~U4DTriangle();
    
    /*!
     @brief  Determines the closest point to the triangle
     
     @param uPoint Point value
     
     @return Closest point to triangle
     */
    U4DPoint3n closestPointOnTriangleToPoint(U4DPoint3n& uPoint);
    
    /*!
     @brief  Test if point is contained in triangle
     
     @param uPoint Point value
     
     @return true if point is on triangle, false otherwise
     */
    bool isPointOnTriangle(U4DPoint3n& uPoint);
    
    void getBarycentricCoordinatesOfPoint(U4DPoint3n& uPoint, float& baryCoordinateU, float& baryCoordinateV, float& baryCoordinateW);
    
};

}

#endif /* defined(__UntoldEngine__U4DTriangle__) */
