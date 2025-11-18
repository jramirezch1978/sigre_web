$PBExportHeader$w_list_qs_pop.srw
$PBExportComments$Quick Search, para ser llamado instantaneamente
forward
global type w_list_qs_pop from Window
end type
type uo_1 from u_cst_quick_search within w_list_qs_pop
end type
end forward

global type w_list_qs_pop from Window
int X=823
int Y=360
int Width=969
int Height=1128
boolean TitleBar=true
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event ue_retorno ( )
event ue_help_topic ( )
event ue_help_index ( )
uo_1 uo_1
end type
global w_list_qs_pop w_list_qs_pop

type variables
Integer ii_help
datawindow idw_obj
Boolean ib_fixed
end variables

event ue_help_topic;ShowHelp(gnvo_app.is_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gnvo_app.is_help, Index!)
end event

on w_list_qs_pop.destroy
destroy(this.uo_1)
end on

event open;Long				ll_row
Str_list_pop	lstr_1

lstr_1 = Message.PowerObjectParm					// lectura de parametros

uo_1.of_set_dw(lstr_1.DataObject)		 		// asignar datawindow
uo_1.of_set_field(lstr_1.field)
THIS.title  = lstr_1.title							// asignar titulo de la ventana
THIS.x = lstr_1.x
THIS.y = lstr_1.y
THIS.width  = lstr_1.width							// asignar ancho y altura de ventana
THIS.height = lstr_1.height
uo_1.ii_cn = lstr_1.id
idw_obj = lstr_1.dw
ib_fixed = lstr_1.fixed

uo_1.of_retrieve_lista()
uo_1.of_sort_lista()

// ii_help = 101           // help topic


end event

on w_list_qs_pop.create
this.uo_1=create uo_1
this.Control[]={this.uo_1}
end on

type uo_1 from u_cst_quick_search within w_list_qs_pop
int X=0
int Y=0
int Height=868
int TabOrder=10
end type

on uo_1.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;
idw_obj.Retrieve(aa_id)

IF ib_fixed = False THEN Close(Parent)
end event

