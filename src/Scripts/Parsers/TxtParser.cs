using Godot;
using System;

public partial class TxtParser : Node
{
    /// <summary>
    /// Saves TXT file
    /// </summary>
    /// <param name="path">Path to save</param>
    /// <param name="content">Content to save</param>
    public static void Save(string path, string content)
    {
        FileAccess file = FileAccess.Open(path, FileAccess.ModeFlags.Write);
        file.StoreString(content);
        file.Close();
    }
    /// <summary>
    /// Loads TXT file
    /// </summary>
    /// <param name="path">Path to read</param>
    /// <returns>Content from TXT file</returns>
    public static string Load(string path)
    {
        FileAccess file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
        string content = file.GetAsText();
        file.Close();
        return content;
    }
}