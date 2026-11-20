/* Home: busca, filtro por categoria, destaques e lista de jogos. Depende de: jogoView, dom, motion. */
(function () {
    "use strict";
    const $ = (id) => document.getElementById(id);
    const el = {
        form: $("form-busca"), busca: $("busca-jogos"), select: $("filtro-categoria"), chips: $("lista-categorias"),
        grid: $("lista-jogos"), counter: $("contador-jogos"), carousel: $("carrossel-destaques"),
        section: $("destaques"), prev: $("carrossel-anterior"), next: $("carrossel-proximo")
    };
    const state = { jogos: [], categorias: [], q: "", categoriaId: "" };
    const norm = (s) => String(s ?? "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();

    function filtrar() {
        const q = norm(state.q.trim());
        return state.jogos.filter((j) =>
            (!state.categoriaId || String(j.categoria_id) === state.categoriaId) &&
            (!q || norm(j.nome).includes(q)));
    }

    function renderFiltros() {
        el.select.innerHTML = '<option value="">Todas</option>' + state.categorias
            .map((c) => `<option value="${dom.escapeHtml(c.id)}">${dom.escapeHtml(c.nome)}</option>`).join("");
        const chip = (id, nome, style = "") => `
            <li><button type="button" class="chip" data-categoria="${dom.escapeHtml(id)}" aria-pressed="false" ${style}>
                ${id ? '<span class="chip-dot" aria-hidden="true"></span>' : ""}${dom.escapeHtml(nome)}
            </button></li>`;
        el.chips.innerHTML = chip("", "Todos") + state.categorias
            .map((c) => chip(String(c.id), c.nome, jogoView.accentStyle({ categoria: c }))).join("");
    }

    function marcarChips() {
        el.chips.querySelectorAll("button[data-categoria]").forEach((b) =>
            b.setAttribute("aria-pressed", String(b.dataset.categoria === state.categoriaId)));
        el.select.value = state.categoriaId;
    }

    function renderGrid() {
        const lista = filtrar();
        el.counter.textContent = `${lista.length} ${lista.length === 1 ? "jogo encontrado" : "jogos encontrados"}`;
        el.grid.innerHTML = lista.length
            ? lista.map((j) => jogoView.card(j)).join("")
            : `<div class="empty-state" data-reveal><p class="empty-state-title">Nenhum jogo encontrado</p><p>Tente outro termo ou categoria.</p></div>`;
        motion.observe(el.grid);
    }

    function renderDestaques() {
        const destaques = state.jogos.filter((j) => j.destaque).slice(0, 8);
        const lista = destaques.length ? destaques : state.jogos.slice(0, 8);
        el.section.hidden = lista.length === 0;
        el.carousel.innerHTML = lista.map((j) => jogoView.card(j, { variant: "featured" })).join("");
        motion.observe(el.carousel);
    }

    function setFiltro(patch) { Object.assign(state, patch); marcarChips(); renderGrid(); }

    async function carregar() {
        try {
            const [categorias, jogos] = await Promise.all([jogosService.listarCategorias(), jogosService.listar()]);
            state.categorias = categorias;
            state.jogos = jogos;
            renderFiltros(); marcarChips(); renderDestaques(); renderGrid();
        } catch (erro) {
            el.grid.innerHTML = '<div class="empty-state"><p class="empty-state-title">Não foi possível carregar os jogos</p><p>Verifique sua conexão e tente novamente.</p></div>';
        }
    }

    el.form.addEventListener("submit", (e) => { e.preventDefault(); setFiltro({ q: el.busca.value }); });
    el.busca.addEventListener("input", () => setFiltro({ q: el.busca.value }));
    el.select.addEventListener("change", () => setFiltro({ categoriaId: el.select.value }));
    el.chips.addEventListener("click", (e) => {
        const b = e.target.closest("button[data-categoria]");
        if (b) setFiltro({ categoriaId: b.dataset.categoria });
    });
    const rolar = (dir) => el.carousel.scrollBy({ left: dir * el.carousel.clientWidth * 0.85, behavior: "smooth" });
    el.prev.addEventListener("click", () => rolar(-1));
    el.next.addEventListener("click", () => rolar(1));
    carregar();
})();
