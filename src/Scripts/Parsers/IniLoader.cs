using Godot;
using System;
/// <summary>
/// It is useful for loading data in data-driven scripts, such as Settings.
/// </summary>
public partial class IniLoader
{
	/// <summary>
	/// Loads INI (finally done)
	/// </summary>
	/// <param name="filename"></param>
	/// <param name="chunk">Chunk name (what is inside "[]")</param>
	/// <param name="chunkData">VChunk data, or parameters name</param>
	/// <returns>INI as Godot.Collections.Array</returns>
	internal Godot.Collections.Array LoadIni(string filename, string chunk, Godot.Collections.Array<string> chunkData)
	{
		var data = new Godot.Collections.Array();
		var config = new ConfigFile();
		
		// Load data from a file.
		Error err = config.Load(filename);
		
		// If the file didn't load, ignore it.
		if (err != Error.Ok)
		{
			GD.PrintErr("No file was loaded - error.");
			return data;
		}
		
		// Iterate over all sections.
		for (int i = 0; i < chunkData.Count; i++)
		{
			data.Add(config.GetValue(chunk, chunkData[i]));
		}
        return data;
	}
}