using System.Collections.Generic;
using UnityEngine;

public class PrettyGrassCmd : ConsoleCmdAbstract
{

    private static string info = "PrettyGrass";

    public override string[] GetCommands()
    {
        return new string[2] { info, "pg" };
    }

    public override string GetDescription() => "Pretty Grass Render Settings";

    public override string GetHelp() => "Fine tune how grass and bushes are rendered\n";

    public override void Execute(List<string> _params, CommandSenderInfo _senderInfo)
    {

        if (_params.Count == 1)
        {
            switch (_params[0])
            {
                case "new":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].
                        material.shader = OcbPrettyGrass.Shader;
                    break;
                case "old":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].
                        material.shader = Shader.Find("Game/SwayingGrass Surface");
                    break;
                case "cast+":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].bCastShadows = true;
                    foreach (MeshRenderer mesh in Object.FindObjectsOfType<MeshRenderer>())
                        if (mesh.name == "grass") mesh.shadowCastingMode =
                                UnityEngine.Rendering.ShadowCastingMode.On;
                    break;
                case "cast-":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].bCastShadows = false;
                    foreach (MeshRenderer mesh in Object.FindObjectsOfType<MeshRenderer>())
                        if (mesh.name == "grass") mesh.shadowCastingMode =
                                UnityEngine.Rendering.ShadowCastingMode.Off;
                    break;
                case "recv+":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].bReceiveShadows = true;
                    foreach (MeshRenderer mesh in Object.FindObjectsOfType<MeshRenderer>())
                        if (mesh.name == "grass") mesh.receiveShadows = true;
                    break;
                case "recv-":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].bReceiveShadows = false;
                    foreach (MeshRenderer mesh in Object.FindObjectsOfType<MeshRenderer>())
                        if (mesh.name == "grass") mesh.receiveShadows = false;
                    break;
                default:
                    Log.Warning("Unknown command " + _params[0]);
                    break;
            }
        }

        if (_params.Count == 3)
        {
            switch (_params[0])
            {
                case "set_float_uniform":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat(_params[1], float.Parse(_params[2]));
                    break;
                case "set_color_uniform":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetColor(_params[1], StringParsers.ParseColor32(_params[2]));
                    break;
            }
        }

        if (_params.Count == 2)
        {
            switch (_params[0])
            {

                case "Al":
                case "AlbedoFactor":
                    OcbPrettyGrass.AlbedoFactor = float.Parse(_params[1]);
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_AlbedoFactor", OcbPrettyGrass.AlbedoFactor);
                    break;
                case "Sp":
                case "SpecularFactor":
                    OcbPrettyGrass.SpecularFactor = float.Parse(_params[1]);
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_SpecularFactor", OcbPrettyGrass.SpecularFactor);
                    break;
                case "Sm":
                case "SmoothnessFactor":
                    OcbPrettyGrass.SmoothnessFactor = float.Parse(_params[1]);
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_SmoothnessFactor", OcbPrettyGrass.SmoothnessFactor);
                    break;
                case "Oc":
                case "OcclusionFactor":
                    OcbPrettyGrass.OcclusionFactor = float.Parse(_params[1]);
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_OcclusionFactor", OcbPrettyGrass.OcclusionFactor);
                    break;
                case "Tr":
                case "TranslucencyFactor":
                    OcbPrettyGrass.TranslucencyFactor = float.Parse(_params[1]);
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_TranslucencyFactor", OcbPrettyGrass.TranslucencyFactor);
                    break;

                    
                case "get_float_uniform":
                    Log.Out("Uniform " + _params[1] + " => " + MeshDescription.meshes
                        [MeshDescription.MESH_GRASS].material.GetFloat(_params[1]));
                    break;
                case "get_color_uniform":
                    Log.Out("Uniform " + _params[1] + " => " + MeshDescription.meshes
                        [MeshDescription.MESH_GRASS].material.GetColor(_params[1]));
                    break;

                case "distance":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_FadeDistance", float.Parse(_params[1]));
                    break;
                case "translucency":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_Translucency", float.Parse(_params[1]));
                    break;

                case "distortion":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_TransNormalDistortion", float.Parse(_params[1]));
                    break;
                case "scattering":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_TransScattering", float.Parse(_params[1]));
                    break;
                case "direct":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_TransDirect", float.Parse(_params[1]));
                    break;
                case "ambient":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_TransAmbient", float.Parse(_params[1]));
                    break;
                case "shadow":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_TransShadow", float.Parse(_params[1]));
                    break;
                case "intensity":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_Translucency_Intensity", float.Parse(_params[1]));
                    break;
                case "color":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetColor("_Translucency_Color", StringParsers.ParseColor32(_params[1]));
                    break;
                case "specular":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetColor("_Specular_Color", StringParsers.ParseColor32(_params[1]));
                    break;

                case "smoothness":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_Smoothness", float.Parse(_params[1]));
                    break;
                case "cutoff":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_Cutoff", float.Parse(_params[1]));
                    break;
                default:
                    Log.Warning("Unknown command " + _params[0]);
                    break;

                // Some hidden features for debugging the shader
                case "f1":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_F1", float.Parse(_params[1]));
                    break;
                case "f2":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_F2", float.Parse(_params[1]));
                    break;
                case "f3":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_F3", float.Parse(_params[1]));
                    break;
                case "f4":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_F4", float.Parse(_params[1]));
                    break;
                case "f5":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_F5", float.Parse(_params[1]));
                    break;
                case "f6":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_F6", float.Parse(_params[1]));
                    break;
                case "f7":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_F7", float.Parse(_params[1]));
                    break;
                case "f8":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_F8", float.Parse(_params[1]));
                    break;
                case "f9":
                    MeshDescription.meshes[MeshDescription.MESH_GRASS].material
                        .SetFloat("_F9", float.Parse(_params[1]));
                    break;

            }
        }
    }
}
