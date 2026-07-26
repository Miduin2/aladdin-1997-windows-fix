# GameVaultDraw 1.1.2 — Cursor polish

This maintenance release removes the permanent animated Windows busy cursor
from the game surface.

The cursor is hidden only while the main game window is enabled. It returns
automatically for the native `F2` Properties panel, the `Esc` exit dialog and
ordinary Windows interaction after Alt+Tab.

All rendering, 4:3 scaling, 60 FPS pacing, audio, short-path launch, input-page
repair, taskbar and DWM preview behaviour from 1.1.1 is preserved.

Copy the contents of `patch` beside the supported original `ALADDINW.EXE`, run
`Install patch.cmd` once, and use `Play Aladdin.exe`.

No original game content is included.
