using UnityEngine;

public class GeometryShaderInstancing : MonoBehaviour
{
    [Range(0, 1000000)]
    public  int      numOfInstancing;
    public  Material material;

    void OnRenderObject()
    {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points, numOfInstancing);
    }
}