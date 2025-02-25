Shader "InfiniteGrass/Modifiers/TestGrassMaskShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Opacity("Opacity", Range(0, 1)) = 1
        _RedInt("Red intens", Range(0, 10)) = 1
        _GreenInt("Green intens", Range(0, 10)) = 1
        _BlueInt("Blue intens", Range(0, 10)) = 1
        _BaseColor("BaseColor", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "LightMode" = "GrassMask"
        }

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off

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
                half4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                half4 color     : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Opacity;
            float _RedInt;
            float _GreenInt;
            float _BlueInt;
            
            float4 _BaseColor;
            half4 temp;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
//                return ((tex2D(_MainTex, i.uv).r - tex2D(_MainTex, i.uv).g - tex2D(_MainTex, i.uv).b) * tex2D(_MainTex, i.uv).a //* i.color.a 
//                    * _Opacity);

                temp = tex2D(_MainTex, i.uv);
                
                return (1 - _Opacity *
                    (-temp.g * _GreenInt +
                    temp.r * _RedInt -
                    temp.b * _BlueInt));

                return (//tex2D(_MainTex, i.uv).r * 
                    (//1 - 
                    ((1 - tex2D(_MainTex, i.uv).r) * _RedInt +
                    (1 - tex2D(_MainTex, i.uv).g) * _GreenInt +
                    (1 - tex2D(_MainTex, i.uv).b) * _BlueInt)) * 
                    //i.color.a * 
                    _Opacity);
            }
            ENDCG
        }
    }
}
