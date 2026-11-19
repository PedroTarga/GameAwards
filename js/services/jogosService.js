/*
 * Leitura pública de jogos e categorias (tabelas `jogos` e `categorias`).
 * Funções lançam o erro do Supabase; a página decide como exibir.
 */
const jogosService = (function () {
    "use strict";

    const COLUMNS = "id, nome, estudio, ano, descricao, imagem_url, destaque, categoria_id, categoria:categorias(id, nome, slug, cor)";

    return Object.freeze({
        async listar() {
            const { data, error } = await window.supabaseClient
                .from("jogos")
                .select(COLUMNS)
                .order("created_at", { ascending: false });

            if (error) throw error;
            return data ?? [];
        },

        async buscarPorId(id) {
            const { data, error } = await window.supabaseClient
                .from("jogos")
                .select(COLUMNS)
                .eq("id", id)
                .maybeSingle();

            if (error) throw error;
            return data;
        },

        async listarCategorias() {
            const { data, error } = await window.supabaseClient
                .from("categorias")
                .select("id, nome, slug, cor")
                .order("nome", { ascending: true });

            if (error) throw error;
            return data ?? [];
        }
    });
})();
