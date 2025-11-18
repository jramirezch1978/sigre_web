$PBExportHeader$w_abc_mastdet_quick_search.srw
$PBExportComments$abc maestro detalle con lista de busqueda intuitiva
forward
global type w_abc_mastdet_quick_search from w_abc_mastdet
end type
type uo_1 from u_cst_quick_search within w_abc_mastdet_quick_search
end type
end forward

global type w_abc_mastdet_quick_search from w_abc_mastdet
int Width=2085
int Height=1164
uo_1 uo_1
end type
global w_abc_mastdet_quick_search w_abc_mastdet_quick_search

on w_abc_mastdet_quick_search.create
int iCurrent
call super::create
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
end on

on w_abc_mastdet_quick_search.destroy
call super::destroy
destroy(this.uo_1)
end on

event ue_open_pre;call super::ue_open_pre;//uo_1.of_set_dw('d_xxxxxx')
//uo_1.of_set_field('name')
//uo_1.of_set_colnum(2)

//uo_1.of_share_lista(dw_master)
//uo_1.of_retrieve_lista()
//uo_1.of_sort_lista()
//uo_1.of_protect()

// ii_help = 101           // help topic

//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
end event

type dw_master from w_abc_mastdet`dw_master within w_abc_mastdet_quick_search
int X=978
int Y=16
boolean BringToTop=true
end type

type dw_detail from w_abc_mastdet`dw_detail within w_abc_mastdet_quick_search
int X=978
int Y=556
boolean BringToTop=true
end type

type uo_1 from u_cst_quick_search within w_abc_mastdet_quick_search
int X=27
int Y=4
int TabOrder=20
boolean BringToTop=true
end type

event ue_retorno;call super::ue_retorno;//dw_master.ScrollToRow(al_row)

//dw_master.retrieve(aa_id)
end event

on uo_1.destroy
call u_cst_quick_search::destroy
end on

