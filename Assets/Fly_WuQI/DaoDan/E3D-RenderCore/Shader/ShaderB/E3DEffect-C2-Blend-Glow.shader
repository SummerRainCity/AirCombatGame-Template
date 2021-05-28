// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// 此Shader用于渲染特效半透明材质
// 参数：1，带有Alpha通道的贴图一张 2，主颜色与贴图颜色为乘的关系

Shader "E3DEffect/C2/Blended-Glow" {
Properties {
	_Alpha ("Alpha", Range(0,1.0)) = 1.0
	_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_MainTex ("Texture(RGBA)", 2D) = "white" {}
	_GlowTex("Glow", 2D) = "" {}
	_GlowColor("Glow Color", Color) = (1,1,1,1)
	_GlowStrength("Glow Strength", Float) = 1.0
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType" = "ZQLTGlowTransparent" "RenderEffect" = "ZQLTGlowTransparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	AlphaTest Greater .01
	Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }

	SubShader {
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_particles
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed4 _TintColor;
			
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};
			
			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}
			
			fixed _Alpha;

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 co = 2.0f * i.color * _TintColor * tex2D(_MainTex, i.texcoord);
				co.a = co.a * _Alpha; 
				return co;
			}
			ENDCG 
		}
	}	
}
CustomEditor "GlowMatInspector"
}
