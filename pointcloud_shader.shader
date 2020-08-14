// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "SITU/pointcloud_shader"
{
    Properties
    {
        // Color property for material inspector, default to white
        _Color ("Main Color", Color) = (1,1,1,1)
        _Distancefactor("Distance Factor", Float) = 0.01
        _DistanceCulling("Distance Culling", Float) = 0

    }
    SubShader
    {
    Pass
        {
            CGPROGRAM
            // use "vert" function as the vertex shader
            #pragma vertex vert
            // use "frag" function as the pixel (fragment) shader
            #pragma fragment frag

            // vertex shader inputs
            struct appdata
            {
                float4 vertex : POSITION; // vertex position
                fixed4 color : COLOR;
            };

            float _Distancefactor;
            float _DistanceCulling;

            // vertex shader outputs ("vertex to fragment")
            struct v2f
            {
                fixed distance : DISTANCE; // texture coordinate
                float4 vertex : SV_POSITION; // clip space position
                fixed4 color : COLOR;
            };




            // vertex shader
            v2f vert (appdata v)
            {
                v2f o;
                // transform position to clip space
                // (multiply with model*view*projection matrix)
                o.vertex = UnityObjectToClipPos(v.vertex);
                // just pass the texture coordinate
                float3 _Position = (1,1,1); 
                o.color = v.color;
                o.distance =  _Distancefactor * distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));
                if (_DistanceCulling > 1 & o.distance > 1){
                    o.vertex = 0.0/0.0;
                }
                return o;
            }
            
            

            // pixel shader; returns low precision ("fixed4" type)
            // color ("SV_Target" semantic)
            fixed4 frag (v2f i) : SV_Target
            {
                // sample texture and return it
                
                fixed4 col = fixed4(i.distance,i.distance,i.distance,i.distance);
                return col;
            }
            ENDCG
        }
    }
}