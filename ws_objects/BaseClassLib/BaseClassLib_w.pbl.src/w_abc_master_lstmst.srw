$PBExportHeader$w_abc_master_lstmst.srw
$PBExportComments$abc para tablas simples que requieren ubicarse con una tabla mayor, formato tabular
forward
global type w_abc_master_lstmst from w_abc_master
end type
type dw_lista from u_dw_list_tbl within w_abc_master_lstmst
end type
end forward

global type w_abc_master_lstmst from w_abc_master
integer width = 1362
integer height = 808
event ue_list_close ( )
dw_lista dw_lista
end type
global w_abc_master_lstmst w_abc_master_lstmst

type variables
Integer ii_sortorder =0, ii_lst_colnum = 1, ii_share = 1, ii_lec_mst =1

end variables

event ue_list_close;dw_lista.visible = False
end event

on w_abc_master_lstmst.create
int iCurrent
call super::create
this.dw_lista=create dw_lista
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
end on

on w_abc_master_lstmst.destroy
call super::destroy
destroy(this.dw_lista)
end on

event ue_open_pre();call super::ue_open_pre;dw_lista.SetTransObject(sqlca)


//ii_share = 0      //deshabilita el share entre el master y la lista
//ii_lec_mst = 0    //deshabilita la lectura inicial del dw_master
// ii_help = 101           // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
end event

event ue_retrieve_list_pos;call super::ue_retrieve_list_pos;dw_lista.visible = True
end event

event resize;call super::resize;dw_lista.height = newheight - dw_lista.y - 10
end event

event ue_dw_share();call super::ue_dw_share;
IF ii_share = 1 THEN dw_lista.of_share_lista(dw_master)  // compartir dw_master con dw_lista

IF ii_lec_mst = 1 THEN dw_master.Retrieve()

end event

type dw_master from w_abc_master`dw_master within w_abc_master_lstmst
integer x = 567
integer y = 0
end type

type dw_lista from u_dw_list_tbl within w_abc_master_lstmst
integer x = 9
integer y = 8
integer width = 530
integer height = 616
integer taborder = 20
boolean bringtotop = true
end type

event ue_output;call super::ue_output;dw_master.ScrollToRow(al_row)
dw_master.il_row = al_row

end event

