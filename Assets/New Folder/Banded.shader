Shader "custom/Banded"
{
    Properties
    {
        _Albedo ("Base Color", Color) = (1, 1, 1, 1)
        _Steps("Bands count,", Range(2.0, 30.0)) = 4.0
        _rate("Band rate", Range(16, 460)) = 256
    }
    
    Subshader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM

        #pragma surface surf Banded

        half4 _Albedo;
        half _Steps;
        half _rate;

        half4 LightingBanded(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = saturate(dot(s.Normal, lightDir));
            half4 c;
            half bandMultiplier = _Steps / _rate;
            half bandAdditive  = _Steps / _rate;
            half banded = (floor((NdotL * _rate + bandAdditive) / _Steps)) * bandMultiplier;
            c.rgb = _Albedo * banded * _LightColor0.rgb * atten * NdotL;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float a;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Albedo.rgb;
        }

        ENDCG
    }
}