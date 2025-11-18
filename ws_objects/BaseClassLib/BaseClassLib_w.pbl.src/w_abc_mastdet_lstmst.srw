$PBExportHeader$w_abc_mastdet_lstmst.srw
$PBExportComments$abc para tablas simples que requieren ubicarse con una tabla mayor, formato tabular
forward
global type w_abc_mastdet_lstmst from w_abc_mastdet
end type
type dw_lista from u_dw_list_tbl within w_abc_mastdet_lstmst
end type
end forward

global type w_abc_mastdet_lstmst from w_abc_mastdet
integer width = 1536
integer height = 1052
event ue_list_close ( )
dw_lista dw_lista
end type
global w_abc_mastdet_lstmst w_abc_mastdet_lstmst

type variables
Integer	ii_share = 1, ii_lec_mst = 1
end variables

event ue_list_close;dw_lista.visible = False
end event

event ue_open_pre();call super::ue_open_pre;dw_lista.SetTransObject(sqlca)


//ii_share = 0      //deshabilita el share entre el master y la lista
//ii_lec_mst = 0    //deshabilita la lectura inicial del dw_master
// dw_master.ii_cn = 1             // indicar el campo key del master
// dw_detail.ii_cn = 1             // indicar el campo de enlace detalle - master
// ii_help = 101           // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)


end event

on w_abc_mastdet_lstmst.create
int iCurrent
call super::create
this.dw_lista=create dw_lista
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
end on

on w_abc_mastdet_lstmst.destroy
call super::destroy
destroy(this.dw_lista)
end on

event resize;call super::resize;dw_lista.height = newheight - dw_lista.y -10
end event

event ue_retrieve_list_pos;call super::ue_retrieve_list_pos;dw_lista.visible = True
end event

event ue_dw_share();call super::ue_dw_share;
IF ii_share = 1 THEN dw_lista.of_share_lista(dw_master)  // compartir dw_master con dw_lista
IF ii_lec_mst = 1 THEN dw_master.Retrieve()

//dw_lista.of_sort_lista()
// THIS.EVENT ue_list_close()
end event

type dw_master from w_abc_mastdet`dw_master within w_abc_mastdet_lstmst
integer x = 485
integer y = 16
integer width = 878
integer height = 440
end type

type dw_detail from w_abc_mastdet`dw_detail within w_abc_mastdet_lstmst
integer x = 485
integer y = 488
integer width = 878
integer height = 240
boolean vscrollbar = true
end type

type dw_lista from u_dw_list_tbl within w_abc_mastdet_lstmst
integer x = 23
integer y = 12
integer width = 439
integer height = 696
integer taborder = 30
boolean bringtotop = true
end type

