$PBExportHeader$w_reprogra_ope_ciclo_res.srw
forward
global type w_reprogra_ope_ciclo_res from w_quick_search_pop
end type
end forward

global type w_reprogra_ope_ciclo_res from w_quick_search_pop
integer x = 59
integer y = 276
integer width = 3086
string title = "Campos sin cortes registrados"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 79741120
end type
global w_reprogra_ope_ciclo_res w_reprogra_ope_ciclo_res

on w_reprogra_ope_ciclo_res.create
int iCurrent
call super::create
end on

on w_reprogra_ope_ciclo_res.destroy
call super::destroy
end on

event open;call super::open;String ls_cod_campo 
ls_cod_campo = Message.StringParm

uo_1.of_set_dw('d_reprogra_ope_ciclo_tbl')
uo_1.of_set_field('corr_corte_t')
//uo_1.of_share_lista(w_abc_inicio_cierre_corte.dw_master)
uo_1.of_retrieve_lista(ls_cod_campo)
uo_1.of_sort_lista()
uo_1.of_set_colnum(8)

end event

type uo_1 from w_quick_search_pop`uo_1 within w_reprogra_ope_ciclo_res
integer width = 3058
end type

event uo_1::ue_retorno;call super::ue_retorno;//w_abc_mastdet.dw_master.ScrollToRow(al_row)
//w_abc_mastdet.tab_1.tabpage_1.dw_1.ScrollToRow(al_row)
//w_abc_mastdet.tab_1.tabpage_2.dw_2.ScrollToRow(al_row)
//w_abc_mastdet.tab_1.tabpage_3.dw_3.ScrollToRow(al_row)

//w_abc_mastdet.dw_detail.retrieve(aa_id)

//long ll_row_detail
//ll_row_detail = w_abc_inicio_cierre_corte.dw_detail.GetRow()
//w_abc_inicio_cierre_corte.dw_detail.Object.Cod_Campo[ll_row_detail] = String(aa_id)
CloseWithReturn(w_reprogra_ope_ciclo_res, String(aa_id))

end event

