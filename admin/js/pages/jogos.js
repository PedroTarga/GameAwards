/* Painel: cadastro, listagem e exclusão de jogos. Depende de: dom, categoriasService, jogosService. */
(function () {
    "use strict";

    const $ = (id) => document.getElementById(id);
    const msg = (texto) => { $("msg").textContent = texto; };

    async function carregarCategorias() {
        try {
            const categorias = await categoriasService.list();
            $("categoria").innerHTML = categorias
                .map((c) => `<option value="${dom.escapeHtml(c.id)}">${dom.escapeHtml(c.nome)}</option>`).join("");
        } catch (erro) {
            msg("Não foi possível carregar as categorias.");
        }
    }

    async function carregarJogos() {
        try {
            const jogos = await jogosService.list();
            $("lista").innerHTML = jogos.map((j) => `
                <article class="admin-game-card">
                    ${j.imagem_url
                        ? `<img class="admin-game-cover" src="${dom.escapeHtml(j.imagem_url)}" alt="Capa de ${dom.escapeHtml(j.nome)}">`
                        : '<div class="admin-game-cover admin-game-cover--empty" aria-label="Sem imagem"></div>'}
                    <div class="admin-game-info">
                        <h3>${dom.escapeHtml(j.nome)}</h3>
                        <p>${dom.escapeHtml(j.categoria?.nome || "Sem categoria")}</p>
                        ${j.destaque ? '<span class="admin-game-tag">Em destaque</span>' : ""}
                    </div>
                    <button type="button" class="btn-sm btn-delete admin-game-delete" data-excluir="${dom.escapeHtml(j.id)}">Excluir</button>
                </article>`).join("") || '<p class="admin-games-empty">Nenhum jogo cadastrado.</p>';
        } catch (erro) {
            $("lista").textContent = "Não foi possível carregar os jogos.";
        }
    }

    $("form").addEventListener("submit", async (evento) => {
        evento.preventDefault();
        const f = evento.target;
        const nome = f.nome.value.trim();
        const imagem = f.imagem_url.value.trim();

        if (nome.length < 2) { msg("Informe o nome do jogo."); return; }
        if (imagem && !/^https:\/\/\S+$/.test(imagem)) { msg("O link da imagem deve começar com https://"); return; }

        $("salvar").disabled = true;
        try {
            await jogosService.create({
                nome,
                descricao: f.descricao.value.trim() || null,
                imagem_url: imagem || null,
                destaque: f.destaque.checked,
                categoria_id: Number(f.categoria_id.value) || null
            });
            f.reset();
            msg("Jogo cadastrado!");
            carregarJogos();
        } catch (erro) {
            msg("Não foi possível salvar o jogo.");
        }
        $("salvar").disabled = false;
    });

    $("lista").addEventListener("click", async (evento) => {
        const botao = evento.target.closest("button[data-excluir]");
        if (!botao || !confirm("Excluir este jogo?")) return;
        try {
            await jogosService.remove(botao.dataset.excluir);
            msg("Jogo excluído.");
            carregarJogos();
        } catch (erro) {
            msg("Não foi possível excluir.");
        }
    });

    carregarCategorias();
    carregarJogos();
})();
