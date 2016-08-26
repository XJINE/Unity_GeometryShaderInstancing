Shader "Custom/Unlit/SimpleInstancing"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma target 5.0
            #pragma vertex vertexShader
            #pragma geometry geometryShader
            #pragma fragment fragmentShader

            #include "UnityCG.cginc"

            struct vertexOutput
            {
                float4 position : SV_POSITION;
                half4 color : TEXCOORD1;
            };

            // ------------------------------------------------------------------------------------
            // VertexShader
            // ------------------------------------------------------------------------------------

            // スクリプト (CPU) 側で、DrawProcedual で指定された回数だけ、VertexShader が呼ばれる。
            //  Graphics.DrawProcedural(MeshTopology.Points, this.numOfInstancing)

            vertexOutput vertexShader(uint vertexID : SV_VertexID)
            {
                // 頂点の座標は ID の分だけずらす。

                vertexOutput output;
                output.position = float4(vertexID % 10, vertexID / 10, 0, 1);

                half value = vertexID % 10 / 10.0;
                output.color = half4(value, value, value, 1);

                return output;
            }

            // ------------------------------------------------------------------------------------
            // GeometryShader
            // ------------------------------------------------------------------------------------

            // https://msdn.microsoft.com/ja-jp/library/bb205146(v=vs.85).aspx
            // https://msdn.microsoft.com/ja-jp/library/bb509609(v=vs.85).aspx
            // 
            // (1) point は頂点のリスト。引数名[num] の num は入力される頂点数。
            //     このサンプルでは (0,0,0) の 1 頂点しか与えられない。
            // (2) inout がつけられた引数は、引数としても出力としても扱われる。参照渡しのようなもの。
            //     TriangleStream としているので、outputStream への入力は、三角形としてみなされる。
            //     他に LineStream などがある。
            // (3) maxvertexcount はジオメトリシェーダが出力する頂点数。
            //     このサンプルでは 1 つの頂点から 4 つの頂点を生成するので 4.

            [maxvertexcount(4)]
            void geometryShader(point vertexOutput input[1],
                                inout TriangleStream<vertexOutput> outputStream)
            {
                vertexOutput output;
                float4 position = input[0].position;

                for (int x = 0; x < 2; x++)
                {
                    for (int y = 0; y < 2; y++)
                    {
                        //座標を設定して射影変換して、三角形を構成する頂点として追加する。
                        output.position = position + float4(float2(x, y) * 0.5, 0, 0);
                        output.position = mul(UNITY_MATRIX_VP, output.position);
                        output.color = input[0] .color;
                        outputStream.Append(output);
                    }
                }

                outputStream.RestartStrip();
            }

            // ------------------------------------------------------------------------------------
            // FragmentShader
            // ------------------------------------------------------------------------------------
            
            fixed4 fragmentShader(vertexOutput input) : COLOR
            {
                return input.color;
            }

            ENDCG
        }
    }
}