Shader "Custom/Phong"
{
    Properties
    {
        _Basecolor("Albedo", color) = (1, 1, 1, 1)
        _SpecularColor("Specular Color", color) = (1, 1, 1, 1)
        _SpecularPower("Specular Power", Range(1.0, 5.0)) = 3.0
        _SpecularGloss("Gloss", Range(1.0, 5.0)) = 5.0
        _SpecularSteps("Specular Steps", Range(1.0, 8.0)) = 1.0
    }

    Subshader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        CGPROGRAM

        #pragma surface surf SpecularModel

        fixed4 _Basecolor;
        half4 _SpecularColor;
        half _SpecularPower;
        half _SpecularGloss;
        int _SpecularSteps;

        half4 LightingSpecularModel(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half4 c = half4(1, 1, 1, 1);
            half Ndotl = max(0, dot(s.Normal, lightDir));
            half3 lightReflected = reflect(-lightDir, s.Normal);
            half RdotV = max(0, dot(lightReflected, viewDir));
            half3 finalSpecular = pow(RdotV, _SpecularGloss /_SpecularSteps) * _SpecularPower * _SpecularColor;
            c.rgb = (Ndotl * _Basecolor + finalSpecular) * _LightColor0.rgb * atten;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            fixed a;

        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Basecolor.rgb;
        }

        ENDCG
    }
}

   
