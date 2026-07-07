# Offline Tasks Demo

Demo Flutter Web offline-first para portfolio. La app crea, edita, completa y elimina tareas guardando primero en almacenamiento local del navegador. Intenta usar SQLite Web con WebAssembly mediante `sqflite_common_ffi_web` y, si SQLite/WASM/worker falla, cambia automaticamente a un fallback con `shared_preferences`.

La sincronizacion remota usa Supabase REST con `dio`, sin Firebase y sin Supabase SDK.

## Configuracion Supabase

Edita [lib/config/supabase_config.dart](lib/config/supabase_config.dart):

```dart
class SupabaseConfig {
  static const String projectUrl = 'https://PROJECT_ID.supabase.co';
  static const String anonKey = 'SUPABASE_ANON_KEY';
}
```

Para esta demo sin login se usa la anon key tanto en `apikey` como en `Authorization: Bearer`. En una app real con login, `apikey` seguiria usando la anon key, pero `Authorization` deberia usar el access token del usuario autenticado.

## Tabla existente

La tabla `tasks` ya existe en Supabase. No hace falta recrearla ni modificar su estructura. Fue creada con:

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

## Policies opcionales para demo sin login

Usar solo si todavia no existen. Estas policies son abiertas para demo publica; en una app real conviene usar Supabase Auth y policies por usuario.

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

## Preparar SQLite Web

Ejecuta:

```bash
dart run sqflite_common_ffi_web:setup
```

Verifica que existan:

```txt
web/sqlite3.wasm
web/sqflite_sw.js
```

Incluye esos archivos en el repositorio y en el deploy. Si no estan disponibles o el navegador/hosting bloquea WASM o workers, la app usa `Browser fallback`.

## Probar la app

```bash
flutter run -d chrome
```

Flujo sugerido:

- Crear tarea offline.
- Editar tarea offline.
- Sincronizar.
- Verificar en Supabase.
- Modificar un dato remoto y volver a sincronizar.

## Nota final

Esta demo usa SQLite Web mediante WebAssembly como desafio tecnico, pero incluye fallback automatico para asegurar que el link publico funcione incluso si el navegador o el hosting tienen problemas con WASM.
