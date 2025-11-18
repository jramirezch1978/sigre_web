$PBExportHeader$w_quick_search_pop.srw
$PBExportComments$pop para ubicar un registro tipo progresivo
forward
global type w_quick_search_pop from Window
end type
type uo_1 from u_cst_quick_search within w_quick_search_pop
end type
end forward

global type w_quick_search_pop from Window
int X=823
int Y=360
int Width=969
int Height=1128
boolean TitleBar=true
string Title="Untitled"
long BackColor=67108864
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event ue_retorno ( )
event ue_help_topic ( )
event ue_help_index ( )
uo_1 uo_1
end type
global w_quick_search_pop w_quick_search_pop

type variables
Integer ii_help
end variables

event ue_help_topic;ShowHelp(gnvo_app.is_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gnvo_app.is_help, Index!)
end event

on w_quick_search_pop.destroy
destroy(this.uo_1)
end on

event open;//uo_1.of_set_dw('d_product_name_tbl')
//uo_1.of_set_field('name')
//uo_1.of_share_lista(dw_master)
//uo_1.of_retrieve_lista()
//uo_1.of_sort_lista()

// ii_help = 101           // help topic


end event

on w_quick_search_pop.create
this.uo_1=create uo_1
this.Control[]={this.uo_1}
end on

type uo_1 from u_cst_quick_search within w_quick_search_pop
int X=0
int Y=0
int Height=868
int TabOrder=10
end type

on uo_1.destroy
call u_cst_quick_search::destroy
end on

