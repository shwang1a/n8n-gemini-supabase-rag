-- =====================================================
-- Update Timestamp Trigger
-- =====================================================

create or replace function update_updated_at_column()
returns trigger
language plpgsql
as
$$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists trg_documents_updated_at on documents;

create trigger trg_documents_updated_at
before update on documents
for each row
execute function update_updated_at_column();

-- =====================================================
-- Vector Search
-- =====================================================

create or replace function match_documents(

    query_embedding vector(768),

    match_count integer default 5,

    filter jsonb default '{}'::jsonb

)

returns table (

    id uuid,

    file_id text,

    filename text,

    chunk_index integer,

    content text,

    metadata jsonb,

    similarity float

)

language plpgsql

as
$$

begin

    return query

    select

        d.id,

        d.file_id,

        d.filename,

        d.chunk_index,

        d.content,

        d.metadata,

        1 - (d.embedding <=> query_embedding) as similarity

    from documents d

    where

        d.metadata @> filter

    order by

        d.embedding <=> query_embedding

    limit match_count;

end;

$$;

-- =====================================================
-- Search By Filename
-- =====================================================

create or replace function search_documents_by_filename(

    target_filename text

)

returns table (

    id uuid,

    file_id text,

    filename text,

    chunk_index integer,

    content text

)

language sql

as
$$

select

    id,

    file_id,

    filename,

    chunk_index,

    content

from documents

where filename = target_filename

order by chunk_index;

$$;

-- =====================================================
-- Delete File
-- =====================================================

create or replace function delete_document(

    target_file_id text

)

returns void

language sql

as
$$

delete

from documents

where file_id = target_file_id;

$$;

-- =====================================================
-- Check Existing File
-- =====================================================

create or replace function file_exists(

    target_file_id text

)

returns boolean

language sql

as
$$

select exists(

    select 1

    from documents

    where file_id = target_file_id

);

$$;

-- =====================================================
-- File Checksum
-- =====================================================

create or replace function get_file_checksum(

    target_file_id text

)

returns text

language sql

as
$$

select checksum

from documents

where file_id = target_file_id

limit 1;

$$;