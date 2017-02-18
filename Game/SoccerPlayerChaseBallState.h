//
//  SoccerPlayerChaseBallState.hpp
//  UntoldEngine
//
//  Created by Harold Serrano on 2/17/17.
//  Copyright © 2017 Untold Game Studio. All rights reserved.
//

#ifndef SoccerPlayerChaseBallState_hpp
#define SoccerPlayerChaseBallState_hpp

#include <stdio.h>
#include "SoccerPlayerStateInterface.h"

class SoccerPlayerChaseBallState:public SoccerPlayerStateInterface {
    
private:
    
protected:
    
    SoccerPlayerChaseBallState();
    
    ~SoccerPlayerChaseBallState();
    
public:
    
    static SoccerPlayerChaseBallState* instance;
    
    static SoccerPlayerChaseBallState* sharedInstance();
    
    void enter(SoccerPlayer *uPlayer);
    
    void execute(SoccerPlayer *uPlayer, double dt);
    
    void exit(SoccerPlayer *uPlayer);
    
};

#endif /* SoccerPlayerChaseBallState_hpp */
