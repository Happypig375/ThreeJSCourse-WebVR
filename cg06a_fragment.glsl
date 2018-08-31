//precision highp float;
uniform float time;
uniform vec2 resolution;
varying vec3 fPosition;
varying vec3 fNormal;
varying vec2 vUv;

uniform sampler2D texture;

vec4 rim(const vec4 color, const float start, const float end, const float coef, const bool outline)
{
  vec3 normal = normalize(fNormal);
  vec3 eye = normalize(-fPosition.xyz);
  float dotProd = dot(normal, eye);
  float rim = smoothstep(start, end, outline ? dotProd : 1.0 - dotProd);
  return clamp(rim, 0.0, 1.0) * coef * color;
}

vec4 toonShade(vec4 original)
{
  vec4 color = rim(original, 0.0, 1.0, 1.0, true);
  for(int i = 0; i < 4; i++)
    if(color[i] > 0.2 && color[i] < 0.5)
      color[i] = 0.25;
    else if (color[i] >= 0.5)
      color[i] = 0.75;
    else 
      color[i] = 0.0;
  return color;
}

void main()
{
  fPosition; //mute warning
  vec4 texture = texture2D(texture, vUv);
  gl_FragColor = toonShade(texture);
  //gl_FragColor = vec4(fNormal, 1.0);
}