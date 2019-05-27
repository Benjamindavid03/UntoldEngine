//
//  U4DSphere.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 2/28/16.
//  Copyright © 2016 Untold Engine Studios. All rights reserved.
//

#include "U4DSphere.h"
#include "U4DVector3n.h"
#include <cmath>

namespace U4DEngine {
    
    U4DSphere::U4DSphere():radius(0.0),center(0.0,0.0,0.0){
            
    }
    
    U4DSphere::U4DSphere(U4DPoint3n &uCenter, float uRadius){
        
        radius=uRadius;
        center=uCenter;
        
    }
    
    U4DSphere::~U4DSphere(){
        
    }
    
    void U4DSphere::setCenter(U4DPoint3n &uCenter){
        
        center=uCenter;
    
    }
    
    void U4DSphere::setRadius(float uRadius){
        
        radius=uRadius;
        
    }
    
    U4DPoint3n U4DSphere::getCenter(){
        
        return center;
        
    }
    
    float U4DSphere::getRadius(){
        
        return radius;
        
    }
    
    bool U4DSphere::intersectionWithVolume(U4DSphere &uSphere){
        
        //Calculate squared distance between centers
        U4DVector3n distanceBetweenCentersVector=center-uSphere.center;
        float distance=distanceBetweenCentersVector.dot(distanceBetweenCentersVector);
        
        //Sphere intersect if squared distance is less than squared sum of radii
        float radiusSum=radius+uSphere.radius;
        
        return distance<=radiusSum*radiusSum;
        
    }
    
    bool U4DSphere::intersectionWithVolume(U4DSphere &uSphere, U4DPlane &uPlane){
        
        if (intersectionWithVolume(uSphere)) {
            
            //if we subtract the two spheres, then we can compute the intersection plane
            
            float x1=center.x;
            float y1=center.y;
            float z1=center.z;
            
            float x2=uSphere.center.x;
            float y2=uSphere.center.y;
            float z2=uSphere.center.z;
            
            float a=2*(x2-x1);
            float b=2*(y2-y1);
            float c=2*(z2-z1);
            
            float d=x1*x1-x2*x2+y1*y1-y2*y2+z1*z1-z2*z2-radius*radius+uSphere.radius*uSphere.radius;
            
            d=fabs(d);
            
            U4DVector3n planeNormal(a,b,c);
            
            planeNormal.normalize();
            
            U4DPlane intersectionPlane(planeNormal,d);
            
            uPlane=intersectionPlane;
            
            return true;
        }
        
        return false;
    }
    
}
