Shader "SITU/pointcloud_glsl_shader" { // defines the name of the shader 
   Properties {
      _MainTex ("Texture Image", 2D) = "white" {} 
         // a 2D texture property that we call "_MainTex", which should
         // be labeled "Texture Image" in Unity's user interface.
         // By default we use the built-in texture "white"  
         // (alternatives: "black", "gray" and "bump").
   }
   SubShader { 
      Pass {
         GLSLPROGRAM

         uniform sampler2D _MainTex;	
         uniform vec4 _MainTex_ST; 


         #ifdef VERTEX 
            varying vec4 vcolor;
            varying vec4 textureCoordinates;
            uniform float time;



            float random (vec3 uv)
            {
               return fract(sin(dot(uv.xyz, vec3(12.9898 + time, 78.233, 45.8094))) * 43758.5453123);
            }

            void main()
            {
               // position of vertex
               // vec4 because GL automatically makes fills vec3s into vec4 by extending with 1.0 idk why
               vec4 position = gl_ModelViewProjectionMatrix * gl_Vertex;

               // random float between 0 and 1
               float rand1 = random(vec3(gl_Vertex.x + position.x, gl_Vertex.y + position.y, gl_Vertex.z + position.z));
               float rand2 = random(vec3(gl_Vertex.y + position.z, gl_Vertex.x + position.x, gl_Vertex.x + position.y));

               // distance from camera
               // float dist = position.z;

               // max distance for points to be rendered
               // float maxDist = 80.0;

               // distance normalized by max distance - float 0 to 1 
               // float distRatio = dist / maxDist;


               // float test = random(vec3(gl_Vertex.x, gl_Vertex.y, gl_Vertex.z)) + position.z/10000.0;
               // if (test < 0.01){

               if ( position.z > 0.0 && (rand1 * position.z + (rand2 * 3.0 * position.z) )< 20.0) {
                  gl_Position = position;
                  gl_PointSize = position.z / 40.0;
               } else {
                  gl_PointSize = 0.0;
               }

               // vcolor = vec4( random(vec3(gl_Vertex.x + position.x, gl_Vertex.y + position.y, gl_Vertex.z + position.z)),  random(vec3(gl_Vertex.x, gl_Vertex.y, gl_Vertex.z)),  random(vec3(gl_Vertex.x, gl_Vertex.y, gl_Vertex.z)),  random(vec3(gl_Vertex.x, gl_Vertex.y, gl_Vertex.z)));
               vcolor = gl_Color;
               // textureCoordinates = position;
            }

         #endif 

         #ifdef FRAGMENT 
         varying vec4 vcolor;
         // varying vec4 textureCoordinates;

         void main()
         {
            // vec4 random1 =  texture2D(_MainTex, _MainTex_ST.xy * textureCoordinates.yz );
            // vec4 random2 = texture2D(_MainTex, _MainTex_ST.xy * random1.xz );
            // if (random2.x < textureCoordinates.z * 1000000.0 ){
            //    // discard;
            // }
            gl_FragColor = vcolor;
         }
         #endif 
         ENDGLSL 
      }
   }
}