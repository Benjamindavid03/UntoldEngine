//
//  U4DBVHManager.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 2/13/16.
//  Copyright © 2016 Untold Game Studio. All rights reserved.
//

#include "U4DBVHManager.h"
#include "U4DBVHTree.h"
#include "U4DVector3n.h"
#include "U4DDynamicModel.h"
#include "U4DBoundingVolume.h"
#include <cmath>
#include <cstdlib>


namespace U4DEngine{
    
    U4DBVHManager::U4DBVHManager(){
        
    }
    
    U4DBVHManager::~U4DBVHManager(){
        
    }
    
    std::vector<U4DDynamicModel *> U4DBVHManager::getModelsContainer(){
        
        return modelsContainer;
    }
    
    void U4DBVHManager::buildBVH(){
        
        //create parent node
        
        std::shared_ptr<U4DBVHTree> root(new U4DBVHTree());
        
        treeContainer.push_back(root);
        
        //copy all models into container
        root->copyModelsContainer(modelsContainer);
        
        //start building the nodes
        buildBVHNode(root.get(), 0, getModelsContainer().size());
        
        U4DBVHTree *child=root.get();
        
        while (child!=NULL) {
            
            if(child->isRoot()){

                
            }else{
                
                std::cout<<"Parent: "<<std::endl;
                
                for (auto n:child->getModelsContainer()) {
                
                    std::cout<<n->getName()<<std::endl;
                }
                
            }
        
            child=child->next;
        }
        
        //clean up all containers
        cleanUp();
        
        std::cout<<"STOP HERE"<<std::endl;
        
    }
    
    void U4DBVHManager::buildBVHNode(U4DBVHTree *uNode, int uLeftIndex, int uSplitIndex){
        
        //1. Create node with current objects
        std::shared_ptr<U4DBVHTree> nodeLeaf(new U4DBVHTree());
        
        treeContainer.push_back(nodeLeaf);
        
        //add it as child
        uNode->addChild(nodeLeaf.get());
        
        //load models in to container
        for (int i=uLeftIndex; i<uSplitIndex; i++) {
            
            U4DDynamicModel *model=uNode->getModelsContainer().at(i);
            
            nodeLeaf->addModelToContainer(model);
            
        }
        
        //check if the node leaf has more than two models, if it does then split it recursively, else stop
        if (nodeLeaf->getModelsContainer().size()>2) {
         
            //2. Calculate volume
            calculateBVHVolume(nodeLeaf.get());
            
            //3. get longest dimension
            getBVHLongestDimensionVector(nodeLeaf.get());
             
            //4. sort objects along the longest dimension
            heapSorting(nodeLeaf.get());
                
            //5. get split index
            getBVHSplitIndex(nodeLeaf.get());
            
            //6. build left and right node
            buildBVHNode(nodeLeaf.get(), 0, nodeLeaf->getSplitIndex());
            buildBVHNode(nodeLeaf.get(), nodeLeaf->getSplitIndex(), nodeLeaf->getModelsContainer().size());
        
        }
        
    }
    
    
    void U4DBVHManager::calculateBVHVolume(U4DBVHTree *uNode){
        
        float xMin=FLT_MAX;
        float xMax=FLT_MIN;
        float yMin=FLT_MAX;
        float yMax=FLT_MIN;
        float zMin=FLT_MAX;
        float zMax=FLT_MIN;
        
        //get the min and max points for the volume
        
        for (auto n:uNode->getModelsContainer()) {
        
            U4DBoundingVolume *sphere=n->getBroadPhaseBoundingVolume();
            
            U4DPoint3n minPoints=sphere->getMinBoundaryPoint();
            U4DPoint3n maxPoints=sphere->getMaxBoundaryPoint();
            
            xMin=MIN(minPoints.x, xMin);
            yMin=MIN(minPoints.y, yMin);
            zMin=MIN(minPoints.z, zMin);

            xMax=MAX(maxPoints.x, xMax);
            yMax=MAX(maxPoints.y, yMax);
            zMax=MAX(maxPoints.z, zMax);
            
        }
        
        //assign volume min and max values to node
        U4DPoint3n maxPoint(xMax,yMax,zMax);
        uNode->setBoundaryVolumeMaxPoint(maxPoint);
        
        U4DPoint3n minPoint(xMin,yMin,zMin);
        uNode->setBoundaryVolumeMinPoint(minPoint);
        
    }
    
    void U4DBVHManager::getBVHLongestDimensionVector(U4DBVHTree *uNode){
        
        //get the longest dimension of the volume
        float xDimension=std::abs(uNode->getBoundaryVolumeMinPoint().x-uNode->getBoundaryVolumeMaxPoint().x);
        float yDimension=std::abs(uNode->getBoundaryVolumeMinPoint().y-uNode->getBoundaryVolumeMaxPoint().y);
        float zDimension=std::abs(uNode->getBoundaryVolumeMinPoint().z-uNode->getBoundaryVolumeMaxPoint().z);
        
        float longestDimension=0.0;
        U4DVector3n longestDimensionVector(0,0,0);
        
        longestDimension=MAX(xDimension, yDimension);
        longestDimension=MAX(zDimension, longestDimension);
        
        if (longestDimension==xDimension) {
            
            longestDimensionVector=U4DVector3n(1,0,0);
            
        }else if(longestDimension==yDimension){
        
            longestDimensionVector=U4DVector3n(0,1,0);
        
        }else{
        
            longestDimensionVector=U4DVector3n(0,0,1);
        
        }
        
         uNode->setLongestVolumeDimensionVector(longestDimensionVector);
        
    }
    
    void U4DBVHManager::getBVHSplitIndex(U4DBVHTree *uNode){
        
        //split the longest dimension of the volume in half
        
        //get min point of volume
        U4DVector3n minBoundary=uNode->getBoundaryVolumeMinPoint().toVector();
        
        //get max point in volume
        U4DVector3n maxBoundary=uNode->getBoundaryVolumeMaxPoint().toVector();
        
        //half distance of longest dimension in volume
        float halfDistance=(maxBoundary.dot(uNode->getLongestVolumeDimensionVector())-minBoundary.dot(uNode->getLongestVolumeDimensionVector()))/2;
        
        halfDistance=maxBoundary.dot(uNode->getLongestVolumeDimensionVector())-halfDistance;
        
        //search for split index
        std::vector<float> tempVectorOfModelPosition;
        
        for (auto n:uNode->getModelsContainer()) {
            
            float broadPhaseBoundingVolumePositionAlongVector=n->getBroadPhaseBoundingVolume()->getLocalPosition().dot(uNode->getLongestVolumeDimensionVector());
            
            float distance=std::abs(broadPhaseBoundingVolumePositionAlongVector-halfDistance);
            
            tempVectorOfModelPosition.push_back(distance);
        
        }
        
        
        //Get the minimum element in the vector with the lowest distance to the half distance of the volue
        auto closestModelToHalfDistance=std::min_element(tempVectorOfModelPosition.cbegin(), tempVectorOfModelPosition.cend());
        
        //Get the actual index in the vector which corresponds to the minimum element
        int splitIndex=std::distance(tempVectorOfModelPosition.cbegin(), closestModelToHalfDistance);
        
        //
        float positionOfModelAlongLongestVector=uNode->getModelsContainer().at(splitIndex)->getBroadPhaseBoundingVolume()->getLocalPosition().dot(uNode->getLongestVolumeDimensionVector());
        
        if (positionOfModelAlongLongestVector<halfDistance) {
            
            splitIndex++;
            
        }
        
        
        uNode->setSplitIndex(splitIndex);
        
    }
    
    void U4DBVHManager::addModel(U4DDynamicModel* uModel){
        
        modelsContainer.push_back(uModel);
        
    }
    
    void U4DBVHManager::clearModels(){
        
        modelsContainer.clear();
        
    }
    
    void U4DBVHManager::heapSorting(U4DBVHTree *uNode){
        
        int index=0;
        
        int numValues=(int)uNode->getModelsContainer().size();
        
        //convert the array of values into a heap
        for (index=numValues/2-1; index>=0; index--) {
        
            reHeapDown(uNode,index,numValues-1);
        }
        
        //sort the array
        for (index=numValues-1; index>=1; index--) {
            
            swap(uNode,0,index);
            reHeapDown(uNode,0,index-1);
            
        }
        
    }
    
    void U4DBVHManager::reHeapDown(U4DBVHTree *uNode,int root, int bottom){
        
        int maxChild;
        int rightChild;
        int leftChild;
        
        leftChild=root*2+1;
        rightChild=root*2+2;
        
        if (leftChild<=bottom) {
            
            if (leftChild==bottom) {
                
                maxChild=leftChild;
                
            }else{
                
                if (uNode->getModelsContainer().at(leftChild)->getBroadPhaseBoundingVolume()->getLocalPosition().dot(uNode->getLongestVolumeDimensionVector())<=uNode->getModelsContainer().at(rightChild)->getBroadPhaseBoundingVolume()->getLocalPosition().dot(uNode->getLongestVolumeDimensionVector())) {
                    
                    maxChild=rightChild;
                    
                }else{
                    maxChild=leftChild;
                }
            }
            
            if (uNode->getModelsContainer().at(root)->getBroadPhaseBoundingVolume()->getLocalPosition().dot(uNode->getLongestVolumeDimensionVector())<uNode->getModelsContainer().at(maxChild)->getBroadPhaseBoundingVolume()->getLocalPosition().dot(uNode->getLongestVolumeDimensionVector())) {
                
                swap(uNode,root,maxChild);
                reHeapDown(uNode,maxChild,bottom);
            }
        }
        
    }
    
    
    
    void U4DBVHManager::swap(U4DBVHTree *uNode,int uIndex1, int uIndex2){
        
        U4DDynamicModel* model1=uNode->getModelsContainer().at(uIndex1);
        U4DDynamicModel* model2=uNode->getModelsContainer().at(uIndex2);
        
        uNode->addModelToContainerAtIndex(uIndex1, model2);
        uNode->addModelToContainerAtIndex(uIndex2, model1);
        
    }
    
    void U4DBVHManager::broadPhaseCollision(U4DBVHTree *uTreeLeftNode, U4DBVHTree *uTreeRightNode){
        
        if (overlapBetweenTreeVolume(uTreeLeftNode,uTreeRightNode)) return;
        
        if (uTreeLeftNode->isLeaf() && uTreeRightNode->isLeaf()) {
            
            //At leaf nodes, perform collision tests on leaf node contents
            overlapBetweenTreeLeafNodes(uTreeLeftNode,uTreeRightNode);
            
        }else{
            
            if (descendTreeRule(uTreeLeftNode,uTreeRightNode)) {
                
                broadPhaseCollision(uTreeLeftNode->getFirstChild(), uTreeRightNode);
                broadPhaseCollision(uTreeLeftNode->getLastChild(), uTreeRightNode);
                
            }else{
                broadPhaseCollision(uTreeLeftNode, uTreeRightNode->getFirstChild());
                broadPhaseCollision(uTreeLeftNode, uTreeRightNode->getLastChild());
            }
            
        }
        
    }
    
    bool U4DBVHManager::overlapBetweenTreeVolume(U4DBVHTree *uTreeLeftNode, U4DBVHTree *uTreeRightNode){
        
        
    }
    
    void U4DBVHManager::overlapBetweenTreeLeafNodes(U4DBVHTree *uTreeLeftNode, U4DBVHTree *uTreeRightNode){
        
        
    }
    
    bool U4DBVHManager::descendTreeRule(U4DBVHTree *uTreeLeftNode, U4DBVHTree *uTreeRightNode){
        
        return uTreeLeftNode->isLeaf();
    }
    
    void U4DBVHManager::cleanUp(){
        
        modelsContainer.clear();
        treeContainer.clear();
        
    }
    
}