-- ============================================================
-- SCHEMA SQL — Conferencia de Estaca Ensenada México
-- Ejecutar en: Supabase Dashboard > SQL Editor
-- ============================================================

-- ------------------------------------------------------------
-- 1. TABLA: unidades
-- Almacena las 11 unidades de la estaca con su cupo y color
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS unidades (
  id    TEXT PRIMARY KEY,
  nombre TEXT NOT NULL,
  cupo  INTEGER DEFAULT 100,
  color TEXT
);

-- ------------------------------------------------------------
-- 2. TABLA: boletos
-- Un registro por cada boleto generado
-- Código formato: BAR01-0001 hasta BAR01-0100
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS boletos (
  codigo     TEXT PRIMARY KEY,
  unidad_id  TEXT REFERENCES unidades(id),
  generado_en TIMESTAMPTZ DEFAULT NOW()
);

-- ------------------------------------------------------------
-- 3. TABLA: registros
-- Se inserta un registro cada vez que se escanea un boleto
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS registros (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  codigo      TEXT REFERENCES boletos(codigo),
  unidad_id   TEXT REFERENCES unidades(id),
  escaneado_en TIMESTAMPTZ DEFAULT NOW(),
  dispositivo TEXT
);

-- ------------------------------------------------------------
-- 4. ROW LEVEL SECURITY (RLS)
-- Habilitar RLS y crear políticas de acceso público
-- ------------------------------------------------------------

-- Habilitar RLS en todas las tablas
ALTER TABLE unidades  ENABLE ROW LEVEL SECURITY;
ALTER TABLE boletos   ENABLE ROW LEVEL SECURITY;
ALTER TABLE registros ENABLE ROW LEVEL SECURITY;

-- Política: lectura pública de unidades
DROP POLICY IF EXISTS "lectura_publica_unidades" ON unidades;
CREATE POLICY "lectura_publica_unidades"
  ON unidades FOR SELECT
  TO anon
  USING (true);

-- Política: lectura pública de boletos
DROP POLICY IF EXISTS "lectura_publica_boletos" ON boletos;
CREATE POLICY "lectura_publica_boletos"
  ON boletos FOR SELECT
  TO anon
  USING (true);

-- Política: lectura pública de registros
DROP POLICY IF EXISTS "lectura_publica_registros" ON registros;
CREATE POLICY "lectura_publica_registros"
  ON registros FOR SELECT
  TO anon
  USING (true);

-- Política: inserción pública de registros (escáneres)
DROP POLICY IF EXISTS "insercion_publica_registros" ON registros;
CREATE POLICY "insercion_publica_registros"
  ON registros FOR INSERT
  TO anon
  WITH CHECK (true);

-- ------------------------------------------------------------
-- 5. INSERT: datos de las 11 unidades
-- ------------------------------------------------------------
INSERT INTO unidades (id, nombre, cupo, color) VALUES
  ('BAR01', 'Barrio Alisos',       100, '#E63946'),
  ('BAR02', 'Barrio Azteca',       100, '#457B9D'),
  ('BAR03', 'Barrio Bahía',        100, '#2A9D8F'),
  ('BAR04', 'Barrio Chapultepec',  100, '#E9A820'),
  ('BAR05', 'Barrio Geranios',     100, '#F4A261'),
  ('BAR06', 'Barrio Hidalgo',      100, '#6A4C93'),
  ('BAR07', 'Barrio Lomitas',      100, '#06D6A0'),
  ('BAR08', 'Barrio San Quintín',  100, '#8338EC'),
  ('BAR09', 'Barrio Universidad',  100, '#FB8500'),
  ('BAR10', 'Barrio Valle Dorado', 100, '#3A86FF'),
  ('RAM01', 'Rama Maneadero',      100, '#FF006E')
ON CONFLICT (id) DO NOTHING;

-- ------------------------------------------------------------
-- 6. ÍNDICES para mejorar rendimiento en consultas frecuentes
-- ------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_boletos_unidad    ON boletos(unidad_id);
CREATE INDEX IF NOT EXISTS idx_registros_unidad  ON registros(unidad_id);
CREATE INDEX IF NOT EXISTS idx_registros_codigo  ON registros(codigo);
CREATE INDEX IF NOT EXISTS idx_registros_tiempo  ON registros(escaneado_en);

-- ============================================================
-- FIN DEL SCHEMA
-- ============================================================
