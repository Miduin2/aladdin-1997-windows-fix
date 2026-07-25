# GameVault Launcher

Lanzador nativo y sin consola para la edicion portable de Disney's Aladdin.

Responsabilidades:

- comprueba que no exista otra instancia del juego;
- aplica una posible actualizacion `ddraw.next.dll`;
- rota el registro anterior de GameVaultDraw;
- crea una ruta corta temporal mediante `SUBST` para evitar el desbordamiento
  del comando MCI MIDI del ejecutable de 1996;
- elimina temporalmente cualquier capa de compatibilidad asociada a esa ruta;
- inicia `ALADDINW.EXE`, espera su cierre y restaura siempre registro, entorno,
  resolucion y unidad temporal;
- muestra errores mediante cuadros de dialogo y escribe
  `GameVaultLauncher.log`.

La consola y PowerShell no forman parte del flujo normal de usuario.

La versión 0.1.0 del lanzador forma parte de GameVaultDraw 1.1.0 y fue validada
con el juego real. Su SHA-256 oficial es
`A358C5731A67524C28787BF866E20183ECE36B5171364471DFF0D4A25F97019D`.

La compilación pública no incrusta el icono extraído del juego original. Así el
parche puede distribuirse sin incluir recursos gráficos de Disney.
