-- Pixel Estoque: execute uma única vez no SQL Editor do Supabase.
-- O estoque é compartilhado entre todos os usuários autenticados do projeto.

create table if not exists public.app_state (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id)
);

alter table public.app_state enable row level security;

drop policy if exists "authenticated users can read inventory" on public.app_state;
create policy "authenticated users can read inventory"
on public.app_state for select to authenticated using (true);

drop policy if exists "authenticated users can create inventory" on public.app_state;
create policy "authenticated users can create inventory"
on public.app_state for insert to authenticated
with check (auth.uid() = updated_by);

drop policy if exists "authenticated users can update inventory" on public.app_state;
create policy "authenticated users can update inventory"
on public.app_state for update to authenticated
using (true) with check (auth.uid() = updated_by);

create or replace function public.set_pixel_inventory_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_pixel_inventory_updated_at on public.app_state;
create trigger set_pixel_inventory_updated_at
before update on public.app_state
for each row execute function public.set_pixel_inventory_updated_at();

revoke all on public.app_state from anon;
grant select, insert, update on public.app_state to authenticated;
