Shader "Comun/Lambert"
{
    Properties
    {
        _MainColor("Albedo", Color)= (1,1,1,1)
        _FallOffDiffuse("FallOff Diffuse", Range(0.0, 0.5))=0.5
    }
    SubShader
    {
        Tags
        {
            "RenderType"= "Opaque"
            "Queque"= "Geometry"
        }
        CGPROGRAM
        #pragma surface surf Diffuse
        float _FallOffDiffuse;
        half4 LightingDiffuse(SurfaceOutput s, half3 lightDir, half atten)
        {
            half4 c= half4(0,0,0,0);
            half NdotL= dot(s.Normal, lightDir)* _FallOffDiffuse+ _FallOffDiffuse;
            c.rgb= s.Albedo* _LightColor0.rgb* NdotL* atten;
            c.a= s.Albedo;
            return c;
        }
        fixed3 _MainColor;
        struct Input
        {
            fixed3 color;
        };
        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo= _MainColor.rgb;
        }
        ENDCG
    }
}
   