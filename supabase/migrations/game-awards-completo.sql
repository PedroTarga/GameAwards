-- Game Awards 2026 — banco completo (cole tudo no SQL Editor do Supabase e clique em Run).
-- Pode rodar de novo: recria as tabelas vazias de dados e carrega tudo outra vez.
-- O usuário do painel NÃO é criado aqui: crie em Authentication > Users > Add user.

create table if not exists categorias (
  id bigint generated always as identity primary key,
  nome text not null,
  slug text,
  cor text
);

create table if not exists jogos (
  id bigint generated always as identity primary key,
  created_at timestamptz default now(),
  nome text not null,
  descricao text,
  imagem_url text,
  destaque boolean default false,
  categoria_id bigint references categorias(id)
);

alter table jogos drop column if exists estudio;
alter table jogos drop column if exists ano;

-- Segurança: todo mundo lê; só quem está logado no painel altera.
alter table categorias enable row level security;
alter table jogos enable row level security;

drop policy if exists "categorias_select_public" on categorias;
drop policy if exists "categorias_write_admin" on categorias;
drop policy if exists "jogos_select_public" on jogos;
drop policy if exists "jogos_write_admin" on jogos;

create policy "categorias_select_public" on categorias for select to anon, authenticated using (true);
create policy "categorias_write_admin" on categorias for all to authenticated using (true) with check (true);
create policy "jogos_select_public" on jogos for select to anon, authenticated using (true);
create policy "jogos_write_admin" on jogos for all to authenticated using (true) with check (true);

-- Limpa os dados antigos
delete from jogos;
delete from categorias;

-- Categorias
insert into categorias (nome, slug, cor) values
  ('Melhor Jogo do Ano', 'melhor-jogo-do-ano', '#e20543'),
  ('Melhor Direção', 'melhor-direcao', '#bf09cf'),
  ('Melhor Narrativa', 'melhor-narrativa', '#14b8a6'),
  ('Melhor Direção de Arte', 'melhor-direcao-de-arte', '#f59e0b'),
  ('Melhor Trilha Sonora e Música', 'melhor-trilha-sonora-e-musica', '#3b82f6'),
  ('Melhor Design de Áudio', 'melhor-design-de-audio', '#ef4444'),
  ('Jogo de Impacto', 'jogo-de-impacto', '#8b5cf6'),
  ('Inovação em Acessibilidade', 'inovacao-em-acessibilidade', '#10b981'),
  ('Melhor Jogo Contínuo', 'melhor-jogo-continuo', '#f97316'),
  ('Melhor Suporte à Comunidade', 'melhor-suporte-a-comunidade', '#06b6d4'),
  ('Melhor Jogo Independente', 'melhor-jogo-independente', '#ec4899'),
  ('Melhor Jogo Independente de Estreia', 'melhor-jogo-independente-de-estreia', '#84cc16'),
  ('Melhor Jogo Mobile', 'melhor-jogo-mobile', '#e20543'),
  ('Melhor Jogo VR/AR', 'melhor-jogo-vr-ar', '#bf09cf'),
  ('Melhor Jogo de Ação', 'melhor-jogo-de-acao', '#14b8a6'),
  ('Melhor Jogo de Ação/Aventura', 'melhor-jogo-de-acao-aventura', '#f59e0b'),
  ('Melhor RPG', 'melhor-rpg', '#3b82f6'),
  ('Melhor Jogo de Luta', 'melhor-jogo-de-luta', '#ef4444'),
  ('Melhor Jogo para a Família', 'melhor-jogo-para-a-familia', '#8b5cf6'),
  ('Melhor Jogo de Simulação/Estratégia', 'melhor-jogo-de-simulacao-estrategia', '#10b981'),
  ('Melhor Jogo de Esporte/Corrida', 'melhor-jogo-de-esporte-corrida', '#f97316'),
  ('Melhor Jogo Multiplayer', 'melhor-jogo-multiplayer', '#06b6d4'),
  ('Jogo Mais Aguardado', 'jogo-mais-aguardado', '#ec4899');

-- Cada linha é (categoria, jogo). Um jogo indicado em várias categorias aparece em cada uma.
insert into jogos (nome, categoria_id)
select v.jogo, c.id
from (values
  ('melhor-jogo-do-ano', '007 First Light'),
  ('melhor-jogo-do-ano', 'Control Resonant'),
  ('melhor-jogo-do-ano', 'GTA 6'),
  ('melhor-jogo-do-ano', 'Phantom Blade Zero'),
  ('melhor-jogo-do-ano', 'Resident Evil Requiem'),
  ('melhor-jogo-do-ano', 'The Legend of Zelda: Ocarina of Time'),
  ('melhor-direcao', 'Control Resonant'),
  ('melhor-direcao', 'GTA 6'),
  ('melhor-direcao', 'Phantom Blade Zero'),
  ('melhor-direcao', 'Pragmata'),
  ('melhor-direcao', 'Resident Evil Requiem'),
  ('melhor-narrativa', '007 First Light'),
  ('melhor-narrativa', 'Control Resonant'),
  ('melhor-narrativa', 'GTA 6'),
  ('melhor-narrativa', 'Resident Evil Requiem'),
  ('melhor-narrativa', 'The Blood of Dawnwalker'),
  ('melhor-direcao-de-arte', 'Control Resonant'),
  ('melhor-direcao-de-arte', 'GTA 6'),
  ('melhor-direcao-de-arte', 'Mouse: P.I. For Hire'),
  ('melhor-direcao-de-arte', 'Phantom Blade Zero'),
  ('melhor-direcao-de-arte', 'The Legend of Zelda: Ocarina of Time'),
  ('melhor-trilha-sonora-e-musica', 'Ace Combat 8: Wings of Theve'),
  ('melhor-trilha-sonora-e-musica', 'GTA 6'),
  ('melhor-trilha-sonora-e-musica', 'Mixtape'),
  ('melhor-trilha-sonora-e-musica', 'Phantom Blade Zero'),
  ('melhor-trilha-sonora-e-musica', 'The Legend of Zelda: Ocarina of Time'),
  ('melhor-design-de-audio', 'Ace Combat 8: Wings of Theve'),
  ('melhor-design-de-audio', 'Control Resonant'),
  ('melhor-design-de-audio', 'GTA 6'),
  ('melhor-design-de-audio', 'Resident Evil Requiem'),
  ('melhor-design-de-audio', 'Star Wars: Galactic Racer'),
  ('jogo-de-impacto', 'Big Walk'),
  ('jogo-de-impacto', 'Cairn'),
  ('jogo-de-impacto', 'Forever Ago'),
  ('jogo-de-impacto', 'Life is Strange: Reunion'),
  ('jogo-de-impacto', 'Lily’s world XD'),
  ('jogo-de-impacto', 'Mixtape'),
  ('inovacao-em-acessibilidade', 'Assassin’s Creed Black Flag Resynced'),
  ('inovacao-em-acessibilidade', 'Forza Horizon 6'),
  ('inovacao-em-acessibilidade', 'Gears of War: E-Day'),
  ('inovacao-em-acessibilidade', 'Marvel’s Wolverine'),
  ('inovacao-em-acessibilidade', 'Rhythm Heaven Groove'),
  ('melhor-jogo-continuo', 'Arc Raiders'),
  ('melhor-jogo-continuo', 'Final Fantasy XIV'),
  ('melhor-jogo-continuo', 'Fortnite'),
  ('melhor-jogo-continuo', 'No Man''s Sky'),
  ('melhor-jogo-continuo', 'The Witcher 3: Wild Hunt'),
  ('melhor-suporte-a-comunidade', 'Crimson Desert'),
  ('melhor-suporte-a-comunidade', 'Helldivers 2'),
  ('melhor-suporte-a-comunidade', 'No Man''s Sky'),
  ('melhor-suporte-a-comunidade', 'The Witcher 3: Wild Hunt'),
  ('melhor-suporte-a-comunidade', 'Warframe'),
  ('melhor-jogo-independente', 'Big Walk'),
  ('melhor-jogo-independente', 'Cairn'),
  ('melhor-jogo-independente', 'Denshattack!'),
  ('melhor-jogo-independente', 'Mewgenics'),
  ('melhor-jogo-independente', 'Mina the Hollower'),
  ('melhor-jogo-independente-de-estreia', 'Dressmaker'),
  ('melhor-jogo-independente-de-estreia', 'Esoteric Ebb'),
  ('melhor-jogo-independente-de-estreia', 'Orbitals'),
  ('melhor-jogo-independente-de-estreia', 'Replaced'),
  ('melhor-jogo-independente-de-estreia', 'Mina the Hollower'),
  ('melhor-jogo-mobile', 'Arknights: Endfield'),
  ('melhor-jogo-mobile', 'Monster Hunter Outlanders'),
  ('melhor-jogo-mobile', 'Neverness to Everness'),
  ('melhor-jogo-mobile', 'Pokémon Champions'),
  ('melhor-jogo-mobile', 'Where Winds Meet'),
  ('melhor-jogo-vr-ar', 'Forefront'),
  ('melhor-jogo-vr-ar', 'Into the Radius 2'),
  ('melhor-jogo-vr-ar', 'Little Nightmares VR: Altered Echoes'),
  ('melhor-jogo-vr-ar', 'Teenage Mutant Ninja Turtles: Empire City'),
  ('melhor-jogo-vr-ar', 'Thief VR: Legacy of Shadow'),
  ('melhor-jogo-de-acao', 'Ace Combat 8: Wings of Theve'),
  ('melhor-jogo-de-acao', 'Gears of War: E-Day'),
  ('melhor-jogo-de-acao', 'Onimusha: Way of the Sword'),
  ('melhor-jogo-de-acao', 'Phantom Blade Zero'),
  ('melhor-jogo-de-acao', 'Saros'),
  ('melhor-jogo-de-acao-aventura', '007 First Light'),
  ('melhor-jogo-de-acao-aventura', 'Control Resonant'),
  ('melhor-jogo-de-acao-aventura', 'GTA 6'),
  ('melhor-jogo-de-acao-aventura', 'Pragmata'),
  ('melhor-jogo-de-acao-aventura', 'Resident Evil Requiem'),
  ('melhor-jogo-de-acao-aventura', 'The Legend of Zelda: Ocarina of Time'),
  ('melhor-rpg', 'Final Fantasy Resonance'),
  ('melhor-rpg', 'Fire Emblem Fortune''s Weave'),
  ('melhor-rpg', 'Monster Hunter Stories 3: Twisted Reflection'),
  ('melhor-rpg', 'The Blood of Dawnwalker'),
  ('melhor-rpg', 'Trails in the Sky 2nd Chapter'),
  ('melhor-jogo-de-luta', '2XKO'),
  ('melhor-jogo-de-luta', 'Avatar Legends: The Fighting Game'),
  ('melhor-jogo-de-luta', 'Invincible VS'),
  ('melhor-jogo-de-luta', 'Marvel Tokon: Fighting Souls'),
  ('melhor-jogo-de-luta', 'My Hero Academia: All''s Justice'),
  ('melhor-jogo-para-a-familia', 'Big Walk'),
  ('melhor-jogo-para-a-familia', 'Lego Batman: Legacy of the Dark Knight'),
  ('melhor-jogo-para-a-familia', 'Pokémon Pokopia'),
  ('melhor-jogo-para-a-familia', 'Yoshi and the Mysterious Book'),
  ('melhor-jogo-de-simulacao-estrategia', 'Mewgenics'),
  ('melhor-jogo-de-simulacao-estrategia', 'Planet Zoo 2'),
  ('melhor-jogo-de-simulacao-estrategia', 'Pokémon Pokopia'),
  ('melhor-jogo-de-simulacao-estrategia', 'Slay the Spire 2'),
  ('melhor-jogo-de-simulacao-estrategia', 'Star Wars Zero Company'),
  ('melhor-jogo-de-esporte-corrida', 'EA Sports FC 27'),
  ('melhor-jogo-de-esporte-corrida', 'Forza Horizon 6'),
  ('melhor-jogo-de-esporte-corrida', 'Nintendo Switch Sports Resort'),
  ('melhor-jogo-de-esporte-corrida', 'Screamer'),
  ('melhor-jogo-de-esporte-corrida', 'Star Wars: Galactic Racer'),
  ('melhor-jogo-multiplayer', 'Big Walk'),
  ('melhor-jogo-multiplayer', 'Call of Duty: Modern Warfare 4'),
  ('melhor-jogo-multiplayer', 'Gears of War: E-Day'),
  ('melhor-jogo-multiplayer', 'Marathon'),
  ('melhor-jogo-multiplayer', 'Meccha Chameleon'),
  ('melhor-jogo-multiplayer', 'Orbitals'),
  ('jogo-mais-aguardado', 'Fable'),
  ('jogo-mais-aguardado', 'Final Fantasy VII Revelation'),
  ('jogo-mais-aguardado', 'God of War Laufey'),
  ('jogo-mais-aguardado', 'Resident Evil Veronic'),
  ('jogo-mais-aguardado', 'The Witcher 4')
) as v(cat, jogo)
join categorias c on c.slug = v.cat;

-- Descrição e imagem de cada jogo (valem para o jogo em todas as categorias).
-- As imagens são capas provisórias; para trocar por uma capa real:
--   update jogos set imagem_url = 'https://...' where nome = 'GTA 6';
update jogos j
set descricao = v.descricao, imagem_url = v.imagem
from (values
  ('007 First Light', 'Aventura de ação e espionagem com James Bond, desenvolvida pela IO Interactive.', 'https://imgs.search.brave.com/qDA-pUy5rlEvMTU5h-YocwXpR_ae5vLY4xNfCmYELJk/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi8y/LzJiLzAwN19GaXJz/dF9MaWdodF8oMjAy/NilfY292ZXIuanBn/LzI1MHB4LTAwN19G/aXJzdF9MaWdodF8o/MjAyNilfY292ZXIu/anBnP3V0bV9zb3Vy/Y2U9ZW4ud2lraXBl/ZGlhLm9yZyZ1dG1f/Y2FtcGFpZ249cGFy/c2VyJnV0bV9jb250/ZW50PXRodW1ibmFp/bA'),
  ('Control Resonant', 'Ação sobrenatural em terceira pessoa, da série Control.', 'https://imgs.search.brave.com/Y-VISiTzMyCufe05qlN8cvqbgbI1OgmBRu4-lAYnves/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zaGFy/ZWQuYWthbWFpLnN0/ZWFtc3RhdGljLmNv/bS9zdG9yZV9pdGVt/X2Fzc2V0cy9zdGVh/bS9hcHBzLzM2Njk4/NzAvMWUwYzc2ZTQy/NTNkMzQ3YmIxMzA0/YzNmMjEzNTcwMjUx/ZDkyNGVkZi9oZWFk/ZXIuanBnP3Q9MTc5/NTAxMDUwMg'),
  ('GTA 6', 'Novo jogo de mundo aberto da Rockstar Games, ambientado no estado fictício de Leonida, com Jason e Lucia como protagonistas.', 'https://imgs.search.brave.com/JwK1DFezRkTto6PPmTW7euVw7QmtgNADiu-TfTuVpLY/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi80/LzQ2L0dyYW5kX1Ro/ZWZ0X0F1dG9fVkku/cG5nLzI1MHB4LUdy/YW5kX1RoZWZ0X0F1/dG9fVkkucG5nP3V0/bV9zb3VyY2U9ZW4u/d2lraXBlZGlhLm9y/ZyZ1dG1fY2FtcGFp/Z249cGFyc2VyJnV0/bV9jb250ZW50PXRo/dW1ibmFpbA'),
  ('Phantom Blade Zero', 'Jogo de ação com combate de espadas rápido e fantasia sombria inspirada em artes marciais chinesas, do estúdio S-Game.', 'https://imgs.search.brave.com/FAHZY80loYZq-Fi9VLreua8QAczLuuT_1D8IiGGDgqg/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi80/LzQxL1BoYW50b21f/QmxhZGVfWmVyb19j/b3Zlcl9hcnQuanBn/LzI1MHB4LVBoYW50/b21fQmxhZGVfWmVy/b19jb3Zlcl9hcnQu/anBnP3V0bV9zb3Vy/Y2U9ZW4ud2lraXBl/ZGlhLm9yZyZ1dG1f/Y2FtcGFpZ249cGFy/c2VyJnV0bV9jb250/ZW50PXRodW1ibmFp/bA'),
  ('Resident Evil Requiem', 'Novo capítulo da série de terror de sobrevivência da Capcom.', 'https://imgs.search.brave.com/9WnJFTQD-634NbQChmKuZ3Ir1cOadSIp5TsqVswzanA/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi8x/LzE1L1Jlc2lkZW50/X0V2aWxfUmVxdWll/bV9Db3Zlcl9BcnQu/anBnLzI1MHB4LVJl/c2lkZW50X0V2aWxf/UmVxdWllbV9Db3Zl/cl9BcnQuanBnP3V0/bV9zb3VyY2U9ZW4u/d2lraXBlZGlhLm9y/ZyZ1dG1fY2FtcGFp/Z249cGFyc2VyJnV0/bV9jb250ZW50PXRo/dW1ibmFpbA'),
  ('The Legend of Zelda: Ocarina of Time', 'Clássico da série Zelda, da Nintendo, em que Link viaja entre dois tempos para enfrentar Ganondorf.', 'https://imgs.search.brave.com/jeP0_Nj-uqqa47ZxIxpOqMk0ttIi0dVdM8xn2xMjLHY/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi83/LzdhL09jYXJpbmFv/ZlRpbWUyMDI2Lmpw/ZWcvMjUwcHgtT2Nh/cmluYW9mVGltZTIw/MjYuanBlZz91dG1f/c291cmNlPWVuLndp/a2lwZWRpYS5vcmcm/dXRtX2NhbXBhaWdu/PXBhcnNlciZ1dG1f/Y29udGVudD10aHVt/Ym5haWw'),
  ('Pragmata', 'Ficção científica de ação e aventura da Capcom, ambientada na Lua.', 'https://imgs.search.brave.com/fUO__RQpX8OScVb8qsHWeP-UrInJVm0ed-KOOCJ50ts/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9jb21tb25zL3Ro/dW1iL2YvZmIvUHJh/Z21hdGFfY292ZXIu/anBnLzI1MHB4LVBy/YWdtYXRhX2NvdmVy/LmpwZz91dG1fc291/cmNlPWVuLndpa2lw/ZWRpYS5vcmcmdXRt/X2NhbXBhaWduPXBh/cnNlciZ1dG1fY29u/dGVudD10aHVtYm5h/aWw'),
  ('The Blood of Dawnwalker', 'RPG de ação em mundo aberto, do estúdio Rebel Wolves, num cenário de fantasia sombria com vampiros.', 'https://imgs.search.brave.com/PxuIjD0HkIEBqy9jeWAW8QPIihtXp6pZ2wDxtekq6UQ/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi84/LzhjL1RoZV9CbG9v/ZF9vZl9EYXdud2Fs/a2VyX2NvdmVyX2Fy/dC5qcGcvMjUwcHgt/VGhlX0Jsb29kX29m/X0Rhd253YWxrZXJf/Y292ZXJfYXJ0Lmpw/Zz91dG1fc291cmNl/PWVuLndpa2lwZWRp/YS5vcmcmdXRtX2Nh/bXBhaWduPXBhcnNl/ciZ1dG1fY29udGVu/dD10aHVtYm5haWw'),
  ('Mouse: P.I. For Hire', 'Jogo de tiro em primeira pessoa com visual de desenho animado antigo e história de detetive.', 'https://imgs.search.brave.com/uPFQsevnXhgFWmPzBTfLAIITE8UHy7qpHNNZXhxvyLw/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Ym5haWxzLnBjZ2Ft/aW5nd2lraS5jb20v/YS9hNC9Nb3VzZV9Q/LkkuX0Zvcl9IaXJl/X2NvdmVyLmpwZy8z/MDBweC1Nb3VzZV9Q/LkkuX0Zvcl9IaXJl/X2NvdmVyLmpwZw'),
  ('Ace Combat 8: Wings of Theve', 'Jogo de combate aéreo da série Ace Combat, da Bandai Namco.', 'https://imgs.search.brave.com/Uh24BXrN7gNR1kRydulggVW_lM6zwMFPthrAoJkOx-A/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi9i/L2JkL0FjZV9Db21i/YXRfOF9jb3Zlcl9h/cnQuanBnLzI1MHB4/LUFjZV9Db21iYXRf/OF9jb3Zlcl9hcnQu/anBnP3V0bV9zb3Vy/Y2U9ZW4ud2lraXBl/ZGlhLm9yZyZ1dG1f/Y2FtcGFpZ249cGFy/c2VyJnV0bV9jb250/ZW50PXRodW1ibmFp/bA'),
  ('Mixtape', 'Aventura narrativa sobre amizade e memórias, guiada por uma trilha sonora marcante.', 'https://imgs.search.brave.com/x10R7U9BWamYltYRHEkXp9ye5gVKmR_rmQ8icnTRIuo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvZW4vMS8xYy9N/aXh0YXBlX3ZpZGVv/X2dhbWVfcG9zdGVy/LmpwZz91dG1fc291/cmNlPWVuLndpa2lw/ZWRpYS5vcmcmdXRt/X2NhbXBhaWduPXBh/cnNlciZ1dG1fY29u/dGVudD10aHVtYm5h/aWxfdW5zY2FsZWQ'),
  ('Star Wars: Galactic Racer', 'Jogo de corrida ambientado no universo Star Wars.', 'https://imgs.search.brave.com/j3wrjpgpL2ja0v1TepqL0z-BdsCAf5EeIayvUlq8jcQ/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi8x/LzE0L1N0YXJfV2Fy/c19HYWxhY3RpY19S/YWNlcl9jb3Zlcl9h/cnQuanBnLzI1MHB4/LVN0YXJfV2Fyc19H/YWxhY3RpY19SYWNl/cl9jb3Zlcl9hcnQu/anBnP3V0bV9zb3Vy/Y2U9ZW4ud2lraXBl/ZGlhLm9yZyZ1dG1f/Y2FtcGFpZ249cGFy/c2VyJnV0bV9jb250/ZW50PXRodW1ibmFp/bA'),
  ('Big Walk', 'Jogo cooperativo de exploração, do estúdio House House, de Untitled Goose Game.', 'https://imgs.search.brave.com/_KrEJ1eaJZ2dr2BIDN0PXWyBYM4uXv3Xvi9Vx4rbG84/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Ym5haWxzLnBjZ2Ft/aW5nd2lraS5jb20v/Yi9iNy9CaWdfV2Fs/a19jb3Zlci5qcGcv/MzAwcHgtQmlnX1dh/bGtfY292ZXIuanBn'),
  ('Cairn', 'Jogo de escalada em que cada movimento exige planejamento, do estúdio The Game Bakers.', 'https://imgs.search.brave.com/DoJKtf9rxq-pKObFz34KKUN9q7Z4PDDaO_LmHFAGi1k/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi8z/LzNkL0NhaXJuX2Nv/dmVyX2FydC5qcGcv/MjUwcHgtQ2Fpcm5f/Y292ZXJfYXJ0Lmpw/Zz91dG1fc291cmNl/PWVuLndpa2lwZWRp/YS5vcmcmdXRtX2Nh/bXBhaWduPXBhcnNl/ciZ1dG1fY29udGVu/dD10aHVtYm5haWw'),
  ('Forever Ago', 'Indicado ao The Game Awards 2026 em: Jogo de Impacto.', 'https://imgs.search.brave.com/t0Y6hHwkAqmf32g9MRHHWbuHYnTaMN-f4Q3VdduN8pg/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Ym5haWxzLnBjZ2Ft/aW5nd2lraS5jb20v/NC80YS9Gb3JldmVy/X0Fnb19jb3Zlci5q/cGcvMzAwcHgtRm9y/ZXZlcl9BZ29fY292/ZXIuanBn'),
  ('Life is Strange: Reunion', 'Novo capítulo da série de aventuras narrativas Life is Strange.', 'https://imgs.search.brave.com/AA9YgZJz_xPqAf9pbEPu3o6kPrxkp3tWDBSVIRb_TX4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zaGFy/ZWQuZmFzdGx5LnN0/ZWFtc3RhdGljLmNv/bS9zdG9yZV9pdGVt/X2Fzc2V0cy9zdGVh/bS9hcHBzLzI2MjQ4/NzAvMDljNDg2ZjFl/YmY3YzMwZWJmM2Fi/ZjVkZjA1NDgzM2Iw/M2MzMzY3ZC9oZWFk/ZXIuanBnP3Q9MTc3/NTU3ODkxMA'),
  ('Lily’s world XD', 'Indicado ao The Game Awards 2026 em: Jogo de Impacto.', 'https://imgs.search.brave.com/eVYf1J-sAvMmsSYBRkXORiKf4dDu_CQw1svaM4uDE4U/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YXByb3h5LnR2dHJv/cGVzLm9yZy93aWR0/aC8xMjAwL2h0dHBz/Oi8vc3RhdGljLnR2/dHJvcGVzLm9yZy9w/bXdpa2kvcHViL2lt/YWdlcy9saWx5XzE1/NS5qcGc'),
  ('Assassin’s Creed Black Flag Resynced', 'Remake de Assassin’s Creed IV: Black Flag, da Ubisoft, com aventuras de pirata em alto-mar.', 'https://imgs.search.brave.com/DJ0C47TMWg41HlBgVzxM9kdoKpNjZJIHtQmw6v7z_vs/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMtcHJkLmlnbmlt/Z3MuY29tLzIwMjYv/MDQvMjMvMDk2MmJj/OTFhNDk1MmU2NDMz/MzY3ZmNmZWMzOGI3/ZTA2NTVjNmJkMjli/NDMxNzEyLTE3NzY5/NzUwNTk3MzYuanBn/P2Nyb3A9MToxLHNt/YXJ0JmZvcm1hdD1q/cGcmYXV0bz13ZWJw/JnF1YWxpdHk9ODA'),
  ('Forza Horizon 6', 'Jogo de corrida em mundo aberto da série Forza Horizon, da Playground Games.', 'https://imgs.search.brave.com/4dfEqa2fna1XFy38_oww6LurJ6Ugg-gPTkfgmKx79eU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdG9y/ZS1pbWFnZXMucy1t/aWNyb3NvZnQuY29t/L2ltYWdlL2FwcHMu/Mjk4NTYuMTQyMDIy/Nzg3NjQ2ODAwODku/OGU0Yzc4NmEtMGEx/Yy00NzM3LWEyNDQt/MGJkZmEzNGFhYjdi/LjY0ODgzY2FjLTI1/YTgtNDcxNS1hMGRj/LTBkZDQyYjBlNTQz/NQ'),
  ('Gears of War: E-Day', 'Prelúdio da série Gears of War, da The Coalition.', 'https://imgs.search.brave.com/MiFm-SI51vu4qOeuEe1R-wGplJo1Skl3xwbnEVrq31M/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi85/LzllL0dlYXJzX29m/X1dhcl9FLURheV9j/b3Zlcl9hcnQucG5n/LzI1MHB4LUdlYXJz/X29mX1dhcl9FLURh/eV9jb3Zlcl9hcnQu/cG5nP3V0bV9zb3Vy/Y2U9ZW4ud2lraXBl/ZGlhLm9yZyZ1dG1f/Y2FtcGFpZ249cGFy/c2VyJnV0bV9jb250/ZW50PXRodW1ibmFp/bA'),
  ('Marvel’s Wolverine', 'Aventura de ação do Wolverine, desenvolvida pela Insomniac Games.', 'https://imgs.search.brave.com/lgGLOyLdYbTeP8mPOg-xv-S2TV-1UihwMQUK_Mqj51E/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWFn/ZS5hcGkucGxheXN0/YXRpb24uY29tL3Z1/bGNhbi9hcC9ybmQv/MjAyNjA1LzIyMjEv/ZWQ2ZmU4N2JiYzE4/NDVmMWRkYmE0ZTVi/ZDk1YjU1ZTc2YzRm/ZTRhOGIyZTg0M2Rh/LnBuZw'),
  ('Rhythm Heaven Groove', 'Jogo de ritmo da Nintendo com minijogos musicais.', 'https://imgs.search.brave.com/vGRjQ0ACVl6jogbMHqknyTNYetL2a7JZ0wCBFRwuIPE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi85/LzkwL1JoeXRobV9I/ZWF2ZW5fR3Jvb3Zl/LmpwZy8yNTBweC1S/aHl0aG1fSGVhdmVu/X0dyb292ZS5qcGc_/dXRtX3NvdXJjZT1l/bi53aWtpcGVkaWEu/b3JnJnV0bV9jYW1w/YWlnbj1wYXJzZXIm/dXRtX2NvbnRlbnQ9/dGh1bWJuYWls'),
  ('Arc Raiders', 'Jogo de tiro de extração cooperativo, do estúdio Embark.', 'https://imgs.search.brave.com/l5jm8CYpv2SoFdu7F8DCTwndp6v6kDkO9EyRbseaScs/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90aHVt/Yi53aWtpbWVkaWEu/b3JnL3dpa2lwZWRp/YS9lbi90aHVtYi83/LzczL0FyY19SYWlk/ZXJzX2NvdmVyX2Fy/dC5qcGcvMjUwcHgt/QXJjX1JhaWRlcnNf/Y292ZXJfYXJ0Lmpw/Zz91dG1fc291cmNl/PWVuLndpa2lwZWRp/YS5vcmcmdXRtX2Nh/bXBhaWduPXBhcnNl/ciZ1dG1fY29udGVu/dD10aHVtYm5haWw'),
  ('Final Fantasy XIV', 'MMORPG da Square Enix, em constante expansão.', 'https://imgs.search.brave.com/Me1EQkgumi8fIabs5M4XP8JrZBtVN1qvpi74weN-bG0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMubmludGVuZG8u/Y29tL2ltYWdlL3Vw/bG9hZC9hcl8xNjo5/LGNfbHBhZCx3XzEy/NDAvYl93aGl0ZS9m/X2F1dG8vcV9hdXRv/L3N0b3JlL3NvZnR3/YXJlL3N3aXRjaDIv/NzAwNTAwMDAwNjk1/NTIvYTA2NDM4ZWE5/N2EwNjNjY2ZlMDk3/MWFkNDYxMGVhNmQz/YzQxNDY5ZjRjOTcx/NWM2M2JjNDZiMzBi/MDg5ODA0Yg'),
  ('Fortnite', 'Battle royale e plataforma de jogos da Epic Games.', 'https://imgs.search.brave.com/I9ftbv_muDh0PgbTkCb7pQPN1eAZnxNmCWqvrcs5J4c/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMtcHJkLmlnbmlt/Z3MuY29tLzIwMjUv/MDQvMDIvbmludGVu/ZG9zd2l0Y2gyLWZv/cnRuaXRlLWtleWFy/dC1zcXVhcmUtMTc0/MzYzNTY3NTQyOS5q/cGc_Y3JvcD0xOjEs/c21hcnQmZm9ybWF0/PWpwZyZhdXRvPXdl/YnAmcXVhbGl0eT04/MA'),
  ('No Man''s Sky', 'Jogo de exploração espacial do estúdio Hello Games, atualizado há anos.', 'https://imgs.search.brave.com/PYFjdMdW7qIIKcv1YZD_i-smB2p_gpLTC9E5_uC0pys/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMxLmlnbmltZ3Mu/Y29tLzIwMTkvMDgv/MTQvbm8tbWFucy1z/a3ktLS1iZXlvbmQt/dmVyc2lvbi0tLWJ1/dHRvbi0xNTY1NzQ0/OTA1MDYxLmpwZz9j/cm9wPTE6MSxzbWFy/dCZmb3JtYXQ9anBn/JmF1dG89d2VicCZx/dWFsaXR5PTgw'),
  ('The Witcher 3: Wild Hunt', 'RPG de mundo aberto da CD Projekt Red, com o caçador de monstros Geralt de Rívia.', 'https://imgs.search.brave.com/4r94b3m-c0hMW2PgP4-AVohkyhEISQvtcV2BHGP7wRo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMtcHJkLmlnbmlt/Z3MuY29tLzIwMjEv/MTIvMDgvd2l0Y2hl/cjMtMTYzODk4NzY1/OTY3OS5qcGc_Y3Jv/cD0xOjEsc21hcnQm/Zm9ybWF0PWpwZyZh/dXRvPXdlYnAmcXVh/bGl0eT04MA'),
  ('Crimson Desert', 'Jogo de ação e aventura em mundo aberto, da Pearl Abyss.', 'https://imgs.search.brave.com/dah6xXa6d6yH__7UMDBgDLMIEe6Ic1Jxfk8tCYzCEQg/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWFn/ZS5hcGkucGxheXN0/YXRpb24uY29tL3Z1/bGNhbi9hcC9ybmQv/MjAyNjA4LzIwMDYv/OGJkMmFmZmI0OTM5/YmY2NjNiMWJkN2E3/OGFkODMzNDViZmQx/ZGYzZTk2MWMyYTcy/LmpwZw'),
  ('Helldivers 2', 'Jogo de tiro cooperativo da Arrowhead, com guerra contra alienígenas.', 'https://imgs.search.brave.com/pN3j530pIWSfNFLMmuxpE6Cn-qN5pXEqoexhU-glTqo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9oZWxs/ZGl2ZXJzLndpa2ku/Z2cvaW1hZ2VzL0hl/bGxkaXZlcnNfMl9L/ZXlfQXJ0XzR4My5w/bmc_YWIyNjJk'),
  ('Warframe', 'Jogo de ação cooperativo gratuito, da Digital Extremes.', 'https://placehold.co/600x800/0a5f73/ffffff/png?text=Warframe'),
  ('Denshattack!', 'Indicado ao The Game Awards 2026 em: Melhor Jogo Independente.', 'https://placehold.co/600x800/9a3f08/ffffff/png?text=Denshattack%21'),
  ('Mewgenics', 'Jogo de estratégia por turnos sobre criar gatos, de Edmund McMillen, criador de The Binding of Isaac.', 'https://placehold.co/600x800/0a5f73/ffffff/png?text=Mewgenics'),
  ('Mina the Hollower', 'Aventura de ação em 2D com visual retrô, da Yacht Club Games.', 'https://placehold.co/600x800/9a3f08/ffffff/png?text=Mina+the+Hollower'),
  ('Dressmaker', 'Indicado ao The Game Awards 2026 em: Melhor Jogo Independente de Estreia.', 'https://placehold.co/600x800/5b0a63/ffffff/png?text=Dressmaker'),
  ('Esoteric Ebb', 'Indicado ao The Game Awards 2026 em: Melhor Jogo Independente de Estreia.', 'https://placehold.co/600x800/0a5f73/ffffff/png?text=Esoteric+Ebb'),
  ('Orbitals', 'Indicado ao The Game Awards 2026 em: Melhor Jogo Independente de Estreia, Melhor Jogo Multiplayer.', 'https://placehold.co/600x800/4a6b0a/ffffff/png?text=Orbitals'),
  ('Replaced', 'Jogo de ação e plataforma em pixel art, num mundo de ficção científica retrô.', 'https://placehold.co/600x800/9a3f08/ffffff/png?text=Replaced'),
  ('Arknights: Endfield', 'Jogo da série Arknights, da Hypergryph.', 'https://placehold.co/600x800/0a6b4a/ffffff/png?text=Arknights%3A+Endfield'),
  ('Monster Hunter Outlanders', 'Jogo para celular da série Monster Hunter.', 'https://placehold.co/600x800/4c2a8f/ffffff/png?text=Monster+Hunter+Outlanders'),
  ('Neverness to Everness', 'RPG de ação em mundo aberto urbano com toques sobrenaturais.', 'https://placehold.co/600x800/173f8f/ffffff/png?text=Neverness+to+Everness'),
  ('Pokémon Champions', 'Jogo de batalhas competitivas de Pokémon.', 'https://placehold.co/600x800/4a6b0a/ffffff/png?text=Pok%C3%A9mon+Champions'),
  ('Where Winds Meet', 'RPG de ação em mundo aberto ambientado na China antiga.', 'https://placehold.co/600x800/4a6b0a/ffffff/png?text=Where+Winds+Meet'),
  ('Forefront', 'Indicado ao The Game Awards 2026 em: Melhor Jogo VR/AR.', 'https://placehold.co/600x800/4a6b0a/ffffff/png?text=Forefront'),
  ('Into the Radius 2', 'Jogo de sobrevivência em primeira pessoa em realidade virtual.', 'https://placehold.co/600x800/4c2a8f/ffffff/png?text=Into+the+Radius+2'),
  ('Little Nightmares VR: Altered Echoes', 'Versão em realidade virtual da série de terror Little Nightmares.', 'https://placehold.co/600x800/8f1c58/ffffff/png?text=Little+Nightmares+VR%3A+Altered+Echoes'),
  ('Teenage Mutant Ninja Turtles: Empire City', 'Jogo em realidade virtual com as Tartarugas Ninja.', 'https://placehold.co/600x800/8f1c58/ffffff/png?text=Teenage+Mutant+Ninja+Turtles%3A+Empire+City'),
  ('Thief VR: Legacy of Shadow', 'Jogo de furtividade em realidade virtual, da série Thief.', 'https://placehold.co/600x800/4a6b0a/ffffff/png?text=Thief+VR%3A+Legacy+of+Shadow'),
  ('Onimusha: Way of the Sword', 'Ação de samurais da Capcom, retorno da série Onimusha.', 'https://placehold.co/600x800/4a6b0a/ffffff/png?text=Onimusha%3A+Way+of+the+Sword'),
  ('Saros', 'Jogo de ação e tiro da Housemarque, estúdio de Returnal.', 'https://placehold.co/600x800/7a0a2e/ffffff/png?text=Saros'),
  ('Final Fantasy Resonance', 'Indicado ao The Game Awards 2026 em: Melhor RPG.', 'https://placehold.co/600x800/7a0a2e/ffffff/png?text=Final+Fantasy+Resonance'),
  ('Fire Emblem Fortune''s Weave', 'RPG tático da série Fire Emblem, da Nintendo.', 'https://placehold.co/600x800/0a6b4a/ffffff/png?text=Fire+Emblem+Fortune%27s+Weave'),
  ('Monster Hunter Stories 3: Twisted Reflection', 'RPG da série Monster Hunter, da Capcom, em que se criam e montam monstros.', 'https://placehold.co/600x800/7a0a2e/ffffff/png?text=Monster+Hunter+Stories+3%3A+Twisted+Reflection'),
  ('Trails in the Sky 2nd Chapter', 'RPG clássico da Nihon Falcom, da série Trails.', 'https://placehold.co/600x800/4c2a8f/ffffff/png?text=Trails+in+the+Sky+2nd+Chapter'),
  ('2XKO', 'Jogo de luta em duplas com personagens de League of Legends, da Riot Games.', 'https://placehold.co/600x800/0a6b4a/ffffff/png?text=2XKO'),
  ('Avatar Legends: The Fighting Game', 'Jogo de luta baseado nas séries Avatar: A Lenda de Aang e A Lenda de Korra.', 'https://placehold.co/600x800/173f8f/ffffff/png?text=Avatar+Legends%3A+The+Fighting+Game'),
  ('Invincible VS', 'Jogo de luta em equipes baseado na série Invincible.', 'https://placehold.co/600x800/0a6b4a/ffffff/png?text=Invincible+VS'),
  ('Marvel Tokon: Fighting Souls', 'Jogo de luta em equipes com heróis da Marvel, da Arc System Works.', 'https://placehold.co/600x800/0a5f73/ffffff/png?text=Marvel+Tokon%3A+Fighting+Souls'),
  ('My Hero Academia: All''s Justice', 'Jogo de luta baseado no anime My Hero Academia.', 'https://placehold.co/600x800/173f8f/ffffff/png?text=My+Hero+Academia%3A+All%27s+Justice'),
  ('Lego Batman: Legacy of the Dark Knight', 'Aventura em Lego com o Batman.', 'https://placehold.co/600x800/8a1c1c/ffffff/png?text=Lego+Batman%3A+Legacy+of+the+Dark+Knight'),
  ('Pokémon Pokopia', 'Jogo de simulação e criação com Pokémon.', 'https://placehold.co/600x800/7a0a2e/ffffff/png?text=Pok%C3%A9mon+Pokopia'),
  ('Yoshi and the Mysterious Book', 'Aventura de plataforma da Nintendo com o Yoshi.', 'https://placehold.co/600x800/5b0a63/ffffff/png?text=Yoshi+and+the+Mysterious+Book'),
  ('Planet Zoo 2', 'Simulador de construção e gestão de zoológico.', 'https://placehold.co/600x800/173f8f/ffffff/png?text=Planet+Zoo+2'),
  ('Slay the Spire 2', 'Sequência do jogo de cartas roguelike da Mega Crit.', 'https://placehold.co/600x800/4a6b0a/ffffff/png?text=Slay+the+Spire+2'),
  ('Star Wars Zero Company', 'Jogo de estratégia tática do universo Star Wars.', 'https://placehold.co/600x800/8a1c1c/ffffff/png?text=Star+Wars+Zero+Company'),
  ('EA Sports FC 27', 'Jogo de futebol da EA Sports.', 'https://placehold.co/600x800/5b0a63/ffffff/png?text=EA+Sports+FC+27'),
  ('Nintendo Switch Sports Resort', 'Jogo de esportes da Nintendo para o Switch.', 'https://placehold.co/600x800/8a4b05/ffffff/png?text=Nintendo+Switch+Sports+Resort'),
  ('Screamer', 'Jogo de corrida arcade, da Milestone.', 'https://placehold.co/600x800/5b0a63/ffffff/png?text=Screamer'),
  ('Call of Duty: Modern Warfare 4', 'Jogo de tiro da série Call of Duty.', 'https://placehold.co/600x800/4c2a8f/ffffff/png?text=Call+of+Duty%3A+Modern+Warfare+4'),
  ('Marathon', 'Jogo de tiro de extração da Bungie.', 'https://placehold.co/600x800/4c2a8f/ffffff/png?text=Marathon'),
  ('Meccha Chameleon', 'Indicado ao The Game Awards 2026 em: Melhor Jogo Multiplayer.', 'https://placehold.co/600x800/0b5f56/ffffff/png?text=Meccha+Chameleon'),
  ('Fable', 'RPG de ação em mundo de fantasia, da Playground Games.', 'https://placehold.co/600x800/8a4b05/ffffff/png?text=Fable'),
  ('Final Fantasy VII Revelation', 'Indicado ao The Game Awards 2026 em: Jogo Mais Aguardado.', 'https://placehold.co/600x800/173f8f/ffffff/png?text=Final+Fantasy+VII+Revelation'),
  ('God of War Laufey', 'Indicado ao The Game Awards 2026 em: Jogo Mais Aguardado.', 'https://placehold.co/600x800/7a0a2e/ffffff/png?text=God+of+War+Laufey'),
  ('Resident Evil Veronic', 'Indicado ao The Game Awards 2026 em: Jogo Mais Aguardado.', 'https://placehold.co/600x800/8f1c58/ffffff/png?text=Resident+Evil+Veronic'),
  ('The Witcher 4', 'Novo jogo da série The Witcher, da CD Projekt Red.', 'https://placehold.co/600x800/8a4b05/ffffff/png?text=The+Witcher+4')
) as v(nome, descricao, imagem)
where j.nome = v.nome;

-- Os indicados a Melhor Jogo do Ano aparecem no carrossel de destaques.
update jogos set destaque = true
where categoria_id = (select id from categorias where slug = 'melhor-jogo-do-ano');