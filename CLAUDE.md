# Conferencia de Estaca — Sistema de Asistencia

Sistema web para gestionar la asistencia a la **Sesión General del domingo 24 de mayo de 2026**.
Estaca Ensenada México · 11 unidades · 1,100 boletos QR.

---

## Stack

- **Frontend:** HTML / CSS / JS vanilla — sin frameworks, sin npm, sin build step
- **Base de datos:** Supabase (PostgreSQL) en la nube
- **Tiempo real:** Supabase Realtime (websocket) en `dashboard.html`
- **Librerías:** todas desde CDN (html5-qrcode, QRCode.js, jsPDF, Chart.js)
- **Hosting:** Vercel o Netlify (HTTPS requerido para cámara en móviles)

## Archivos principales

| Archivo | Función |
|---|---|
| `index.html` | Página de inicio / navegación |
| `admin.html` | Generación de boletos y PDFs (contraseña: `Ensenada2026`) |
| `scanner.html` | Escáner QR para celular (Chrome, HTTPS) |
| `dashboard.html` | Dashboard en tiempo real (proyector) |
| `styles.css` | Estilos compartidos — paleta: navy `#1B2A5E`, dorado `#C9A84C` |
| `config.js` | Credenciales Supabase + configuración del evento |
| `schema.sql` | DDL completo — ejecutar en Supabase SQL Editor |

## Base de datos (Supabase)

Tablas: `unidades`, `boletos`, `registros`

- `boletos.codigo` = clave primaria, formato `BAR01-0001`
- `registros` = un registro por escaneo exitoso; tiene `dispositivo` (nombre del escáner)
- RLS habilitado: lectura pública en todo, escritura pública en `boletos` y `registros`
- Realtime activo en tabla `registros` (`ALTER PUBLICATION supabase_realtime ADD TABLE registros`)

Credenciales en `config.js` (URL y anon key reales ya configuradas).

## Unidades (11)

BAR01–BAR10 (barrios) + RAM01 (Rama Maneadero) · 100 boletos cada una · meta 800 asistentes.

## Comportamiento del escáner

- Verde: boleto válido → inserta en `registros`
- Rojo: boleto ya registrado → muestra hora previa
- Naranja: código no encontrado en `boletos`
- Offline: guarda en localStorage y sincroniza al reconectar
- Bloqueo de 3 s por código para evitar doble lectura

## Comandos útiles

```bash
# Servidor local para pruebas (celular en misma red WiFi)
python3 -m http.server 8080
```

No hay `npm install` ni proceso de build.
