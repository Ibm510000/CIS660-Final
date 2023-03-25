#include "image_data.h"
#include "glm/detail/func_geometric.hpp"
#include <cmath>

image_data::image_data()
{

}


void image_data::calculate_neighbor(){

    for(auto &[key1,sample]: this->sample_data){
        for(auto &[key2,target]: this->sample_data){
            float phy_distance = glm::distance(sample->position,target->position);
            if(phy_distance<this->neighbor_r){
                sample->neighborhood[target->index]=phy_distance;
                //B->neighborhood[A->index]=distance;
            }
        }
    }

};


float image_data::calculate_distance(sample* nSo, sample* nS1){
    float distance=INFINITY;
    float sample_distance=0;
    for(auto &[key1,distance1]: nSo->neighborhood){
        for(auto &[ke2,distance2]: nS1->neighborhood){

            sample_distance = abs(distance1-distance2);







            distance = min(distance,sample_distance);
        }
    }


    return distance;

}

float image_data::calculate_sampleSimilarity(){

}
