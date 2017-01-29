//
//  SoccerBall.hpp
//  UntoldEngine
//
//  Created by Harold Serrano on 1/28/17.
//  Copyright © 2017 Untold Game Studio. All rights reserved.
//

#ifndef SoccerBall_hpp
#define SoccerBall_hpp

#include <stdio.h>

#include "U4DGameObject.h"
#include "UserCommonProtocols.h"

class SoccerBall:public U4DEngine::U4DGameObject {
    
private:
    GameEntityState entityState;
    
public:
    SoccerBall(){};
    ~SoccerBall(){};
    
    void init(const char* uName, const char* uBlenderFile);
    
    void update(double dt);
    
    void changeState(GameEntityState uState);
    
    void setState(GameEntityState uState);
    
    GameEntityState getState();
    
};

#endif /* SoccerBall_hpp */
