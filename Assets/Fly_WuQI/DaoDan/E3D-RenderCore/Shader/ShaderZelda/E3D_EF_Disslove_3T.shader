// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "E3DEffect/C3/DDisslove-3T"
{
	Properties
	{
		_UVFlowSpeed("UVFlowSpeed", Vector) = (0,-0.3,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_BaseColor("BaseColor", Color) = (0.3574827,0.5000507,0.8382353,0)
		_UVTiling("UV-Tiling", Range( 0 , 4)) = 0
		_MaskMap("MaskMap", 2D) = "white" {}
		_DissLoveMap("DissLoveMap", 2D) = "white" {}
		[Toggle]_DissAlpha("Diss-Alpha", Float) = 1
		_DissInstensity("Diss-Instensity", Range( 0.01 , 1)) = 0.468391
		_Thickness("Thickness  ", Range( 0 , 0.2)) = 0.3574858
		[HDR]_EdgeColor("EdgeColor", Color) = (0.4411765,0.8843812,1,0)
		_Opacity("Opacity", Range( 0 , 5)) = 2.843909
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			half2 uv_texcoord;
			half4 uv_tex4coord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _DissLoveMap;
		uniform half _UVTiling;
		uniform half2 _UVFlowSpeed;
		uniform sampler2D _MaskMap;
		uniform half _Opacity;
		uniform half _DissInstensity;
		uniform float4 _DissLoveMap_ST;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform half4 _BaseColor;
		uniform half _Thickness;
		uniform half4 _EdgeColor;
		uniform half _DissAlpha;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 temp_cast_0 = (_UVTiling).xx;
			float mulTime5 = _Time.y * 0.4;
			float2 panner24 = ( mulTime5 * _UVFlowSpeed + float2( 0,0 ));
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_0 + panner24;
			half4 tex2DNode46 = tex2D( _DissLoveMap, uv_TexCoord4 );
			half2 temp_cast_1 = (_UVTiling).xx;
			float mulTime28 = _Time.y * 0.4;
			float2 panner27 = ( mulTime28 * ( _UVFlowSpeed * 3.0 ) + float2( 0,0 ));
			float2 uv_TexCoord25 = i.uv_texcoord * temp_cast_1 + panner27;
			float4 temp_output_7_0 = ( tex2DNode46 * tex2D( _MaskMap, uv_TexCoord25 ) * _Opacity );
			float temp_output_22_0 = ( i.uv_tex4coord.z + _DissInstensity );
			half4 temp_cast_2 = (temp_output_22_0).xxxx;
			float2 uv_DissLoveMap = i.uv_texcoord * _DissLoveMap_ST.xy + _DissLoveMap_ST.zw;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_45_0 = ( tex2D( _DissLoveMap, uv_DissLoveMap ).r * tex2D( _TextureSample0, uv_TextureSample0 ) );
			float4 temp_output_10_0 = step( temp_cast_2 , temp_output_45_0 );
			half4 temp_cast_3 = (temp_output_22_0).xxxx;
			float4 temp_output_14_0 = step( temp_cast_3 , ( temp_output_45_0 + _Thickness ) );
			half4 temp_cast_4 = (temp_output_22_0).xxxx;
			o.Emission = ( ( tex2DNode46 * temp_output_7_0 * ( temp_output_10_0 * _BaseColor ) ) + ( ( temp_output_14_0 - temp_output_10_0 ) * _EdgeColor ) ).rgb;
			half4 temp_cast_6 = (1.0).xxxx;
			half4 temp_cast_7 = (temp_output_22_0).xxxx;
			float4 clampResult36 = clamp( temp_output_7_0 , float4( 0.2205882,0.2205882,0.2205882,0 ) , float4( 1,1,1,0 ) );
			o.Alpha = ( lerp(temp_cast_6,temp_output_14_0,_DissAlpha) * i.vertexColor.a * clampResult36 ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
361;29;1552;1004;1036.408;-648.5607;1;True;False
Node;AmplifyShaderEditor.Vector2Node;1;-1673.945,132.8393;Float;False;Property;_UVFlowSpeed;UVFlowSpeed;0;0;Create;True;0;0;False;0;0,-0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;40;-1661.327,407.9665;Float;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-1265.743,568.1488;Float;False;1;0;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-1382.393,1057.125;Float;True;Property;_DissLoveMap;DissLoveMap;4;0;Create;True;0;0;False;0;723d609500fd514409fabd10ed79ed0e;ef7d9f8f093e28f46b80f3b211446a92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1415.327,321.9665;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;44;-1365.702,1318.045;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;0bcf1deac9851004fb3b8deaf07ce4d9;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1249.454,237.6467;Float;False;1;0;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1003.414,1210.287;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1315.565,1557.645;Float;False;Property;_Thickness;Thickness  ;7;0;Create;True;0;0;False;0;0.3574858;0.2;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1250.035,307.3705;Float;False;Property;_UVTiling;UV-Tiling;2;0;Create;True;0;0;False;0;0;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;27;-1037.978,447.8551;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;24;-1036.408,119.023;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-1088.891,719.6761;Float;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1129.716,936.9177;Float;False;Property;_DissInstensity;Diss-Instensity;6;0;Create;True;0;0;False;0;0.468391;0.255;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-733.0718,1295.409;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-820.139,403.2906;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-755.3536,813.8474;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-812.6773,120.0522;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-154.4691,918.8425;Float;False;Property;_BaseColor;BaseColor;1;1;[HDR];Create;True;0;0;False;0;0.3574827,0.5000507,0.8382353,0;1.655,0.7875518,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;-485.8701,80.21361;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;723d609500fd514409fabd10ed79ed0e;723d609500fd514409fabd10ed79ed0e;True;0;False;white;Auto;False;Instance;9;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;14;-447.7909,1119.049;Float;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;10;-462.3815,846.6862;Float;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-485.4724,601.6407;Float;False;Property;_Opacity;Opacity;9;0;Create;True;0;0;False;0;2.843909;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-523.5349,377.0211;Float;True;Property;_MaskMap;MaskMap;3;0;Create;True;0;0;False;0;None;e5e4f8d6f0dfeca45a8fcc8174dfa252;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;33.68195,441.3041;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;-162.6417,1341.432;Float;False;Property;_EdgeColor;EdgeColor;8;1;[HDR];Create;True;0;0;False;0;0.4411765,0.8843812,1,0;1,0.7655172,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;201.3798,1439.482;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;161.9189,839.0635;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-171.7437,1084.554;Float;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;33;524.2264,999.8;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;29;524.4994,1212.31;Float;True;Property;_DissAlpha;Diss-Alpha;5;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;555.6655,400.0595;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;191.4832,1151.166;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;36;531.7144,743.4788;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.2205882,0.2205882,0.2205882,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;894.7187,1036.953;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;26;-1267.978,443.8551;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;0,-0.9;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;21;895.4907,778.7656;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1211.563,734.7306;Half;False;True;2;Half;ASEMaterialInspector;0;0;Unlit;E3DEffect/C3/DDisslove-3T;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;False;False;False;False;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;0;1;0
WireConnection;38;1;40;0
WireConnection;45;0;9;1
WireConnection;45;1;44;0
WireConnection;27;2;38;0
WireConnection;27;1;28;0
WireConnection;24;2;1;0
WireConnection;24;1;5;0
WireConnection;12;0;45;0
WireConnection;12;1;13;0
WireConnection;25;0;34;0
WireConnection;25;1;27;0
WireConnection;22;0;42;3
WireConnection;22;1;23;0
WireConnection;4;0;34;0
WireConnection;4;1;24;0
WireConnection;46;1;4;0
WireConnection;14;0;22;0
WireConnection;14;1;12;0
WireConnection;10;0;22;0
WireConnection;10;1;45;0
WireConnection;8;1;25;0
WireConnection;7;0;46;0
WireConnection;7;1;8;0
WireConnection;7;2;35;0
WireConnection;20;0;10;0
WireConnection;20;1;19;0
WireConnection;16;0;14;0
WireConnection;16;1;10;0
WireConnection;29;0;30;0
WireConnection;29;1;14;0
WireConnection;6;0;46;0
WireConnection;6;1;7;0
WireConnection;6;2;20;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;36;0;7;0
WireConnection;32;0;29;0
WireConnection;32;1;33;4
WireConnection;32;2;36;0
WireConnection;21;0;6;0
WireConnection;21;1;18;0
WireConnection;0;2;21;0
WireConnection;0;9;32;0
ASEEND*/
//CHKSM=04A31BD5212C18B07CE9F284EE0EF51A70CD1A3A