-- =====================================================
-- Enable Extensions
-- =====================================================

create extension if not exists vector;
create extension if not exists pgcrypto;

-- =====================================================
-- Documents
-- =====================================================

create table if not exists documents (

    id uuid primary key default gen_random_uuid(),

    file_id text not null,

    filename text not null,

    mime_type text,

    chunk_index integer not null,

    content text not null,

    metadata jsonb default '{}'::jsonb,

    embedding vector(768) not null,

    checksum text,

    created_at timestamptz default now(),

    updated_at timestamptz default now()
);

-- =====================================================
-- Indexes
-- =====================================================

create unique index if not exists idx_documents_chunk
on documents(file_id, chunk_index);

create index if not exists idx_documents_filename
on documents(filename);

create index if not exists idx_documents_metadata
on documents using gin(metadata);

create index if not exists idx_documents_embedding
on documents
using ivfflat
(
    embedding vector_cosine_ops
)
with
(
    lists = 100
);

analyze documents;