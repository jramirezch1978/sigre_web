$PBExportHeader$w_abc_mastdet_treeview.srw
$PBExportComments$abc maestro detalle con treeview de busqueda
forward
global type w_abc_mastdet_treeview from w_abc_mastdet
end type
type tv_1 from u_treeview within w_abc_mastdet_treeview
end type
end forward

global type w_abc_mastdet_treeview from w_abc_mastdet
int Width=1874
int Height=1024
tv_1 tv_1
end type
global w_abc_mastdet_treeview w_abc_mastdet_treeview

event resize;call super::resize;tv_1.height = newheight - tv_1.y
end event

event ue_delete_pos;call super::ue_delete_pos;tv_1.of_selected_item_delete()
end event

on w_abc_mastdet_treeview.create
int iCurrent
call super::create
this.tv_1=create tv_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_1
end on

on w_abc_mastdet_treeview.destroy
call super::destroy
destroy(this.tv_1)
end on

type dw_master from w_abc_mastdet`dw_master within w_abc_mastdet_treeview
int X=512
boolean BringToTop=true
end type

type dw_detail from w_abc_mastdet`dw_detail within w_abc_mastdet_treeview
int X=512
int Y=540
boolean BringToTop=true
end type

type tv_1 from u_treeview within w_abc_mastdet_treeview
int X=14
int Y=8
int Width=485
int Height=896
int TabOrder=20
boolean BringToTop=true
end type

event selectionchanged;call super::selectionchanged;PARENT.EVENT ue_update_request()
end event

