# Reproducibility

## From an owned game copy

1. Obtain `ALADDINW.EXE` and the remaining Aladdin files from your own 1997
   *Disney Classic Video Games* disc/install.
2. Confirm the original executable SHA-256 is
   `77B7B7B03F80BAD087E23217D4CDCA51A5F93C550D0FF290B22EC7FB4694C209`.
3. Copy `patch` into that directory and run `Install patch.cmd`.
4. Confirm the resulting executable SHA-256 is
   `8CE7F608D1BFEF1F67B5495D33653ED602B1CA05BBFC521255D9D6DF48FB4740`.
5. Start only `Play Aladdin.exe` during normal use.

The repository recipe at
`recipes/disney-classic-aladdin-gamevaultdraw-v111.json` expresses the same
operation for the Game Vault CLI. From the separate Game Vault project root:

```powershell
python -m gamevault prepare-compat `
  --recipe <THIS_REPOSITORY>\recipes\disney-classic-aladdin-gamevaultdraw-v111.json `
  --game-dir <ORIGINAL_GAME_DIRECTORY> `
  --components-dir <EXTRACTED_RELEASE>\patch `
  --output <NEW_OUTPUT_DIRECTORY>
```

The recipe validates each input, component and intermediate executable hash.
It never patches the owned source directory in place.

## Build from source

The exact source snapshots are under `src/gamevaultdraw` and
`src/gamevaultlauncher`. Both are 32-bit C++ projects built with Visual
Studio 2022 Build Tools and the Windows SDK. Run each `build.cmd`; then compare:

- `ddraw.dll`: `B2200A365FB371DE34FFD87734086B4D3DF4174FED85F91FDD2E0B6660C05C27`
- `Play Aladdin.exe`: `44BA3FB33C0FFF64E31198CD5FE6810E10BF5C059656F06F020B620279FDF300`

The public projects disable PE debug information so local PDB paths are not
embedded and pass `/Brepro` to the linker. Repeated clean builds with the
documented toolchain produce the hashes above. A different compiler or SDK may
still change the binary output; functional reproducibility is also defined by
the included source, tests, component behaviour and strict game-output hash.
