# Offline Tasks Demo

Demo Flutter Web de una app de tareas offline-first.

La app guarda cada cambio primero en el navegador, usando SQLite Web mediante WebAssembly cuando está disponible. Esto permite seguir creando, editando, completando y eliminando tareas aunque falle la conexión a internet. Cuando la red vuelve, la app intenta sincronizar automáticamente contra una API REST de Supabase. Si falla SQLite Web, WebAssembly, el worker o la inicialización de IndexedDB, la app usa un fallback con `shared_preferences` para que la demo pública siga funcionando.

El proyecto está pensado como demo de portfolio: alcance chico, arquitectura clara, comportamiento offline real.

Esta demo usa SQLite Web mediante WebAssembly como desafío técnico, pero incluye fallback automático para que el link público siga funcionando incluso si el navegador o el hosting tienen problemas con WASM o workers.

## Qué Demuestra

- Flujo offline-first para crear, editar, completar y eliminar tareas.
- Uso normal de la app aunque no haya conexión a internet.
- SQLite ejecutándose localmente en el navegador mediante WebAssembly.
- Fallback automático a almacenamiento local del navegador.
- Estados locales de sincronización para cambios pendientes o fallidos.
- Sincronización automática con opción de reintento manual.
- Integración con Supabase REST usando `dio`.
- Arquitectura Flutter separada por capas.
- Estado simple con `ChangeNotifier`.
- UI responsive para mobile, tablet y desktop.

## Stack

- Flutter Web
- `sqflite_common_ffi_web`
- SQLite WebAssembly
- `shared_preferences`
- `dio`
- `uuid`
- `connectivity_plus`
- Supabase REST API

## Estructura Del Proyecto

```txt
lib/
  config/
  data/
    local/
    remote/
    repositories/
  domain/
    models/
  presentation/
    controllers/
    pages/
    responsive/
    widgets/
```

La UI no contiene lógica de sincronización. La persistencia local, las llamadas remotas, la coordinación de sync, los modelos de dominio y el estado de presentación están separados.

## Configuración De Supabase

La app lee los datos de Supabase desde Dart defines:

```dart
class SupabaseConfig {
  static const String projectId = String.fromEnvironment('PROJECT_ID');
  static const String anonKey = String.fromEnvironment('ANON_KEY');
  static const String projectUrl = 'https://$projectId.supabase.co';
  static const String restUrl = '$projectUrl/rest/v1';
}
```

Para ejecutar localmente:

```bash
flutter run -d chrome \
  --dart-define=PROJECT_ID=tu-project-id \
  --dart-define=ANON_KEY=tu-anon-key
```

En VS Code, configurarlo en `.vscode/launch.json` dentro de `toolArgs`:

```json
"toolArgs": [
  "--dart-define=PROJECT_ID=tu-project-id",
  "--dart-define=ANON_KEY=tu-anon-key"
]
```

Para esta demo sin login, la anon key se usa en ambos headers:

```txt
apikey: <anon key>
Authorization: Bearer <anon key>
```

En una app real con usuarios autenticados, `apikey` seguiría usando la anon key, pero `Authorization` debería usar el access token del usuario.

## Tabla Supabase

La tabla `tasks` debe existir previamente en Supabase. Este proyecto no la recrea ni modifica su estructura.

```sql
create table tasks (
  id uuid primary key,
  title text not null,
  description text,
  completed boolean default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);
```

El campo local `syncStatus` no se envía a Supabase.

## Policies Opcionales Para Demo Sin Login

Usar solo si todavía no existen. Estas policies son abiertas para una demo pública y no deberían usarse en una app real multiusuario.

```sql
alter table tasks enable row level security;

create policy "demo_select_tasks"
on tasks for select
to anon
using (true);

create policy "demo_insert_tasks"
on tasks for insert
to anon
with check (true);

create policy "demo_update_tasks"
on tasks for update
to anon
using (true)
with check (true);

create policy "demo_delete_tasks"
on tasks for delete
to anon
using (true);
```

Para producción, conviene usar Supabase Auth y policies por usuario.

## Preparar SQLite Web

Instalar los binarios web:

```bash
dart run sqflite_common_ffi_web:setup
```

Verificar que existan y se desplieguen estos archivos:

```txt
web/sqlite3.wasm
web/sqflite_sw.js
```

Importante: `sqlite3.wasm` debe coincidir con la versión del paquete `sqlite3` resuelta en `pubspec.lock`. Si aparece un error como:

```txt
WebAssembly.instantiate(): Import ... "env": module is not an object or function
```

probablemente el binario WASM pertenece a otra versión de `sqlite3`. Descargar el `sqlite3.wasm` compatible desde:

```txt
https://github.com/simolus3/sqlite3.dart/releases
```

Mantener el archivo WASM alineado con la versión de `sqlite3` indicada en `pubspec.lock`.

## Comportamiento Del Almacenamiento Local

Flujo de arranque:

1. Intenta usar SQLite Web con `sqlite3.wasm` y `sqflite_sw.js`.
2. Si falla el worker, intenta usar SQLite Web sin worker.
3. Si SQLite también falla, usa `shared_preferences`.

El motor de almacenamiento activo se muestra en la UI.

## Comportamiento De Sincronización

La app intenta sincronizar automáticamente:

- al cargar inicialmente
- después de crear una tarea
- después de editar una tarea
- después de completar o descompletar una tarea
- después de eliminar una tarea

El usuario también puede usar `Sincronizar ahora` como reintento manual.

Estrategia de sincronización:

- los cambios se guardan primero localmente
- las creaciones pendientes se envían con `POST`
- las actualizaciones pendientes se envían con `PATCH`
- las eliminaciones pendientes se envían con `DELETE`
- los cambios remotos se descargan usando `updated_at`
- si hay conflicto, los cambios locales pendientes tienen prioridad en esta demo

## Ejecutar Localmente

```bash
flutter pub get
flutter run -d chrome \
  --dart-define=PROJECT_ID=tu-project-id \
  --dart-define=ANON_KEY=tu-anon-key
```

Flujo sugerido:

- Abrir la app.
- Desconectar internet o bloquear temporalmente la red desde DevTools.
- Crear una tarea.
- Editar o completar la tarea sin conexión.
- Volver a conectar internet.
- Refrescar la página y confirmar que la tarea persiste.
- Confirmar que cambia el estado de sincronización.
- Verificar la fila en Supabase.
- Modificar una fila desde Supabase y volver a sincronizar.

## Troubleshooting

### "Supabase no esta configurado"

La app no recibió `PROJECT_ID` o `ANON_KEY` mediante `--dart-define`.

Revisar el comando de ejecución/build o la configuración de VS Code en `launch.json`.

### SQLite Web cae al fallback

Revisar:

- que exista `web/sqlite3.wasm`
- que exista `web/sqflite_sw.js`
- que el navegador no esté usando un worker viejo cacheado
- que el deploy no devuelva 404 para el `.wasm`
- que la versión del WASM coincida con `sqlite3` en `pubspec.lock`

Probar con hard refresh, limpiar datos del sitio o abrir en incógnito.

### Los datos cambian entre ejecuciones locales

El almacenamiento del navegador depende del origen y del puerto. Por ejemplo:

```txt
localhost:8080
localhost:8081
```

son orígenes distintos y tienen almacenamiento separado.

