#include "UnityCG.cginc"
#include "Common.cginc"

// Object rendering things

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

struct MotionVectorData
{
    float4 transferPos : TEXCOORD0;
    float4 transferPosOld : TEXCOORD1;
    float3 uv_texcoord : TEXCOORD2;
    float4 pos : SV_POSITION;
    UNITY_VERTEX_OUTPUT_STEREO
};

struct MotionVertexInput
{
    float4 vertex : POSITION;
    float3 texcoord : TEXCOORD0;
    float3 oldPos : TEXCOORD4;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

MotionVectorData VertMotionVectors(MotionVertexInput v)
{
    MotionVectorData o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    #define CALC_OLD_POS
    #include "Motion.cginc"

    o.pos = UnityObjectToClipPos(posNew);

    // this works around an issue with dynamic batching
    // potentially remove in 5.4 when we use instancing
    #if defined(UNITY_REVERSED_Z)
    o.pos.z -= _MotionVectorDepthBias * o.pos.w;
    #else
    o.pos.z += _MotionVectorDepthBias * o.pos.w;
    #endif

    #if defined(USING_STEREO_MATRICES)
    o.transferPos = mul(_StereoNonJitteredVP[unity_StereoEyeIndex], mul(unity_ObjectToWorld, float4(posNew.xyz, 1.0)));
    o.transferPosOld = mul(_StereoPreviousVP[unity_StereoEyeIndex], mul(_PreviousM, float4(posOld.xyz, 1.0));
    #else
    o.transferPos = mul(_NonJitteredVP, mul(unity_ObjectToWorld, float4(posNew.xyz, 1.0)));
    o.transferPosOld = mul(_PreviousVP, mul(_PreviousM, float4(posOld.xyz, 1.0)));
    #endif

    o.uv_texcoord = v.texcoord;

    return o;
}

half4 FragMotionVectors(MotionVectorData i) : SV_Target
{
    float3 hPos = (i.transferPos.xyz / i.transferPos.w);
    float3 hPosOld = (i.transferPosOld.xyz / i.transferPosOld.w);

    float4 albedo = tex2D(_Albedo, i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw);
    float upper = _FadeDistance * 0.6;
    float lower = _FadeDistance * -0.4;
     //  + distance(i.worldPos, _WorldSpaceCameraPos)
    clip(albedo.w - clamp(lower / upper, 0.0, 1.0) - _Cutoff);

    // V is the viewport position at this pixel in the range 0 to 1.
    float2 vPos = (hPos.xy + 1.0f) / 2.0f;
    float2 vPosOld = (hPosOld.xy + 1.0f) / 2.0f;

    #if UNITY_UV_STARTS_AT_TOP
    vPos.y = 1.0 - vPos.y;
    vPosOld.y = 1.0 - vPosOld.y;
    #endif

    return lerp(half4(vPos - vPosOld, 0, 1), 0, (half)_ForceNoMotion);
}

