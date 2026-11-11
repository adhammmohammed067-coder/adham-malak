-- نفّذ مرة واحدة في محرر SQL في مشروع Supabase
create table if not exists public.memories (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in ('photo','audio')),
  name text not null,
  file_path text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.memories enable row level security;
-- الوصول للجدول والتخزين يتم حصراً من Edge Function بمفتاح الخادم،
-- ولا نضيف سياسات عامة للزوار.
insert into storage.buckets (id,name,public)
values ('adham-malak','adham-malak',false)
on conflict (id) do nothing;


-- شات خاص بين أدهم وملك
create table if not exists public.chat_messages (
  id uuid primary key default gen_random_uuid(),
  sender text not null check (char_length(sender) between 1 and 24),
  body text not null check (char_length(body) between 1 and 1000),
  created_at timestamptz not null default now()
);
alter table public.chat_messages enable row level security;
-- لا توجد سياسات عامة؛ دالة الخادم فقط هي التي تصل للرسائل.
