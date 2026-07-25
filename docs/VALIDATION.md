# Validation record

Date: 2026-07-22  
Host: Windows 10 22H2, build 19045.6466

## Real-game acceptance

The game owner validated the complete flow with GameVaultDraw DLL SHA-256
`B421ADD985DE9AF3D2F5EE8FBAC037FFC66ADE696F02486CA8DD21642827B90B`
and the console-free launcher build SHA-256
`BB74321E051C10310D3E2904A352B6A4E55BAC376E84A35489BF2E313815B1A7`.
Rendering, audio, gameplay, 60 FPS, 4:3 presentation, task switching, DWM
preview, F2, Esc, difficulty, Joystick, Keyboard and remapping passed.

That private launcher embedded an icon extracted from the owned game. It is
preserved only in the private validation workspace and is **not** distributed.

## Public binaries — 1.1.1

The public DLL SHA-256 is
`B2200A365FB371DE34FFD87734086B4D3DF4174FED85F91FDD2E0B6660C05C27`
and the public launcher SHA-256 is
`44BA3FB33C0FFF64E31198CD5FE6810E10BF5C059656F06F020B620279FDF300`.
They are built from the same functional source after removing the third-party
icon and embedded local PDB paths. Version 1.1.1 changes only public naming,
English user-facing text, version metadata and the exit prompt; the validated
rendering and input paths are unchanged. The following passed:

- x86 Release build;
- two consecutive clean builds with identical SHA-256 output;
- native launcher integration test with a stub game;
- temporary `SUBST` path creation and removal;
- hidden/no-console launch and clean exit;
- installer, idempotence and verified restore cycle;
- Game Vault recipe round-trip to the exact patched executable hash;
- Microsoft Defender custom scan: zero detections for the release directory.
- privacy scan: no user profile paths, credentials, e-mail addresses or
  network identifiers in the public package.

The README gameplay image was separately audited. It contains only standard
PNG image, colour and resolution chunks, with no EXIF, textual metadata, user
paths or account information.

## Diagnostic counts

| Evidence | Exceptions | Input subclasses | Pointer repairs |
|---|---:|---:|---:|
| `01-long-path-stack-overflow.log` | 1 | 0 | 0 |
| `02-joystick-em-getsel-crash.log` | 1 | 3 | 0 |
| `03-keyboard-em-getsel-crash.log` | 1 | 3 | 3 |
| `04-input-pages-clean-validation.log` | 0 | 17 | 57 |
| `05-final-real-game-validation.log` | 0 | 7 | 7 |

`06-console-free-launcher-validation.log` records the validated private launch
and its completed cleanup sequence.
