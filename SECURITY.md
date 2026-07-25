# Security

## Supported version

Only the latest published release is supported.

## Reporting a problem

Open a GitHub issue for reproducible bugs that do not contain private data or
copyrighted game files. Do not attach `ALADDINW.EXE`, game assets, disc images,
account details, personal paths or other sensitive information.

If a report may expose a security vulnerability, use GitHub's private
vulnerability reporting feature when it is available for this repository.

## Safety properties

The installer:

- accepts only the documented original executable SHA-256;
- verifies every distributed patch component;
- creates a verified backup before applying three one-byte edits;
- refuses unknown or changed executables;
- provides a verified restoration path.
