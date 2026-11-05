-- Pawna Escape: shared villa-or-camping preference poll
-- Run this once in Supabase Dashboard -> SQL Editor.
-- The browser can submit votes and read aggregate counts only.
-- Voter names are not exposed by the public results function.

create table if not exists public.pawna_villa_votes (
  voter_key uuid primary key,
  voter_name text not null check (char_length(trim(voter_name)) between 2 and 80),
  villa_id text not null check (villa_id in (
    'kino-lakeside',
    'atlantis-4bhk',
    'sierra-vista',
    'lake-sanctuary'
  )),
  updated_at timestamptz not null default now()
);

-- Rebuild the allowed-choice constraint so existing projects can add the camping option.
alter table public.pawna_villa_votes
  drop constraint if exists pawna_villa_votes_villa_id_check;
alter table public.pawna_villa_votes
  add constraint pawna_villa_votes_villa_id_check
  check (villa_id in (
    'kino-lakeside',
    'atlantis-4bhk',
    'sierra-vista',
    'lake-sanctuary',
    'pawna-camping'
  ));

alter table public.pawna_villa_votes enable row level security;
revoke all on table public.pawna_villa_votes from anon, authenticated;

create or replace function public.cast_pawna_villa_vote(
  p_voter_key uuid,
  p_voter_name text,
  p_villa_id text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  cleaned_name text := trim(coalesce(p_voter_name, ''));
begin
  if p_voter_key is null then
    raise exception 'A voter key is required';
  end if;

  if char_length(cleaned_name) < 2 or char_length(cleaned_name) > 80 then
    raise exception 'Enter a name between 2 and 80 characters';
  end if;

  if p_villa_id not in (
    'kino-lakeside',
    'atlantis-4bhk',
    'sierra-vista',
    'lake-sanctuary',
    'pawna-camping'
  ) then
    raise exception 'Choose a stay option from the shortlist';
  end if;

  insert into public.pawna_villa_votes (voter_key, voter_name, villa_id, updated_at)
  values (p_voter_key, cleaned_name, p_villa_id, now())
  on conflict (voter_key) do update
    set voter_name = excluded.voter_name,
        villa_id = excluded.villa_id,
        updated_at = now();
end;
$$;

create or replace function public.get_pawna_villa_vote_counts()
returns table (villa_id text, vote_count bigint)
language sql
stable
security definer
set search_path = public
as $$
  select v.villa_id, count(*)::bigint as vote_count
  from public.pawna_villa_votes v
  group by v.villa_id;
$$;

revoke all on function public.cast_pawna_villa_vote(uuid, text, text) from public;
revoke all on function public.get_pawna_villa_vote_counts() from public;

grant execute on function public.cast_pawna_villa_vote(uuid, text, text) to anon, authenticated;
grant execute on function public.get_pawna_villa_vote_counts() to anon, authenticated;
