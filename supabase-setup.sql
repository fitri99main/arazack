create extension if not exists pgcrypto;

create table if not exists public.site_data (
  key text primary key,
  value jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.site_data enable row level security;

grant usage on schema public to anon, authenticated;
grant select, insert, update on table public.site_data to anon, authenticated;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'site_data'
      and policyname = 'site_data_anon_read'
  ) then
    create policy site_data_anon_read
      on public.site_data
      for select
      to anon, authenticated
      using (true);
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'site_data'
      and policyname = 'site_data_anon_write'
  ) then
    create policy site_data_anon_write
      on public.site_data
      for insert
      to anon, authenticated
      with check (true);
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'site_data'
      and policyname = 'site_data_anon_update'
  ) then
    create policy site_data_anon_update
      on public.site_data
      for update
      to anon, authenticated
      using (true)
      with check (true);
  end if;
end
$$;

insert into storage.buckets (id, name, public)
values ('media', 'media', true)
on conflict (id) do update
set public = excluded.public;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'media_public_read'
  ) then
    create policy media_public_read
      on storage.objects
      for select
      to anon, authenticated
      using (bucket_id = 'media');
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'media_public_insert'
  ) then
    create policy media_public_insert
      on storage.objects
      for insert
      to anon, authenticated
      with check (bucket_id = 'media');
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'media_public_update'
  ) then
    create policy media_public_update
      on storage.objects
      for update
      to anon, authenticated
      using (bucket_id = 'media')
      with check (bucket_id = 'media');
  end if;
end
$$;
