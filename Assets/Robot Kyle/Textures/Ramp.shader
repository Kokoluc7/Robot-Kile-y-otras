Shader "Costum/Ramp"
{
    properties
    {
        _MainTex("Main Texture", 2D) = "White"{}
        _Albedio("Base color", Color) = (1, 1, 1, 1)
        _RampTex("Ramp Texture", 2D) = "White"{}
        _Normaltex("Normal map", 2D)= "bumb"{}
        _NomralForce("Normal Effect", Range(-4.0,4.0))= 1.0
        [HDR] 
    }

    SubShader
    {
         Tags
        {
            "Queue" = "Geometry"
            "EnderType" = "Opaque"
        }

        CGPROGRAM
         
        sampler2D _MainTex;
        sampler2D _RampTex;
        fixed _Albedo;
        #pragma surface surf Ramp

        half4 LightingRamp(SurfaceOutput s, half3 lightDir, half aftten)
         {
            float Ndotl= dot(s.Normal, lightDir); 
            float wrapNdotL= Ndotl* 0.5 + 0.5;
            float2 uv_ramp= float2(wrapNdotL, 0);
            half3 ramp= tex2D(_RampTex, uv_ramp).rgb;
            half4 c= half4(1,1,1,1);
            c.rgb= s.Albedo * _LightColor0.rgb * atten * ramp;
            c.a= s.Alpha;
            return c;
         }
         

        struct Imput
        {
            float2 uv _MainTex;
            float2 uv_RampTex;
            float viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo= _Albedo.rgb* tex2D( _MainTex, IN.uv_MainTex).rgb;
            o.Normal= UnpackNormal(tex2D(_Normaltex, IN.uv_NormalTex));
            o.Normal.z /= _NomralForce;
            half rim= 1.0 - saturate(dot(normlize(IN.viewDir), o.Normal));
            o.Emission= _RimColor0.rgb * pow(rim, _RimPower)* _LightColor0-rgb;
        }

        ENDCG
    }
}
