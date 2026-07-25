#pragma once

namespace gamevaultdraw
{
// Installs narrowly-scoped Win32 compatibility hooks for the original
// Aladdin input property pages. Safe to call repeatedly.
void InstallInputCompatibility() noexcept;
}
