//
//  U4DPadButtonPressedState.hpp
//  UntoldEngine
//
//  Created by Harold Serrano on 2/8/18.
//  Copyright © 2018 Untold Game Studio. All rights reserved.
//

#ifndef U4DPadButtonPressedState_hpp
#define U4DPadButtonPressedState_hpp

#include <stdio.h>
#include "U4DPadButton.h"
#include "U4DPadButtonStateInterface.h"

namespace U4DEngine {
    
    class U4DPadButtonPressedState:public U4DPadButtonStateInterface {
        
    private:
        
        U4DPadButtonPressedState();
        
        ~U4DPadButtonPressedState();
        
    public:
        
        static U4DPadButtonPressedState* instance;
        
        static U4DPadButtonPressedState* sharedInstance();
        
        void enter(U4DPadButton *uPadButton);
        
        void execute(U4DPadButton *uPadButton, double dt);
        
        void exit(U4DPadButton *uPadButton);
        
    };
    
}
#endif /* U4DPadButtonPressedState_hpp */
