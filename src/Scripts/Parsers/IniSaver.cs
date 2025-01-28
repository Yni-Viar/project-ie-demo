using Godot;
using System;

public partial class IniSaver : Node
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

    internal void SaveIni(string chunk, Godot.Collections.Array<string> names, Godot.Collections.Array datas, string output)
    {
        // Create new ConfigFile object.
        var config = new ConfigFile();

        // Store some values.
        for (int i = 0; i < names.Count; i++)
        {
            config.SetValue(chunk, names[i], datas[i]);
        }

        // Save it to a file (overwrite if already exists).
        config.Save(output);
    }
}
