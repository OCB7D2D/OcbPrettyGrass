Shader "OCBNET/PrettyGrass"
{
    Properties
    {
        _FadeDistance("FadeDistance", Range(1, 400)) = 55
        _Cutoff("Mask Clip Value", Float) = 0.1
        [Header(Translucency)] _Translucency("Strength", Range(0, 50)) = 50
        _TransNormalDistortion("Normal Distortion", Range(0, 1)) = 0
        _TransScattering("Scaterring Falloff", Range(1, 50)) = 1
        _TransDirect("Direct", Range(0, 1)) = 1
        _TransAmbient("Ambient", Range(0, 1)) = 1
        _TransShadow("Shadow", Range(0, 1)) = 1.0
        _AlbedoFactor("AlbedoFactor", Range(0, 1)) = 0.6
        _SpecularFactor("SpecularFactor", Range(0, 1)) = 1.0
        _SmoothnessFactor("SmoothnessFactor", Range(0, 1)) = 0.8
        _OcclusionFactor("OcclusionFactor", Range(0, 1)) = 0.6
        _TranslucencyFactor("TranslucencyFactor", Range(0, 1)) = 0.4
        _TransDirect("Direct", Range(0, 1)) = 1
        _Albedo("Albedo", 2D) = "white" { }
        _Normal("Normal", 2D) = "white" { }
        _Gloss_AO_SSS("Gloss_AO_SSS", 2D) = "white" { }
        [HideInInspector] _texcoord("", 2D) = "white" { }
    }
        SubShader
    {
        Tags { "IGNOREPROJECTOR" = "False" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
        LOD 200

        CGPROGRAM

        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf StandardSpecularCustom fullforwardshadows addshadow vertex:vert
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // #pragma multi_compile _ SHADOWS_SCREEN
        // #pragma multi_compile _ VERTEXLIGHT_ON
        #pragma multi_compile _ LIGHTMAP_ON

        #include "SurfacePass.cginc"

        ENDCG

        Pass
        {
            Tags{ "LightMode" = "MotionVectors" }
            ZWrite Off

            CGPROGRAM
            #pragma vertex VertMotionVectors
            #pragma fragment FragMotionVectors
            #include "MotionPass.cginc"
            ENDCG
        }

    }

    // FallBack "Transparent/Cutout/VertexLit"
    // FallBack "Hidden/Internal-MotionVectors"
}
