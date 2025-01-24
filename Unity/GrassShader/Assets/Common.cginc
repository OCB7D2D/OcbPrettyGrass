// ParticleMotionVector - Example implementation of motion vector writer for
// mesh particle systems | https://github.com/keijiro/ParticleMotionVector

#include "UnityCG.cginc"


uniform sampler2D _Normal;
uniform sampler2D _Albedo;
uniform sampler2D _Gloss_AO_SSS;
uniform sampler2D _texcoord;

uniform float4 _Wind;

uniform float _FadeDistance = 55;

uniform float4 _Normal_ST;
uniform float4 _Albedo_ST;
uniform float4 _Gloss_AO_SSS_ST;

uniform half _AlbedoFactor = 0.6;
uniform half _SpecularFactor = 1.0;
uniform half _SmoothnessFactor = 0.8;
uniform half _OcclusionFactor = 0.6;
uniform half _TranslucencyFactor = 0.4;

uniform half _Translucency = 50;
uniform half _TransNormalDistortion = 0;
uniform half _TransScattering = 1;
uniform half _TransDirect = 1;
uniform half _TransAmbient = 1;
uniform half _TransShadow = 0.9;
uniform float _Cutoff = 0.1;


struct Input
{
    float2 uv_texcoord;
    float3 worldPos;
};

struct SurfaceOutputStandardSpecularCustom
{
    fixed3 Albedo;
    fixed3 Specular;
    fixed3 Normal;
    fixed3 Emission;
    fixed Smoothness;
    fixed Occlusion;
    fixed Alpha;
    fixed3 Translucency;
};

bool4 lessThan(float4 a, float4 b)
{
    bool4 rv;
    rv.x = a.x < b.x;
    rv.y = a.y < b.y;
    rv.z = a.z < b.z;
    rv.w = a.w < b.w;
    return rv;
}
