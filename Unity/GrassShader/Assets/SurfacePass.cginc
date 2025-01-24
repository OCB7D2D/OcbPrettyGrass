#include "UnityPBSLighting.cginc"

#if defined(USING_STEREO_MATRICES)
float4x4 _StereoNonJitteredVP[2];
float4x4 _StereoPreviousVP[2];
#else
float4x4 _NonJitteredVP;
float4x4 _PreviousVP;
#endif
float4x4 _PreviousM;
bool _HasLastPositionData;
bool _ForceNoMotion;
float _MotionVectorDepthBias;

#include "Common.cginc"

// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
// #pragma instancing_options assumeuniformscaling
UNITY_INSTANCING_BUFFER_START(Props)
    // put more per-instance properties here
UNITY_INSTANCING_BUFFER_END(Props)

void vert(inout appdata_full v)
{
    #undef CALC_OLD_POS
    #include "Motion.cginc"
    v.vertex = float4(posNew.xyz, v.vertex.w);
}

void surf(Input i, inout SurfaceOutputStandardSpecularCustom o)
{

    // float exp = exp2(log2(unity_AmbientSky.xyz) * 2.2);
    float4 albedo = tex2D(_Albedo, i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw);
    o.Normal = UnpackNormal(tex2D(_Normal, i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw));

    float upper = _FadeDistance * 0.6;
    float lower = _FadeDistance * -0.4 +
        distance(i.worldPos, _WorldSpaceCameraPos);
    clip(albedo.w - clamp(lower / upper, 0.0, 1.0) - _Cutoff);

    float4 gaos = tex2D(_Gloss_AO_SSS, i.uv_texcoord * _Gloss_AO_SSS_ST.xy + _Gloss_AO_SSS_ST.zw);

    // Here most of the magic happens
    o.Albedo = albedo.xyz * _AlbedoFactor;
    o.Specular = gaos.r * _SpecularFactor;
    o.Occlusion = gaos.g * _OcclusionFactor;
    o.Smoothness = gaos.b * _SmoothnessFactor;
    o.Translucency = min(pow(gaos.b, _TranslucencyFactor) / 10, 1);

    o.Alpha = 1.0;
}

inline half4 LightingStandardSpecularCustom(inout SurfaceOutputStandardSpecularCustom s, half3 viewDir, UnityGI gi)
{
    #if !DIRECTIONAL
    float3 lightAtten = gi.light.color;
    #else
    float3 lightAtten = lerp(_LightColor0.rgb, gi.light.color, _TransShadow);
    #endif
    
    // Calculate translucency by inverting the light prope vector
    // Basically checking the lighting at the other side of the plane
    half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
    half transVdotL = pow(saturate(dot(viewDir, -lightDir)), _TransScattering);
    half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
    half4 c = half4(s.Albedo * translucency * _Translucency, 0);

    SurfaceOutputStandardSpecular r;
    r.Albedo = s.Albedo;
    r.Specular = s.Specular;
    r.Normal = s.Normal;
    // r.Emission = s.Emission;
    r.Smoothness = s.Smoothness;
    r.Occlusion = s.Occlusion;
    r.Alpha = s.Alpha;
    return LightingStandardSpecular(r, viewDir, gi) + c;
}

inline void LightingStandardSpecularCustom_GI(SurfaceOutputStandardSpecularCustom s, UnityGIInput data, inout UnityGI gi)
{
    UNITY_GI(gi, s, data);
}
