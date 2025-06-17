# 📱 EasyNotes Pro

Una aplicación avanzada de notas desarrollada en Flutter con funcionalidades premium de seguridad, multimedia y productividad.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

## 🎯 Descripción del Proyecto

EasyNotes Pro es una aplicación móvil desarrollada como proyecto académico que evoluciona una simple app de notas hacia una plataforma integral de productividad personal con características avanzadas de seguridad y multimedia.

### 👥 Equipo de Desarrollo
- **Piero De La Cruz Mancilla**
- **Jerson Ernesto Chura Pacci**

**Duración del Proyecto:** 4 semanas (Mayo 2025)

## ✨ Funcionalidades Implementadas

### 📝 **Core Features (Completado)**
- ✅ **CRUD Completo de Notas**
  - Crear, editar, eliminar notas
  - Títulos y contenido enriquecido
  - Guardado automático
  
- ✅ **Búsqueda Avanzada**
  - Búsqueda en tiempo real
  - Filtrado por título y contenido
  - Interfaz de búsqueda intuitiva

- ✅ **Sistema de Favoritos**
  - Marcar/desmarcar notas favoritas
  - Indicadores visuales
  - Acceso rápido

- ✅ **Base de Datos Local**
  - SQLite con Room
  - Persistencia de datos
  - Consultas optimizadas

### 🔐 **Seguridad Biométrica (Completado)**
- ✅ **Autenticación Biométrica**
  - Huella dactilar
  - Reconocimiento facial
  - Compatibilidad con Samsung Galaxy S25 Ultra

- ✅ **Sistema de Bloqueo de App**
  - PIN personalizado de 4 dígitos
  - Auto-bloqueo configurable (1-30 minutos)
  - Detección de ciclo de vida de la app

- ✅ **Notas Privadas**
  - Marcado de notas como privadas
  - Indicadores visuales de seguridad
  - Protección adicional

- ✅ **Configuración de Seguridad**
  - Panel de configuración completo
  - Test de diagnóstico biométrico
  - Gestión de permisos

### 🎨 **Interfaz de Usuario (Completado)**
- ✅ **Material Design 3**
  - Tema claro y oscuro
  - Componentes modernos
  - Animaciones fluidas

- ✅ **Navegación Intuitiva**
  - AppBar con acciones contextuales
  - FloatingActionButton para crear notas
  - Navegación entre pantallas

- ✅ **Filtros Rápidos**
  - Chips de filtrado
  - Acceso rápido a categorías
  - Interfaz responsive

### 📱 **Funcionalidades de Productividad (Completado)**
- ✅ **Colores Personalizados**
  - Paleta de colores para notas
  - Selector visual de colores
  - Organización visual

- ✅ **Recordatorios (Parcial)**
  - Configuración de fecha y hora
  - Interfaz de recordatorios
  - Sistema base implementado

## 🛠️ Stack Tecnológico

### **Frontend**
- **Flutter 3.16+** - Framework principal
- **Dart 3.0+** - Lenguaje de programación
- **Material 3** - Sistema de diseño
- **Riverpod 2.4+** - State management

### **Base de Datos**
- **SQLite** - Base de datos local
- **Sqflite** - Plugin para Flutter

### **Seguridad**
- **local_auth** - Autenticación biométrica
- **shared_preferences** - Configuraciones seguras
- **crypto** - Cifrado de datos

### **Arquitectura**
- **Clean Architecture** - Separación de capas
- **MVVM Pattern** - Presentación
- **Repository Pattern** - Datos

## 📁 Estructura del Proyecto

```
lib/
├── core/
│   ├── database/           # SQLite database helper
│   └── theme/             # Tema y estilos
├── data/
│   └── models/            # Modelos de datos
├── presentation/
│   ├── pages/             # Pantallas de la app
│   ├── providers/         # State management
│   └── widgets/           # Componentes reutilizables
├── services/              # Servicios (biometría, seguridad)
└── main.dart             # Punto de entrada
```

## 🚀 Instalación y Configuración

### **Prerrequisitos**
- Flutter SDK 3.16+
- Android Studio / VS Code
- Dispositivo Android con API 23+
- Git

### **Pasos de Instalación**

1. **Clonar el repositorio**
```bash
git clone https://github.com/JersonCh1/MovilesProyec.git
cd MovilesProyec
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar permisos Android**
   - Los permisos ya están configurados en `AndroidManifest.xml`
   - Incluye permisos biométricos, cámara, almacenamiento

4. **Ejecutar la aplicación**
```bash
flutter run
```

### **Configuración de Seguridad**
1. Asegúrate de tener huella dactilar configurada en tu dispositivo
2. Permite permisos biométricos cuando la app lo solicite
3. Configura un PIN en la app para habilitar el bloqueo

## 📖 Guía de Uso

### **Configurar Seguridad**
1. Toca el ícono 🛡️ en la pantalla principal
2. Activa "Bloquear aplicación"
3. Crea un PIN de 4 dígitos
4. Habilita la autenticación biométrica
5. Configura el tiempo de auto-bloqueo

### **Crear y Gestionar Notas**
1. Toca el botón ➕ para crear una nueva nota
2. Escribe el título y contenido
3. Selecciona un color personalizado
4. Marca como favorita con ❤️
5. Marca como privada con 🔒

### **Buscar Notas**
1. Usa la barra de búsqueda en la pantalla principal
2. Filtra por categorías usando los chips
3. Accede a favoritas y notas privadas

## 🔬 Testing y Diagnóstico

La app incluye herramientas de diagnóstico:

### **Test Biométrico**
- Accede desde Configuración de Seguridad
- Diagnostica problemas de autenticación
- Verifica compatibilidad del dispositivo

### **Logs de Debug**
- Los logs aparecen en la consola de Flutter
- Información detallada de errores biométricos
- Estados de autenticación

## 🔄 Roadmap - Funcionalidades Pendientes

### **🎯 Próximas 2 Semanas**

#### **📸 Multimedia Avanzado**
- [ ] **Captura de Imágenes**
  - Integración con cámara
  - Galería de fotos
  - Compresión de imágenes

- [ ] **Grabación de Audio**
  - Grabación de notas de voz
  - Reproductor integrado
  - Gestión de archivos de audio

- [ ] **Modo Dibujo**
  - Canvas para sketches
  - Herramientas de dibujo básicas
  - Exportación de dibujos

#### **🏷️ Sistema de Categorías Avanzado**
- [ ] **Categorías Personalizadas**
  - Crear categorías con colores
  - Iconos personalizados
  - Jerarquía de categorías

- [ ] **Etiquetas Múltiples**
  - Sistema de tags
  - Filtrado por etiquetas
  - Gestión de etiquetas

- [ ] **Filtros Avanzados**
  - Combinación de filtros
  - Búsqueda por fechas
  - Filtros guardados

#### **🔔 Notificaciones Inteligentes**
- [ ] **Notificaciones Locales**
  - Recordatorios programados
  - Notificaciones recurrentes
  - Gestión de notificaciones

- [ ] **Recordatorios Geográficos**
  - Recordatorios basados en ubicación
  - Geofencing
  - Mapas integrados

### **☁️ Funcionalidades Futuras (Semanas 3-4)**

#### **Firebase Integration**
- [ ] **Autenticación en la Nube**
  - Login con email/password
  - Login con Google
  - Gestión de cuentas

- [ ] **Sincronización**
  - Backup automático
  - Sync entre dispositivos
  - Resolución de conflictos

- [ ] **Colaboración**
  - Notas compartidas
  - Comentarios
  - Control de permisos

#### **Funcionalidades Premium**
- [ ] **Modo Focus Avanzado**
  - Escritura sin distracciones
  - Contador de palabras
  - Estadísticas de escritura

- [ ] **Exportación Avanzada**
  - Export a PDF
  - Export a Word
  - Templates personalizados

- [ ] **Widgets de Android**
  - Widget de notas rápidas
  - Widget de recordatorios
  - Accesos directos

## 🐛 Problemas Conocidos

### **Solucionados**
- ✅ Error de `no_fragment_activity` en biometría
- ✅ Incompatibilidad con `flutter_local_notifications`
- ✅ Problemas de compilación con NDK

### **En Investigación**
- ⚠️ Optimización de rendimiento en listas grandes
- ⚠️ Mejora de animaciones en dispositivos de gama baja

## 📊 Métricas del Proyecto

### **Líneas de Código**
- **Dart:** ~2,500 líneas
- **Kotlin:** ~50 líneas
- **XML:** ~100 líneas

### **Archivos Principales**
- 15+ archivos Dart
- 8 pantallas/páginas
- 12 widgets personalizados
- 6 servicios

### **Funcionalidades Core**
- 🟢 **85% Completado**
- 🟡 **15% En desarrollo**

## 🤝 Contribución

Este es un proyecto académico, pero las contribuciones son bienvenidas:

1. Fork del proyecto
2. Crear feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la branch (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Contacto

- **Piero De La Cruz Mancilla** - [GitHub](https://github.com/PieroDeLaCruz)
- **Jerson Ernesto Chura Pacci** - [GitHub](https://github.com/JersonCh1)

**Link del Proyecto:** [https://github.com/JersonCh1/MovilesProyec](https://github.com/JersonCh1/MovilesProyec)

---

## 🎉 Reconocimientos

- Flutter Team por el excelente framework
- Comunidad de pub.dev por los packages utilizados
- Samsung por el dispositivo de testing (Galaxy S25 Ultra)

---

**Desarrollado con ❤️ usando Flutter**
