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
        initAsPlatform(true);
        initMass(10.0);
        initCoefficientOfRestitution(0.2);
        enableCollisionBehavior();
    }
}

void Floor::update(double dt){
    
}