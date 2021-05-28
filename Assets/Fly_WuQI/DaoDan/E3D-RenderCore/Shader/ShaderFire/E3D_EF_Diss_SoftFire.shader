// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "E3DEffect/C2/Diss-SoftFire"
{
	Properties
	{
		_MainMap("MainMap", 2D) = "white" {}
		_NoiseMap("NoiseMap", 2D) = "white" {}
		_Progress("Progress", Range( 0 , 1)) = 0.6261891
		[HDR]_InColor("InColor", Color) = (1,0.8924949,0.6102941,0)
		[HDR]_OutColor("OutColor", Color) = (0.8602941,0.4425367,0.06325693,0)
		_SmokeColor("SmokeColor", Color) = (0.2794118,0.2794118,0.2794118,0)
		_TilingNoise("TilingNoise", Range( 0 , 10)) = 1
		_FireEdgeIn("FireEdgeIn", Range( 0 , 3)) = 1.680977
		_FireEdgeOut("FireEdgeOut", Range( 0 , 3)) = 1.248434
		[Toggle]_SoftCross("SoftCross", Float) = 1
		[Toggle]_Smoke("Smoke", Float) = 1
		_TimeScale("TimeScale", Range( 0 , 10)) = 1
		_VertexOffset("VertexOffset", Range( 0 , 0.2)) = 0.2
		_FlowSpeed("Flow-Speed", Vector) = (-0.2,-0.3,-0.32,-0.15)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma only_renderers d3d9 d3d11 glcore gles gles3 d3d11_9x 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _VertexOffset;
		uniform float _Progress;
		uniform sampler2D _NoiseMap;
		uniform float4 _FlowSpeed;
		uniform float _TimeScale;
		uniform float _TilingNoise;
		uniform float4 _SmokeColor;
		uniform sampler2D _MainMap;
		uniform float4 _MainMap_ST;
		uniform float _FireEdgeOut;
		uniform float4 _OutColor;
		uniform float _FireEdgeIn;
		uniform float4 _InColor;
		uniform float _Smoke;
		uniform float _SoftCross;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float temp_output_23_0 = (-1.0 + (( v.color.a * _Progress ) - 0.0) * (0.8 - -1.0) / (1.0 - 0.0));
			float2 appendResult6 = (float2(_FlowSpeed.x , _FlowSpeed.y));
			float mulTime9 = _Time.y * _TimeScale;
			float2 temp_cast_0 = (( _TilingNoise + ( _TilingNoise * 0.2 ) )).xx;
			float2 uv_TexCoord4 = v.texcoord.xy * temp_cast_0;
			float temp_output_24_0 = ( temp_output_23_0 + tex2Dlod( _NoiseMap, float4( ( ( appendResult6 * mulTime9 ) + uv_TexCoord4 ), 0, 0.0) ).r );
			v.vertex.xyz += ( ase_vertexNormal * _VertexOffset * temp_output_24_0 );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_23_0 = (-1.0 + (( i.vertexColor.a * _Progress ) - 0.0) * (0.8 - -1.0) / (1.0 - 0.0));
			float2 appendResult6 = (float2(_FlowSpeed.x , _FlowSpeed.y));
			float mulTime9 = _Time.y * _TimeScale;
			float2 temp_cast_0 = (( _TilingNoise + ( _TilingNoise * 0.2 ) )).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_0;
			float temp_output_24_0 = ( temp_output_23_0 + tex2D( _NoiseMap, ( ( appendResult6 * mulTime9 ) + uv_TexCoord4 ) ).r );
			float clampResult88 = clamp( temp_output_24_0 , 0.0 , 1.2 );
			float2 appendResult13 = (float2(_FlowSpeed.z , _FlowSpeed.w));
			float2 temp_cast_1 = (_TilingNoise).xx;
			float2 uv_TexCoord17 = i.uv_texcoord * temp_cast_1;
			float clampResult89 = clamp( ( temp_output_23_0 + tex2D( _NoiseMap, ( ( appendResult13 * mulTime9 ) + uv_TexCoord17 ) ).r ) , 0.0 , 1.2 );
			float2 uv_MainMap = i.uv_texcoord * _MainMap_ST.xy + _MainMap_ST.zw;
			float4 tex2DNode48 = tex2D( _MainMap, uv_MainMap );
			float temp_output_20_0 = ( clampResult88 * clampResult89 * tex2DNode48.r );
			float temp_output_29_0 = saturate( (-5.0 + (temp_output_20_0 - 0.0) * (5.0 - -5.0) / (_FireEdgeOut - 0.0)) );
			float4 lerpResult86 = lerp( _SmokeColor , ( temp_output_29_0 * _OutColor ) , temp_output_29_0);
			float temp_output_57_0 = ( temp_output_20_0 + ( temp_output_23_0 * tex2DNode48.g ) );
			o.Emission = ( lerpResult86 + ( saturate( (-3.0 + (temp_output_57_0 - 0.0) * (3.0 - -3.0) / (( 1.0 + _FireEdgeIn ) - 0.0)) ) * _InColor ) ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float eyeDepth66 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float clampResult74 = clamp( ( abs( ( eyeDepth66 - ase_screenPos.w ) ) * (0.01 + (4.0 - 0.0) * (0.2 - 0.01) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			float4 temp_cast_3 = (clampResult74).xxxx;
			o.Alpha = ( lerp(temp_output_29_0,saturate( temp_output_57_0 ),_Smoke) * lerp(float4(1,1,1,0),temp_cast_3,_SoftCross) ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
403;142;1552;1004;1536.117;1013.31;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;76;-1895.501,-818.8901;Float;False;2050.687;1310.347;Comment;24;25;21;24;11;1;35;37;36;12;19;4;17;18;13;9;10;7;6;34;39;23;96;97;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1798.825,101.6472;Float;False;Property;_TilingNoise;TilingNoise;6;0;Create;True;0;0;False;0;1;1.49;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1712.723,225.4867;Float;False;Constant;_Float5;Float 5;5;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1491.322,204.8246;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1738.394,-215.7829;Float;False;Property;_TimeScale;TimeScale;11;0;Create;True;0;0;False;0;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;96;-1739.965,-129.0245;Float;False;Property;_FlowSpeed;Flow-Speed;13;0;Create;True;0;0;False;0;-0.2,-0.3,-0.32,-0.15;-0.2,-0.2,-0.2,-0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1378.331,-185.2776;Float;False;1;0;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-1319.817,-353.7425;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-1315.465,154.2116;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1300.98,-57.04375;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1100.998,-353.7183;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1113.518,72.58427;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;97;-878.3934,-802.3667;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1102.163,-251.9605;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.2,1.2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-944.7969,-587.0489;Float;False;Property;_Progress;Progress;2;0;Create;True;0;0;False;0;0.6261891;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1075.111,-58.56079;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-807.4271,-22.13125;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-840.9715,-363.6743;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-576.1167,-647.3103;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-830.7515,-251.5644;Float;True;Property;_NoiseMap;NoiseMap;1;0;Create;True;0;0;False;0;None;aecddca81359b6a42b0ec3e4b8681c15;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;1;-516.3721,-358.3993;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;23;-391.9445,-555.8469;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-514.5762,-125.0686;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;64;276.6877,1085.488;Float;False;1612;528.8;DepthSoftEdge;9;74;71;70;69;68;66;65;80;85;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;65;384.6115,1156.732;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-107.7079,-350.5025;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-118.4425,-115.7483;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;88;146.506,-347.4503;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;66;601.4805,1153.966;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;77;270.933,-510.7461;Float;False;2376.635;965.7271;Comment;16;20;47;46;30;31;45;29;44;40;26;54;42;41;43;86;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;48;-368.458,595.674;Float;True;Property;_MainMap;MainMap;0;0;Create;True;0;0;False;0;None;23bdd970b0908004fbeb4184305902bb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;89;131.906,-144.1503;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;557.9988,-370.7782;Float;False;Property;_FireEdgeOut;FireEdgeOut;8;0;Create;True;0;0;False;0;1.248434;1.13;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;76.4702,622.1454;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;78;265.8849,536.7079;Float;False;1974.049;534.8065;Comment;6;79;59;58;57;82;84;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;80;418.3295,1499.993;Float;False;Constant;_SoftCrossMax;Soft-Cross-Max;7;0;Create;True;0;0;False;0;0.2;0.4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;353.0234,-242.6905;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;420.6896,1383.271;Float;False;Constant;_Float4;Float 4;7;0;Create;True;0;0;False;0;4;0.037;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;68;820.2725,1157.298;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;518.2289,233.4481;Float;False;Property;_FireEdgeIn;FireEdgeIn;7;0;Create;True;0;0;False;0;1.680977;0.64;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;571.8159,121.6021;Float;False;Constant;_Float6;Float 6;7;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;26;879.1889,-309.3701;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.11;False;3;FLOAT;-5;False;4;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;839.025,110.1391;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;69;829.6885,1388.855;Float;False;5;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.01;False;4;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;70;1057.127,1162.814;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;446.4467,628.3128;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;1709.09,-201.0441;Float;False;Property;_OutColor;OutColor;4;1;[HDR];Create;True;0;0;False;0;0.8602941,0.4425367,0.06325693,0;1.2,0.53075,0.1676466,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;40;1049.838,64.72272;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.33;False;3;FLOAT;-3;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;29;1249.094,-305.4989;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;1198.784,1170.941;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;2020.228,-240.8318;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;74;1442.925,1168.146;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;87;1831.832,-454.5101;Float;False;Property;_SmokeColor;SmokeColor;5;0;Create;True;0;0;False;0;0.2794118,0.2794118,0.2794118,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;58;895.5911,629.6521;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;1719.974,53.72118;Float;False;Property;_InColor;InColor;3;1;[HDR];Create;True;0;0;False;0;1,0.8924949,0.6102941,0;1.3,0.8523835,0.3727939,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;44;1386.839,27.42101;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;84;1538.839,881.3623;Float;False;Constant;_Color0;Color 0;11;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;91;2612.867,611.3032;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;59;1616.805,576.1162;Float;True;Property;_Smoke;Smoke;10;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;2668.161,848.7836;Float;False;Property;_VertexOffset;VertexOffset;12;0;Create;True;0;0;False;0;0.2;0.087;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;2015.408,-8.464912;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;86;2254.832,-377.5101;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;82;1869.064,886.0045;Float;True;Property;_SoftCross;SoftCross;9;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;3087.321,623.5419;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;2474.757,-118.1164;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;2227.873,585.9423;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3198.905,-205.4653;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;E3DEffect/C2/Diss-SoftFire;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;False;True;False;False;False;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;34;0
WireConnection;37;1;36;0
WireConnection;9;0;39;0
WireConnection;6;0;96;1
WireConnection;6;1;96;2
WireConnection;35;0;34;0
WireConnection;35;1;37;0
WireConnection;13;0;96;3
WireConnection;13;1;96;4
WireConnection;7;0;6;0
WireConnection;7;1;9;0
WireConnection;17;0;34;0
WireConnection;4;0;35;0
WireConnection;18;0;13;0
WireConnection;18;1;9;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;10;0;7;0
WireConnection;10;1;4;0
WireConnection;98;0;97;4
WireConnection;98;1;21;0
WireConnection;1;0;12;0
WireConnection;1;1;10;0
WireConnection;23;0;98;0
WireConnection;11;0;12;0
WireConnection;11;1;19;0
WireConnection;24;0;23;0
WireConnection;24;1;1;1
WireConnection;25;0;23;0
WireConnection;25;1;11;1
WireConnection;88;0;24;0
WireConnection;66;0;65;0
WireConnection;89;0;25;0
WireConnection;90;0;23;0
WireConnection;90;1;48;2
WireConnection;20;0;88;0
WireConnection;20;1;89;0
WireConnection;20;2;48;1
WireConnection;68;0;66;0
WireConnection;68;1;65;4
WireConnection;26;0;20;0
WireConnection;26;2;54;0
WireConnection;42;0;43;0
WireConnection;42;1;41;0
WireConnection;69;0;85;0
WireConnection;69;4;80;0
WireConnection;70;0;68;0
WireConnection;57;0;20;0
WireConnection;57;1;90;0
WireConnection;40;0;57;0
WireConnection;40;2;42;0
WireConnection;29;0;26;0
WireConnection;71;0;70;0
WireConnection;71;1;69;0
WireConnection;30;0;29;0
WireConnection;30;1;31;0
WireConnection;74;0;71;0
WireConnection;58;0;57;0
WireConnection;44;0;40;0
WireConnection;59;0;29;0
WireConnection;59;1;58;0
WireConnection;46;0;44;0
WireConnection;46;1;45;0
WireConnection;86;0;87;0
WireConnection;86;1;30;0
WireConnection;86;2;29;0
WireConnection;82;0;84;0
WireConnection;82;1;74;0
WireConnection;92;0;91;0
WireConnection;92;1;93;0
WireConnection;92;2;24;0
WireConnection;47;0;86;0
WireConnection;47;1;46;0
WireConnection;79;0;59;0
WireConnection;79;1;82;0
WireConnection;0;2;47;0
WireConnection;0;9;79;0
WireConnection;0;11;92;0
ASEEND*/
//CHKSM=48A5EF56C270CBC7A66F9331C29355CCB98219BB