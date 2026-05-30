# Future Agent Guide to this Quickshell Configuration

Welcome, future AI agent! 
This `AGENT.md` file contains a brain-dump of all the specific architectural choices, engine bugs, and workarounds implemented in this Quickshell configuration (specifically concerning QML, Mpris, and Pipewire). Read this carefully before touching the Media or Sound widgets to avoid introducing regressions.

## 1. QML Declarative Array Bugs (CRITICAL)
**Issue:** In Quickshell 0.11, binding a QML property directly to a C++ list value from the backend services (like `Mpris.players.values` or `Pipewire.nodes.values`) **will break**. The QML engine often fails to detect when these arrays mutate under the hood. For example, if you plug in a new speaker or open a new music player, the widget will permanently freeze on the old data and never update. 
**Solution:** Do **not** use declarative bindings for these arrays. Instead, use a strict imperative `Timer` loop (e.g. `interval: 250` or `200`) to constantly poll the values and manually push them into your QML properties. Check `Media.qml` and `SoundWidget.qml` to see this pattern in action.

## 2. Pipewire `audio-src` and Spotify Heuristic
**Issue:** Browsers and CEF wrappers (especially Spotify on Linux) are notorious for spawning audio streams lazily named `audio-src` or `Playback`. Furthermore, Quickshell's 0.11 `PwNode` implementation doesn't directly expose the `client` properties for these streams, effectively masking the identity of the application playing the audio.
**Solution:** `SoundWidget.qml` uses a smart heuristic. 
1. It tries to pull `application.process.binary` from the Pipewire client if possible.
2. If the stream defaults to the generic `audio-src` tag, the widget explicitly cross-references the running `Mpris` players to check if Spotify is active. If so, it manually flags the generic `audio-src` as "spotify", enabling the correct UI icon and label. **Do not block `audio-src`**.

## 3. MPRIS Cross-Referencing in SoundWidget
**Issue:** Applications like Brave and Chrome embed their active media title (like YouTube video names) natively into the Pipewire stream (`media.name`). Applications like Spotify and VLC do **not** do this, meaning their volume slider would normally just show "Spotify" instead of the song name.
**Solution:** The SoundWidget dynamically scans all active `Mpris.players.values`. If the Pipewire application name (e.g. "spotify") matches an MPRIS player's identity, the Sound widget steals the `trackTitle` directly from MPRIS and maps it onto the Pipewire volume slider.

## 4. Ghost Media Player Filtering
**Issue:** Quickshell's Mpris service often registers "ghost" media players (e.g., when a browser is open but not actually playing any media). If rendered, these show up as broken, empty widgets with no track titles.
**Solution:** `Media.qml` relies on a strict `isValidPlayer(p)` filter that ensures `trackTitle` or a valid fallback actually exists. Furthermore, `busName` is frequently unpopulated by Quickshell, so the Media module relies exclusively on `desktopEntry` and `identity` combined into a unique PID string to track state over time.

## 5. UI Structure Preferences
- The user prefers highly integrated, unified popups.
- For example, `SoundWidget.qml` displays the per-application volume sliders directly inside the main dropdown view alongside the master volume and device pickers, avoiding the use of nested sub-pages. 
- Ensure that text headings use `Theme.colors.textPrimary` for high visibility and contrast.
