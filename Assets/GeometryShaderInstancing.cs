using System.Runtime.InteropServices;
using UnityEngine;

public class GeometryShaderInstancing : MonoBehaviour
{
    [Range(0, 1000000)]
    public  int           numOfInstancing;
    public  Material      material;
    private ComputeBuffer vertexBuffer;

    void Start()
    {
        Vector3[] vertices = new Vector3[]
        {
            new Vector3(0, 0, 0)
        };

        vertexBuffer = new ComputeBuffer(1, Marshal.SizeOf(typeof(Vector3)));
        vertexBuffer.SetData(vertices);

        material.SetBuffer("_VertexBuffer", vertexBuffer);
    }

    void OnRenderObject()
    {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points, numOfInstancing);
    }

    void OnDestroy()
    {
        vertexBuffer.Release();
    }
}