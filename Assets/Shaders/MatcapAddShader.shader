Shader "Matcap/MatcapShaderAdd"
{
    Properties
    {
        _BaseColor ("BaseColor", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _LightStrength ("LightStrength", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _BaseColor;
            float _LightStrength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float4x4 matrixConversion = UNITY_MATRIX_MV;
                float4 normalDirection = mul(matrixConversion,float4(v.normal, 0.0));
                o.normal = normalize(normalDirection);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uvByNormal = i.normal.xy;
                uvByNormal = uvByNormal * 0.5 + 0.5;
                // sample the texture
                fixed4 col = tex2D(_MainTex, uvByNormal);
                // col = (((col * 2.0) - 1.0) + 1.0) * _BaseColor;
                // col = (((col * 2.0) - 1.0));
                col = (col * _LightStrength) * _BaseColor;
                col.a = 1.0;
                return col;
                // return fixed4( i.normal * 0.5 + 0.5, 1);
            }
            ENDCG
        }
    }
}
