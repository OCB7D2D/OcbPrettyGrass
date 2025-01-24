float4 xlat0;
int4 xlati0;
bool4 xlatb0;
float4 xlat1;
bool4 xlatb1;
float4 xlat3;
float4 xlat4;
float4 xlat5;
float3 xlat6;
int3 xlati6;
bool3 xlatb6;

xlatb0 = lessThan(float4(0.0, 0.14, 0.29, 0.425), v.texcoord.yyyy);
xlatb1 = lessThan(v.texcoord.yyyy, float4(0.1, 0.23, 0.38, 0.51));
xlati0 = int4((uint4(xlatb0) * 0xffffffffu) & (uint4(xlatb1) * 0xffffffffu));
xlati0 = ~(xlati0);
xlati0.x = int(uint(xlati0.y) & uint(xlati0.x));
xlati0.x = int(uint(xlati0.z) & uint(xlati0.x));
xlati0.x = int(uint(xlati0.w) & uint(xlati0.x));
xlatb6.xyz = lessThan(float4(0.565999985, 0.707, 0.85, 0.85), v.texcoord.yyyy).xyz;
xlatb1 = lessThan(v.texcoord.yyyy, float4(0.61, 0.79, 0.92, 0.26343751));
xlati6.xyz = int3((uint3(xlatb6.xyz) * 0xffffffffu) & (uint3(xlatb1.xyz) * 0xffffffffu));
xlati6.xyz = ~(xlati6.xyz);
xlati0.x = int(uint(xlati6.x) & uint(xlati0.x));
xlati0.x = int(uint(xlati6.y) & uint(xlati0.x));
xlati0.x = int(uint(xlati6.z) & uint(xlati0.x));
xlat6.x = v.vertex.y + v.vertex.x;
xlat6.x = xlat6.x + v.vertex.z;
xlat6.x = xlat6.x * 0.85;

float4 offsets = _Wind.yyww * float4(-12.48, -12.48, -12.48, -12.48) + xlat6.xxxx;
offsets = sin(offsets);
offsets = offsets + float4(0.5, 1.0, 0.5, 1.0);
offsets = offsets * _Wind.xxzz;

float3 posNew = offsets.xyx * float3(0.2, 0.3125, 0.25);
posNew.xy = posNew.yy + posNew.xz;
xlat1.xz = posNew.xy + v.vertex.xz;

xlat3 = offsets.xyxy * float4(0.05, 0.078125, 0.1, 0.125);
posNew.xy = xlat3.yw + xlat3.xz;
xlat3.xz = posNew.xy + v.vertex.xz;

xlat1.y = (-offsets.y) * 0.35 + v.vertex.y;
xlat3.y = (-offsets.y) * 0.15 + v.vertex.y;
posNew.xyz = (xlatb1.w) ? xlat1.xyz : xlat3.xyz;
posNew.xyz = (xlati0.x != 0) ? posNew.xyz : v.vertex.xyz;

#ifdef CALC_OLD_POS

float3 posOld = offsets.zwz * float3(0.2, 0.3125, 0.25);
posOld.xy = posOld.yy + posOld.xz;
xlat1.xz = posOld.xy + v.vertex.xz;

xlat3 = offsets.zwzw * float4(0.05, 0.078125, 0.1, 0.125);
posOld.xy = xlat3.yw + xlat3.xz;
xlat3.xz = posOld.xy + v.vertex.xz;

xlat1.y = (-offsets.w) * 0.35 + v.vertex.y;
xlat3.y = (-offsets.w) * 0.15 + v.vertex.y;
posOld.xyz = (xlatb1.w) ? xlat1.xyz : xlat3.xyz;
posOld.xyz = (xlati0.x != 0) ? posOld.xyz : v.vertex.xyz;

#endif