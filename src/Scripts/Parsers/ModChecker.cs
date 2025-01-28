using Godot;
using System;

public partial class ModChecker
{
	internal string mod_name;
	internal string config_version;
	internal string compatibility;
	internal bool CheckIni(string path)
	{
		var config = new ConfigFile();
		
		// Load data from a file.
		Error err = config.Load(path);
		
		// If the file didn't load, ignore it.
		if (err != Error.Ok)
		{
			return false;
		}

		config_version = (string)config.GetValue("Information", "ConfigVersion");

		if (config_version != "1.0.0")
		{
			return false;
		}
		
		// Iterate over all sections.
		foreach (String header in config.GetSections())
		{
			// Fetch the data for each section.
			mod_name = (string)config.GetValue(header, "Name");
			
			compatibility = (string)config.GetValue(header, "CompatibilityVersion");
		}

		if (compatibility != Globals.serverConfigCompatibility)
		{
			return false;
		}
		return true;
	}
}