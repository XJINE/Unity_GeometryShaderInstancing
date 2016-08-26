using System.Runtime.InteropServices;
using UnityEngine;

public class SimpleInstancing : MonoBehaviour
{
    public Shader simpleInstancingShader;
    [Range(0, 1000000)]
    public int numOfInstancing;

    private Material material;
    private ComputeBuffer vertexBuffer;

    void Start()
    {
        Vector3[] vertices = new Vector3[] { new Vector3(0, 0, 0) };
        this.vertexBuffer = new ComputeBuffer(1, Marshal.SizeOf(typeof(Vector3)));
        this.vertexBuffer.SetData(vertices);

        this.material = new Material(this.simpleInstancingShader);
        this.material.SetBuffer("_VertexBuffer", this.vertexBuffer);
    }

    void OnRenderObject()
    {
        this.material.SetPass(0);
        Graphics.DrawProcedural(MeshTopology.Points, this.numOfInstancing);
    }

    void OnDestroy()
    {
        DestroyImmediate(this.material);
        this.vertexBuffer.Release();
    }
}