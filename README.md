# Conferencia de Estaca — Sistema de Asistencia
### Estaca Ensenada México · 23 y 24 de mayo de 2026

Sistema web completo para gestionar la asistencia a la Sesión General del domingo 24 de mayo de 2026. Funciona 100% en el navegador usando **Supabase** como base de datos en la nube — sin servidor propio.

---

## Descripción del sistema

| Módulo | Archivo | Dispositivo |
|---|---|---|
| Página de inicio | `index.html` | Cualquiera |
| Administrador | `admin.html` | Computadora |
| Escáner QR | `scanner.html` | Celular (Chrome) |
| Dashboard en vivo | `dashboard.html` | Pantalla grande / proyector |

**Flujo general:**
1. El administrador genera 1,100 boletos (100 por cada una de las 11 unidades)
2. Se imprimen en PDF y se entregan físicamente a cada barrio/rama
3. El día del evento, 4-6 personas escanean los boletos en la puerta con sus celulares
4. El dashboard muestra en tiempo real cuántas personas han llegado por unidad

---

## Unidades de la Estaca (11)

| ID | Nombre | Cupo | Color |
|---|---|---|---|
| BAR01 | Barrio Alisos | 100 | `#E63946` |
| BAR02 | Barrio Azteca | 100 | `#457B9D` |
| BAR03 | Barrio Bahía | 100 | `#2A9D8F` |
| BAR04 | Barrio Chapultepec | 100 | `#E9A820` |
| BAR05 | Barrio Geranios | 100 | `#F4A261` |
| BAR06 | Barrio Hidalgo | 100 | `#6A4C93` |
| BAR07 | Barrio Lomitas | 100 | `#06D6A0` |
| BAR08 | Barrio San Quintín | 100 | `#8338EC` |
| BAR09 | Barrio Universidad | 100 | `#FB8500` |
| BAR10 | Barrio Valle Dorado | 100 | `#3A86FF` |
| RAM01 | Rama Maneadero | 100 | `#FF006E` |

---

## Stack tecnológico

| Capa | Tecnología | Uso |
|---|---|---|
| Base de datos | [Supabase](https://supabase.com) (PostgreSQL) | Almacenamiento de boletos y registros |
| Tiempo real | Supabase Realtime | Actualización instantánea del dashboard |
| Escáner QR | [html5-qrcode](https://github.com/mebjas/html5-qrcode) | Acceso a cámara y decodificación |
| Generación QR | [QRCode.js](https://github.com/davidshimjs/qrcodejs) | QR en los boletos PDF |
| PDF | [jsPDF](https://github.com/parallax/jsPDF) | Impresión de boletos |
| Gráficas | [Chart.js](https://chartjs.org) | Dashboard visual |
| Frontend | HTML / CSS / JS vanilla | Sin frameworks pesados |

Todas las librerías se cargan desde CDN — no hay `npm install` ni proceso de compilación.

---

## Configuración inicial

### 1. Crear proyecto en Supabase

1. Ve a [supabase.com](https://supabase.com) y crea una cuenta gratuita
2. Crea un nuevo proyecto (anota la contraseña de la base de datos)
3. Espera a que el proyecto termine de inicializarse (~2 min)

### 2. Ejecutar el schema SQL

1. En tu proyecto de Supabase ve a **SQL Editor → New query**
2. Copia y pega el contenido completo de `schema.sql`
3. Haz clic en **Run ▶**
4. Verifica que no aparezcan errores

Esto crea:
- Tabla `unidades` con las 11 unidades preinsertadas
- Tabla `boletos` (códigos BAR01-0001 a RAM01-0100)
- Tabla `registros` (cada escaneo exitoso)
- Políticas RLS de acceso público

**Política adicional requerida** — ejecuta también esto en el SQL Editor:
```sql
CREATE POLICY "insercion_publica_boletos"
  ON boletos FOR INSERT
  TO anon
  WITH CHECK (true);
```

### 3. Habilitar Realtime

Para que el dashboard se actualice en vivo, ejecuta en el SQL Editor:
```sql
ALTER PUBLICATION supabase_realtime ADD TABLE registros;
```

### 4. Obtener las credenciales API

1. En Supabase ve a **Settings → API**
2. Copia la **Project URL** → algo como `https://xxxxxxxxxxxx.supabase.co`
3. Copia la **anon / public key** → JWT largo que empieza con `eyJhbGci...`

### 5. Configurar `config.js`

Abre el archivo `config.js` y reemplaza los valores:

```js
const SUPABASE_URL = 'https://TU-PROJECT-REF.supabase.co';
const SUPABASE_PUBLISHABLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

> ⚠️ La anon key es segura para el frontend — las políticas RLS de Supabase controlan el acceso.

---

## Despliegue (hosting)

Para que el escáner funcione en celulares se requiere **HTTPS**. Opciones recomendadas:

### Vercel (recomendado — gratis)
1. Crea cuenta en [vercel.com](https://vercel.com)
2. Conecta este repositorio de GitHub
3. Click en **Deploy** — en 2 minutos tienes una URL con HTTPS
4. Opcional: agrega un dominio propio en Settings → Domains

### Netlify
1. Ve a [netlify.com](https://netlify.com)
2. Conecta el repositorio de GitHub
3. Deploy automático en cada push a `main`

### Local (para pruebas)
```bash
python3 -m http.server 8080
# Accede desde celular en la misma red WiFi:
# http://192.168.X.X:8080/scanner.html
```

---

## Guía de uso — Antes del evento

### Módulo Administrador (`admin.html`)

**Contraseña:** `Ensenada2026`

#### Generar boletos
1. Inicia sesión con la contraseña
2. Haz clic en **"⚡ Generar boletos para todas las unidades"**
3. Confirma el diálogo
4. Espera el progreso (inserta 1,100 registros en Supabase, ~1-2 min)
5. Solo necesitas hacerlo **una sola vez**

#### Imprimir boletos en PDF
1. Una vez generados, haz clic en **"🖨 PDF"** junto a cada unidad
2. Se descarga un PDF con 6 boletos por página (formato 9×6 cm, tarjeta apaisada)
3. Imprime en papel normal o cartulina
4. Recorta y entrega los 100 boletos al líder de cada barrio/rama

**Diseño del boleto:**
- Encabezado dorado: "CONFERENCIA DE ESTACA"
- Nombre de la estaca y fecha de la sesión
- Franja de color del barrio/rama
- Número de boleto (ej. Boleto #0042)
- Código QR grande con el código exacto (ej. `BAR01-0042`)

#### Boleto de prueba
- Botón **"🧪 Boleto de prueba"** → genera 1 boleto de muestra sin necesidad de generar los 100
- Útil para verificar el diseño y probar el escáner antes del evento
- Inserta automáticamente ese código en Supabase para que el escáner lo valide

#### Exportar datos
- **"📊 Exportar CSV completo"** → descarga todos los registros con: código, unidad, hora de registro, dispositivo

---

## Guía de uso — El día del evento

### Módulo Escáner (`scanner.html`)

**Dispositivo:** Celular con Chrome (Android o iOS)
**Requisito:** HTTPS (necesario para acceso a cámara)

#### Configuración inicial del dispositivo
1. Abre `scanner.html` en Chrome
2. La primera vez aparece un modal pidiendo el nombre del dispositivo
3. Escribe el nombre del escáner: `Puerta-1`, `Puerta-2`, etc.
4. Acepta el permiso de cámara cuando Chrome lo solicite
5. La cámara trasera se activa automáticamente

#### Escaneo de boletos
Apunta el boleto al recuadro de escaneo. El resultado aparece de inmediato:

| Resultado | Pantalla | Significado |
|---|---|---|
| ✅ Verde — BIENVENIDO | Muestra barrio, número y hora | Boleto válido, registro exitoso |
| 🔴 Rojo — YA REGISTRADO | Muestra hora del registro anterior | El boleto ya fue usado |
| 🟠 Naranja — CÓDIGO NO VÁLIDO | Muestra el código escaneado | No pertenece a esta conferencia |

- La pantalla vuelve al escáner automáticamente (2s válido/duplicado, 1.5s inválido)
- Un beep de audio diferente para cada caso
- El contador de asistentes se actualiza en tiempo real

#### Modo sin internet
Si se cae la conexión:
- Aparece un banner naranja "Sin conexión"
- Los escaneos se guardan localmente en el dispositivo
- Al recuperar la conexión, se sincronizan automáticamente con Supabase
- El escáner sigue funcionando sin interrupción

#### Múltiples escáneres simultáneos
Cada dispositivo opera de forma completamente independiente. No hay conflicto si varias personas escanean al mismo tiempo. Supabase maneja la concurrencia.

---

### Módulo Dashboard (`dashboard.html`)

**Dispositivo:** Computadora conectada a proyector o pantalla grande
**Diseño:** "War room" — fondo oscuro, números grandes, legible desde lejos

#### Secciones del dashboard

**1. Métricas generales (parte superior)**
- Total de asistentes registrados en tiempo real (número gigante)
- Porcentaje de avance hacia la meta de 800 personas
- Comparación con el récord anterior (500) — muestra "🏆 NUEVO RÉCORD" si se supera

**2. Barra de progreso general**
- Barra ancha con gradiente azul marino → dorado
- Se anima con cada nuevo registro

**3. Tabla por unidad**
- Barrio/Rama | Boletos emitidos | Registrados | % Asistencia | Estado | Barra
- Estado con color: 🟢 Verde ≥70% | 🟡 Amarillo 40-69% | 🔴 Rojo <40%
- Ordenable haciendo clic en cualquier columna
- Las filas parpadean en verde cuando llega un nuevo registro de esa unidad

**4. Gráficas**
- Barras horizontales por unidad (con el color de cada barrio)
- Línea de tiempo: llegadas acumuladas cada 15 minutos

**5. Podio en vivo**
- 🥇 🥈 🥉 — Los 3 barrios con mayor porcentaje de asistencia
- Se actualiza con cada escaneo

#### Actualización en tiempo real
- Usa Supabase Realtime (websocket) para actualizaciones instantáneas
- Como respaldo, también hace polling cada 10 segundos
- Indicador de conexión visible en la barra superior

#### Exportar reporte final
- Botón **"Exportar CSV"** en la barra superior
- Descarga todos los registros con: código, unidad, hora, dispositivo escáner

---

## Qué hacer si falla el internet el día del evento

### Escáner (impacto mínimo)
- Continúa funcionando sin internet
- Guarda registros localmente en el dispositivo
- Al volver la conexión, sincroniza automáticamente

### Dashboard
- Deja de actualizarse hasta recuperar la conexión
- Los números quedan "congelados" en el último valor

### Recomendaciones
1. Genera todos los PDFs de boletos **al menos 2 días antes** del evento
2. Ten un **hotspot de datos móviles** como respaldo del WiFi del edificio
3. Prueba el sistema completo **un día antes** con un boleto de prueba
4. Abre el dashboard en una pestaña y el administrador en otra para monitorear

---

## Estructura de archivos

```
conferenciaEstaca/
├── index.html          # Página de inicio
├── admin.html          # Módulo administrador
├── scanner.html        # Escáner QR para celular
├── dashboard.html      # Dashboard en tiempo real
├── styles.css          # Estilos compartidos (navy #1B2A5E, dorado #C9A84C)
├── config.js           # ⚠️ Credenciales Supabase — actualizar antes de usar
├── schema.sql          # DDL completo de la base de datos
└── README.md           # Esta documentación
```

---

## Schema de la base de datos

```sql
-- Unidades de la estaca
unidades (
  id    TEXT PRIMARY KEY,   -- 'BAR01', 'RAM01', etc.
  nombre TEXT NOT NULL,
  cupo  INTEGER DEFAULT 100,
  color TEXT                -- Color hex para UI
)

-- Boletos generados
boletos (
  codigo      TEXT PRIMARY KEY,  -- 'BAR01-0001' ... 'BAR01-0100'
  unidad_id   TEXT REFERENCES unidades(id),
  generado_en TIMESTAMPTZ DEFAULT NOW()
)

-- Registros de escaneo (asistencia)
registros (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  codigo       TEXT REFERENCES boletos(codigo),
  unidad_id    TEXT REFERENCES unidades(id),
  escaneado_en TIMESTAMPTZ DEFAULT NOW(),
  dispositivo  TEXT   -- 'Puerta-1', 'Puerta-2', etc.
)
```

**Reglas RLS:** Lectura pública en todas las tablas. Escritura pública en `boletos` y `registros`.

---

## Solución de problemas comunes

| Problema | Causa probable | Solución |
|---|---|---|
| "Error: [object Object]" al generar | Credenciales Supabase incorrectas | Verificar `config.js` con las credenciales de Settings → API |
| "row-level security policy" al insertar | Falta política de inserción | Ejecutar el `CREATE POLICY` indicado en la sección de configuración |
| La cámara no abre en el celular | No hay HTTPS | Usar Vercel/Netlify en lugar de servidor local |
| El QR no aparece en el PDF | Error de librería | Recargar la página e intentar de nuevo |
| El dashboard no se actualiza | Realtime no habilitado | Ejecutar `ALTER PUBLICATION supabase_realtime ADD TABLE registros` |
| Escáner lee el mismo boleto dos veces | Doble lectura del QR | El sistema tiene un bloqueo de 3 segundos por código, se ignora automáticamente |

---

## Créditos

Desarrollado para la **Conferencia de Estaca de La Iglesia de Jesucristo de los Santos de los Últimos Días**
Estaca Ensenada México · Mayo 2026
