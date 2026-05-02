[Back to README](../README.md)

## OmniSharp: No .NET SDKs Were Found

**Symptom:** When opening a `.cs` file you get a notification that OmniSharp failed. The LSP log contains:

```
No .NET SDKs were found.
System.InvalidOperationException: Failed to find all versions of .NET Core MSBuild.
```

**Cause:** Mason installs the OmniSharp binary correctly, but OmniSharp also requires the **.NET SDK** (v8+) installed system-wide to locate MSBuild. Unity ships with its own runtime and does not install the .NET SDK globally.

**Fix:** The setup scripts handle this automatically when the vstuc flag is passed — .NET SDK 8 is installed if not already present:

```bash
# Linux
bash ~/.config/nvim/scripts/setup.sh --install-vstuc
```

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File $env:LOCALAPPDATA\nvim\scripts\setup.ps1 -InstallVstuc
```

If you set up manually, install the .NET SDK 8 from https://aka.ms/dotnet/download, then restart Neovim.

---

## Generating a .sln File for a Unity Project

OmniSharp requires a `.sln` file to understand your Unity project structure.

### Step 1 — Generate .csproj files from Unity

Unity generates `.csproj` files when an external editor is configured. In Unity:

**Preferences > External Tools > Regenerate Project Files**

This produces `Assembly-CSharp.csproj` and related files in your project root. No specific editor needs to stay configured — just click the button once.

### Step 2 — Generate the .sln from nvim

With a `.cs` file open inside the Unity project, run:

```
:GenUnitySln
```

This calls `dotnet new sln` and `dotnet sln add` on the generated `.csproj` files, creates `<ProjectName>.sln` in the project root, and restarts OmniSharp automatically. Visual Studio is not required.

[Back to README](../README.md)

