# Validation record

Host: Windows 10 22H2, build 19045.6466

## Real-game acceptance

The game owner validated the complete flow: opening logos, main menu,
gameplay, MIDI music, voices, sound effects, 60 FPS, 4:3 presentation, task
switching, DWM preview, `F2`, `Esc`, difficulty, Joystick, Keyboard and input
remapping.

Version 1.1.2 additionally validates that the permanent busy cursor is hidden
during play, returns for `F2` Properties and the `Esc` exit dialog, and behaves
normally across Alt+Tab.

## Public binaries — 1.1.2

- `ddraw.dll`:
  `F60CDC156F40BB29866618D9AB2DEB9057E5C7B6A94939F37CDDD85A9106C45C`
- `GameVaultDraw.ini`:
  `57E0DF9C9C29CC8B147D400C917171ABACB6AC21DB5B01B758DCA07396E58167`
- `Play Aladdin.exe`:
  `6DF132AACFDFBBBAE3728BE6F208ABDEDFA0BE7C08E90462B35F9F48A9A361D8`

The following automated checks passed:

- x86 Release build;
- DirectDraw smoke test at 1920×1080, 32 bpp;
- native launcher integration test with a stub game;
- temporary `SUBST` path creation and removal;
- hidden/no-console launch and clean exit;
- installer and verified restore cycle;
- recipe round-trip to the exact patched executable hash;
- privacy scan for user paths, credentials, e-mail addresses and network
  identifiers.

The public binary has no icon extracted from the owned game and no local PDB
path.

## Privacy-audited screenshot

The README gameplay image contains only standard PNG image, colour and
resolution chunks. It has no EXIF or textual metadata, user paths or account
information.

## Historical diagnostic counts

| Evidence | Exceptions | Input subclasses | Pointer repairs |
|---|---:|---:|---:|
| `01-long-path-stack-overflow.log` | 1 | 0 | 0 |
| `02-joystick-em-getsel-crash.log` | 1 | 3 | 0 |
| `03-keyboard-em-getsel-crash.log` | 1 | 3 | 3 |
| `04-input-pages-clean-validation.log` | 0 | 17 | 57 |
| `05-final-real-game-validation.log` | 0 | 7 | 7 |

`06-console-free-launcher-validation.log` records the validated private launch
and its completed cleanup sequence.
