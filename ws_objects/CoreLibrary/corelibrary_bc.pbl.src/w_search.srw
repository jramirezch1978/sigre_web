$PBExportHeader$w_search.srw
forward
global type w_search from w_abc_master_smpl
end type
type cb_cerrar from commandbutton within w_search
end type
type uo_search from n_cst_search within w_search
end type
end forward

global type w_search from w_abc_master_smpl
integer width = 2889
integer height = 2180
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_cerrar cb_cerrar
uo_search uo_search
end type
global w_search w_search

type variables
String  is_field_return, is_tipo, is_col = ''
integer ii_ik[]
str_parametros ist_datos
end variables

on w_search.create
int iCurrent
call super::create
this.cb_cerrar=create cb_cerrar
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cerrar
this.Control[iCurrent+2]=this.uo_search
end on

on w_search.destroy
call super::destroy
destroy(this.cb_cerrar)
destroy(this.uo_search)
end on

event ue_open_pre;// Overr

str_parametros sl_param
String ls_null, ls_cen
Long ll_row
Integer li_ano, li_mes

ii_lec_mst = 0

uo_search.of_set_dw(dw_master)

// Recoge parametro enviado
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	sl_param = MESSAGE.POWEROBJECTPARM
	ii_ik = sl_param.field_ret_i	// Numero de campo a devolver
	is_tipo = sl_param.tipo
	dw_master.DataObject = sl_param.dw1
	dw_master.SetTransObject( SQLCA)	
	
	if TRIM( is_tipo) = '' then 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_master.retrieve()
	else		// caso contrario hace un retrieve con parametros
		CHOOSE CASE is_tipo
			CASE '1S'
				ll_row = dw_master.Retrieve( sl_param.string1)
			CASE '1S2S'
				ll_row = dw_master.Retrieve( sl_param.string1, sl_param.string2)
			CASE '1S2S3S'
				ll_row = dw_master.Retrieve( sl_param.string1, sl_param.string2, sl_param.string3)
			CASE '1I'				
				ll_row = dw_master.Retrieve( sl_param.int1)
			CASE 'CP'  // Dispara procedimiento creando archivo temporal
						  // para aquellas cuentas que tengan presupuesto.
				ls_cen = sl_param.string1
				li_ano = sl_param.int2
				li_mes = sl_param.int1
				if f_saldos_pto_x_ccosto(li_mes, li_ano, ls_cen) = 0 then return				
			  
				ll_row = dw_master.Retrieve()
			case '1N1S'
				ll_row = dw_master.retrieve(sl_param.long1, sl_param.string1)
				
			case '1N'
				ll_row = dw_master.retrieve(sl_param.long1)

			case else
				ll_row = dw_master.retrieve()
				
		END CHOOSE
	end if	

	ist_datos.titulo = 'n'
	This.Title = sl_param.titulo
		
	// Muestra proveedores segun registro actual		
END IF
end event

event ue_set_access;// OVER
end event

event resize;//Overr
uo_search.width 	= newwidth - uo_Search.x - 10
uo_search.event ue_resize(sizetype, newwidth, newheight)

cb_cerrar.x = newwidth / 2 - cb_cerrar.width / 2
cb_cerrar.y = newheight - cb_cerrar.height - 10

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = cb_cerrar.y - dw_master.y - 10
end event

event open;THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

end event

type dw_master from w_abc_master_smpl`dw_master within w_search
integer y = 96
integer width = 2359
integer height = 1848
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then	
	f_select_current_row( this)
end if	
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column 

li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

if row= 0 then return

Any  la_id
Integer li_x, li_y
String ls_tipo

FOR li_x = 1 TO UpperBound(ii_ik)			
	la_id = dw_master.object.data.primary.current[row, ii_ik[li_x]]
	// tipo del dato
	ls_tipo = This.Describe("#" + String(ii_ik[li_x]) + ".ColType")

	if LEFT( ls_tipo,1) = 'd' or left(ls_tipo, 6) = 'number' then
		ist_datos.field_ret[li_x] = string ( la_id)
	elseif LEFT( ls_tipo,1) = 'c' then
		ist_datos.field_ret[li_x] = la_id
	end if
NEXT
ist_datos.titulo = "s"		
CloseWithReturn( parent, ist_datos)

// Si el evento es disparado desde otro objeto que esta activo, este evento no reconoce el valor row como tal.
end event

event dw_master::constructor;call super::constructor;ii_access = 0
ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::clicked;call super::clicked;Int j, li_col

// Desactiva edicion
li_col = Long( this.Object.DataWindow.Column.Count)

for j =1 to li_col
	this.modify( This.GetColumnName()+ ".edit.displayonly = true")
	this.modify( This.GetColumnName()+ ".tabsequence = 0")
next
f_select_current_row( this)
end event

type cb_cerrar from commandbutton within w_search
integer x = 1019
integer y = 1984
integer width = 247
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
boolean cancel = true
end type

event clicked;ist_datos.titulo = "n"
CloseWithReturn( parent, ist_datos)
end event

type uo_search from n_cst_search within w_search
event destroy ( )
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

