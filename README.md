# AnyTogether Scoop bucket

[Scoop](https://scoop.sh) manifests for [AnyPS5 Desktop](https://github.com/AnyTogether/AnyPS5-Desktop), the PS5 game launcher for Windows.

```powershell
scoop bucket add anytogether https://github.com/AnyTogether/scoop-bucket
scoop install anytogether/anyps5-desktop
```

Scoop unpacks the release's portable zip (`AnyPS5-Desktop-windows-x64.zip`, with SDL2 and the Visual C++ runtime beside the launcher) and adds **AnyPS5 Desktop** to the Start menu under *Scoop Apps*. No administrator rights are needed. For clips, broadcasting and Remote Play the launcher uses ffmpeg from the PATH, so `scoop install ffmpeg` is enough, or the launcher can download it itself.

## Updates

```powershell
scoop update anyps5-desktop
```

The launcher still says when a new version is out, but releases after 0.1.20 see that Scoop installed them: instead of downloading the Windows installer they show `scoop update anyps5-desktop` (Settings › About copies it), so Scoop keeps the only copy. 0.1.20's own update runs the installer, which puts a second copy in `%LOCALAPPDATA%\Programs\AnyPS5 Desktop` next to Scoop's, so on 0.1.20 turn off **Settings → Behaviour → Check for updates**.

Settings, profiles, logs, caches and downloaded engines live in `%APPDATA%\AnyPS5` and `%LOCALAPPDATA%\AnyPS5`, not in Scoop's folder, so updates and `scoop uninstall anyps5-desktop` leave them alone. Delete those two folders by hand to remove them as well. Your games and their saves stay where they are.

## How the manifest stays current

The manifest follows the latest stable release, never a nightly pre-release. A scheduled workflow (`.github/workflows/update.yml`) checks every 6 hours. When a new release is out, Scoop's own `checkver.ps1` moves the version, the zip's URL and its SHA-256 from the release's `SHA256SUMS`, the new manifest is installed and uninstalled with Scoop on Windows, and only then is it pushed. `.github/workflows/test.yml` does the same install test for every change, after checking the manifest against Scoop's schema.

The release's `SHA256SUMS` is signed (`SHA256SUMS.sig`, Ed25519, AnyPS5 release key `f8fe0d55df962105`); the launcher checks that signature for its own updates.
