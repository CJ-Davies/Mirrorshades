//************************************************************************************
//
// Filename    :   OVRLensCorrection_Mesh_CA_TW.shader
// Content     :   Full screen shader
//				   This shader warps the final camera image to match the lens curvature on the Rift.
//				   Includes time warp.
// Created     :   March 14, 2014
// Authors     :   Peter Giokaris
//
// Copyright   :   Copyright 2014 Oculus VR, Inc. All Rights reserved.
//
// Use of this software is subject to the terms of the Oculus LLC license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.
//
//************************************************************************************/

Shader "Custom/OVRLensCorrection_Mesh_CA_TW"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "" {}
		_TimeWarpConstants ("Time Warp Constants", 2D) = "" {}
	}
	
	// Shader code pasted into all further CGPROGRAM blocks
	#LINE 116
 
	
	Subshader 
	{
 	Pass 
 	{
	 	ZTest Always Cull Off ZWrite Off
	  	Fog { Mode off }      

      	Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 45 to 45
//   d3d9 - ALU: 45 to 45
//   d3d11 - ALU: 35 to 35, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 35 to 35, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "normal" Normal
Vector 9 [_DMScale]
Vector 10 [_DMOffset]
Matrix 1 [_TimeWarpStart]
Matrix 5 [_TimeWarpEnd]
"!!ARBvp1.0
# 45 ALU
PARAM c[11] = { { 1 },
		program.local[1..10] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
ADD R4.y, -vertex.normal.z, c[0].x;
MUL R0, vertex.normal.z, c[6];
MAD R3, R4.y, c[2], R0;
MUL R1, vertex.normal.z, c[7];
MAD R2, R4.y, c[3], R1;
MUL R1, vertex.normal.z, c[5];
MOV R0.xy, vertex.texcoord[0];
MOV R0.zw, c[0].x;
DP4 R4.z, R0, R2;
MAD R1, R4.y, c[1], R1;
DP4 R4.x, R0, R3;
DP4 R0.x, R1, R0;
RCP R4.y, R4.z;
MUL R0.x, R0, R4.y;
MUL R0.y, R4, R4.x;
MUL R0.x, R0, c[9];
MUL R0.y, R0, c[9];
MOV R0.zw, c[0].x;
ADD result.texcoord[0].x, R0, c[10];
ADD result.texcoord[0].y, R0, c[10];
MOV R0.xy, vertex.texcoord[1];
DP4 R4.y, R2, R0;
DP4 R4.x, R3, R0;
DP4 R0.x, R1, R0;
RCP R4.y, R4.y;
MUL R0.x, R0, R4.y;
MUL R0.x, R0, c[9];
MUL R0.y, R4, R4.x;
MUL R0.y, R0, c[9];
MOV R0.zw, c[0].x;
ADD result.texcoord[1].x, R0, c[10];
ADD result.texcoord[1].y, R0, c[10];
MOV R0.xy, vertex.normal;
DP4 R2.x, R2, R0;
DP4 R2.y, R3, R0;
DP4 R0.x, R1, R0;
RCP R2.x, R2.x;
MUL R0.x, R0, R2;
MUL R0.y, R2.x, R2;
MUL R0.x, R0, c[9];
MUL R0.y, R0, c[9];
ADD result.texcoord[2].x, R0, c[10];
ADD result.texcoord[2].y, R0, c[10];
MOV result.position, vertex.position;
MOV result.color, vertex.position.z;
END
# 45 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "normal" Normal
Vector 8 [_DMScale]
Vector 9 [_DMOffset]
Matrix 0 [_TimeWarpStart]
Matrix 4 [_TimeWarpEnd]
"vs_2_0
; 45 ALU
def c10, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dcl_normal0 v3
add r4.y, -v3.z, c10.x
mul r0, v3.z, c5
mad r3, r4.y, c1, r0
mul r1, v3.z, c6
mad r2, r4.y, c2, r1
mul r1, v3.z, c4
mov r0.xy, v1
mov r0.zw, c10.x
dp4 r4.z, r0, r2
mad r1, r4.y, c0, r1
dp4 r4.x, r0, r3
dp4 r0.x, r1, r0
rcp r4.y, r4.z
mul r0.x, r0, r4.y
mul r0.y, r4, r4.x
mul r0.x, r0, c8
mul r0.y, r0, c8
mov r0.zw, c10.x
add oT0.x, r0, c9
add oT0.y, r0, c9
mov r0.xy, v2
dp4 r4.y, r2, r0
dp4 r4.x, r3, r0
dp4 r0.x, r1, r0
rcp r4.y, r4.y
mul r0.x, r0, r4.y
mul r0.x, r0, c8
mul r0.y, r4, r4.x
mul r0.y, r0, c8
mov r0.zw, c10.x
add oT1.x, r0, c9
add oT1.y, r0, c9
mov r0.xy, v3
dp4 r2.x, r2, r0
dp4 r2.y, r3, r0
dp4 r0.x, r1, r0
rcp r2.x, r2.x
mul r0.x, r0, r2
mul r0.y, r2.x, r2
mul r0.x, r0, c8
mul r0.y, r0, c8
add oT2.x, r0, c9
add oT2.y, r0, c9
mov oPos, v0
mov oD0, v0.z
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "normal" Normal
ConstBuffer "$Globals" 160 // 160 used size, 5 vars
Vector 16 [_DMScale] 2
Vector 24 [_DMOffset] 2
Matrix 32 [_TimeWarpStart] 4
Matrix 96 [_TimeWarpEnd] 4
BindCB "$Globals" 0
// 58 instructions, 8 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgbiobcanoglpoajoafloacaaeipmondaabaaaaaabmaiaaaaadaaaaaa
cmaaaaaaliaaaaaafmabaaaaejfdeheoieaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaahbaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaahkaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafaepfdej
feejepeoaafeeffiedepepfceeaaeoepfcenebemaaklklklepfdeheojmaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadamaaaajfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaedepemepfcaaklfdeieefc
liagaaaaeaaaabaakoabaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaa
fpaaaaadhcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagiaaaaacaiaaaaaadgaaaaafpccabaaaaaaaaaaa
egbobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaackbabaaaadaaaaaackiacaaa
aaaaaaaaagaaaaaadiaaaaaiccaabaaaaaaaaaaackbabaaaadaaaaaackiacaaa
aaaaaaaaahaaaaaadiaaaaaiecaabaaaaaaaaaaackbabaaaadaaaaaackiacaaa
aaaaaaaaaiaaaaaadiaaaaaiicaabaaaaaaaaaaackbabaaaadaaaaaackiacaaa
aaaaaaaaajaaaaaaaaaaaaaibcaabaaaabaaaaaackbabaiaebaaaaaaadaaaaaa
abeaaaaaaaaaiadpdiaaaaaibcaabaaaacaaaaaaakaabaaaabaaaaaackiacaaa
aaaaaaaaacaaaaaadiaaaaaiccaabaaaacaaaaaaakaabaaaabaaaaaackiacaaa
aaaaaaaaadaaaaaadiaaaaaiecaabaaaacaaaaaaakaabaaaabaaaaaackiacaaa
aaaaaaaaaeaaaaaadiaaaaaiicaabaaaacaaaaaaakaabaaaabaaaaaackiacaaa
aaaaaaaaafaaaaaaaaaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
acaaaaaadgaaaaafdcaabaaaacaaaaaaegbabaaaabaaaaaadgaaaaaimcaabaaa
acaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaiadpbbaaaaahccaabaaa
abaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaadiaaaaaidcaabaaaadaaaaaa
kgbkbaaaadaaaaaabgifcaaaaaaaaaaaagaaaaaadgaaaaafbcaabaaaaeaaaaaa
bkaabaaaadaaaaaadiaaaaaimcaabaaaabaaaaaakgbkbaaaadaaaaaaagiecaaa
aaaaaaaaahaaaaaadgaaaaafccaabaaaaeaaaaaackaabaaaabaaaaaadgaaaaaf
ccaabaaaadaaaaaadkaabaaaabaaaaaadiaaaaaimcaabaaaabaaaaaakgbkbaaa
adaaaaaaagiecaaaaaaaaaaaaiaaaaaadgaaaaafecaabaaaaeaaaaaackaabaaa
abaaaaaadgaaaaafecaabaaaadaaaaaadkaabaaaabaaaaaadiaaaaaimcaabaaa
abaaaaaakgbkbaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaadgaaaaaficaabaaa
aeaaaaaackaabaaaabaaaaaadgaaaaaficaabaaaadaaaaaadkaabaaaabaaaaaa
diaaaaaidcaabaaaafaaaaaaagaabaaaabaaaaaabgifcaaaaaaaaaaaacaaaaaa
dgaaaaafbcaabaaaagaaaaaabkaabaaaafaaaaaadiaaaaaimcaabaaaabaaaaaa
agaabaaaabaaaaaaagiecaaaaaaaaaaaadaaaaaadgaaaaafccaabaaaagaaaaaa
ckaabaaaabaaaaaadgaaaaafccaabaaaafaaaaaadkaabaaaabaaaaaadiaaaaai
mcaabaaaabaaaaaaagaabaaaabaaaaaaagiecaaaaaaaaaaaaeaaaaaadiaaaaai
dcaabaaaahaaaaaaagaabaaaabaaaaaaegiacaaaaaaaaaaaafaaaaaadgaaaaaf
ecaabaaaagaaaaaackaabaaaabaaaaaadgaaaaafecaabaaaafaaaaaadkaabaaa
abaaaaaadgaaaaaficaabaaaagaaaaaaakaabaaaahaaaaaadgaaaaaficaabaaa
afaaaaaabkaabaaaahaaaaaaaaaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaa
egaobaaaafaaaaaaaaaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaa
agaaaaaabbaaaaahbcaabaaaafaaaaaaegaobaaaaeaaaaaaegapbaaaacaaaaaa
bbaaaaahccaabaaaafaaaaaaegaobaaaadaaaaaaegapbaaaacaaaaaaaoaaaaah
dcaabaaaabaaaaaaegaabaaaafaaaaaafgafbaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegaabaaaabaaaaaaegiacaaaaaaaaaaaabaaaaaaogikcaaaaaaaaaaa
abaaaaaadgaaaaafdcaabaaaabaaaaaaegbabaaaacaaaaaadgaaaaaimcaabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaiadpbbaaaaahecaabaaa
acaaaaaaegaobaaaaeaaaaaaegapbaaaabaaaaaabbaaaaahicaabaaaacaaaaaa
egaobaaaadaaaaaaegapbaaaabaaaaaabbaaaaahbcaabaaaabaaaaaaegaobaaa
aaaaaaaaegaobaaaabaaaaaaaoaaaaahdcaabaaaabaaaaaaogakbaaaacaaaaaa
agaabaaaabaaaaaadcaaaaalmccabaaaabaaaaaaagaebaaaabaaaaaaagiecaaa
aaaaaaaaabaaaaaakgiocaaaaaaaaaaaabaaaaaadgaaaaafdcaabaaaabaaaaaa
egbabaaaadaaaaaadgaaaaaimcaabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaiadpbbaaaaahbcaabaaaacaaaaaaegaobaaaaeaaaaaaegaobaaa
abaaaaaabbaaaaahccaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaa
bbaaaaahbcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaaoaaaaah
dcaabaaaaaaaaaaaegaabaaaacaaaaaaagaabaaaaaaaaaaadcaaaaaldccabaaa
acaaaaaaegaabaaaaaaaaaaaegiacaaaaaaaaaaaabaaaaaaogikcaaaaaaaaaaa
abaaaaaadgaaaaafpccabaaaadaaaaaakgbkbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _TimeWarpEnd;
uniform highp mat4 _TimeWarpStart;
uniform highp vec2 _DMOffset;
uniform highp vec2 _DMScale;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp mat4 tmpvar_2;
  tmpvar_2 = (((_TimeWarpStart * (1.0 - tmpvar_1.z)) + (_TimeWarpEnd * tmpvar_1.z)));
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(1.0, 1.0);
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * tmpvar_3).xyz;
  highp vec3 tmpvar_5;
  tmpvar_5.z = 1.0;
  tmpvar_5.xy = (((tmpvar_4.xy / tmpvar_4.z) * _DMScale) + _DMOffset);
  highp vec4 tmpvar_6;
  tmpvar_6.zw = vec2(1.0, 1.0);
  tmpvar_6.xy = _glesMultiTexCoord1.xy;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_2 * tmpvar_6).xyz;
  highp vec3 tmpvar_8;
  tmpvar_8.z = 1.0;
  tmpvar_8.xy = (((tmpvar_7.xy / tmpvar_7.z) * _DMScale) + _DMOffset);
  highp vec4 tmpvar_9;
  tmpvar_9.zw = vec2(1.0, 1.0);
  tmpvar_9.xy = tmpvar_1.xy;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_2 * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11.z = 1.0;
  tmpvar_11.xy = (((tmpvar_10.xy / tmpvar_10.z) * _DMScale) + _DMOffset);
  gl_Position = _glesVertex;
  xlv_TEXCOORD0 = tmpvar_5.xy;
  xlv_TEXCOORD1 = tmpvar_8.xy;
  xlv_TEXCOORD2 = tmpvar_11.xy;
  xlv_COLOR = _glesVertex.zzzz;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  highp float blue_1;
  highp float green_2;
  highp float red_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0).x;
  red_3 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD1).y;
  green_2 = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, xlv_TEXCOORD2).z;
  blue_1 = tmpvar_6;
  bvec2 tmpvar_7;
  tmpvar_7 = bvec2((clamp (xlv_TEXCOORD1, vec2(0.0, 0.0), vec2(1.0, 1.0)) - xlv_TEXCOORD1));
  bool tmpvar_8;
  tmpvar_8 = any(tmpvar_7);
  if (tmpvar_8) {
    red_3 = 0.0;
    green_2 = 0.0;
    blue_1 = 0.0;
  };
  highp vec4 tmpvar_9;
  tmpvar_9.x = red_3;
  tmpvar_9.y = green_2;
  tmpvar_9.z = blue_1;
  tmpvar_9.w = 1.0;
  gl_FragData[0] = (tmpvar_9 * xlv_COLOR);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 _TimeWarpEnd;
uniform highp mat4 _TimeWarpStart;
uniform highp vec2 _DMOffset;
uniform highp vec2 _DMScale;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp mat4 tmpvar_2;
  tmpvar_2 = (((_TimeWarpStart * (1.0 - tmpvar_1.z)) + (_TimeWarpEnd * tmpvar_1.z)));
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(1.0, 1.0);
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * tmpvar_3).xyz;
  highp vec3 tmpvar_5;
  tmpvar_5.z = 1.0;
  tmpvar_5.xy = (((tmpvar_4.xy / tmpvar_4.z) * _DMScale) + _DMOffset);
  highp vec4 tmpvar_6;
  tmpvar_6.zw = vec2(1.0, 1.0);
  tmpvar_6.xy = _glesMultiTexCoord1.xy;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_2 * tmpvar_6).xyz;
  highp vec3 tmpvar_8;
  tmpvar_8.z = 1.0;
  tmpvar_8.xy = (((tmpvar_7.xy / tmpvar_7.z) * _DMScale) + _DMOffset);
  highp vec4 tmpvar_9;
  tmpvar_9.zw = vec2(1.0, 1.0);
  tmpvar_9.xy = tmpvar_1.xy;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_2 * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11.z = 1.0;
  tmpvar_11.xy = (((tmpvar_10.xy / tmpvar_10.z) * _DMScale) + _DMOffset);
  gl_Position = _glesVertex;
  xlv_TEXCOORD0 = tmpvar_5.xy;
  xlv_TEXCOORD1 = tmpvar_8.xy;
  xlv_TEXCOORD2 = tmpvar_11.xy;
  xlv_COLOR = _glesVertex.zzzz;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  highp float blue_1;
  highp float green_2;
  highp float red_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0).x;
  red_3 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD1).y;
  green_2 = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, xlv_TEXCOORD2).z;
  blue_1 = tmpvar_6;
  bvec2 tmpvar_7;
  tmpvar_7 = bvec2((clamp (xlv_TEXCOORD1, vec2(0.0, 0.0), vec2(1.0, 1.0)) - xlv_TEXCOORD1));
  bool tmpvar_8;
  tmpvar_8 = any(tmpvar_7);
  if (tmpvar_8) {
    red_3 = 0.0;
    green_2 = 0.0;
    blue_1 = 0.0;
  };
  highp vec4 tmpvar_9;
  tmpvar_9.x = red_3;
  tmpvar_9.y = green_2;
  tmpvar_9.z = blue_1;
  tmpvar_9.w = 1.0;
  gl_FragData[0] = (tmpvar_9 * xlv_COLOR);
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "normal" Normal
Vector 8 [_DMScale]
Vector 9 [_DMOffset]
Matrix 0 [_TimeWarpStart]
Matrix 4 [_TimeWarpEnd]
"agal_vs
c10 1.0 0.0 0.0 0.0
[bc]
bfaaaaaaaaaaaeacabaaaakkaaaaaaaaaaaaaaaaaaaaaaaa neg r0.z, a1.z
abaaaaaaaeaaacacaaaaaakkacaaaaaaakaaaaaaabaaaaaa add r4.y, r0.z, c10.x
adaaaaaaaaaaapacabaaaakkaaaaaaaaafaaaaoeabaaaaaa mul r0, a1.z, c5
adaaaaaaadaaapacaeaaaaffacaaaaaaabaaaaoeabaaaaaa mul r3, r4.y, c1
abaaaaaaadaaapacadaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r3, r3, r0
adaaaaaaabaaapacabaaaakkaaaaaaaaagaaaaoeabaaaaaa mul r1, a1.z, c6
adaaaaaaacaaapacaeaaaaffacaaaaaaacaaaaoeabaaaaaa mul r2, r4.y, c2
abaaaaaaacaaapacacaaaaoeacaaaaaaabaaaaoeacaaaaaa add r2, r2, r1
adaaaaaaabaaapacabaaaakkaaaaaaaaaeaaaaoeabaaaaaa mul r1, a1.z, c4
aaaaaaaaaaaaadacadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, a3
aaaaaaaaaaaaamacakaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.zw, c10.x
bdaaaaaaaeaaaeacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa dp4 r4.z, r0, r2
adaaaaaaafaaapacaeaaaaffacaaaaaaaaaaaaoeabaaaaaa mul r5, r4.y, c0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
bdaaaaaaaeaaabacaaaaaaoeacaaaaaaadaaaaoeacaaaaaa dp4 r4.x, r0, r3
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaaaaaaoeacaaaaaa dp4 r0.x, r1, r0
afaaaaaaaeaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r4.y, r4.z
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffacaaaaaa mul r0.x, r0.x, r4.y
adaaaaaaaaaaacacaeaaaaffacaaaaaaaeaaaaaaacaaaaaa mul r0.y, r4.y, r4.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa mul r0.x, r0.x, c8
adaaaaaaaaaaacacaaaaaaffacaaaaaaaiaaaaoeabaaaaaa mul r0.y, r0.y, c8
aaaaaaaaaaaaamacakaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.zw, c10.x
abaaaaaaaaaaabaeaaaaaaaaacaaaaaaajaaaaoeabaaaaaa add v0.x, r0.x, c9
abaaaaaaaaaaacaeaaaaaaffacaaaaaaajaaaaoeabaaaaaa add v0.y, r0.y, c9
aaaaaaaaaaaaadacaeaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, a4
bdaaaaaaaeaaacacacaaaaoeacaaaaaaaaaaaaoeacaaaaaa dp4 r4.y, r2, r0
bdaaaaaaaeaaabacadaaaaoeacaaaaaaaaaaaaoeacaaaaaa dp4 r4.x, r3, r0
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaaaaaaoeacaaaaaa dp4 r0.x, r1, r0
afaaaaaaaeaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r4.y, r4.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffacaaaaaa mul r0.x, r0.x, r4.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa mul r0.x, r0.x, c8
adaaaaaaaaaaacacaeaaaaffacaaaaaaaeaaaaaaacaaaaaa mul r0.y, r4.y, r4.x
adaaaaaaaaaaacacaaaaaaffacaaaaaaaiaaaaoeabaaaaaa mul r0.y, r0.y, c8
aaaaaaaaaaaaamacakaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.zw, c10.x
abaaaaaaabaaabaeaaaaaaaaacaaaaaaajaaaaoeabaaaaaa add v1.x, r0.x, c9
abaaaaaaabaaacaeaaaaaaffacaaaaaaajaaaaoeabaaaaaa add v1.y, r0.y, c9
aaaaaaaaaaaaadacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, a1
bdaaaaaaacaaabacacaaaaoeacaaaaaaaaaaaaoeacaaaaaa dp4 r2.x, r2, r0
bdaaaaaaacaaacacadaaaaoeacaaaaaaaaaaaaoeacaaaaaa dp4 r2.y, r3, r0
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaaaaaaoeacaaaaaa dp4 r0.x, r1, r0
afaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r2.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r0.x, r0.x, r2.x
adaaaaaaaaaaacacacaaaaaaacaaaaaaacaaaaffacaaaaaa mul r0.y, r2.x, r2.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa mul r0.x, r0.x, c8
adaaaaaaaaaaacacaaaaaaffacaaaaaaaiaaaaoeabaaaaaa mul r0.y, r0.y, c8
abaaaaaaacaaabaeaaaaaaaaacaaaaaaajaaaaoeabaaaaaa add v2.x, r0.x, c9
abaaaaaaacaaacaeaaaaaaffacaaaaaaajaaaaoeabaaaaaa add v2.y, r0.y, c9
aaaaaaaaaaaaapadaaaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov o0, a0
aaaaaaaaahaaapaeaaaaaakkaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a0.z
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "normal" Normal
ConstBuffer "$Globals" 160 // 160 used size, 5 vars
Vector 16 [_DMScale] 2
Vector 24 [_DMOffset] 2
Matrix 32 [_TimeWarpStart] 4
Matrix 96 [_TimeWarpEnd] 4
BindCB "$Globals" 0
// 58 instructions, 8 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedjmbmblljomiblonbmadifjcihakfnefmabaaaaaabmamaaaaaeaaaaaa
daaaaaaacmaeaaaaomakaaaahialaaaaebgpgodjpeadaaaapeadaaaaaaacpopp
maadaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaabaa
ajaaabaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafakaaapkaaaaaiadpaaaaaaaa
aaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
bpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaafaaaaadaaaaabia
adaakkjaagaakkkaafaaaaadaaaaaciaadaakkjaahaakkkaafaaaaadaaaaaeia
adaakkjaaiaakkkaafaaaaadaaaaaiiaadaakkjaajaakkkaacaaaaadabaaabia
adaakkjbakaaaakaafaaaaadacaaabiaabaaaaiaacaakkkaafaaaaadacaaacia
abaaaaiaadaakkkaafaaaaadacaaaeiaabaaaaiaaeaakkkaafaaaaadacaaaiia
abaaaaiaafaakkkaacaaaaadaaaaapiaaaaaoeiaacaaoeiaaeaaaaaeacaaapia
abaaaejaakaafakaakaaafkaajaaaaadabaaaciaaaaaoeiaacaaoeiaagaaaaac
abaaaciaabaaffiaafaaaaadadaaadiaadaakkjaagaaobkaabaaaaacaeaaabia
adaaffiaafaaaaadabaaamiaadaakkjaahaaeekaabaaaaacaeaaaciaabaakkia
abaaaaacadaaaciaabaappiaafaaaaadabaaamiaadaakkjaaiaaeekaabaaaaac
aeaaaeiaabaakkiaabaaaaacadaaaeiaabaappiaafaaaaadabaaamiaadaakkja
ajaaeekaabaaaaacaeaaaiiaabaakkiaabaaaaacadaaaiiaabaappiaafaaaaad
afaaadiaabaaaaiaacaaobkaabaaaaacagaaabiaafaaffiaafaaaaadabaaamia
abaaaaiaadaaeekaabaaaaacagaaaciaabaakkiaabaaaaacafaaaciaabaappia
afaaaaadabaaamiaabaaaaiaaeaaeekaafaaaaadahaaadiaabaaaaiaafaaoeka
abaaaaacagaaaeiaabaakkiaabaaaaacafaaaeiaabaappiaabaaaaacagaaaiia
ahaaaaiaabaaaaacafaaaiiaahaaffiaacaaaaadadaaapiaadaaoeiaafaaoeia
acaaaaadaeaaapiaaeaaoeiaagaaoeiaajaaaaadafaaabiaaeaaoeiaacaaoeia
ajaaaaadafaaaciaadaaoeiaacaaoeiaafaaaaadabaaadiaabaaffiaafaaoeia
aeaaaaaeaaaaadoaabaaoeiaabaaoekaabaaookaaeaaaaaeabaaapiaacaaaeja
akaafakaakaaafkaajaaaaadacaaaiiaaeaaoeiaabaaoeiaajaaaaadacaaaeia
adaaoeiaabaaoeiaajaaaaadabaaabiaaaaaoeiaabaaoeiaagaaaaacabaaabia
abaaaaiaafaaaaadabaaadiaabaaaaiaacaaooiaaeaaaaaeaaaaamoaabaaeeia
abaabekaabaalekaaeaaaaaeabaaapiaadaaaejaakaafakaakaaafkaajaaaaad
acaaabiaaeaaoeiaabaaoeiaajaaaaadacaaaciaadaaoeiaabaaoeiaajaaaaad
aaaaabiaaaaaoeiaabaaoeiaagaaaaacaaaaabiaaaaaaaiaafaaaaadaaaaadia
aaaaaaiaacaaoeiaaeaaaaaeabaaadoaaaaaoeiaabaaoekaabaaookaaeaaaaae
aaaaadmaaaaappjaaaaaoekaaaaaoejaabaaaaacaaaaammaaaaaoejaabaaaaac
acaaapoaaaaakkjappppaaaafdeieefcliagaaaaeaaaabaakoabaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaa
abaaaaaafpaaaaaddcbabaaaacaaaaaafpaaaaadhcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaa
abaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagiaaaaac
aiaaaaaadgaaaaafpccabaaaaaaaaaaaegbobaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaackbabaaaadaaaaaackiacaaaaaaaaaaaagaaaaaadiaaaaaiccaabaaa
aaaaaaaackbabaaaadaaaaaackiacaaaaaaaaaaaahaaaaaadiaaaaaiecaabaaa
aaaaaaaackbabaaaadaaaaaackiacaaaaaaaaaaaaiaaaaaadiaaaaaiicaabaaa
aaaaaaaackbabaaaadaaaaaackiacaaaaaaaaaaaajaaaaaaaaaaaaaibcaabaaa
abaaaaaackbabaiaebaaaaaaadaaaaaaabeaaaaaaaaaiadpdiaaaaaibcaabaaa
acaaaaaaakaabaaaabaaaaaackiacaaaaaaaaaaaacaaaaaadiaaaaaiccaabaaa
acaaaaaaakaabaaaabaaaaaackiacaaaaaaaaaaaadaaaaaadiaaaaaiecaabaaa
acaaaaaaakaabaaaabaaaaaackiacaaaaaaaaaaaaeaaaaaadiaaaaaiicaabaaa
acaaaaaaakaabaaaabaaaaaackiacaaaaaaaaaaaafaaaaaaaaaaaaahpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaegaobaaaacaaaaaadgaaaaafdcaabaaaacaaaaaa
egbabaaaabaaaaaadgaaaaaimcaabaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaiadpbbaaaaahccaabaaaabaaaaaaegaobaaaaaaaaaaaegaobaaa
acaaaaaadiaaaaaidcaabaaaadaaaaaakgbkbaaaadaaaaaabgifcaaaaaaaaaaa
agaaaaaadgaaaaafbcaabaaaaeaaaaaabkaabaaaadaaaaaadiaaaaaimcaabaaa
abaaaaaakgbkbaaaadaaaaaaagiecaaaaaaaaaaaahaaaaaadgaaaaafccaabaaa
aeaaaaaackaabaaaabaaaaaadgaaaaafccaabaaaadaaaaaadkaabaaaabaaaaaa
diaaaaaimcaabaaaabaaaaaakgbkbaaaadaaaaaaagiecaaaaaaaaaaaaiaaaaaa
dgaaaaafecaabaaaaeaaaaaackaabaaaabaaaaaadgaaaaafecaabaaaadaaaaaa
dkaabaaaabaaaaaadiaaaaaimcaabaaaabaaaaaakgbkbaaaadaaaaaaagiecaaa
aaaaaaaaajaaaaaadgaaaaaficaabaaaaeaaaaaackaabaaaabaaaaaadgaaaaaf
icaabaaaadaaaaaadkaabaaaabaaaaaadiaaaaaidcaabaaaafaaaaaaagaabaaa
abaaaaaabgifcaaaaaaaaaaaacaaaaaadgaaaaafbcaabaaaagaaaaaabkaabaaa
afaaaaaadiaaaaaimcaabaaaabaaaaaaagaabaaaabaaaaaaagiecaaaaaaaaaaa
adaaaaaadgaaaaafccaabaaaagaaaaaackaabaaaabaaaaaadgaaaaafccaabaaa
afaaaaaadkaabaaaabaaaaaadiaaaaaimcaabaaaabaaaaaaagaabaaaabaaaaaa
agiecaaaaaaaaaaaaeaaaaaadiaaaaaidcaabaaaahaaaaaaagaabaaaabaaaaaa
egiacaaaaaaaaaaaafaaaaaadgaaaaafecaabaaaagaaaaaackaabaaaabaaaaaa
dgaaaaafecaabaaaafaaaaaadkaabaaaabaaaaaadgaaaaaficaabaaaagaaaaaa
akaabaaaahaaaaaadgaaaaaficaabaaaafaaaaaabkaabaaaahaaaaaaaaaaaaah
pcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaafaaaaaaaaaaaaahpcaabaaa
aeaaaaaaegaobaaaaeaaaaaaegaobaaaagaaaaaabbaaaaahbcaabaaaafaaaaaa
egaobaaaaeaaaaaaegapbaaaacaaaaaabbaaaaahccaabaaaafaaaaaaegaobaaa
adaaaaaaegapbaaaacaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaafaaaaaa
fgafbaaaabaaaaaadcaaaaaldccabaaaabaaaaaaegaabaaaabaaaaaaegiacaaa
aaaaaaaaabaaaaaaogikcaaaaaaaaaaaabaaaaaadgaaaaafdcaabaaaabaaaaaa
egbabaaaacaaaaaadgaaaaaimcaabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaiadpbbaaaaahecaabaaaacaaaaaaegaobaaaaeaaaaaaegapbaaa
abaaaaaabbaaaaahicaabaaaacaaaaaaegaobaaaadaaaaaaegapbaaaabaaaaaa
bbaaaaahbcaabaaaabaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaogakbaaaacaaaaaaagaabaaaabaaaaaadcaaaaalmccabaaa
abaaaaaaagaebaaaabaaaaaaagiecaaaaaaaaaaaabaaaaaakgiocaaaaaaaaaaa
abaaaaaadgaaaaafdcaabaaaabaaaaaaegbabaaaadaaaaaadgaaaaaimcaabaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaiadpbbaaaaahbcaabaaa
acaaaaaaegaobaaaaeaaaaaaegaobaaaabaaaaaabbaaaaahccaabaaaacaaaaaa
egaobaaaadaaaaaaegaobaaaabaaaaaabbaaaaahbcaabaaaaaaaaaaaegaobaaa
aaaaaaaaegaobaaaabaaaaaaaoaaaaahdcaabaaaaaaaaaaaegaabaaaacaaaaaa
agaabaaaaaaaaaaadcaaaaaldccabaaaacaaaaaaegaabaaaaaaaaaaaegiacaaa
aaaaaaaaabaaaaaaogikcaaaaaaaaaaaabaaaaaadgaaaaafpccabaaaadaaaaaa
kgbkbaaaaaaaaaaadoaaaaabejfdeheoieaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaahbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaahbaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaahkaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafaepfdej
feejepeoaafeeffiedepepfceeaaeoepfcenebemaaklklklepfdeheojmaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadamaaaajfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaa
fdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaedepemepfcaakl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 323
struct v2f {
    highp vec4 pos;
    highp vec2 uvR;
    highp vec2 uvG;
    highp vec2 uvB;
    highp vec4 c;
};
#line 315
struct appdata {
    highp vec4 pos;
    highp vec2 uvR;
    highp vec2 uvG;
    highp vec3 uvB;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 332
uniform sampler2D _MainTex;
uniform sampler2D _TimeWarpConstants;
uniform highp vec2 _DMScale = vec2( 0.0, 0.0);
uniform highp vec2 _DMOffset = vec2( 0.0, 0.0);
#line 336
uniform highp mat4 _TimeWarpStart;
uniform highp mat4 _TimeWarpEnd;
#line 344
#line 357
#line 338
highp vec2 TimewarpTexCoordToWarpedPos( in highp vec2 inTexCoord, in highp mat4 rotMat ) {
    #line 340
    highp vec3 transformed = (rotMat * vec4( inTexCoord.xy, 1.0, 1.0)).xyz;
    highp vec2 flattened = (transformed.xy / transformed.z);
    return ((flattened * _DMScale) + _DMOffset);
}
#line 344
v2f vert( in appdata v ) {
    v2f o;
    o.pos = v.pos;
    #line 348
    o.c = vec4( o.pos.z);
    highp float twLerpEnd = v.uvB.z;
    highp float twLerpStart = (1.0 - v.uvB.z);
    highp mat4 lerpedEyeRot = ((_TimeWarpStart * twLerpStart) + (_TimeWarpEnd * twLerpEnd));
    #line 352
    o.uvR = vec2( vec3( TimewarpTexCoordToWarpedPos( v.uvR.xy, lerpedEyeRot), 1.0));
    o.uvG = vec2( vec3( TimewarpTexCoordToWarpedPos( v.uvG.xy, lerpedEyeRot), 1.0));
    o.uvB = vec2( vec3( TimewarpTexCoordToWarpedPos( v.uvB.xy, lerpedEyeRot), 1.0));
    return o;
}
out highp vec2 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_COLOR;
void main() {
    v2f xl_retval;
    appdata xlt_v;
    xlt_v.pos = vec4(gl_Vertex);
    xlt_v.uvR = vec2(gl_MultiTexCoord0);
    xlt_v.uvG = vec2(gl_MultiTexCoord1);
    xlt_v.uvB = vec3(gl_Normal);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uvR);
    xlv_TEXCOORD1 = vec2(xl_retval.uvG);
    xlv_TEXCOORD2 = vec2(xl_retval.uvB);
    xlv_COLOR = vec4(xl_retval.c);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 323
struct v2f {
    highp vec4 pos;
    highp vec2 uvR;
    highp vec2 uvG;
    highp vec2 uvB;
    highp vec4 c;
};
#line 315
struct appdata {
    highp vec4 pos;
    highp vec2 uvR;
    highp vec2 uvG;
    highp vec3 uvB;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 332
uniform sampler2D _MainTex;
uniform sampler2D _TimeWarpConstants;
uniform highp vec2 _DMScale = vec2( 0.0, 0.0);
uniform highp vec2 _DMOffset = vec2( 0.0, 0.0);
#line 336
uniform highp mat4 _TimeWarpStart;
uniform highp mat4 _TimeWarpEnd;
#line 344
#line 357
#line 357
highp vec4 frag( in v2f i ) {
    highp float red = texture( _MainTex, i.uvR).x;
    highp float green = texture( _MainTex, i.uvG).y;
    #line 361
    highp float blue = texture( _MainTex, i.uvB).z;
    highp float alpha = 1.0;
    if (any(bvec2((clamp( i.uvG, vec2( 0.0, 0.0), vec2( 1.0, 1.0)) - i.uvG)))){
        #line 365
        red = 0.0;
        green = 0.0;
        blue = 0.0;
    }
    #line 369
    return (vec4( red, green, blue, alpha) * i.c);
}
in highp vec2 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_COLOR;
void main() {
    highp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uvR = vec2(xlv_TEXCOORD0);
    xlt_i.uvG = vec2(xlv_TEXCOORD1);
    xlt_i.uvB = vec2(xlv_TEXCOORD2);
    xlt_i.c = vec4(xlv_COLOR);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 3 to 3
//   d3d9 - ALU: 11 to 11, TEX: 3 to 3
//   d3d11 - ALU: 4 to 4, TEX: 3 to 3, FLOW: 1 to 1
//   d3d11_9x - ALU: 4 to 4, TEX: 3 to 3, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 13 ALU, 3 TEX
PARAM c[1] = { { 0, 1 } };
TEMP R0;
TEMP R1;
TEX R0.z, fragment.texcoord[2], texture[0], 2D;
TEX R0.y, fragment.texcoord[1], texture[0], 2D;
TEX R0.x, fragment.texcoord[0], texture[0], 2D;
MOV_SAT R1.xy, fragment.texcoord[1];
ADD R1.xy, R1, -fragment.texcoord[1];
ABS R1.xy, R1;
CMP R1.xy, -R1, c[0].y, c[0].x;
ADD_SAT R1.x, R1, R1.y;
CMP R0.x, -R1, c[0], R0;
CMP R0.y, -R1.x, c[0].x, R0;
MOV R0.w, c[0].y;
CMP R0.z, -R1.x, c[0].x, R0;
MUL result.color, R0, fragment.color.primary;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 11 ALU, 3 TEX
dcl_2d s0
def c0, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl v0
texld r0, t2, s0
texld r1, t1, s0
texld r2, t0, s0
mov_sat r0.xy, t1
add r0.xy, r0, -t1
abs r0.xy, r0
cmp r0.xy, -r0, c0.x, c0.y
add_pp_sat r1.x, r0, r0.y
cmp r0.x, -r1, r2, c0
cmp r0.y, -r1.x, r1, c0.x
mov r0.w, c0.y
cmp r0.z, -r1.x, r0, c0.x
mul r0, r0, v0
mov oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
SetTexture 0 [_MainTex] 2D 0
// 13 instructions, 3 temp regs, 0 temp arrays:
// ALU 4 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkomaklhodaimpfekmabembbmljfkfjccabaaaaaaniacaaaaadaaaaaa
cmaaaaaanaaaaaaaaeabaaaaejfdeheojmaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaajfaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapapaaaafdfgfpfagphdgjhegjgpgoaa
feeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklklfdeieefcmmabaaaaeaaaaaaahdaaaaaafkaaaaadaagabaaaaaaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadpcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaadgcaaaafdcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaaaaaaaaidcaabaaaaaaaaaaaegaabaaaaaaaaaaaogbkbaia
ebaaaaaaabaaaaaaapaaaaahbcaabaaaaaaaaaaaegaabaaaaaaaaaaaegaabaaa
aaaaaaaadjaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadgaaaaafccaabaaaabaaaaaabkaabaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
dgaaaaafecaabaaaabaaaaaackaabaaaacaaaaaadhaaaaamhcaabaaaaaaaaaaa
agaabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahpccabaaa
aaaaaaaaegaobaaaaaaaaaaaegbobaaaadaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"agal_ps
c0 0.0 1.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacacaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v2, s0 <2d wrap linear point>
ciaaaaaaabaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v1, s0 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
aaaaaaaaaaaaadacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, v1
bgaaaaaaaaaaadacaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa sat r0.xy, r0.xyyy
acaaaaaaaaaaadacaaaaaafeacaaaaaaabaaaaoeaeaaaaaa sub r0.xy, r0.xyyy, v1
beaaaaaaaaaaadacaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa abs r0.xy, r0.xyyy
bfaaaaaaabaaamacaaaaaafeacaaaaaaaaaaaaaaaaaaaaaa neg r1.zw, r0.xyyy
ckaaaaaaabaaamacabaaaapoacaaaaaaaaaaaaaaabaaaaaa slt r1.zw, r1.zwww, c0.x
aaaaaaaaadaaapacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r3, c0
aaaaaaaaaeaaapacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4, c0
acaaaaaaacaaagacadaaaaffacaaaaaaaeaaaaaaacaaaaaa sub r2.yz, r3.y, r4.x
adaaaaaaaaaaadacacaaaakjacaaaaaaabaaaapoacaaaaaa mul r0.xy, r2.yzzz, r1.zwww
abaaaaaaaaaaadacaaaaaafeacaaaaaaaaaaaaaaabaaaaaa add r0.xy, r0.xyyy, c0.x
abaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaffacaaaaaa add r1.x, r0.x, r0.y
bgaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r1.x, r1.x
bfaaaaaaadaaacacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.y, r1.x
ckaaaaaaadaaacacadaaaaffacaaaaaaaaaaaaaaabaaaaaa slt r3.y, r3.y, c0.x
acaaaaaaadaaabacaaaaaaoeabaaaaaaacaaaaaaacaaaaaa sub r3.x, c0, r2.x
adaaaaaaaaaaabacadaaaaaaacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.x, r3.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaaaacaaaaaa add r0.x, r0.x, r2.x
bfaaaaaaadaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.x, r1.x
ckaaaaaaadaaacacadaaaaaaacaaaaaaaaaaaaaaabaaaaaa slt r3.y, r3.x, c0.x
acaaaaaaacaaacacaaaaaaaaabaaaaaaabaaaaffacaaaaaa sub r2.y, c0.x, r1.y
adaaaaaaaaaaacacacaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.y, r2.y, r3.y
abaaaaaaaaaaacacaaaaaaffacaaaaaaabaaaaffacaaaaaa add r0.y, r0.y, r1.y
aaaaaaaaaaaaaiacaaaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c0.y
bfaaaaaaadaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.x, r1.x
ckaaaaaaadaaaeacadaaaaaaacaaaaaaaaaaaaaaabaaaaaa slt r3.z, r3.x, c0.x
acaaaaaaabaaaeacaaaaaaaaabaaaaaaaaaaaakkacaaaaaa sub r1.z, c0.x, r0.z
adaaaaaaabaaaeacabaaaakkacaaaaaaadaaaakkacaaaaaa mul r1.z, r1.z, r3.z
abaaaaaaaaaaaeacabaaaakkacaaaaaaaaaaaakkacaaaaaa add r0.z, r1.z, r0.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaahaaaaoeaeaaaaaa mul r0, r0, v7
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
SetTexture 0 [_MainTex] 2D 0
// 13 instructions, 3 temp regs, 0 temp arrays:
// ALU 4 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedemmlagggdifcnmckigncnloeadplcacpabaaaaaabmaeaaaaaeaaaaaa
daaaaaaahaabaaaaeeadaaaaoiadaaaaebgpgodjdiabaaaadiabaaaaaaacpppp
baabaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
aaacppppfbaaaaafaaaaapkaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaabpaaaaac
aaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaadlabpaaaaacaaaaaaiaacaaapla
bpaaaaacaaaaaajaaaaiapkaabaaaaacaaaabdiaaaaabllaacaaaaadaaaaadia
aaaaoeiaaaaabllbfkaaaaaeaaaaabiaaaaaoeiaaaaaoeiaaaaaaakaabaaaaac
abaaadiaaaaabllaecaaaaadabaaapiaabaaoeiaaaaioekaecaaaaadacaaapia
aaaaoelaaaaioekaecaaaaadadaaapiaabaaoelaaaaioekaabaaaaacadaaacia
abaaffiaabaaaaacadaaabiaacaaaaiafiaaaaaeaaaaahiaaaaaaaibadaaoeia
aaaaaakaabaaaaacaaaaaiiaaaaaffkaafaaaaadaaaaapiaaaaaoeiaacaaoela
abaaaaacaaaiapiaaaaaoeiappppaaaafdeieefcmmabaaaaeaaaaaaahdaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaa
gcbaaaadpcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
dgcaaaafdcaabaaaaaaaaaaaogbkbaaaabaaaaaaaaaaaaaidcaabaaaaaaaaaaa
egaabaaaaaaaaaaaogbkbaiaebaaaaaaabaaaaaaapaaaaahbcaabaaaaaaaaaaa
egaabaaaaaaaaaaaegaabaaaaaaaaaaadjaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaogbkbaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadgaaaaafccaabaaaabaaaaaa
bkaabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadgaaaaafecaabaaaabaaaaaackaabaaaacaaaaaa
dhaaaaamhcaabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpdiaaaaahpccabaaaaaaaaaaaegaobaaaaaaaaaaaegbobaaaadaaaaaa
doaaaaabejfdeheojmaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaajfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapapaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 129

  	}
}

Fallback off
	
} // shader