﻿Shader "Unlit/scrollShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opague" }
		LOD 100
		Ztest Off Cull Off ZWrite Off
		Fog { Mode off }
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			//#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;

			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv + _Time.y*fixed2(0.001,0.001), _MainTex);
				;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);//* _Offset.xy );
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				//col = fixed4(1.0, 0.,0., 1.);
				col.r = col.a;
				return col;
			}
			ENDCG
		}
	}
}
