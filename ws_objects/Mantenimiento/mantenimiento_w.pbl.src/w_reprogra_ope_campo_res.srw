$PBExportHeader$w_reprogra_ope_campo_res.srw
forward
global type w_reprogra_ope_campo_res from w_quick_search_pop
end type
end forward

global type w_reprogra_ope_campo_res from w_quick_search_pop
string title = "Campos sin cortes registrados"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 79741120
end type
global w_reprogra_ope_campo_res w_reprogra_ope_campo_res

on w_reprogra_ope_campo_res.create
int iCurrent
call super::create
end on

on w_reprogra_ope_campo_res.destroy
call super::destroy
end on

event open;call super::open;uo_1.of_set_dw('d_reprogra_ope_campo_tbl')
uo_1.of_set_field('cod_campo_t')
//uo_1.of_share_lista(w_abc_inicio_cierre_corte.dw_master)
uo_1.of_retrieve_lista()
uo_1.of_sort_lista()

end event

type uo_1 from w_quick_search_pop`uo_1 within w_reprogra_ope_campo_res
end type

event uo_1::ue_retorno;call super::ue_retorno;//w_abc_mastdet.dw_master.ScrollToRow(al_row)
//w_abc_mastdet.tab_1.tabpage_1.dw_1.ScrollToRow(al_row)
//w_abc_mastdet.tab_1.tabpage_2.dw_2.ScrollToRow(al_row)
//w_abc_mastdet.tab_1.tabpage_3.dw_3.ScrollToRow(al_row)

//w_abc_mastdet.dw_detail.retrieve(aa_id)

//long ll_row_detail
//ll_row_detail = w_abc_inicio_cierre_corte.dw_detail.GetRow()
//w_abc_inicio_cierre_corte.dw_detail.Object.Cod_Campo[ll_row_detail] = String(aa_id)
CloseWithReturn(w_reprogra_ope_campo_res, String(aa_id))

end event

