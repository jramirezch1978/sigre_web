$PBExportHeader$w_fl307_posib_arribo.srw
forward
global type w_fl307_posib_arribo from w_abc_master_smpl
end type
type em_1 from editmask within w_fl307_posib_arribo
end type
type gb_1 from groupbox within w_fl307_posib_arribo
end type
type pb_1 from picturebutton within w_fl307_posib_arribo
end type
type st_1 from statictext within w_fl307_posib_arribo
end type
end forward

global type w_fl307_posib_arribo from w_abc_master_smpl
integer width = 2706
integer height = 1084
string title = "Registro de posbles arribos nuevos (FL307)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
em_1 em_1
gb_1 gb_1
pb_1 pb_1
st_1 st_1
end type
global w_fl307_posib_arribo w_fl307_posib_arribo

event ue_open_pre;call super::ue_open_pre;//im_1.m_cortar.visible = false

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
//dw_detail.SetTransObject(sqlca)
//dw_lista.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
//dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

dw_master.of_protect()         		// bloquear modificaciones 
//dw_detail.of_protect()

of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
ii_consulta = 1                      // 1 = la lista de consulta es gobernada por el sistema de acceso
ii_access = 1
end event

on w_fl307_posib_arribo.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.em_1=create em_1
this.gb_1=create gb_1
this.pb_1=create pb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_1
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.st_1
end on

on w_fl307_posib_arribo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_1)
destroy(this.gb_1)
destroy(this.pb_1)
destroy(this.st_1)
end on

event ue_open_pos;call super::ue_open_pos;dw_master.event ue_insert()
end event

event ue_update_pre;call super::ue_update_pre;integer li_nro
string ls_nave
ls_nave = dw_master.object.fl_posib_arribos_nave[dw_master.GetRow()]
declare usp_fl_modifica_arribos procedure for 
	usp_fl_modifica_arribos(:ls_nave, :gs_origen);
	
execute usp_fl_modifica_arribos;

IF SQLCA.sqlcode = -1 THEN
	MessageBox('SQL error', SQLCA.SQLErrText)       
	Rollback ;
ELSE
	FETCH usp_fl_modifica_arribos INTO :li_nro; 
END IF
CLOSE usp_fl_modifica_arribos;

dw_master.of_set_flag_replicacion()

end event

event ue_dw_share;// se ha quitado la herencia para evitar el retrieve
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl307_posib_arribo
integer width = 2656
integer height = 844
string dataobject = "d_posib_arribos_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
//idw_det  =  				// dw_detail

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;long ll_row
integer li_nro
string ls_nro, ls_origen, ls_sql, ls_nave, ls_nave_nomb,ls_hora
str_seleccionar lstr_seleccionar
dw_master.setcolumn(3)
////////////////////////EL INSERT///////////////////////////
em_1.visible = true
pb_1.visible = true

ll_row = this.RowCount()
////////////////COLOCANDO LA NUMERACION//////////////////////
declare usf_fl_numera_posib_arribo procedure for 
	usf_fl_numera_posib_arribo(:gs_origen);

execute usf_fl_numera_posib_arribo;

IF SQLCA.sqlcode = -1 THEN
	MessageBox('SQL error', SQLCA.SQLErrText)       
	Rollback ;
ELSE
	FETCH usf_fl_numera_posib_arribo INTO :li_nro; 
END IF
CLOSE usf_fl_numera_posib_arribo;

ls_nro = gs_origen+right(string(li_nro, '000000'),6)

This.Object.fl_posib_arribos_origen[ll_row] = gs_origen
This.Object.fl_posib_arribos_reg_pos_arrib[ll_row] = ls_nro

select nombre 
	into :ls_origen 
from origen 
where cod_origen = :gs_origen;

This.Object.origen_nombre[ll_row] = ls_origen

//////////////////////COLOCANDO LA NAVE///////////////////////

ls_sql = "select n.nave as codigo, n.nomb_nave as descripcion from tg_naves n"
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	
IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_nave = lstr_seleccionar.param1[1]
	ls_nave_nomb = lstr_seleccionar.param2[1]
	this.object.fl_posib_arribos_nave[ll_row] = ls_nave
	this.object.tg_naves_nomb_nave[ll_row] = ls_nave_nomb
ELSE		
	Messagebox('Error', "No ha seleccionado una nave", StopSign!)
end if

///////////////////COLOCANDO LA FECHA//////////////////////////
This.Object.fl_posib_arribos_fecha_hora_reg[ll_row] = datetime(Today(),Now())
ls_hora = string(hour(Now())+1)+':'+string(minute(now()))
This.Object.fl_posib_arribos_fecha_hora_arribo[ll_row] = datetime(Today(),Time(ls_hora))
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_nave, ls_nave_nomb, ls_sql, ls_tipo, ls_especie, ls_especie_desc, ls_origen, ls_origen_desc, ls_nro
long ll_row, ll_count
integer li_i, li_cuenta, li_nro
str_seleccionar lstr_seleccionar
ls_columna = lower(dwo.name)

If this.Describe(ls_columna  + ".Protect") = '1' then
	if ls_columna = 'fl_posib_arribos_nave' then
		messagebox('Flota', 'Para poder seleccionar una '+ls_columna+', deberá habilitar la opción de edición', StopSign!)
	end if
	RETURN
END IF

this.AcceptText()
ll_row = this.GetRow()
Choose case ls_columna

	case 'fl_posib_arribos_nave'
		
		ls_sql = "select n.nave as codigo, " &
				 + "n.nomb_nave as descripcion " &
				 + "from tg_naves n"
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_nave = lstr_seleccionar.param1[1]
			ls_nave_nomb = lstr_seleccionar.param2[1]
			this.object.fl_posib_arribos_nave[ll_row] = ls_nave
			this.object.tg_naves_nomb_nave[ll_row] = ls_nave_nomb
		ELSE		
			Messagebox('Error', "No ha seleccionado una nave", StopSign!)
		end if
end choose
end event

event dw_master::ue_insert;////////////////¿GRABAMOS?//////////////////////////////////
IF dw_master.ii_update = 1 THEN
	IF MessageBox("Flota", "¿Desea grabar el arribo anterior?", Question!, YesNo!, 1) = 1 THEN
 		PARENT.EVENT ue_update()
	END IF
END IF
//////////////////////LA HERENCIA///////////////////////////

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

event dw_master::itemchanged;call super::itemchanged;string ls_columna, ls_nave, ls_nomb_nave
long ll_row
 
str_seleccionar lstr_seleccionar
ls_columna = lower(dwo.name)
If this.Describe(ls_columna  + ".Protect") = '1' then
	if ls_columna = 'fl_posib_arribos_nave' then
		messagebox('Flota', 'Para poder seleccionar una '+ls_columna+', deberá habilitar la opción de edición', StopSign!)
	end if
	RETURN
END IF
this.AcceptText()

Choose case ls_columna
	case 'fl_posib_arribos_nave'
		ll_row = this.RowCount()
		SetNull(ls_nomb_nave)
		ls_nave = this.object.fl_posib_arribos_nave[ll_row]
		select tgn.nomb_nave into :ls_nomb_nave from tg_naves tgn where tgn.nave = :ls_nave;
		if IsNull(ls_nomb_nave ) or len(trim(ls_nomb_nave)) = 0 then
			messagebox('Flota','Nave no válida')
			this.object.fl_posib_arribos_nave[ll_row] = ''
			this.object.tg_naves_nomb_nave[ll_row] = ''
			this.event doubleclicked(1,1,ll_row,dwo)
		else
			this.object.fl_posib_arribos_nave[ll_row] = ls_nave
			this.object.tg_naves_nomb_nave[ll_row] = ls_nomb_nave

		end if
end choose
return 2						
end event

type em_1 from editmask within w_fl307_posib_arribo
boolean visible = false
integer x = 946
integer y = 288
integer width = 201
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
double increment = 1
string minmax = "0~~999"
end type

type gb_1 from groupbox within w_fl307_posib_arribo
boolean visible = false
integer x = 1134
integer y = 260
integer width = 347
integer height = 124
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
end type

type pb_1 from picturebutton within w_fl307_posib_arribo
boolean visible = false
integer x = 1463
integer y = 284
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "\source\BMP\green_arrow.bmp"
alignment htextalign = left!
end type

event clicked;long ll_row, ll_incremento
integer li_hour_ant, li_minute_ant, li_increment, li_day_ant, li_month_ant, li_year_ant, li_last_day
string ls_new_time, ls_new_date
time lt_hora_dw
dateTime ldt_fecha1, ldt_fecha2

ll_row = dw_master.GetRow()

ll_incremento = long(em_1.text)

ldt_fecha1 = DateTime(dw_master.object.fl_posib_arribos_fecha_hora_reg[ll_row])

ldt_fecha2 = f_relative_date( ldt_fecha1, ll_incremento, 'HRS')
dw_master.object.fl_posib_arribos_fecha_hora_arribo[ll_row] = ldt_fecha2


end event

type st_1 from statictext within w_fl307_posib_arribo
integer x = 1161
integer y = 300
integer width = 183
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Horas"
boolean focusrectangle = false
end type

