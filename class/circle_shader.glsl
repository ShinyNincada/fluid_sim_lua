extern vec2 resolution;
extern vec2 center;
extern float radius;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 pos = vec2(0,0);
    float dist = length(pos);
    if (dist < radius) {
        return vec4(color.rgb, 1.0); // Inside the circle
    } else {
        return vec4(0.0, 0.0, 0.0, 0.0); // Outside the circle
    }
}
