//
//  U4DRestingForces.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 4/30/16.
//  Copyright © 2016 Untold Game Studio. All rights reserved.
//

#include "U4DRestingForcesGenerator.h"
#include <vector>

namespace U4DEngine {
    
    U4DRestingForcesGenerator::U4DRestingForcesGenerator(){
        
    }
    
    U4DRestingForcesGenerator::~U4DRestingForcesGenerator(){
        
    }
    
    void U4DRestingForcesGenerator::updateForce(U4DDynamicModel *uModel, float dt){
        
        generateNormalForce(uModel);
            
    }
    
    void U4DRestingForcesGenerator::generateNormalForce(U4DDynamicModel *uModel){
        
        //get normal collision vector
        U4DVector3n contactCollisionNormal=uModel->getCollisionNormalFaceDirection();
        
        //get mass of model
        float mass=uModel->getMass();
        
        //calculate the normal force at each contact point
        U4DVector3n normalForce(0.0,0.0,0.0);
        
        //normalize plane
        contactCollisionNormal.normalize();
        
        //normalize gravity vector
        U4DVector3n normGravity=uModel->getGravity();
        normGravity.normalize();
        
        //get the dot product
        float normalDotGravity=contactCollisionNormal.dot(normGravity);
        
        normalForce=uModel->getGravity()*mass*normalDotGravity;
        
        if (normalDotGravity>0) {
            normalForce*=-1.0;
        }

        uModel->addForce(normalForce);
        
    }
    
    void U4DRestingForcesGenerator::generateTorqueForce(U4DDynamicModel *uModel){
        
        //get center of mass
        U4DVector3n centerOfMass=uModel->getCenterOfMass()+uModel->getAbsolutePosition();

        //get contact points
        std::vector<U4DVector3n> contactManifold=uModel->getCollisionContactPoints();

        //get mass
        float mass=uModel->getMass();
        
        //calculate torque
        U4DVector3n torque(0.0,0.0,0.0);
        
        for(auto n:contactManifold){
            
            //get the radius from the contact manifold to the center of mass
            U4DVector3n radius=centerOfMass-n;
            
            torque+=(radius).cross(uModel->getGravity()*mass);
        }
        
        uModel->addMoment(torque);
       
    }
    
}
