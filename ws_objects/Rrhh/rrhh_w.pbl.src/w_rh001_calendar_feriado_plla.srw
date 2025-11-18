$PBExportHeader$w_rh001_calendar_feriado_plla.srw
forward
global type w_rh001_calendar_feriado_plla from w_abc_master_smpl
end type
type st_1 from statictext within w_rh001_calendar_feriado_plla
end type
type ddlb_1 from u_ddlb within w_rh001_calendar_feriado_plla
end type
type cb_1 from commandbutton within w_rh001_calendar_feriado_plla
end type
type st_2 from statictext within w_rh001_calendar_feriado_plla
end type
end forward

global type w_rh001_calendar_feriado_plla from w_abc_master_smpl
integer width = 2290
integer height = 1936
string title = "[RH001] Calendario de feriados"
string menuname = "m_master_simple"
event ue_retrieve ( )
st_1 st_1
ddlb_1 ddlb_1
cb_1 cb_1
st_2 st_2
end type
global w_rh001_calendar_feriado_plla w_rh001_calendar_feriado_plla

event ue_retrieve();String ls_origen, ls_desc_origen 
ls_origen = TRIM(LEFT(ddlb_1.Text,2))
ls_desc_origen = MID(trim(ddlb_1.text),5,20)

dw_master.retrieve(ls_origen)
end event

on w_rh001_calendar_feriado_plla.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.cb_1=create cb_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_2
end on

on w_rh001_calendar_feriado_plla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.cb_1)
destroy(this.st_2)
end on

event ue_dw_share;// Override

/*
String ls_origen, ls_desc_origen 
ls_origen = TRIM(LEFT(ddlb_1.Text,2))
ls_desc_origen = MID(trim(ddlb_1.text),5,20)
MessageBox('Origen', ls_origen)
MessageBox('Descripcion de Origen', ls_desc_origen)
*/
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh001_calendar_feriado_plla
event ue_display ( string as_columna,  long al_row )
integer y = 280
integer width = 2144
integer height = 1464
string dataobject = "d_abc_calendar_feriad_plla_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_parametros sl_param

choose case lower(as_columna)
		
	case "origen"
		
		ls_sql = "SELECT cod_origen as codigo_origen, " &
				  + "nombre AS nombre " &
				  + "FROM origen " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.origen 		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose

end event

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = dw_master

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String ls_origen

ls_origen = TRIM(LEFT(ddlb_1.Text,2))

IF ISNULL(ls_origen) OR TRIM(ls_origen)='' THEN
	MessageBox('Aviso', 'Defina origen')
	Return
END IF 

this.object.origen				[al_row] = ls_origen
this.object.flag_medio_dia_lab[al_row] = '0'
this.object.porcentaje			[al_row] = 100.00
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

type st_1 from statictext within w_rh001_calendar_feriado_plla
integer x = 50
integer y = 76
integer width = 201
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
boolean focusrectangle = false
end type

type ddlb_1 from u_ddlb within w_rh001_calendar_feriado_plla
integer x = 293
integer y = 64
integer width = 631
integer height = 372
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_lista_origen_todos_tbl'

ii_cn1 = 1                     	// Nro del campo 1
ii_cn2 = 2                     	// Nro del campo 2
ii_ck  = 1                     	// Nro del campo key
ii_lc1 = 5                     	// Longitud del campo 1
ii_lc2 = 30								// Longitud del campo 2

end event

type cb_1 from commandbutton within w_rh001_calendar_feriado_plla
integer x = 942
integer y = 52
integer width = 293
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recupera"
end type

event clicked;String ls_origen

ls_origen = TRIM(LEFT(ddlb_1.Text,2))

IF ISNULL(ls_origen) OR TRIM(ls_origen)='' THEN
	MessageBox('Aviso', 'Defina origen')
	Return 1
END IF 

event ue_retrieve()
end event

type st_2 from statictext within w_rh001_calendar_feriado_plla
integer x = 69
integer y = 204
integer width = 1157
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Si feriado es domingo, no considerarlo"
boolean focusrectangle = false
end type

