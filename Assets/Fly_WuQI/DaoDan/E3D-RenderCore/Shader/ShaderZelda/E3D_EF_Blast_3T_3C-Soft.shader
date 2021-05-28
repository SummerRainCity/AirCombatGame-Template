// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "E3DEffect/C3/Blast-3T-3C-Soft"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_SmokeColor("SmokeColor", Color) = (0.3183391,0.3949051,0.6764706,0)
		[HDR]_AbroadColor("AbroadColor", Color) = (2,0.6916838,0.1029413,1)
		[HDR]_WithinColor("WithinColor", Color) = (1.5,1.060289,0.6507353,1)
		_FireMap("FireMap", 2D) = "white" {}
		_UVFlowSpeed("UVFlowSpeed", Vector) = (0,-0.3,0,0)
		_UVTiling("UV-Tiling", Range( 0 , 4)) = 0
		_SmokeTexture("SmokeTexture", 2D) = "white" {}
		_DissloveMap("DissloveMap", 2D) = "white" {}
		_FireEdge("FireEdge", Range( 1 , 1.5)) = 0.468391
		_FireOffsetInstensity("Fire-Offset-Instensity", Range( 0 , 6)) = 0.468391
		[Toggle]_FireOffset("Fire-Offset", Float) = 0
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
		#pragma surface surf Unlit keepalpha noshadow nolightmap  nodynlightmap nodirlightmap nofog vertex:vertexDataFunc tessellate:tessFunction 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_tex4coord;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _FireOffsetInstensity;
		uniform float _FireOffset;
		uniform sampler2D _SmokeTexture;
		uniform float _UVTiling;
		uniform float2 _UVFlowSpeed;
		uniform sampler2D _FireMap;
		uniform float4 _WithinColor;
		uniform float4 _AbroadColor;
		uniform float _FireEdge;
		uniform float4 _SmokeColor;
		uniform sampler2D _DissloveMap;
		uniform float4 _DissloveMap_ST;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float2 temp_cast_1 = (_UVTiling).xx;
			float mulTime28 = _Time.y * 0.4;
			float2 panner27 = ( mulTime28 * ( _UVFlowSpeed * 3.0 ) + float2( 0,0 ));
			float2 uv_TexCoord25 = v.texcoord.xy * temp_cast_1 + panner27;
			float4 tex2DNode8 = tex2Dlod( _SmokeTexture, float4( uv_TexCoord25, 0, 0.0) );
			float4 temp_cast_2 = (v.texcoord.z).xxxx;
			float4 tex2DNode44 = tex2Dlod( _FireMap, float4( uv_TexCoord25, 0, 0.0) );
			float4 temp_output_52_0 = step( temp_cast_2 , tex2DNode44 );
			v.vertex.xyz += ( float4( ase_vertexNormal , 0.0 ) * _FireOffsetInstensity * lerp(( tex2DNode8 * 1.0 ),temp_output_52_0,_FireOffset) ).rgb;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 temp_cast_0 = (i.uv_tex4coord.z).xxxx;
			float2 temp_cast_1 = (_UVTiling).xx;
			float mulTime28 = _Time.y * 0.4;
			float2 panner27 = ( mulTime28 * ( _UVFlowSpeed * 3.0 ) + float2( 0,0 ));
			float2 uv_TexCoord25 = i.uv_texcoord * temp_cast_1 + panner27;
			float4 tex2DNode44 = tex2D( _FireMap, uv_TexCoord25 );
			float4 lerpResult49 = lerp( _WithinColor , _AbroadColor , step( temp_cast_0 , ( tex2DNode44 * _FireEdge ) ));
			float4 tex2DNode8 = tex2D( _SmokeTexture, uv_TexCoord25 );
			float4 temp_cast_2 = (i.uv_tex4coord.z).xxxx;
			float4 temp_output_52_0 = step( temp_cast_2 , tex2DNode44 );
			float4 lerpResult48 = lerp( lerpResult49 , ( tex2DNode8 * _SmokeColor ) , temp_output_52_0);
			o.Emission = ( lerpResult48 * i.vertexColor ).rgb;
			float2 uv_DissloveMap = i.uv_texcoord * _DissloveMap_ST.xy + _DissloveMap_ST.zw;
			float4 temp_cast_4 = (( 1.0 - abs( i.uv_tex4coord.w ) )).xxxx;
			float4 temp_cast_5 = (5.0).xxxx;
			o.Alpha = ( i.vertexColor.a * saturate( pow( (float4( 0,0,0,0 ) + (saturate( ( ( 1.0 - tex2D( _DissloveMap, uv_DissloveMap ) ) + i.uv_tex4coord.w ) ) - float4( 0,0,0,0 )) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_4 - float4( 0,0,0,0 ))) , temp_cast_5 ) ) ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
464;770;1066;599;948.8771;-255.7486;4.743006;True;False
Node;AmplifyShaderEditor.Vector2Node;1;-2918.345,614.2433;Float;False;Property;_UVFlowSpeed;UVFlowSpeed;10;0;Create;True;0;0;False;0;0,-0.3;0,-0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;40;-2903.727,792.3706;Float;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2657.727,706.3706;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-2508.144,952.553;Float;False;1;0;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-1067.193,1310.37;Float;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-2373.397,729.5186;Float;False;Property;_UVTiling;UV-Tiling;11;0;Create;True;0;0;False;0;0;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;27;-2280.379,832.2592;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;-72.69605,706.5175;Float;True;Property;_DissloveMap;DissloveMap;13;0;Create;True;0;0;False;0;723d609500fd514409fabd10ed79ed0e;2d278e9219f95fd469f4ff3136fd7ff8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;99;294.5251,701.6487;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;107;301.421,1107.409;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-2048.54,758.6947;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;98;505.932,704.3141;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;104;520.9719,1097.658;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-1681.376,1229.6;Float;True;Property;_FireMap;FireMap;9;0;Create;True;0;0;False;0;None;2d278e9219f95fd469f4ff3136fd7ff8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1509.279,773.3278;Float;False;Property;_FireEdge;FireEdge;14;0;Create;True;0;0;False;0;0.468391;1.263;1;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;111;771.1801,706.0066;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;105;701.2908,1100.243;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-942.1599,746.4808;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;110;579.6117,1349.756;Float;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;False;0;5;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1654.05,7.696415;Float;True;Property;_SmokeTexture;SmokeTexture;12;0;Create;True;0;0;False;0;None;2d278e9219f95fd469f4ff3136fd7ff8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-604.5555,1884.155;Float;False;Constant;_FireOffsetInstensity2;Fire-Offset-Instensity2;13;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;100;940.8087,932.217;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;10;-590.1305,726.2983;Float;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;47;-684.4188,85.67099;Float;False;Property;_SmokeColor;SmokeColor;6;0;Create;True;0;0;False;0;0.3183391,0.3949051,0.6764706,0;0.1617646,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;50;-684.5942,240.6183;Float;False;Property;_WithinColor;WithinColor;8;1;[HDR];Create;True;0;0;False;0;1.5,1.060289,0.6507353,1;1.617,1.20209,0.309132,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;51;-681.1942,421.127;Float;False;Property;_AbroadColor;AbroadColor;7;1;[HDR];Create;True;0;0;False;0;2,0.6916838,0.1029413,1;3.087,0.8500011,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;109;1277.91,975.0692;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;52;-546.2343,1049.011;Float;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-156.3507,1866.366;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-344.1516,-7.96847;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;49;-211.4665,350.0295;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;113;1528.574,793.3208;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;56;418.6745,1580.566;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;59;420.4412,1859.499;Float;False;Property;_FireOffset;Fire-Offset;16;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;112;1548.773,979.3488;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;54;431.618,1754.577;Float;False;Property;_FireOffsetInstensity;Fire-Offset-Instensity;15;0;Create;True;0;0;False;0;0.468391;1;0;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;48;377.8008,321.8337;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;1875.759,747.2689;Float;False;2;2;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;1871.543,985.1967;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;26;-2510.379,828.2592;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;0,-0.9;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;850.4958,1729.318;Float;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-104.3738,985.158;Float;False;Property;_Smook;Smook;17;0;Create;True;0;0;False;0;-0.2;0.246;-0.2;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2379.311,795.2427;Float;False;True;6;Float;ASEMaterialInspector;0;0;Unlit;E3DEffect/C3/Blast-3T-3C-Soft;False;False;False;False;False;False;True;True;True;True;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;False;False;False;False;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;0;1;0
WireConnection;38;1;40;0
WireConnection;27;2;38;0
WireConnection;27;1;28;0
WireConnection;99;0;9;0
WireConnection;107;0;42;4
WireConnection;25;0;34;0
WireConnection;25;1;27;0
WireConnection;98;0;99;0
WireConnection;98;1;107;0
WireConnection;104;0;107;0
WireConnection;44;1;25;0
WireConnection;111;0;98;0
WireConnection;105;0;104;0
WireConnection;53;0;44;0
WireConnection;53;1;23;0
WireConnection;8;1;25;0
WireConnection;100;0;111;0
WireConnection;100;2;105;0
WireConnection;10;0;42;3
WireConnection;10;1;53;0
WireConnection;109;0;100;0
WireConnection;109;1;110;0
WireConnection;52;0;42;3
WireConnection;52;1;44;0
WireConnection;91;0;8;0
WireConnection;91;1;60;0
WireConnection;7;0;8;0
WireConnection;7;1;47;0
WireConnection;49;0;50;0
WireConnection;49;1;51;0
WireConnection;49;2;10;0
WireConnection;59;0;91;0
WireConnection;59;1;52;0
WireConnection;112;0;109;0
WireConnection;48;0;49;0
WireConnection;48;1;7;0
WireConnection;48;2;52;0
WireConnection;116;0;48;0
WireConnection;116;1;113;0
WireConnection;114;0;113;4
WireConnection;114;1;112;0
WireConnection;32;0;56;0
WireConnection;32;1;54;0
WireConnection;32;2;59;0
WireConnection;0;2;116;0
WireConnection;0;9;114;0
WireConnection;0;11;32;0
ASEEND*/
//CHKSM=813591899337714B0FFE4A935323A89F647183B1