$PBExportHeader$w_cns_list.srw
$PBExportComments$Consulta, basada en una seleccion de lista
forward
global type w_cns_list from w_cns
end type
type dw_1 from u_dw_abc within w_cns_list
end type
type pb_1 from picturebutton within w_cns_list
end type
type pb_2 from picturebutton within w_cns_list
end type
type dw_2 from u_dw_abc within w_cns_list
end type
type cb_consulta from commandbutton within w_cns_list
end type
type dw_cns from u_dw_cns within w_cns_list
end type
end forward

global type w_cns_list from w_cns
int Width=3529
int Height=1664
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
dw_2 dw_2
cb_consulta cb_consulta
dw_cns dw_cns
end type
global w_cns_list w_cns_list

type variables
u_dw_abc   idw_otro
end variables

forward prototypes
public subroutine of_dw_sort ()
end prototypes

public subroutine of_dw_sort ();Integer	li_rc, li_x, li_total
string	ls_sort

li_total = UpperBound(idw_otro.ii_ck)
IF li_total < 1 THEN RETURN

ls_sort = "#" + String(idw_otro.ii_ck[1]) + " A"

FOR li_x = 2 TO li_total
	 ls_sort = ls_sort + ", #" + String(idw_otro.ii_ck[li_x]) +" A"
NEXT

idw_otro.SetSort (ls_sort)
idw_otro.Sort()

end subroutine

on w_cns_list.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_2=create dw_2
this.cb_consulta=create cb_consulta
this.dw_cns=create dw_cns
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.cb_consulta
this.Control[iCurrent+6]=this.dw_cns
end on

on w_cns_list.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_2)
destroy(this.cb_consulta)
destroy(this.dw_cns)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_cns
idw_1.SetTransObject(sqlca)

//dw_1.SetTransObject(sqlca)
//dw_2.SetTransObject(sqlca)

// ii_help = 101           // help topic

//of_position_window(0,0) 		// Posicionar window
end event

type dw_1 from u_dw_abc within w_cns_list
int X=18
int Y=276
int Width=640
int Height=1112
boolean BringToTop=true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det = dw_2

//ii_ck[1] = 1
//ii_dk[1] = 1
//ii_rk[1] = 1
end event

event ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event ue_selected_row_pro;call super::ue_selected_row_pro;Long		ll_row, ll_rc
Any		la_id
Integer	li_x

ll_row = idw_otro.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)

end event

type pb_1 from picturebutton within w_cns_list
event ue_clicked_pre ( )
int X=123
int Y=1420
int Width=146
int Height=112
int TabOrder=20
boolean BringToTop=true
string Text=" >"
Alignment HTextAlign=Left!
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event ue_clicked_pre;idw_otro = dw_2
end event

event clicked;THIS.EVENT ue_clicked_pre()

dw_1.EVENT ue_selected_row()

// ordenar ventana derecha
of_dw_sort()

end event

type pb_2 from picturebutton within w_cns_list
event ue_clicked_pre ( )
int X=389
int Y=1420
int Width=146
int Height=120
int TabOrder=40
boolean BringToTop=true
string Text="<"
Alignment HTextAlign=Left!
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event ue_clicked_pre;idw_otro = dw_1
end event

event clicked;THIS.EVENT ue_clicked_pre()

dw_2.EVENT ue_selected_row()

// ordenar ventana izquierda
of_dw_sort()
end event

type dw_2 from u_dw_abc within w_cns_list
int X=686
int Y=280
int Width=640
int Height=1112
int TabOrder=30
boolean BringToTop=true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det = dw_1

//ii_ck[1] = 1
//ii_dk[1] = 1
//ii_rk[1] = 1
end event

event ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event ue_selected_row_pro;call super::ue_selected_row_pro;Long		ll_row, ll_rc
Any		la_id
Integer	li_x

ll_row = idw_otro.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)

end event

type cb_consulta from commandbutton within w_cns_list
int X=754
int Y=1428
int Width=539
int Height=108
int TabOrder=50
boolean BringToTop=true
string Text="Generar Consulta"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//Any			la_arg[]
//Long 		ll_row
//
//FOR ll_row = 1 to dw_2.rowcount()
//	la_arg[ll_row] = dw_2.of_get_column_data(ll_row, dw_2.ii_c[1])
//NEXT
//
//idw_1.retrieve(la_arg)
//idw_1.event ue_preview()
	    
end event

type dw_cns from u_dw_cns within w_cns_list
int X=1367
int Y=24
int Width=2103
int Height=1520
int TabOrder=20
boolean BringToTop=true
end type

