# GameVaultDraw 1.1.0 oficial

Versión final validada de la restauración de compatibilidad para Disney's
Aladdin, incluida en *Disney Classic Video Games* (1997).

## Validación del 22 de julio de 2026

- Logos, menú, partida, música MIDI, voces y efectos correctos.
- Pantalla completa sin bordes a 4:3, ritmo estable de 60 FPS y sin cambiar la
  resolución del escritorio.
- Barra de tareas, Alt+Tab, miniatura y vista previa en vivo correctos.
- `F2` abre las opciones originales; Joystick y Keyboard ya no colapsan.
- Cambio de dificultad y reasignación de Throw de `X` a `C` comprobados.
- `Esc` pausa y muestra un diálogo funcional de salida Sí/No.
- Lanzador gráfico sin consola y limpieza automática de la unidad temporal.
- Cero excepciones durante las validaciones finales.

## Distribución

El ZIP oficial es un parche: no contiene el juego. `patch` incluye instalador,
restauración, DLL, configuración y lanzador. `source` permite auditar y
recompilar ambos componentes. `diagnostics` conserva las trazas que justifican
cada reparación.

Se preservan `GameVaultDraw_0.0.7_MVP.zip` y
`GameVaultDraw_1.0.0_Official.zip` como puntos de restauración históricos.
