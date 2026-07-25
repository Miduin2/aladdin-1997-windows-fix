# Aladdin 1997 Windows Fix

An unofficial compatibility fix for the Windows version of *Disney's Aladdin*
included in the 1997 *Disney Classic Video Games* compilation.

It restores correct graphics, sound, timing and modern Windows integration
while keeping the original game data. The project was developed from a
personally owned physical copy and validated on Windows 10 22H2.

> This repository and its downloads contain **no game executable, music,
> artwork or other Disney assets**. You need your own original disc or
> installation.

## Download and install

1. Open the [latest release](https://github.com/Miduin2/aladdin-1997-windows-fix/releases/latest).
2. Download the named `GameVaultDraw_*.zip` asset. Do not download GitHub's
   automatically generated “Source code” archives unless you want to compile
   the project yourself.
3. Extract the ZIP.
4. Copy the contents of its `patch` directory beside your original
   `ALADDINW.EXE` and MIDI files.
5. Run `Instalar parche.cmd` once.
6. Start the game with `Jugar Aladdin.exe`.

The installer verifies the exact original executable before changing anything,
creates a checked backup and refuses unsupported versions. Run
`Restaurar original.cmd` to restore the verified original executable.

## What it fixes

- obsolete 256-colour detection;
- privileged x86 `CLI` and `STI` instructions rejected by modern Windows;
- invalid DirectDraw destination rectangles and 8-bit palette handling;
- black output, unstable exclusive fullscreen and uncontrolled game speed;
- long-path MCI/MIDI crashes;
- taskbar, Alt+Tab, thumbnail and live-preview integration;
- crashes in the original Joystick and Keyboard settings pages;
- access to the original Properties panel with `F2`;
- a safe pause-and-exit dialog with `Esc`.

The default presentation is borderless 4:3 at 60 FPS and does not change the
desktop resolution.

## Supported executable

- Original SHA-256: `77B7B7B03F80BAD087E23217D4CDCA51A5F93C550D0FF290B22EC7FB4694C209`
- Patched SHA-256: `8CE7F608D1BFEF1F67B5495D33653ED602B1CA05BBFC521255D9D6DF48FB4740`

Only that exact executable is supported. No unknown executable is modified.

## Source and technical documentation

- `src/gamevaultdraw`: the 32-bit DirectDraw compatibility layer;
- `src/gamevaultlauncher`: the native console-free short-path launcher;
- `installer`: auditable installation and restoration scripts;
- `recipes`: the strict Game Vault patch recipe;
- `docs/TECHNICAL_REPORT.es.md`: complete Spanish technical report;
- `docs/REPRODUCIBILITY.md`: build and reproduction instructions;
- `docs/VALIDATION.md`: validation record;
- `diagnostics`: sanitized evidence for the repaired failures.

The compiled `ddraw.dll` and `Jugar Aladdin.exe` are distributed in the
release asset, not committed to the source tree.

## Estado en español

La versión 1.1.0 fue validada con logos, menú, partida, música MIDI, voces,
efectos, dificultad, reasignación de teclado, páginas Joystick y Keyboard,
`F2`, `Esc`, barra de tareas y `Alt+Tab`. El parche no incluye ningún archivo
del juego y solo acepta el ejecutable original cuyo hash aparece arriba.

## Disclaimer

This is an independent, unofficial preservation and compatibility project. It
is not affiliated with, endorsed by or sponsored by Disney or the original
game's developers and publishers. All third-party names, trademarks and game
assets belong to their respective owners.

## License

The original compatibility code, launcher and scripts in this repository are
available under the [MIT License](LICENSE). That licence does not apply to the
original game or any third-party property.
