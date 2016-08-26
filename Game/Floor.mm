//
//  Floor.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 8/4/16.
//  Copyright © 2016 Untold Game Studio. All rights reserved.
//

#include "Floor.h"


Floor::Floor(){
    
}

Floor::~Floor(){
    
}

void Floor::init(const char* uName, const char* uBlenderFile){
    
    if (loadModel(uName, uBlenderFile)) {
        
        //initialize everything else here
        //initAsInfinitePlatform(true);
        translateBy(1.0, 0.0, 0.0);
        initMass(1000.0);
        enableCollisionBehavior();
        setBroadPhaseBoundingVolumeVisibility(true);
    }
}

void Floor::update(double dt){
    
}