using HarmonyLib;
using OCB;
using System.IO;
using System.Reflection;
using UnityEngine;

public class OcbPrettyGrass : IModApi
{

    public static Shader Shader = null;

    public static float AlbedoFactor = 0.6f;
    public static float SpecularFactor = 1.0f;
    public static float SmoothnessFactor = 0.8f;
    public static float OcclusionFactor = 0.6f;
    public static float TranslucencyFactor = 0.4f;

    public static bool HasCrookedDeco(Mod mod)
    {
        foreach (string path in Directory.GetDirectories(mod.Path + "/.."))
        {
            if (path.ContainsCaseInsensitive("CrookedDeco") &&
                File.Exists(path + "/ModInfo.xml"))
                    return true;
        }
        return false;
    }

    public void InitMod(Mod mod)
    {
        if (GameManager.IsDedicatedServer) return;
        Log.Out("OCB Harmony Patch: " + GetType().ToString());
        Harmony harmony = new Harmony(GetType().ToString());
        harmony.PatchAll(Assembly.GetExecutingAssembly());
        var ShaderBundle = mod.Path + "/Resources/GrassShader.unity3d";
        if (SystemInfo.graphicsDeviceType == UnityEngine.Rendering.GraphicsDeviceType.Metal)
            ShaderBundle = Path.Combine(mod.Path, "Resources/GrassShader.metal.unity3d");
        AssetBundle bundle = AssetBundle.LoadFromFile(ShaderBundle);
        Shader = bundle.LoadAsset<Shader>("assets/grass.shader");
        ModEvents.GameStartDone.RegisterHandler(ApplyGamePrefs);
    }

    static public void ApplyGamePrefs()
    {
        if (GameStats.GetInt(EnumGameStats.GameState) == 0)
        {
            return;
        }

        MeshDescription.meshes[MeshDescription.MESH_GRASS].material.shader = Shader;
        int quality = GamePrefs.GetInt(EnumGamePrefs.OptionsGfxTerrainQuality);
        MeshDescription.meshes[MeshDescription.MESH_GRASS].bReceiveShadows = quality > 0;
        foreach (MeshRenderer mesh in Object.FindObjectsOfType<MeshRenderer>())
            if (mesh.name == "grass") mesh.receiveShadows = quality > 0;
        MeshDescription.meshes[MeshDescription.MESH_GRASS].bCastShadows = quality > 2;
        foreach (MeshRenderer mesh in Object.FindObjectsOfType<MeshRenderer>())
            if (mesh.name == "grass") mesh.shadowCastingMode = quality > 2
                    ? UnityEngine.Rendering.ShadowCastingMode.On
                    : UnityEngine.Rendering.ShadowCastingMode.Off;
        MeshDescription.meshes[MeshDescription.MESH_GRASS].material
            .SetFloat("AlbedoFactor", AlbedoFactor);
        MeshDescription.meshes[MeshDescription.MESH_GRASS].material
            .SetFloat("SpecularFactor", SpecularFactor);
        MeshDescription.meshes[MeshDescription.MESH_GRASS].material
            .SetFloat("SmoothnessFactor", SmoothnessFactor);
        MeshDescription.meshes[MeshDescription.MESH_GRASS].material
            .SetFloat("OcclusionFactor", OcclusionFactor);
        MeshDescription.meshes[MeshDescription.MESH_GRASS].material
            .SetFloat("TranslucencyFactor", TranslucencyFactor);
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

    [HarmonyPatch(typeof(BlockShapeBillboardPlant))]
    [HarmonyPatch("RenderSpinMesh")]
    public class BlockShapeBillboardPlant_RenderSpinMesh
    {

        static readonly ulong Seed01 = StaticRandom.RandomSeed();
        static readonly ulong Seed02 = StaticRandom.RandomSeed();
        static readonly ulong Seed03 = StaticRandom.RandomSeed();
        static readonly ulong Seed04 = StaticRandom.RandomSeed();
        static readonly ulong Seed05 = StaticRandom.RandomSeed();

        static bool Prepare(MethodBase original) =>
            ModManager.GetMod("OcbCrookedDeco") == null;

        static void Prefix(Vector3 _drawPos,
            ref BlockShapeBillboardPlant.RenderData _data)
        {
            ulong seed = Seed01;
            StaticRandom.HashSeed(ref seed, _drawPos.x);
            StaticRandom.HashSeed(ref seed, _drawPos.y);
            StaticRandom.HashSeed(ref seed, _drawPos.z);
            _data.count += StaticRandom.RangeSquare(0,
                MeshDescription.GrassQualityPlanes, seed);
            StaticRandom.HashSeed(ref seed, Seed02);
            _data.scale *= StaticRandom.Range(0.8f, 1.2f, seed);
            StaticRandom.HashSeed(ref seed, Seed03);
            _data.rotation += StaticRandom.Range(-22.5f, 22.5f, seed);
            StaticRandom.HashSeed(ref seed, Seed04);
            _data.height *= StaticRandom.RangeSquare(0.9f, 1.3f, seed);
            StaticRandom.HashSeed(ref seed, Seed05);
            _data.sideShift += StaticRandom.RangeSquare(-.2f, .2f, seed);
        }
    }

    [HarmonyPatch(typeof(BlockShapeBillboardPlant))]
    [HarmonyPatch("RenderGridMesh")]
    public class BlockShapeBillboardPlant_RenderGridMesh
    {

        static readonly ulong Seed01 = StaticRandom.RandomSeed();
        static readonly ulong Seed02 = StaticRandom.RandomSeed();
        static readonly ulong Seed03 = StaticRandom.RandomSeed();
        static readonly ulong Seed04 = StaticRandom.RandomSeed();
        static readonly ulong Seed05 = StaticRandom.RandomSeed();

        static bool Prepare(MethodBase original) =>
            ModManager.GetMod("OcbCrookedDeco") == null;

        static void Prefix(Vector3 _drawPos,
            ref BlockShapeBillboardPlant.RenderData _data)
        {
            ulong seed = Seed01;
            StaticRandom.HashSeed(ref seed, _drawPos.z);
            StaticRandom.HashSeed(ref seed, _drawPos.y);
            StaticRandom.HashSeed(ref seed, _drawPos.x);
            _data.count += StaticRandom.RangeSquare(0,
                MeshDescription.GrassQualityPlanes, seed);
            StaticRandom.HashSeed(ref seed, Seed02);
            _data.scale *= StaticRandom.Range(0.8f, 1.2f, seed);
            StaticRandom.HashSeed(ref seed, Seed03);
            _data.rotation += StaticRandom.Range(-22.5f, 22.5f, seed);
            StaticRandom.HashSeed(ref seed, Seed04);
            _data.height *= StaticRandom.RangeSquare(0.9f, 1.3f, seed);
            StaticRandom.HashSeed(ref seed, Seed05);
            _data.sideShift += StaticRandom.RangeSquare(-.2f, .2f, seed);
        }
    }

}
