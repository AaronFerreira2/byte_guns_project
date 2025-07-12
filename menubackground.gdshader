shader_type canvas_item;
uniform float speed = 0.01;
uniform float max_speed = 0.1;
// Função hash simples pra gerar valores pseudoaleatórios
float rand(float t) {
    return fract(sin(t * 12.9898) * 43758.5453);
}

// Gera uma cor pseudoaleatória com base em um tempo
vec3 random_color(float t) {
    return vec3(
        rand(t),
        rand(t + 5.3),
        rand(t + 8.1)
    );
}

void fragment() {
    // Valor animado baseado na posição UV e tempo
    float gradient = mod(UV.y + TIME * speed, 1.0);

    // Suaviza as bordas do degradê
    float blurred = smoothstep(0.0, 0.5, gradient) * (1.0 - smoothstep(0.5, 1.0, gradient));

    // Tempo base atual (a cada 20s)
    float t = floor(TIME / 20.0);
    float blend = fract(TIME / 20.0); // valor de interpolação entre 0 e 1

    // Cores atual e próxima
    vec3 color1 = random_color(t);
    vec3 color2 = random_color(t + 1.0);

    // Transição suave entre elas
    vec3 final_color = mix(color1, color2, blend);

    // Aplica o degradê com a cor interpolada
    COLOR.rgb = blurred * final_color;
}
void vertex(){
	UV.y += TIME * speed;
}
//shader_type canvas_item;
//
//uniform float speed = 0.01;
//uniform float max_speed = 0.1;
//// Função hash simples pra gerar valores pseudoaleatórios
//float rand(float t) {
    //return fract(sin(t * 12.9898) * 43758.5453);
//}
//
//// Gera uma cor pseudoaleatória com base em um tempo
//vec3 random_color(float t) {
    //return vec3(
        //rand(t),
        //rand(t + 5.3),
        //rand(t + 8.1)
    //);
//}
//
//void fragment() {
    //// Valor animado baseado na posição UV e tempo
    //float gradient = mod(UV.x + UV.y + TIME * speed, 1.0);
//
    //// Suaviza as bordas do degradê
    //float blurred = smoothstep(0.0, 0.5, gradient) * (1.0 - smoothstep(0.5, 1.0, gradient));
//
    //// Tempo base atual (a cada 20s)
    //float t = floor(TIME / 20.0);
    //float blend = fract(TIME / 20.0); // valor de interpolação entre 0 e 1
//
    //// Cores atual e próxima
    //vec3 color1 = random_color(t);
    //vec3 color2 = random_color(t + 1.0);
//
    //// Transição suave entre elas
    //vec3 final_color = mix(color1, color2, blend);
//
    //// Aplica o degradê com a cor interpolada
    //COLOR.rgb = blurred * final_color;
//}
//vec2 random_direction(float t) {
    //float angle = rand(t) * 6.2831; // 2π
    //return vec2(cos(angle), sin(angle));
//}
//void vertex() {
    //// Duração do ciclo (em segundos)
    //float cycle = 20.0;
//
    //// Tempo dentro do ciclo atual
    //float t = floor(TIME / cycle);
    //float blend = fract(TIME / cycle);
//
    //// Duas direções aleatórias interpoladas suavemente
    //vec2 dir1 = random_direction(t);
    //vec2 dir2 = random_direction(t + 1.0);
    //vec2 direction = normalize(mix(dir1, dir2, smoothstep(0.0, 1.0, blend)));
//
    //// Multiplicador com tempo local do ciclo (0 → 20)
    //float local_time = mod(TIME, cycle);
//
    //// Aplica movimento dentro de um ciclo, controlado
    //vec2 movement = direction * min(speed, max_speed) * local_time;
//
    //UV += movement;
//}