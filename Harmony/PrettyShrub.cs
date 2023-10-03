using HarmonyLib;
using System.Collections.Generic;
using UnityEngine;
using static GameObjectPool;

public class PrettyShrubPatch
{

    [HarmonyPatch(typeof(GameObjectPool))]
    [HarmonyPatch("AddPooledObject")]
    public class AddPooledObject_AddPooledObject
    {

        // static Dictionary<string, Color> ShrubColors = new Dictionary<string, Color>()
        // {
        //     { "plantShrubPrefab", new Color(0.254f, 0.282f, 0.228f) },
        //     { "plantShrubDeadPrefab", new Color(0.22f, 0.24f, 0.14f) },
        //     { "plantShrubSnowPrefab", new Color(1f, 1f, 1f) }
        // };

        static void Postfix(Dictionary<string, GameObjectPool.PoolItem> ___pool, string name)
        {
            if (!name.StartsWith("plantShrub")) return;
            if (___pool.TryGetValue(name, out PoolItem item))
            {
                if (item.prefab == null) return;
                var transform = item.prefab.transform;
                if (transform == null) return;
                var group = transform.GetComponent<LODGroup>();
                if (group == null) return;
                LOD[] lods = group.GetLODs();
                if (lods.Length != 4) return;
                lods[2].fadeTransitionWidth =
                    lods[3].fadeTransitionWidth;
                lods[2].screenRelativeTransitionHeight =
                    lods[3].screenRelativeTransitionHeight;
                foreach (var rndr in lods[3].renderers)
                    rndr.enabled = false;
                System.Array.Resize(ref lods, 3);
                group.SetLODs(lods);
                /*
                // Alternative way to adjust the billboard shader
                // Seems impossible to get right for all situations
                transform = transform.Find("plantShrub_LOD3");
                if (transform == null) return;
                if (ShrubColors.TryGetValue(name, out Color color))
                {
                    foreach (var rndr in transform.GetComponentsInChildren<Renderer>())
                    {
                        foreach (var mat in rndr.sharedMaterials)
                        {
                            if (!mat.HasFloat("_TransAmbient")) continue;
                            mat.SetColor("_TintColor", color);
                            mat.SetFloat("_Translucency", 2f);
                            mat.SetFloat("_TransNormalDistortion", 0.1f);
                            mat.SetFloat("_TransScattering", 2f);
                            mat.SetFloat("_TransDirect", 1f);
                            mat.SetFloat("_TransAmbient", 0.2f);
                            mat.SetFloat("_TransShadow", 0.95f);
                        }
                    }
                }
                */
            }
        }
    }
}
