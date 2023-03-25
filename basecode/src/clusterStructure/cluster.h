#ifndef CLUSTER_H
#define CLUSTER_H

#include <unordered_map>
#endif // CLUSTER_H

#include <glm/common.hpp>
#include <glm/vec3.hpp>
#include <svgpp/svgpp.hpp>

using namespace glm;


struct sample{
    int index =0;
    vec2 position = vec2(0);
    int cluster_ID;
    vec3 col = vec3(0);
    //value1: neighborhoodID
    //value2: neighborhood distance
    std::unordered_map<int,float> neighborhood;

};


// the cluster a sample belonging to. one element only have one cluster!
class cluster{
private:
    int id=0;
    std::vector<sample> sample_list;

public:
    cluster();

    void sample_cluster();

};

