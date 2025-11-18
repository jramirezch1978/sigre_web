$PBExportHeader$w_treeview_pop.srw
$PBExportComments$pop para ubicar un registro usando un arbol jerarquico
forward
global type w_treeview_pop from Window
end type
type tv_lista from u_treeview within w_treeview_pop
end type
end forward

global type w_treeview_pop from Window
int X=823
int Y=360
int Width=462
int Height=660
boolean TitleBar=true
string Title="Untitled"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
WindowType WindowType=popup!
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

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
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
int X=9
int Y=8
int Width=311
int Height=504
int TabOrder=20
end type

