// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "E3DEffect/C3/Blend-DissSoft2"
{
	Properties
	{
		_BaseMap("BaseMap", 2D) = "white" {}
		_BaseMaskMap("BaseMaskMap", 2D) = "white" {}
		[HDR]_BaseColor("BaseColor", Color) = (1,1,1,1)
		_FaceBaseColor("FaceBaseColor", Range( 0 , 1)) = 1
		_NoiseMap("NoiseMap", 2D) = "white" {}
		[HDR]_EdgeColor("EdgeColor", Color) = (1,1,1,1)
		_FaceEdgeColor("FaceEdgeColor", Range( 0 , 1)) = 1
		_Diss("Diss", Range( 0 , 1)) = 1
		_Soft("Soft", Range( 0.5 , 50)) = 0.5
		_Glow("Glow", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow nolightmap  nodynlightmap nodirlightmap noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			half ASEVFace : VFACE;
		};

		uniform sampler2D _NoiseMap;
		uniform float4 _NoiseMap_ST;
		uniform float _Diss;
		uniform float _Soft;
		uniform float4 _EdgeColor;
		uniform float _FaceEdgeColor;
		uniform sampler2D _BaseMap;
		uniform float4 _BaseMap_ST;
		uniform sampler2D _BaseMaskMap;
		uniform float4 _BaseMaskMap_ST;
		uniform float4 _BaseColor;
		uniform float _FaceBaseColor;
		uniform float _Glow;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_NoiseMap = i.uv_texcoord * _NoiseMap_ST.xy + _NoiseMap_ST.zw;
			float blendOpSrc16 = tex2D( _NoiseMap, uv_NoiseMap ).r;
			float blendOpDest16 = ( _Diss * i.vertexColor.a );
			float temp_output_27_0 = pow( ( saturate( ( blendOpDest16 / blendOpSrc16 ) )) , _Soft );
			float4 switchResult64 = (((i.ASEVFace>0)?(_EdgeColor):(( _EdgeColor * _FaceEdgeColor ))));
			float2 uv_BaseMap = i.uv_texcoord * _BaseMap_ST.xy + _BaseMap_ST.zw;
			float4 tex2DNode39 = tex2D( _BaseMap, uv_BaseMap );
			float2 uv_BaseMaskMap = i.uv_texcoord * _BaseMaskMap_ST.xy + _BaseMaskMap_ST.zw;
			float temp_output_92_0 = ( tex2DNode39.a * tex2D( _BaseMaskMap, uv_BaseMaskMap ).r );
			float4 switchResult58 = (((i.ASEVFace>0)?(_BaseColor):(( _BaseColor * _FaceBaseColor ))));
			o.Emission = ( ( ( 1.0 - temp_output_27_0 ) * switchResult64 * i.vertexColor * temp_output_92_0 * _EdgeColor.a ) + ( tex2DNode39 * switchResult58 * i.vertexColor ) ).rgb;
			o.Alpha = ( temp_output_27_0 * temp_output_92_0 * _BaseColor.a * _Glow );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
2123;140;1552;1004;704.7258;655.7684;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;24;-1502.32,-338.0899;Float;False;Property;_Diss;Diss;7;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;33;-1511.613,-230.7432;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1393.294,-602.0872;Float;True;Property;_NoiseMap;NoiseMap;4;0;Create;True;0;0;False;0;None;c6e263e7995f1a84d95a1d96d66a51a6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1176.379,-347.013;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;16;-938.4313,-601.1973;Float;True;Divide;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;37;-301.3029,-432.0788;Float;False;Property;_EdgeColor;EdgeColor;5;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-940.3364,297.1237;Float;False;Property;_FaceBaseColor;FaceBaseColor;3;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;-918.795,125.3932;Float;False;Property;_BaseColor;BaseColor;2;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.3772059,1.297588,2.565,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-343.6397,-203.4388;Float;False;Property;_FaceEdgeColor;FaceEdgeColor;6;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-922.9233,-344.8718;Float;False;Property;_Soft;Soft;8;0;Create;True;0;0;False;0;0.5;50;0.5;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;91;-937.0819,-72.52291;Float;True;Property;_BaseMaskMap;BaseMaskMap;1;0;Create;True;0;0;False;0;None;87ae15c744e5b9f428615d4de6883711;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;58.05973,-263.4181;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-628.6007,210.6408;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;39;-942.5992,-268.9255;Float;True;Property;_BaseMap;BaseMap;0;0;Create;True;0;0;False;0;None;b25eb1ff4456b2c479239bd9db3ec35e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;27;-562.5601,-457.5352;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;32.31827,-520.1949;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;64;236.7438,-283.3611;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-485.1358,-55.36517;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;58;-392.8479,78.05144;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-53.66675,36.90729;Float;False;Property;_Glow;Glow;9;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;66.34351,-157.473;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;460.5822,-232.536;Float;False;5;5;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;645.1241,-188.7855;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;247.4443,-96.35881;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;50;852.3898,-284.0565;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;E3DEffect/C3/Blend-DissSoft2;False;False;False;False;False;False;True;True;True;False;False;True;False;False;True;False;False;False;False;False;False;Front;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;False;False;False;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;51;0;24;0
WireConnection;51;1;33;4
WireConnection;16;0;1;1
WireConnection;16;1;51;0
WireConnection;63;0;37;0
WireConnection;63;1;62;0
WireConnection;61;0;43;0
WireConnection;61;1;60;0
WireConnection;27;0;16;0
WireConnection;27;1;29;0
WireConnection;30;0;27;0
WireConnection;64;0;37;0
WireConnection;64;1;63;0
WireConnection;92;0;39;4
WireConnection;92;1;91;1
WireConnection;58;0;43;0
WireConnection;58;1;61;0
WireConnection;41;0;39;0
WireConnection;41;1;58;0
WireConnection;41;2;33;0
WireConnection;38;0;30;0
WireConnection;38;1;64;0
WireConnection;38;2;33;0
WireConnection;38;3;92;0
WireConnection;38;4;37;4
WireConnection;44;0;38;0
WireConnection;44;1;41;0
WireConnection;45;0;27;0
WireConnection;45;1;92;0
WireConnection;45;2;43;4
WireConnection;45;3;94;0
WireConnection;50;2;44;0
WireConnection;50;9;45;0
ASEEND*/
//CHKSM=DB52B4517D4340CB0DAFC25A9C52053FAEBA68E8