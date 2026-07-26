# Informe técnico — restauración de Disney's Aladdin para Windows

## Resultado

GameVaultDraw 1.1.2 ejecuta la conversión Windows incluida en *Disney Classic
Video Games* (1997) sin máquina virtual, sin cambiar la resolución de Windows y
sin depender de wrappers genéricos. La prueba final cubrió una partida real,
audio completo, 60 FPS, pantalla sin bordes 4:3, Alt+Tab, miniaturas DWM, cambio
de dificultad y reasignación de controles.

## Síntomas, causas y reparaciones

| Síntoma | Causa observada | Reparación |
|---|---|---|
| “Aladdin must run in at least 256 colours” | Comprobación de profundidad de color propia de Win95 | Salto `JAE` convertido en salto incondicional en `0x2E0B` |
| “A privileged instruction was executed at 00409592” | Uso de las instrucciones x86 `CLI` y `STI` desde proceso de usuario | Ambos opcodes se sustituyen por `NOP` en `0x8992` y `0x89A0` |
| Ventana negra o blit fallido | El juego entrega un borde inferior de `RECT` no inicializado | El proxy deriva únicamente esa altura desde el rectángulo fuente válido |
| Paleta incorrecta o DirectDraw rechaza `SetPalette` | Superficie convertida a 32 bits frente a lógica VGA de 8 bits | Asociación de paleta lógica cuando DirectDraw devuelve `DDERR_INVALIDPIXELFORMAT` |
| Caída tras los logos desde una ruta larga | El comando MCI terminado en `title.mid alias 0 wait` desborda un búfer fijo y pisa la dirección de retorno | El lanzador crea una unidad `SUBST` temporal con ruta corta y la elimina al salir |
| Juego diminuto/acelerado o fullscreen inestable | Presentación Win9x ligada al modo de vídeo y al ritmo de blit | Presentación sin bordes 4:3, sin cambio de modo, con limitador a 60 FPS |
| No aparece bien en barra de tareas/Alt+Tab | Ventana heredada con propietario y estilos incompatibles | Ventana activable `WS_EX_APPWINDOW`, sin propietario heredado |
| Miniatura vertical o negra | DWM no captura correctamente la primaria DirectDraw | Miniatura y live preview de 32 bits generadas desde el último frame 320×200 |
| No se puede abrir el menú oculto | La presentación sin bordes retira la barra de menú nativa | `F2` envía el comando nativo `WM_COMMAND 201` de Properties |
| `Esc` no hace nada | Esta conversión recibe la tecla pero no ofrece salida moderna | Diálogo modal seguro; No por defecto y Sí envía `WM_CLOSE` |
| Joystick/Keyboard cierran el juego | Diez callbacks de 1996 truncan a 16 bits el `WPARAM` puntero de `EM_GETSEL` | Hooks IAT limitados a esos callbacks reconstruyen el puntero usando el `LPARAM` adyacente |

## Cambio binario mínimo

El ejecutable original y el final difieren en exactamente tres bytes:

| Offset de archivo | Original | Final | Significado |
|---:|---:|---:|---|
| `0x2E0B` | `73` | `EB` | omitir comprobación de color obsoleta |
| `0x8992` | `FA` | `90` | neutralizar `CLI` |
| `0x89A0` | `FB` | `90` | neutralizar `STI` |

Huellas SHA-256 intermedias, útiles para reproducir y auditar la secuencia:

1. Original: `77B7B7B03F80BAD087E23217D4CDCA51A5F93C550D0FF290B22EC7FB4694C209`.
2. Tras `0x2E0B`: `4AFBFA0D4C7BA1C00E5172B9162EF94A28D5E93F162CF88B155951BE70A71151`.
3. Tras `0x8992`: `23D2F2FC2F3CEA161EDE3938A1012BAB0C3A7AC565341CC3CDC960F9DCEDE219`.
4. Final: `8CE7F608D1BFEF1F67B5495D33653ED602B1CA05BBFC521255D9D6DF48FB4740`.

## Alcance del wrapper

`ddraw.dll` es una DLL x86 local: Windows sólo la carga junto a este juego. La
DLL reenvía a la implementación DirectDraw del sistema y envuelve las
interfaces necesarias. No se instala en `System32`, no se inyecta en otros
procesos y no llama a `ChangeDisplaySettings`.

La reparación de entrada tampoco sustituye globalmente `USER32`. Modifica dos
entradas IAT del ejecutable (`SetWindowLongA` y `CallWindowProcA`), reconoce
únicamente los siete callbacks de Keyboard y tres de Joystick por RVA y sólo
reconstruye el puntero del mensaje documentado `EM_GETSEL` cuando ambos
punteros quedan adyacentes.

## Intentos descartados

Las capas de compatibilidad de Windows, 256 colores y 640×480 permitieron
observar partes del juego, pero no dieron una experiencia estable. Las pruebas
con wrappers genéricos (DDrawCompat, dgVoodoo y cnc-ddraw) produjeron según la
combinación pantalla negra, cambios de tamaño repetidos, caídas o un flujo de
Alt+Enter frágil. Esas pruebas sirvieron para aislar color, DirectDraw, ruta y
temporización; la solución final implementa sólo el comportamiento demostrado
por las trazas de este ejecutable.

## Evidencia conservada

`diagnostics` incluye seis trazas renombradas y ordenadas: desbordamiento por
ruta larga, caída de Joystick, caída posterior de Keyboard, validación limpia
de las diez subclases, ejecución real final y limpieza del lanzador sin consola.
Los hashes de todos los archivos figuran en `SHA256SUMS.txt`.
