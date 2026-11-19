create table categorias (
  id bigint generated always as identity primary key,
  nome text not null,
  slug text,
  cor text
);

create table jogos (
  id bigint generated always as identity primary key,
  created_at timestamptz default now(),
  nome text not null,
  estudio text,
  ano int,
  descricao text,
  imagem_url text,
  destaque boolean default false,
  categoria_id bigint references categorias(id)
);

insert into categorias (nome, slug, cor) values
  ('Jogo do Ano', 'jogo-do-ano', '#e20543'),
  ('Melhor Direção', 'melhor-direcao', '#bf09cf'),
  ('Melhor Narrativa', 'melhor-narrativa', '#14b8a6'),
  ('Melhor Indie', 'melhor-indie', '#f59e0b'),
  ('Melhor Multiplayer', 'melhor-multiplayer', '#3b82f6');
