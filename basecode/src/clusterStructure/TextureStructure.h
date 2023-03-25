#ifndef TEXTURESTRUCTURE_H
#define TEXTURESTRUCTURE_H

#endif // TEXTURESTRUCTURE_H


#include <glm/common.hpp>
#include <glm/vec3.hpp>
#include <svgpp/svgpp.hpp>

using namespace glm;


struct spatial_par{

    vec2 position = vec2(0);
    int cluster_ID;


};


struct sample{
    spatial_par m_spatial_par;
    vec2 position = vec2(0);
    vec3 col = vec3(0);


};

class cluster{
private:
    int id=0;
    std::vector<sample> sample_list;

public:




}
