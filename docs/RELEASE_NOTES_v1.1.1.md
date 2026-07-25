# GameVaultDraw 1.1.1 — International release

This maintenance release makes the public package consistently accessible to
international users. It does not change the supported game edition or include
any original game content.

## Changes since 1.1.0

- The launcher is now named `Play Aladdin.exe`.
- The installer and restoration tools are now `Install patch.cmd` and
  `Restore original.cmd`.
- Installer, launcher and exit-dialog text is now in English.
- Executable metadata and version information now match release 1.1.1.
- The project page includes a privacy-audited gameplay screenshot.

## Installation

Copy the contents of `patch` beside the supported original `ALADDINW.EXE`, run
`Install patch.cmd` once, then use `Play Aladdin.exe`.

The installer verifies the exact supported executable, creates a verified
backup and refuses unknown versions. `Restore original.cmd` restores that
backup.

## Privacy and copyright

The screenshot contains no embedded text, EXIF data, user paths or account
information. The release contains no original executable, music, artwork or
other game asset.
