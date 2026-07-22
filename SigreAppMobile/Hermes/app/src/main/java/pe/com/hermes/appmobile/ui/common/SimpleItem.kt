package pe.com.hermes.appmobile.ui.common

/** Ítem genérico (id + título + subtítulo) para listas simples de selección. */
data class SimpleItem(
    val id: Long,
    val titulo: String,
    val subtitulo: String? = null,
)
