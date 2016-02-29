//
//  U4DBVHTree.hpp
//  UntoldEngine
//
//  Created by Harold Serrano on 2/13/16.
//  Copyright © 2016 Untold Game Studio. All rights reserved.
//

#ifndef U4DBVHTree_hpp
#define U4DBVHTree_hpp

#include <stdio.h>
#include <vector>
#include "U4DPoint3n.h"
#include "U4DVector3n.h"

namespace U4DEngine {

    class U4DDynamicModel;
    
    class U4DBVHTree{
        
    private:
        
        //min & max of volume
        
        U4DPoint3n boundaryVolumeMinPoint;
        
        U4DPoint3n boundaryVolumeMaxPoint;
        
        //longest volume dimension
        U4DVector3n longestVolumeDimensionVector;
        
        //longest dimension split index
        int splitIndex;
        
        //vector of objects
        std::vector<U4DDynamicModel *> modelsContainer;
        
    public:
        
        U4DBVHTree();
        
        ~U4DBVHTree();
        
        U4DBVHTree *parent;
        
        U4DBVHTree *prevSibling;
        
        U4DBVHTree *next;
        
        U4DBVHTree *lastDescendant;
        
        std::vector<U4DDynamicModel *> getModelsContainer();
        
        void addModelToContainer(U4DDynamicModel *uModelsContainer);
        
        void addModelToContainerAtIndex(int uIndex, U4DDynamicModel *uModelsContainer);
        
        void copyModelsContainer(std::vector<U4DDynamicModel *> uModelsContainer);
        
        //scenegraph
        
        void addChild(U4DBVHTree *uChild);
        
        void removeChild(U4DBVHTree *uChild);
        
        void changeLastDescendant(U4DBVHTree *uNewLastDescendant);
        
        U4DBVHTree *getFirstChild();
        
        U4DBVHTree *getLastChild();
        
        U4DBVHTree *getNextSibling();
        
        U4DBVHTree *getPrevSibling();
        
        U4DBVHTree *prevInPreOrderTraversal();
        
        U4DBVHTree *nextInPreOrderTraversal();
        
        bool isLeaf();
        
        bool isRoot();
        
        U4DPoint3n getBoundaryVolumeMinPoint();
        
        U4DPoint3n getBoundaryVolumeMaxPoint();
        
        void setBoundaryVolumeMinPoint(U4DPoint3n& uMinPoint);
        
        void setBoundaryVolumeMaxPoint(U4DPoint3n& uMaxPoint);
        
        void setLongestVolumeDimensionVector(U4DVector3n& uLongestVolumeDimensionVector);
        
        U4DVector3n getLongestVolumeDimensionVector();
        
        void setSplitIndex(int uSplitIndex);
        
        int getSplitIndex();

    };
    
}


#endif /* U4DBVHTree_hpp */
