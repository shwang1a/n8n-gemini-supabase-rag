-- =====================================================
-- Enable Row Level Security
-- =====================================================

alter table documents enable row level security;

-- =====================================================
-- Service Role
--
-- Service Role 會自動繞過 RLS，
-- 不需要另外建立 Policy。
-- =====================================================


-- =====================================================
-- Authenticated Users
--
-- 預設不允許任何一般登入使用者存取 documents。
-- 若未來需要，可再新增更細緻的 Policy。
-- =====================================================

drop policy if exists "Authenticated can read documents"
on documents;

drop policy if exists "Authenticated can insert documents"
on documents;

drop policy if exists "Authenticated can update documents"
on documents;

drop policy if exists "Authenticated can delete documents"
on documents;

-- =====================================================
-- Optional Read Policy
--
-- 如果未來需要讓登入使用者查詢，可取消註解：
--
-- create policy "Authenticated can read documents"
-- on documents
-- for select
-- to authenticated
-- using (true);
--
-- =====================================================


-- =====================================================
-- Anonymous
--
-- 不允許匿名使用者存取
-- =====================================================

drop policy if exists "Anonymous read"
on documents;

drop policy if exists "Anonymous insert"
on documents;

drop policy if exists "Anonymous update"
on documents;

drop policy if exists "Anonymous delete"
on documents;