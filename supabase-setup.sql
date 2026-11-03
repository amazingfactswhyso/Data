-- The Decor Zudio: run once in Supabase > SQL Editor.
-- Replace artist@example.com with your confirmed artist login email in ONE place only (the is_artist function below).
-- Safe to re-run.
create extension if not exists pgcrypto;

create or replace function public.is_artist() returns boolean
language sql stable as $$
  select lower(coalesce(auth.jwt()->>'email','')) = lower('artist@example.com')
$$;

create table if not exists public.artworks (
 id uuid primary key default gen_random_uuid(),
 title text not null check (char_length(title) between 1 and 150),
 category text not null check (category in ('Forever Home','Memory Wall','Living Canvas','First Home, First Art','Suburb Stories','Family Fingerprint','Business Art')),
 description text not null check (char_length(description) between 1 and 4000),
 price_aud numeric(12,2) check (price_aud >= 0),
 dimensions text, medium text,
 availability text not null default 'Available' check (availability in ('Available','Made to order','Sold')),
 image_path text not null, image_url text not null,
 created_at timestamptz not null default now()
);
create table if not exists public.enquiries (
 id uuid primary key default gen_random_uuid(),
 name text not null check (char_length(name) between 1 and 100),
 email text not null check (char_length(email) between 3 and 254),
 category text, budget text,
 message text not null check (char_length(message) between 1 and 3000),
 created_at timestamptz not null default now()
);
alter table public.enquiries add column if not exists enquirer_type text check (enquirer_type is null or char_length(enquirer_type) <= 60);

alter table public.artworks enable row level security;
alter table public.enquiries enable row level security;

drop policy if exists "Everyone can browse art" on public.artworks;
drop policy if exists "Artist adds art" on public.artworks;
drop policy if exists "Artist updates art" on public.artworks;
drop policy if exists "Artist deletes art" on public.artworks;
drop policy if exists "Public can send enquiry" on public.enquiries;
drop policy if exists "Artist reads enquiries" on public.enquiries;
create policy "Everyone can browse art" on public.artworks for select to anon,authenticated using (true);
create policy "Artist adds art" on public.artworks for insert to authenticated with check ((select public.is_artist()));
create policy "Artist updates art" on public.artworks for update to authenticated using ((select public.is_artist())) with check ((select public.is_artist()));
create policy "Artist deletes art" on public.artworks for delete to authenticated using ((select public.is_artist()));
-- Visitors can send enquiries but cannot read anyone's messages.
create policy "Public can send enquiry" on public.enquiries for insert to anon,authenticated with check (true);
create policy "Artist reads enquiries" on public.enquiries for select to authenticated using ((select public.is_artist()));

-- Public artwork images; only the artist can upload or delete.
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('artworks','artworks',true,5242880,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public=true,file_size_limit=5242880,allowed_mime_types=array['image/jpeg','image/png','image/webp'];
drop policy if exists "Public artwork images" on storage.objects;
drop policy if exists "Artist uploads images" on storage.objects;
drop policy if exists "Artist deletes images" on storage.objects;
create policy "Public artwork images" on storage.objects for select to anon,authenticated using (bucket_id='artworks');
create policy "Artist uploads images" on storage.objects for insert to authenticated with check (bucket_id='artworks' and (select public.is_artist()));
create policy "Artist deletes images" on storage.objects for delete to authenticated using (bucket_id='artworks' and (select public.is_artist()));
