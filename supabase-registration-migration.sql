begin;

-- Bổ sung thông tin đăng ký riêng cho từng vai trò.
alter table public.profiles
  add column if not exists tax_code text,
  add column if not exists address text,
  add column if not exists driver_license_number text,
  add column if not exists driver_license_class text;

-- Tài khoản farmer cũ được chuyển sang exporter trước khi đổi ràng buộc.
update public.profiles
set role = 'exporter',
    updated_at = now()
where role = 'farmer';

-- Xóa ràng buộc CHECK cũ liên quan đến role, bất kể tên constraint.
do $$
declare
  role_constraint record;
begin
  for role_constraint in
    select conname
    from pg_constraint
    where conrelid = 'public.profiles'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) ilike '%role%'
  loop
    execute format(
      'alter table public.profiles drop constraint %I',
      role_constraint.conname
    );
  end loop;
end $$;

alter table public.profiles
  add constraint profiles_role_check
  check (role in ('exporter', 'carrier', 'driver'));

alter table public.profiles enable row level security;

drop policy if exists "Nguoi dung xem ho so cua minh"
on public.profiles;

create policy "Nguoi dung xem ho so cua minh"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

drop policy if exists "Nguoi dung tao ho so cua minh"
on public.profiles;

create policy "Nguoi dung tao ho so cua minh"
on public.profiles
for insert
to authenticated
with check (
  auth.uid() = id
  and role in ('exporter', 'carrier', 'driver')
);

grant select, insert on table public.profiles to authenticated;

-- Chỉ exporter được tạo nhu cầu vận chuyển.
drop policy if exists "Nguoi dung tao dang ky cua minh"
on public.bookings;

create policy "Nguoi dung tao dang ky cua minh"
on public.bookings
for insert
to authenticated
with check (
  auth.uid() = user_id
  and exists (
    select 1
    from public.profiles
    where profiles.id = auth.uid()
      and profiles.role = 'exporter'
      and profiles.account_status = 'active'
  )
);

commit;
