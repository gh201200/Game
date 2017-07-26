Shader "Custom/GrabBlur"   
{  
    Properties   
    {  
        //_MainTex("MainTex", 2D) = "white" { }
        _Offset("Offset", Range(0, 10)) = 1
        _Percent("Percent", Range(0, 10)) = 1
        //_TextureSize ("_TextureSize",Float) = 256
        //_BlurRadius ("_BlurRadius",Range(0,15) ) = 1
    }  
    SubShader   
    {  
        Tags{"Queue"="Transparent"}  
        GrabPass{}  
                 
        Pass  
        {  
            CGPROGRAM  
            #pragma vertex vert  
            #pragma fragment frag  
            #include "UnityCG.cginc"  
            //sampler2D _MainTex
            sampler2D _GrabTexture;  
            float _Offset;
            float _Percent;
            //int _BlurRadius;
            //float _TextureSize;
  
            struct VertexOutput   
            {  
                float4 pos:SV_POSITION;  
                float2 uv:TEXCOORD0;  
            };  
  
            VertexOutput vert(appdata_base v)  
            {  
                VertexOutput o;  
                o.pos = mul(UNITY_MATRIX_MVP,v.vertex);  
                o.uv = float2(v.texcoord.x , 1-v.texcoord.y);  
  
                return o;  
            }

            //高斯模糊算法
            //计算权重
            //float GetGaussianDistribution( float x, float y, float rho ) 
            //{
            //    float g = 1.0f / sqrt( 2.0f * 3.141592654f * rho * rho );
            //    return g * exp( -(x * x + y * y) / (2 * rho * rho) );
            //}

            //float4 GetGaussBlurColor( float2 uv )
            //{
            //    //算出一个像素的空间
            //    float space = 1.0/_TextureSize; 
            //    //参考正态分布曲线图，可以知道 3σ 距离以外的点，权重已经微不足道了。
            //    //反推即可知道当模糊半径为r时，取σ为 r/3 是一个比较合适的取值。
            //    float rho = (float)_BlurRadius * space / 3.0;

            //    //---权重总和
            //    float weightTotal = 0;
            //    for( int x = -_BlurRadius ; x <= _BlurRadius ; x++ )
            //    {
            //        for( int y = -_BlurRadius ; y <= _BlurRadius ; y++ )
            //        {
            //            weightTotal += GetGaussianDistribution(x * space, y * space, rho );
            //        }
            //    }
            //    //--------
            //    float4 colorTmp = float4(0,0,0,0);
            //    for( int x = -_BlurRadius ; x <= _BlurRadius ; x++ )
            //    {
            //        for( int y = -_BlurRadius ; y <= _BlurRadius ; y++ )
            //        {
            //            float weight = GetGaussianDistribution( x * space, y * space, rho )/weightTotal;

            //            float4 color = tex2D(_GrabTexture,uv + float2(x * space,y * space));
            //            color = color * weight;
            //            colorTmp += color;
            //        }
            //    }
            //    return colorTmp;
            //}  
  
            float4 frag(VertexOutput input):COLOR  
            {  
                half4 a = tex2D(_GrabTexture,input.uv + float2(_Offset / 100,0));  
                half4 b = tex2D(_GrabTexture,input.uv + float2(-_Offset / 100,0));  
                half4 c = tex2D(_GrabTexture,input.uv + float2(0,_Offset / 100));  
                half4 d = tex2D(_GrabTexture,input.uv + float2(0,-_Offset / 100));  
  
                half4 e = tex2D(_GrabTexture,input.uv + float2(_Offset / 2 / 100,_Offset / 2 / 100));  
                half4 f = tex2D(_GrabTexture,input.uv + float2(-_Offset / 2 / 100,_Offset / 2 / 100));  
                half4 g = tex2D(_GrabTexture,input.uv + float2(_Offset / 2 / 100,-_Offset / 2 / 100));  
                half4 h = tex2D(_GrabTexture,input.uv + float2(-_Offset / 2 / 100,-_Offset / 2 / 100));  
                  
                half4 texCol = tex2D(_GrabTexture,input.uv);  
                texCol = (texCol + a + b + c + d + e + f + g + h) * _Percent / 100;  
                return texCol;
                //return GetGaussBlurColor(input.uv);
            }  
            ENDCG  
        }          
    }   
    FallBack "Diffuse"  
}