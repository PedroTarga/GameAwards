/* Página de detalhe de um jogo. Depende de: jogoView, dom, motion. */
(function () {
    "use strict";
    const $ = (id) => document.getElementById(id);
    const el = { crumb: $("breadcrumb-titulo"), skeleton: $("detalhe-skeleton"), content: $("detalhe-conteudo"), notFound: $("detalhe-nao-encontrado") };
    const esc = dom.escapeHtml;

    function info(icon, label, value) {
        if (!value) return "";
        return `<li class="info-item"><span class="info-icon">${icon}</span><span>
            <span class="info-label">${esc(label)}</span><span class="info-value">${esc(value)}</span></span></li>`;
    }

    function render(jogo) {
        const tags = jogo.categoria ? `<span class="tag tag--glass">${esc(jogo.categoria.nome)}</span>` : "";
        el.content.innerHTML = `
            <article class="detail-layout" ${jogoView.accentStyle(jogo)}>
                <header class="detail-hero" ${jogoView.coverStyle(jogo)} data-reveal="scale">
                    <div class="detail-hero-text">
                        <div class="detail-tags">${tags}${jogo.destaque ? '<span class="tag tag--highlight">Destaque</span>' : ""}</div>
                        <h1 class="detail-title">${esc(jogo.nome)}</h1>
                        <p class="detail-subtitle">${esc([jogo.estudio, jogo.ano].filter(Boolean).join(" · "))}</p>
                    </div>
                </header>
                <div class="detail-columns">
                    <section class="detail-main" data-reveal>
                        <h2 class="detail-section-title">Sobre o jogo</h2>
                        <p class="detail-description">${esc(jogo.descricao ?? "Descrição em breve.")}</p>
                        <h2 class="detail-section-title">Informações</h2>
                        <ul class="info-list">
                            ${info(jogoView.ICONS.user, "Estúdio", jogo.estudio)}
                            ${info(jogoView.ICONS.calendar, "Lançamento", jogo.ano)}
                        </ul>
                    </section>
                    <aside class="detail-aside" data-reveal>
                        <div class="ticket-card">
                            <p class="ticket-label">Categoria</p>
                            <div class="detail-tags">${tags || "<span>Sem categoria</span>"}</div>
                            <a class="btn-ghost" href="index.html#jogos">Ver todos os jogos</a>
                        </div>
                    </aside>
                </div>
            </article>`;
        el.crumb.textContent = jogo.nome;
        document.title = `${jogo.nome} | Game Awards`;
        el.skeleton.hidden = true; el.content.hidden = false;
        motion.observe(el.content);
    }

    function naoEncontrado() {
        el.skeleton.hidden = true; el.content.hidden = true; el.notFound.hidden = false;
        el.crumb.textContent = "Jogo não encontrado";
    }

    async function init() {
        const id = new URLSearchParams(location.search).get("id");
        if (!/^\d+$/.test(id || "")) return naoEncontrado();
        try {
            const jogo = await jogosService.buscarPorId(id);
            if (!jogo) return naoEncontrado();
            render(jogo);
        } catch (erro) {
            naoEncontrado();
        }
    }
    init();
})();
