//
//  GameLogic.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 6/11/13.
//  Copyright (c) 2013 Untold Story Studio. All rights reserved.
//

#include "GameLogic.h"
#include "MyCharacter.h"
#include "UserCommonProtocols.h"
#include "U4DControllerInterface.h"
#include "GameController.h"
#include "U4DButton.h"
#include "U4DJoyStick.h"
#include "CommonProtocols.h"

void GameLogic::update(double dt){

}

void GameLogic::init(){
    
    //set my main actor and attach camera to follow it
    rocket=dynamic_cast<MyCharacter*>(searchChild("rocket"));
    
    buttonA=getGameController()->getButtonWithName("buttonA");
    buttonB=getGameController()->getButtonWithName("buttonB");
    joystick=getGameController()->getJoyStickWithName("joystick");
    
}

void GameLogic::receiveTouchUpdate(){


    
    if (buttonA->getIsPressed()) {
        
        rocket->changeState(kTraveling);
        
    }else if(buttonA->getIsReleased()){
        
        rocket->changeState(kNull);
    }
    
    if (buttonB->getIsPressed()) {
        
        //robot->changeState(kJump);
        
        
    }else if(buttonB->getIsReleased()){
        
        //robot->changeState(kNull);
        
    }
    
    if(joystick->getIsActive()){
        
        //robot->changeState(kRotating);
        U4DEngine::U4DVector3n joyData=joystick->getDataPosition();
        //robot->setJoystickData(joyData);
        
        U4DEngine::U4DVector3n setView(joyData.x*10.0,joyData.y*10.0,-20.0);
        
        rocket->viewInDirection(setView);
        
    }
    
}



