// ============================================================
// CONFIGURACIÓN DE SUPABASE
// Actualiza estas credenciales con las tuyas desde el dashboard
// de Supabase: Settings > API
// ============================================================

const SUPABASE_URL = 'https://yukkzromeekdhipdqbed.supabase.co';
const SUPABASE_PUBLISHABLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl1a2t6cm9tZWVrZGhpcGRxYmVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUxNTMyODIsImV4cCI6MjA5MDcyOTI4Mn0.WQK2M7NHRUrP2bYz6C28whIJCOvb62OlW1tIzpr-tfs';

// ============================================================
// CONFIGURACIÓN DEL EVENTO
// ============================================================
const CONFIG_EVENTO = {
  nombreEstaca: 'Estaca Ensenada México',
  nombreSesion: 'Sesión General',
  fecha: 'Domingo 24 de mayo de 2026',
  metaAsistencia: 800,
  recordAnterior: 500,
  cupoXUnidad: 100
};

// ============================================================
// UNIDADES DE LA ESTACA
// Cada unidad tiene id, nombre, cupo y color identificador
// ============================================================
const UNIDADES = [
  { id: 'BAR01', nombre: 'Barrio Alisos', cupo: 100, color: '#E63946' },
  { id: 'BAR02', nombre: 'Barrio Azteca', cupo: 100, color: '#457B9D' },
  { id: 'BAR03', nombre: 'Barrio Bahía', cupo: 100, color: '#2A9D8F' },
  { id: 'BAR04', nombre: 'Barrio Chapultepec', cupo: 100, color: '#E9A820' },
  { id: 'BAR05', nombre: 'Barrio Geranios', cupo: 100, color: '#F4A261' },
  { id: 'BAR06', nombre: 'Barrio Hidalgo', cupo: 100, color: '#6A4C93' },
  { id: 'BAR07', nombre: 'Barrio Lomitas', cupo: 100, color: '#06D6A0' },
  { id: 'BAR08', nombre: 'Barrio San Quintín', cupo: 100, color: '#8338EC' },
  { id: 'BAR09', nombre: 'Barrio Universidad', cupo: 100, color: '#FB8500' },
  { id: 'BAR10', nombre: 'Barrio Valle Dorado', cupo: 100, color: '#3A86FF' },
  { id: 'RAM01', nombre: 'Rama Maneadero', cupo: 100, color: '#FF006E' }
];

// Contraseña del módulo administrador
const ADMIN_PASSWORD = 'Ensenada2026';
