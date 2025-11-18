$PBExportHeader$w_search_pop.srw
$PBExportComments$pop para buscar un registro tipo lista fija
forward
global type w_search_pop from Window
end type
type dw_lista from u_dw_list_tbl within w_search_pop
end type
type cb_filter from commandbutton within w_search_pop
end type
end forward

shared variables

end variables

global type w_search_pop from Window
int X=2171
int Y=628
int Width=690
int Height=928
boolean TitleBar=true
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
WindowType WindowType=popup!
event ue_sort ( )
event ue_filter ( )
event ue_retrieve ( )
event ue_help_topic ( )
event ue_help_index ( )
dw_lista dw_lista
cb_filter cb_filter
end type
global w_search_pop w_search_pop

type variables
Integer ii_sort =0, ii_help
Integer ii_colnum = 1
end variables

forward prototypes
public function integer of_share_lista (datawindow adw_1)
end prototypes

event ue_sort;dw_lista.Event ue_sort()
end event

event ue_filter;dw_lista.Event ue_filter()
end event

event ue_retrieve;SetPointer(hourglass!)				// cambiar cursor para lectura de lista


// Esta parte puede ser que tenga que ser personalizada en la herencia
dw_lista.Retrieve()					// Lectura de la lista
end event

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

public function integer of_share_lista (datawindow adw_1);Integer li_rc
Datawindow ldw_master

SetPointer(hourglass!)				// cambiar cursor para lectura de lista

ldw_master = adw_1

li_rc = ldw_master.ShareData (dw_lista)
IF li_rc <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con dw",exclamation!)
END IF

SetNull(ldw_master)

RETURN li_rc
end function

on w_search_pop.create
this.dw_lista=create dw_lista
this.cb_filter=create cb_filter
this.Control[]={this.dw_lista,&
this.cb_filter}
end on

on w_search_pop.destroy
destroy(this.dw_lista)
destroy(this.cb_filter)
end on

event open;//*****************************************************************************
//	Nombre del Objeto:	w_mastdet_pop		Objeto Ancestro:
//
//	Fecha Creación:		3/Feb/99				Fecha Modificación:
//	
//	Autor:			Pedro Wong					Autor Modificacion:
//
//	Descripción: Pop up window para realizar la ubicacion y apertura del registro maestro
//					 en el main window "w_mastdet"
//******************************************************************************

dw_lista.SetTransObject(sqlca)

// of_share_lista(dw_master)
// THIS.EVENT ue_retrieve()

// ii_help = 101           // help topic
end event

event resize;dw_lista.width = newwidth - dw_lista.x - 10
dw_lista.height = newheight - dw_lista.y - 10

end event

type dw_lista from u_dw_list_tbl within w_search_pop
int X=9
int Y=72
int Width=658
int Height=760
int TabOrder=30
end type

type cb_filter from commandbutton within w_search_pop
int X=14
int Y=12
int Width=133
int Height=52
int TabOrder=20
string Text="Filter"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Parent.PostEvent("ue_filter")
end event

