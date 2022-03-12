using HarmonyLib;
using System.Reflection;
using UnityEngine;
using XMLData.Parsers;

public class OcbBetterGrass : IModApi
{

    public static Shader GrassShader = null;

    public void InitMod(Mod mod)
    {
        Debug.Log("Loading OCB Better Grass Patch: " + GetType().ToString());
        new Harmony(GetType().ToString()).PatchAll(Assembly.GetExecutingAssembly());
        AssetBundle bundle = AssetBundle.LoadFromFile(mod.Path + "/Resources/GrassShader.unity3d");
        GrassShader = bundle.LoadAsset<Shader>("assets/grass.shader");
        ModEvents.GameStartDone.RegisterHandler(ApplyGamePrefs);
    }

    static public void ApplyGamePrefs()
    {
        MeshDescription.meshes[MeshDescription.MESH_GRASS].material.shader = GrassShader;
        int quality = GamePrefs.GetInt(EnumGamePrefs.OptionsGfxTerrainQuality);
        // Log.Out(" OcbNetterGrass: Have terrain quality: " + quality);
        MeshDescription.meshes[MeshDescription.MESH_GRASS].bReceiveShadows = quality > 0;
        foreach (MeshRenderer mesh in Object.FindObjectsOfType<MeshRenderer>())
            if (mesh.name == "grass") mesh.receiveShadows = quality > 0;
        MeshDescription.meshes[MeshDescription.MESH_GRASS].bCastShadows = quality > 2;
        foreach (MeshRenderer mesh in Object.FindObjectsOfType<MeshRenderer>())
            if (mesh.name == "grass") mesh.shadowCastingMode = quality > 2
                    ? UnityEngine.Rendering.ShadowCastingMode.On
                    : UnityEngine.Rendering.ShadowCastingMode.Off;
    }

    [HarmonyPatch(typeof(MeshDescription))]
    [HarmonyPatch("SetGrassQuality")]
    public class MeshDescription_SetGrassQuality
    {
        static void Postfix()
        {
            ApplyGamePrefs();
        }
    }

}
