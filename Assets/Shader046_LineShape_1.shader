Shader "Custom/Shader046_LineShape_1"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white" {}
        _discardValue("DiscardValue", Range(0.0, 1.0)) = 0.5
    }

    SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        Blend One OneMinusSrcAlpha
        pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            float _discardValue;

            struct a2v {
                float4 position:POSITION;
                float2 uv:TEXCOORD0;
            };


            struct v2f {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.position);
                o.uv = v.uv;
                o.uv.x += _SinTime.w;
                return o;
            }
            [maxvertexcount(3)]
            void geom (triangle v2f p[3], inout LineStream<v2f> lStream) {
                for(uint i = 0; i < 3; i++){
                    lStream.Append(p[i]);
                }
            }

            fixed4 frag(v2f i):SV_Target {
                if(i.uv.y < _discardValue){
                    discard;
                }
                return tex2D(_MainTex, i.uv);
            }


            ENDCG
        }
        pass {
            cull off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#pragma geometry geom
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            float _discardValue;

            struct a2v {
                float4 position:POSITION;
                float2 uv:TEXCOORD0;
            };


            struct v2f {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.position);
                o.uv = v.uv;
                o.uv.x += _SinTime.w;
                return o;
            }
            fixed4 frag(v2f i):SV_Target {
                if(i.uv.y > _discardValue){
                    discard;
                }
                fixed4 col = tex2D(_MainTex, i.uv);
               // col.a = 0.5;
                return col;
            }


            ENDCG
        }
    }
}
