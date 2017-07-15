

// Matrix PlayGround Shader - UnityCoder.com
// References:
// Matrices http://www.codinglabs.net/article_world_view_projection_matrix.aspx
// Rotation: http://www.gamedev.net/topic/610115-solved-rotation-deforming-mesh-opengl-es-20/#entry4859756

Shader "Custom/MatrixPlayground"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_tX ("TranslateX", float) = 0
		_tY ("TranslateY", float) = 0
		_tZ ("TranslateZ", float) = 0
		_sX ("ScaleX", float) = 1
		_sY ("ScaleY", float) = 1
		_sZ ("ScaleZ", float) = 1
		_rX ("RotateX", float) = 0
		_rY ("RotateY", float) = 0
		_rZ ("RotateZ", float) = 0
		_skewX ("SkewX", float) = 0
		_skewX2 ("SkewX2", float) = 0
		_skewY ("SkewY", float) = 0
		_skewY2 ("SkewY2", float) = 0
		_skewZ ("SkewZ", float) = 0
		_skewZ2 ("SkewZ2", float) = 0
		_Color ("Main Color", Color) = (1,1,1,1)
        _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
        _Shininess ("Shininess", Range (0.03, 1)) = 0.078125
        _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
        _BumpMap ("Normalmap", 2D) = "bump" {}
       	_Treshold ("Cel treshold", Range(1., 20.)) = 5.
		_Ambient ("Ambient intensity", Range(0., 0.5)) = 0.1
		_NormalExtrusion ("Normal Extursion", Range(0., 100)) = 0.
	}
	SubShader
	{
		

		//Cull Off

		Pass
		{
			Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
			//Tags {"LightMode" = "ForwardBase"}    
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
//			//#pragma multi_compile_fwdbase                       // This line tells Unity to compile this pass for forward base.
//            #pragma fragmentoption ARB_fog_exp2
//            #pragma fragmentoption ARB_precision_hint_fastest
//            #pragma target 3.0

			#include "UnityCG.cginc"
			//#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
//				float3  viewDir     : TEXCOORD1;
//                float3  lightDir    : TEXCOORD2;
//				LIGHTING_COORDS(4,5) 
				float3 worldNormal : NORMAL;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float _tX,_tY,_tZ; 
			float _sX,_sY,_sZ;
			float _rX,_rY,_rZ;
			float _skewX,_skewX2,_skewY,_skewY2,_skewZ,_skewZ2;

			sampler2D _BumpMap;
                fixed4 _Color;
                half _Shininess;
            float _NormalExtrusion;
 

			float _Treshold;
			float LightToonShading(float3 normal, float3 lightDir)
			{
				float NdotL = max(0.0, dot(normalize(normal), normalize(lightDir)));
				return floor(NdotL * _Treshold) / (_Treshold - 0.5); 
			}

			v2f vert (appdata_full v)
			{
				v2f o;

				float4x4 translateMatrix = float4x4(1,	0,	0,	_tX,
											 		0,	1,	0,	_tY,
									  				0,	0,	1,	_tZ,
									  				0,	0,	0,	1);
	
				float4x4 scaleMatrix 	= float4x4(_sX,	0,	0,	0,
											 		0,	_sY,0,	0,
								  					0,	0,	_sZ,0,
								  					0,	0,	0,	1);

				float angleX = radians(_rX * v.vertex.x );
				float c = cos(angleX);
				float s = sin(angleX);
				float4x4 rotateXMatrix	= float4x4(	1,	0,	0,	0,
											 		0,	c,	-s,	0,
								  					0,	s,	c,	0,
								  					0,	0,	0,	1);

				float angleY = radians(_rY * v.vertex.y );
				c = cos(angleY) ;
				s = sin(angleY );
				float4x4 rotateYMatrix	= float4x4(	c,	0,	s,	0,
											 		0,	1,	0,	0,
								  					-s,	0,	c,	0,
								  					0,	0,	0,	1);

				float angleZ = radians(_rZ * v.vertex.z );
				c = cos(angleZ);
				s = sin(angleZ);
				float4x4 rotateZMatrix	= float4x4(	c,	-s,	0,	0,
											 		s,	c,	0,	0,
								  					0,	0,	1,	0,
								  					0,	0,	0,	1);



				float t = tanh(radians(_skewX * v.vertex.x));
				float4x4 skewXMatrix = float4x4(
				1,  0,  0,  0,
				t, 1,  0,  0,
				0,  0,  1,  0,
				0,  0,  0,  1);
				t = tanh(radians(_skewX2 * v.vertex.x));
				float4x4 skewX2Matrix = float4x4(
				    1,  0,  0,  0,
				    0,  1,  0,  0,
				    t, 0,  1,  0,
				    0,  0,  0,  1);

				t = tanh(radians(_skewY * v.vertex.y));
				float4x4 skewYMatrix = float4x4( 
				    1,  t, 0,  0,
				    0,  1,  0,  0,
				    0,  0,  1,  0,
				    0,  0,  0,  1
				);
				t = tanh(radians(_skewY2 * v.vertex.y));
				float4x4 skewY2Matrix = float4x4(
				    1,  0,  0,  0,
				    0,  1,  0,  0,
				    0,  t, 1,  0,
				    0,  0,  0,  1
				);
				t = tanh(radians(_skewZ * v.vertex.z));
				float4x4 skewZMatrix = float4x4(
				    1,  0, t, 0,
				    0,  1,  0,  0,
				    0,  0,  1,  0,
				    0,  0,  0,  1
				);
				t = tanh(radians(_skewZ2 * v.vertex.z));
				float4x4 skewZ2Matrix = float4x4(
				    1,  0,  0,  0,
				    0,  1,  t, 0,
				    0,  0,  1,  0,
				    0,  0,  0,  1
				);

  				float4 localVertexPos = v.vertex;

  				// NOTE: the order matters, try scaling first before translating, different results
  				float4 localTranslated = mul(translateMatrix,localVertexPos);
  				float4 localScaledTranslated = mul(localTranslated,scaleMatrix);
  				float4 localScaledTranslatedRotX = mul(localScaledTranslated,rotateXMatrix);
  				float4 localScaledTranslatedRotXY = mul(localScaledTranslatedRotX,rotateYMatrix);
  				float4 localScaledTranslatedRotXYZ = mul(localScaledTranslatedRotXY,rotateZMatrix);
  				float4 localScaledTranslatedRotSkewX = mul(localScaledTranslatedRotXY,skewXMatrix);
  				float4 localScaledTranslatedRotSkewX2 = mul(localScaledTranslatedRotSkewX,skewX2Matrix);
  				float4 localScaledTranslatedRotSkewY = mul(localScaledTranslatedRotSkewX2,skewYMatrix);
  				float4 localScaledTranslatedRotSkewY2 = mul(localScaledTranslatedRotSkewY,skewY2Matrix);
  				float4 localScaledTranslatedRotSkewZ = mul(localScaledTranslatedRotSkewY2,skewZMatrix);
  				float4 localScaledTranslatedRotSkewZ2 = mul(localScaledTranslatedRotSkewZ,skewZ2Matrix);

				//o.vertex = mul(UNITY_MATRIX_MVP, localScaledTranslatedRotXYZ);
				o.vertex = mul(UNITY_MATRIX_MVP, localScaledTranslatedRotSkewZ2);
				o.vertex.xyz += v.normal * _NormalExtrusion;
				//pass on tiling and offset parameters
				//http://answers.unity3d.com/questions/33404/accessing-uv-offset-in-cg-shader.html
				o.uv = TRANSFORM_TEX(v.vertex.xy, _MainTex);
				o.worldNormal = mul(v.normal.xyz, (float3x3) unity_WorldToObject);
//				//TANGENT_SPACE_ROTATION;                         // Macro for unity to build the Object>Tangent rotation matrix "rotation".
//                o.viewDir = mul(UNITY_MATRIX_MVP, ObjSpaceViewDir(v.vertex));
//                o.lightDir = mul(UNITY_MATRIX_MVP, ObjSpaceLightDir(v.vertex));
//
//				TRANSFER_VERTEX_TO_FRAGMENT(o);

				return o;
			}

			fixed4 _LightColor0;
			half _Ambient;

			fixed4 frag (v2f i) : SV_Target
			{
				
				fixed4 col = tex2D(_MainTex, i.uv) * _Color;
				//fixed atten = LIGHT_ATTENUATION(i);
				col.rgb *= saturate(LightToonShading(i.worldNormal, _WorldSpaceLightPos0.xyz) + _Ambient) * _LightColor0.rgb;

				return col;




//				i.viewDir = normalize(i.viewDir);
//                    i.lightDir = normalize(i.lightDir);
//                   
//                    fixed atten = LIGHT_ATTENUATION(i); // Macro to get you the combined shadow  attenuation value.
// 
//                    fixed4 tex = tex2D(_MainTex, i.uv);
//                    fixed gloss = tex.a;
//                    tex *= _Color;
//                    fixed3 normal = UnpackNormal(tex2D(_BumpMap, i.uv));
// 
//                    half3 h = normalize(i.lightDir + i.viewDir);
//                   
//                    fixed diff = saturate(dot(normal, i.lightDir));
//                   
//                    float nh = saturate(dot (normal, h));
//                    float spec = pow(nh, _Shininess * 128.0) * gloss;
//                    fixed4 c;
//                    c.rgb = UNITY_LIGHTMODEL_AMBIENT.rgb * 2 * tex.rgb;         // Ambient term. Only do this in Forward Base. It only needs calculating once.
//                    c.rgb += (tex.rgb * _LightColor0.rgb * diff + _LightColor0.rgb * _SpecColor.rgb * spec) * (atten * 2); // Diffuse and specular.
//                    c.a = tex.a + _LightColor0.a * _SpecColor.a * spec * atten;
//                    return c;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}