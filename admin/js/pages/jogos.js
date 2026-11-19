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
                <div class="item">
                    ${j.imagem_url ? `<img src="${dom.escapeHtml(j.imagem_url)}" alt="">` : '<div class="ph"></div>'}
                    <div>
                        <strong>${dom.escapeHtml(j.nome)}</strong><br>
                        <small>${dom.escapeHtml([j.estudio, j.ano, j.categoria?.nome].filter(Boolean).join(" · "))}</small>
                    </div>
                    <button type="button" class="danger" data-excluir="${dom.escapeHtml(j.id)}">Excluir</button>
                </div>`).join("") || "<p>Nenhum jogo cadastrado.</p>";
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
                estudio: f.estudio.value.trim() || null,
                ano: f.ano.value ? Number(f.ano.value) : null,
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

    $("sair").addEventListener("click", async () => {
        await authService.signOut();
        window.location.replace("login.html");
    });

    carregarCategorias();
    carregarJogos();
})();
