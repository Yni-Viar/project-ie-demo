# v0.0.8

- Upgraded to Godot 4.4 and switched to Jolt physics.
- Added photo mode.
- Added SSAO shader for OpenGL Compatibility (useful for old devices and Web)
- (Web) Fixed a bug, where Settings manager will still try user's settings, thus requiring cookies.
- Added no lights setting (except sun) - optimization for Web and low-end devices.
- Tweaked lights in the home hall, so there is no light leak into house
- Home lamp has now shadows (you can disable or enable in settings)
Godot 4.4+ specific updates:
- Added face IK to NPCs - they will look (not rotate) at you when is following you or speaking
- Julia's hair can wave now - added SpringBone.
- Increased the default thread limit - needed for Vulkan shader compilation.

# v0.0.7.4
- Major NPC backend overhaul: imported wander support from my SCP game.
- Added support for game ratings for some countries.
- Added missing copyright notice, removed previous git history due to possible copyright violation.

# v0.0.7.3
- Disable cookies in the Web build

# v0.0.7.2
- Re-added main menu + door unlock sound.
- Added dynamic GI setting for Vulkan Windows demo.
- Health bar is now hidden for more realistic gameplay.


# v0.0.7.1
- Decreased the build size to fit itch io limit for Web games!

# v0.0.7
- Optimized elevator code + smooth move
- Remove human generator, since it is not used in this demo, except one pre-baked character -> optimized build.
- Dialogues now have fixed screen + the NPC is looking at you.
- NPC can now enter elevators.
- Workarounded a bug, where NPC cannot use NavigationLink, when elevator is moving.
- Added translations.
- Added third dialogue.
- USB disk item can now be picked up (unused now)


# v0.0.6.4
- Re-added intro image

# v0.0.6 - v.0.0.6.3
- Improved the look of the protagonist's home (thanks to advice from dscrd community).
- Added the whole home for the web demo.
- Patches included only decrease of the build size.

# v0.0.5
- Inityial release