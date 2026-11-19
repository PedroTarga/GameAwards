/* Peças visuais de jogo (cards e capa). Depende de: dom. */
const jogoView = (function () {
    "use strict";
    const esc = dom.escapeHtml;
    const HEX = /^#(?:[0-9a-f]{3}|[0-9a-f]{6})$/i;
    const ICONS = Object.freeze({
        user: '<svg class="icon" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="3.5"/><path d="M5 20a7 7 0 0 1 14 0"/></svg>',
        calendar: '<svg class="icon" viewBox="0 0 24 24" aria-hidden="true"><rect x="3.5" y="5" width="17" height="15" rx="3"/><path d="M8 3v4M16 3v4M3.5 10h17"/></svg>',
        arrow: '<svg class="icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>'
    });

    function accentStyle(jogo) {
        const cor = jogo.categoria?.cor;
        return HEX.test(cor ?? "") ? `style="--accent: ${cor}"` : "";
    }
    /** background-image só para URLs https (a capa vem do bucket do Supabase). */
    function coverStyle(jogo, extra = "") {
        const url = jogo.imagem_url;
        if (!/^https:\/\//i.test(url || "")) return "";
        const safe = esc(encodeURI(url).replace(/'/g, "%27").replace(/\(/g, "%28").replace(/\)/g, "%29"));
        return `style="background-image:linear-gradient(to top,rgba(0,0,0,.72),transparent 60%),url('${safe}');background-size:cover;background-position:center;${extra}"`;
    }

    function card(jogo, { variant = "grid" } = {}) {
        const categoria = jogo.categoria?.nome ?? "Indicado";
        const href = `jogo.html?id=${encodeURIComponent(jogo.id)}`;
        return `
            <article class="event-card event-card--${variant}" ${accentStyle(jogo)} data-reveal>
                <a class="event-card-link" href="${href}" aria-label="${esc(jogo.nome)} — ver detalhes">
                    <div class="event-cover" ${coverStyle(jogo)}>
                        ${jogo.imagem_url ? "" : `<span class="event-cover-watermark" aria-hidden="true">${esc(categoria)}</span>`}
                        <div class="event-cover-tags">${jogo.destaque ? '<span class="tag tag--highlight">Destaque</span>' : ""}</div>
                        <span class="event-cover-category">${esc(categoria)}</span>
                    </div>
                    <div class="event-body">
                        <h3 class="event-title">${esc(jogo.nome)}</h3>
                        <ul class="event-meta">
                            ${jogo.estudio ? `<li>${ICONS.user}<span>${esc(jogo.estudio)}</span></li>` : ""}
                            ${jogo.ano ? `<li>${ICONS.calendar}<span>${esc(jogo.ano)}</span></li>` : ""}
                        </ul>
                    </div>
                </a>
                <div class="event-actions">
                    <a class="btn-cta btn-cta--block btn-cta--sm" href="${href}">Ver detalhes ${ICONS.arrow}</a>
                </div>
            </article>`;
    }

    return Object.freeze({ ICONS, accentStyle, coverStyle, card });
})();
