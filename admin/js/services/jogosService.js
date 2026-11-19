/* Acesso à tabela `jogos` no painel. Funções lançam o erro do Supabase. */
const jogosService = (function () {
    "use strict";

    const TABLE = "jogos";

    return Object.freeze({
        async list() {
            const { data, error } = await window.supabaseClient
                .from(TABLE)
                .select("id, nome, estudio, ano, imagem_url, destaque, categoria:categorias(nome)")
                .order("created_at", { ascending: false });

            if (error) throw error;
            return data ?? [];
        },

        async create(payload) {
            const { data, error } = await window.supabaseClient
                .from(TABLE)
                .insert(payload)
                .select("id");

            if (error) throw error;
            return data;
        },

        async remove(id) {
            const { error } = await window.supabaseClient
                .from(TABLE)
                .delete()
                .eq("id", id);

            if (error) throw error;
        }
    });
})();
