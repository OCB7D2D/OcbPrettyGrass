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
        _TransShadow("Shadow", Range(0, 1)) = 0.9
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

        #include "UnityPBSLighting.cginc"

        uniform sampler2D _Normal;
        uniform sampler2D _Albedo;
        uniform sampler2D _Gloss_AO_SSS;
        uniform sampler2D _texcoord;

        uniform float _Wind;
        uniform float _WindTime;

        uniform float _FadeDistance = 55;

        uniform float4 _Normal_ST;
        uniform float4 _Albedo_ST;
        uniform float4 _Gloss_AO_SSS_ST;

        uniform half _Translucency = 50;
        uniform half _TransNormalDistortion = 0;
        uniform half _TransScattering = 1;
        uniform half _TransDirect = 1;
        uniform half _TransAmbient = 1;
        uniform half _TransShadow = 0.9;
        uniform float _Cutoff = 0.1;

        // Shouldn't cost much to keep
        uniform float _F1 = 0.0;
        uniform float _F2 = 0.0;
        uniform float _F3 = 0.0;
        uniform float _F4 = 0.0;
        uniform float _F5 = 0.0;
        uniform float _F6 = 0.0;
        uniform float _F7 = 0.0;
        uniform float _F8 = 0.0;
        uniform float _F9 = 0.0;

        struct Input
        {
            //float4 _LightColor;
            float2 uv_texcoord;
            float3 worldPos;
            float2 color : COLOR;
            float2 other : TEXCOORD;
        };

        struct SurfaceOutputStandardSpecularCustom
        {
            float2 other;
            fixed3 Albedo;
            fixed3 Specular;
            fixed3 Normal;
            fixed3 Emission;
            fixed Smoothness;
            fixed Occlusion;
            fixed Alpha;
            fixed3 Translucency;
            fixed Distance;
            // fixed4 Color;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        bool4 lessThan(float4 a, float4 b)
        {
            bool4 rv;
            rv.x = a.x < b.x;
            rv.y = a.y < b.y;
            rv.z = a.z < b.z;
            rv.w = a.w < b.w;
            return rv;
        }

        void vert(inout appdata_full v)
        {
            float4 xlat0;
            float4 xlat1;
            int4 xlati1;
            bool4 xlatb1;
            bool4 xlatb2;
            bool4 xlatb3;
            int xlati12;
            // Code is simply copied via AssetRipper ;)
            // It works so no need to understand it (yet)
            xlat0.x = v.vertex.y + v.vertex.x;
            xlat0.x = xlat0.x + v.vertex.z;
            xlat0.x = xlat0.x * 0.850000024;
            xlat0.x = _WindTime * -12.4799995 + xlat0.x;
            xlat0.x = sin(xlat0.x);
            xlat0 = xlat0.xxxx + float4(0.5, 0.5, 1.0, 1.0);
            xlat0 = xlat0 * float4(float4(_Wind, _Wind, _Wind, _Wind));
            xlat1.xy = xlat0.yy * float2(0.200000003, 0.25) + v.vertex.xz;
            xlat1.xz = xlat0.ww * float2(0.3125, 0.3125) + xlat1.xy;
            xlat0.xy = xlat0.xy * float2(0.0500000007, 0.100000001) + v.vertex.xz;
            xlat0.xz = xlat0.zw * float2(0.078125, 0.125) + xlat0.xy;
            xlat1.y = -0.349999994 * xlat0.w + v.vertex.y;
            xlat0.y = -0.150000006 * xlat0.w + v.vertex.y;
            xlatb2 = lessThan(v.texcoord.yyyy, float4(0.610000014, 0.790000021, 0.920000017, 0.26343751));
            xlat0.xyz = (xlatb2.w) ? xlat1.xyz : xlat0.xyz;
            xlatb1 = lessThan(float4(0.0, 0.140000001, 0.289999992, 0.425000012), v.texcoord.yyyy);
            xlatb3 = lessThan(v.texcoord.yyyy, float4(0.100000001, 0.230000004, 0.379999995, 0.50999999));
            xlati1 = int4((uint4(xlatb1) * 0xffffffffu) & (uint4(xlatb3) * 0xffffffffu));
            xlati1 = ~(xlati1);
            xlati12 = int(uint(xlati1.x) & uint(xlati1.y));
            xlati12 = int(uint(xlati1.z) & uint(xlati12));
            xlati12 = int(uint(xlati1.w) & uint(xlati12));
            xlatb1.xyz = lessThan(float4(0.565999985, 0.707000017, 0.850000024, 0.0), v.texcoord.yyyy).xyz;
            xlati1.xyz = int3((uint3(xlatb2.xyz) * 0xffffffffu) & (uint3(xlatb1.xyz) * 0xffffffffu));
            xlati1.xyz = ~(xlati1.xyz);
            xlati12 = int(uint(xlati12) & uint(xlati1.x));
            xlati12 = int(uint(xlati1.y) & uint(xlati12));
            xlati12 = int(uint(xlati1.z) & uint(xlati12));
            //v.color.x = distance(v.vertex, _WorldSpaceCameraPos);
            v.color.y = distance(v.vertex, _WorldSpaceCameraPos);
            v.vertex.xyz = (int(xlati12) != 0) ? xlat0.xyz : v.vertex.xyz;
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

            o.Albedo = albedo.xyz; // min(max(albedo, gaos.xxx), 1);
            o.Specular = gaos.xxx * _F1 + gaos.yyy * _F2 + gaos.zzz * _F3 + gaos.www * _F4 - i.other.x * _F5/* correct 0.4 */; //  _Smoothness;
            o.Smoothness = gaos.xxx /* noty */ * 0.8 /* it's 0.8! */; //  _Smoothness;
            o.Translucency = albedo * gaos.zzz; // * i.color
            // o.Emission = min(gaos.xxx, 0.8);
            o.Alpha = 1.0;

            o.other.x = distance(i.worldPos, _WorldSpaceCameraPos) * 0.25;
            //o.outOthers.y = COLOR0.x;

        }

        inline half4 LightingStandardSpecularCustom(inout SurfaceOutputStandardSpecularCustom s, half3 viewDir, UnityGI gi)
        {
            #if !DIRECTIONAL
            float3 lightAtten = gi.light.color;
            #else
            float3 lightAtten = lerp(_LightColor0.rgb, gi.light.color, _TransShadow);
            #endif
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

        ENDCG
    }
    FallBack "Transparent/Cutout/Bumped Specular"
}
