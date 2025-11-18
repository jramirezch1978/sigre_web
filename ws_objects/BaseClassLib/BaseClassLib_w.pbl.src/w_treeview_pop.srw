$PBExportHeader$w_treeview_pop.srw
$PBExportComments$pop para ubicar un registro usando un arbol jerarquico
forward
global type w_treeview_pop from window
end type
type tv_lista from u_treeview within w_treeview_pop
end type
end forward

global type w_treeview_pop from window
integer x = 823
integer y = 360
integer width = 462
integer height = 660
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 79741120
event ue_delete_lista ( )
event ue_help_topic ( )
event ue_help_index ( )
tv_lista tv_lista
end type
global w_treeview_pop w_treeview_pop

type variables
Datastore     ids_data[]
String            is_dataobject[]
Integer ii_help
end variables

event ue_delete_lista;tv_lista.of_selected_item_delete()
end event

event ue_help_topic;ShowHelp(gnvo_app.is_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gnvo_app.is_help, Index!)
end event

on w_treeview_pop.create
this.tv_lista=create tv_lista
this.Control[]={this.tv_lista}
end on

on w_treeview_pop.destroy
destroy(this.tv_lista)
end on

event close;tv_lista.Event ue_close_pos()
end event

event resize;tv_lista.width = newwidth - tv_lista.x
tv_lista.height = newheight - tv_lista.y
end event

event open;// ii_help = 101           // help topic
end event

type tv_lista from u_treeview within w_treeview_pop
integer x = 9
integer y = 8
integer width = 311
integer height = 504
integer taborder = 20
end type

