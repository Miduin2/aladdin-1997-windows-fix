# GameVault Launcher

Native, console-free launcher for the portable edition of Disney's Aladdin.

Responsibilities:

- checks that another game instance is not already running;
- applies a pending `ddraw.next.dll` update;
- rotates the previous GameVaultDraw log;
- creates a temporary short path with `SUBST` to prevent the 1996
  executable's MCI MIDI command buffer overflow;
- temporarily removes compatibility layers associated with that short path;
- starts `ALADDINW.EXE`, waits for it to close and always restores registry,
  environment, display mode and temporary drive state;
- displays errors in dialog boxes and writes
  `GameVaultLauncher.log`.

Neither a console window nor PowerShell is part of the normal launch flow.

Launcher version 1.1.1 is part of GameVaultDraw 1.1.1 and was validated with
the original game. Its official SHA-256 is
`44BA3FB33C0FFF64E31198CD5FE6810E10BF5C059656F06F020B620279FDF300`.

The public build does not embed an icon extracted from the original game, so
the patch can be distributed without including Disney artwork.
