package pe.com.sigre.logistica.ui.common

/** Ítem genérico (id + título + subtítulo) para listas simples de selección. */
data class SimpleItem(
    val id: Long,
    val titulo: String,
    val subtitulo: String? = null,
)
