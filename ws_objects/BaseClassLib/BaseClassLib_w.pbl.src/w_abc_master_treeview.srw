$PBExportHeader$w_abc_master_treeview.srw
$PBExportComments$Mantenimiento de un dw con treeview como lista
forward
global type w_abc_master_treeview from w_abc_master
end type
type tv_1 from u_treeview within w_abc_master_treeview
end type
end forward

global type w_abc_master_treeview from w_abc_master
int Width=823
int Height=652
tv_1 tv_1
end type
global w_abc_master_treeview w_abc_master_treeview

on w_abc_master_treeview.create
int iCurrent
call super::create
this.tv_1=create tv_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_1
end on

on w_abc_master_treeview.destroy
call super::destroy
destroy(this.tv_1)
end on

event ue_delete_pos;call super::ue_delete_pos;tv_1.of_selected_item_delete()
end event

event resize;call super::resize;tv_1.height = newheight - tv_1.y
end event

type dw_master from w_abc_master`dw_master within w_abc_master_treeview
int X=329
int Y=8
int Width=439
int Height=280
end type

type tv_1 from u_treeview within w_abc_master_treeview
int X=9
int Y=4
int Width=302
int Height=464
int TabOrder=20
boolean BringToTop=true
end type

event ue_selectionchanged_pre;call super::ue_selectionchanged_pre;PARENT.EVENT ue_update_request()
end event

