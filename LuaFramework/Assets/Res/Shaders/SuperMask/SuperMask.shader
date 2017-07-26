// Shader created with Shader Forge v1.30 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.30;sub:START;pass:START;ps:flbk:Mobile/VertexLit,iptp:1,cusa:True,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:True,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1873,x:33529,y:32884,varname:node_1873,prsc:2|alpha-6928-OUT;n:type:ShaderForge.SFN_TexCoord,id:8292,x:31872,y:33254,varname:node_8292,prsc:2,uv:0;n:type:ShaderForge.SFN_RemapRange,id:7955,x:32056,y:33255,varname:node_7955,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-8292-UVOUT;n:type:ShaderForge.SFN_Length,id:5081,x:32738,y:33346,varname:node_5081,prsc:2|IN-259-OUT;n:type:ShaderForge.SFN_Slider,id:2416,x:31474,y:33167,ptovrint:False,ptlb:Radius,ptin:_Radius,varname:node_2416,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.8185028,max:1;n:type:ShaderForge.SFN_Floor,id:6589,x:32925,y:33076,varname:node_6589,prsc:2|IN-8622-OUT;n:type:ShaderForge.SFN_Add,id:8622,x:32677,y:33095,varname:node_8622,prsc:2|A-2555-OUT,B-5081-OUT;n:type:ShaderForge.SFN_Add,id:744,x:32304,y:33255,varname:node_744,prsc:2|A-7955-OUT,B-3963-OUT;n:type:ShaderForge.SFN_Slider,id:9131,x:31477,y:33293,ptovrint:False,ptlb:PositionX,ptin:_PositionX,varname:node_9131,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:1181,x:31481,y:33413,ptovrint:False,ptlb:PositionY,ptin:_PositionY,varname:_node_9131_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0,max:1;n:type:ShaderForge.SFN_Append,id:4649,x:31975,y:33430,varname:node_4649,prsc:2|A-9131-OUT,B-1181-OUT;n:type:ShaderForge.SFN_Multiply,id:3963,x:32308,y:33415,varname:node_3963,prsc:2|A-4649-OUT,B-1892-OUT;n:type:ShaderForge.SFN_Vector1,id:1892,x:32115,y:33485,varname:node_1892,prsc:2,v1:-1;n:type:ShaderForge.SFN_Slider,id:6584,x:31485,y:33561,ptovrint:False,ptlb:SizeX,ptin:_SizeX,varname:node_6584,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:259,x:32551,y:33341,varname:node_259,prsc:2|A-744-OUT,B-9730-OUT;n:type:ShaderForge.SFN_Append,id:6955,x:32134,y:33700,varname:node_6955,prsc:2|A-6584-OUT,B-8079-OUT;n:type:ShaderForge.SFN_Slider,id:8079,x:31485,y:33714,ptovrint:False,ptlb:SizeY,ptin:_SizeY,varname:_node_6584_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Subtract,id:9730,x:32312,y:33603,varname:node_9730,prsc:2|A-2467-OUT,B-6955-OUT;n:type:ShaderForge.SFN_Vector2,id:2467,x:32130,y:33576,varname:node_2467,prsc:2,v1:1,v2:1;n:type:ShaderForge.SFN_ValueProperty,id:5696,x:31962,y:33104,ptovrint:False,ptlb:node_5696,ptin:_node_5696,varname:node_5696,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Subtract,id:2555,x:32410,y:33102,varname:node_2555,prsc:2|A-5696-OUT,B-2416-OUT;n:type:ShaderForge.SFN_Multiply,id:6928,x:33219,y:33022,varname:node_6928,prsc:2|A-3171-OUT,B-6589-OUT;n:type:ShaderForge.SFN_Slider,id:3171,x:32777,y:32973,ptovrint:False,ptlb:node_3171,ptin:_node_3171,varname:node_3171,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;proporder:2416-9131-1181-6584-8079-5696-3171;pass:END;sub:END;*/

Shader "Custom/SuperMask" {
    Properties {
        _Radius ("Radius", Range(0, 1)) = 0.8185028
        _PositionX ("PositionX", Range(-1, 1)) = 0
        _PositionY ("PositionY", Range(-1, 1)) = 0
        _SizeX ("SizeX", Range(0, 1)) = 0
        _SizeY ("SizeY", Range(0, 1)) = 0
        _node_5696 ("node_5696", Float ) = 1
        _node_3171 ("node_3171", Range(0, 1)) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "CanUseSpriteAtlas"="True"
            "PreviewType"="Plane"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #pragma multi_compile _ PIXELSNAP_ON
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float _Radius;
            uniform float _PositionX;
            uniform float _PositionY;
            uniform float _SizeX;
            uniform float _SizeY;
            uniform float _node_5696;
            uniform float _node_3171;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                #ifdef PIXELSNAP_ON
                    o.pos = UnityPixelSnap(o.pos);
                #endif
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
                float3 finalColor = 0;
                float node_8622 = ((_node_5696-_Radius)+length((((i.uv0*2.0+-1.0)+(float2(_PositionX,_PositionY)*(-1.0)))*(float2(1,1)-float2(_SizeX,_SizeY)))));
                return fixed4(finalColor,(_node_3171*floor(node_8622)));
            }
            ENDCG
        }
    }
    FallBack "Mobile/VertexLit"
    CustomEditor "ShaderForgeMaterialInspector"
}
