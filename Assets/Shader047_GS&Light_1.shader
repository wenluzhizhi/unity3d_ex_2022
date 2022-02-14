Shader "Custom/Shader047_GS&Light_1"
{
    Properties {
        _MainTex("Albedo", 2D) = "white" {}
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _ReflectColor("ReflectColor", Color) =(1, 1, 1, 1)
        _ReflectRatio("R", float) = 8.0
    }
    SubShader {
        pass {

           // Tags {"LightMode" = "ForwardBase"}
           
            CGPROGRAM
             #pragma enable_d3d11_debug_symbols
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityStandardBRDF.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _ReflectColor;
            float _ReflectRatio;
            float4 _Tint;

            struct  a2v{
                float4 position:POSITION;
                float3 normal:NORMAL;
                float2 uv:TEXCOORD0;
            };

            struct interpolators {
                float4 position:SV_POSITION;
                float2 uv:TEXCOORD0;
                float3 normal:TEXCOORD1;
                float3 worldPos :TEXCOORD2;
            };

            interpolators vert(a2v v) {
                interpolators i;
                i.position = UnityObjectToClipPos(v.position);
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                i.normal = UnityObjectToWorldNormal(v.normal);
                i.worldPos = mul(unity_ObjectToWorld, v.position);
                return i;
            }

            fixed4 frag(interpolators i):SV_TARGET {
                i.normal = normalize(i.normal);
                float3 lit = _WorldSpaceLightPos0.xyz;
                float diffuseRatio = DotClamped(lit, i.normal)*0.5 + 0.5;
                float3  albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

                float3 diffuse = albedo * _LightColor0.rgb * diffuseRatio;

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);


                float3 refrectionDir = reflect(-lit, i.normal);

                float4 r = _ReflectColor * pow(   DotClamped(refrectionDir, viewDir), _ReflectRatio);
                
                
                return fixed4(diffuse + r.rgb, 1.0);
            }
            ENDCG
        }
    }
}
