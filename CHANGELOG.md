# ⚠️ VERSIONS BELOW v0.0.7.4 ARE REMOVED ENTIRELY (and became lost media), DUE TO POSSIBLE COPYRIGHT PROBLEMS.

# v0.0.9 (2025.03.27)

- Fixed wooden table jiggle.
- Fixed drawers animation.
- Replaced something.
- Added a secret (which you cannot see normally (it is behind a wall), but if you see somehow, it will be reveal of another story character)
- Added more realistic display (spoiler - it isn't, just it is a once-time rendered 2D viewport (I hope it won't be a performance problem for mobile to render two more frame (because the viewport and a window inside it)))
- Added game seed support (map generator, hidden in protagonist's PC is an example of this mechanic)

# v0.0.8.10 (2025.03.14)

- Changed to AgX tonemap, instead of Filmic.
- Improved translation.
- Inventory: items can be viewed in first-person!
- Fog setting is hidden, due to uselessness.
- Added 4rd easter egg.

# v0.0.8.7 (2025.03.13)

- Added MSAA toggle-off, also disabled MSAA on Android
- Added resolution scaling.
- Added ability to make screnshots (PC only).
- Player now holds ActionItems with left hand.

# v0.0.8.6 (2025.03.11)

- Fixed chance of falling out of bounds when holding chair.

# v0.0.8.5 (2025.03.11)

- (Android) fixed SSAO removing hair from Julia (:D)
- Renamed the app to the actual name.

# v0.0.8.4 (2025.03.10)

- Added 3rd easter egg.
- (Android) Player can now use alternative interaction (such as dropping a toy on the floor) as long touch.
- Fix missing keymap action.

# v0.0.8.3 (2025.03.09)

- (Backend) Updated renderer check by using new Godot 4.4 function.
- Workaround a navigation bug, where Julia could pass through bathroom door.
- Player can now remove items from inventory!
- Added footstep sounds (they are quiet, but still can be heared (especially in house hall))
- Added my own 2-color shader as a photomode.

# v0.0.8.2 (2025.03.06)

- Added new in-game console (old console was deleted earlier in older versions, because of license issues).
- Fixed easter eggs not popping out
- Removed unnecessary check in touch controls.

# v0.0.8.1 (2025.03.05)

- Added initial Android support
- Fixed Photomode button translation

# v0.0.8 (2025.03.03)

- Upgraded to Godot 4.4 and switched to Jolt physics.
- Added photo mode.
- Added SSAO shader for OpenGL Compatibility (useful for old devices and Web)
- (Web) Fixed a bug, where Settings manager will still try user's settings, thus requiring cookies. **(later edit: it is impossible to disable cookies in Godot Web game due to checking user:// availability!!!)**
- Added no lights setting (except sun) - optimization for Web and low-end devices.
- Tweaked lights in the home hall, so there is no light leak into house
- Home lamp has now shadows (you can disable or enable in settings)
Godot 4.4+ specific updates:
- Added face IK to NPCs - they will look (not rotate) at you when is following you or speaking
- Julia's hair can wave now - added SpringBone.
- Increased the default thread limit - needed for Vulkan shader compilation.

# v0.0.7.4 (2025.02.24)
- Major NPC backend overhaul: imported wander support from my SCP game.
- Added support for game ratings for some countries.
- Added missing copyright notice, removed previous git history due to possible copyright violation.

# v0.0.7.3 (2025.02.20, lost media)
- Disable cookies in the Web build **(later edit: it is impossible to disable cookies in Godot Web game due to checking user:// availability!!!)**

# v0.0.7.2 (2025.02.19, lost media)
- Re-added main menu + door unlock sound.
- Added dynamic GI setting for Vulkan Windows demo.
- Health bar is now hidden for more realistic gameplay.


# v0.0.7.1 (2025.02.17, lost media)
- Decreased the build size to fit itch io limit for Web games!

# v0.0.7 (2025.02.17, lost media)
- Optimized elevator code + smooth move
- Remove human generator, since it is not used in this demo, except one pre-baked character -> optimized build.
- Dialogues now have fixed screen + the NPC is looking at you.
- NPC can now enter elevators.
- Workarounded a bug, where NPC cannot use NavigationLink, when elevator is moving.
- Added translations.
- Added third dialogue.
- USB disk item can now be picked up (unused now)


# v0.0.6.4 (2025.02.13, lost media)
- Re-added intro image

# v0.0.6 - v.0.0.6.3 (2025.02.12, lost media)
- Improved the look of the protagonist's home (thanks to advice from dscrd community).
- Added the whole home for the web demo.
- Patches included only decrease of the build size.

# v0.0.5 (2025.01.28, lost media)
- Initial release