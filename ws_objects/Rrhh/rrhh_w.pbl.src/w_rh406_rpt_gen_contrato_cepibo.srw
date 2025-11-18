$PBExportHeader$w_rh406_rpt_gen_contrato_cepibo.srw
forward
global type w_rh406_rpt_gen_contrato_cepibo from w_rpt
end type
type ddlb_contrato_tipo from dropdownlistbox within w_rh406_rpt_gen_contrato_cepibo
end type
type sle_codigo from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
end type
type sle_nombre from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
end type
type st_1 from statictext within w_rh406_rpt_gen_contrato_cepibo
end type
type ddlb_dia_mes from dropdownlistbox within w_rh406_rpt_gen_contrato_cepibo
end type
type sle_tprueba from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
end type
type cb_1 from commandbutton within w_rh406_rpt_gen_contrato_cepibo
end type
type st_3 from statictext within w_rh406_rpt_gen_contrato_cepibo
end type
type sle_cod from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
end type
type em_origen from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
end type
type dw_report from u_dw_rpt within w_rh406_rpt_gen_contrato_cepibo
end type
type st_4 from statictext within w_rh406_rpt_gen_contrato_cepibo
end type
type uo_fecha from u_ingreso_rango_fechas within w_rh406_rpt_gen_contrato_cepibo
end type
type sle_gerente from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
end type
type em_descripcion from editmask within w_rh406_rpt_gen_contrato_cepibo
end type
type gb_2 from groupbox within w_rh406_rpt_gen_contrato_cepibo
end type
type gb_3 from groupbox within w_rh406_rpt_gen_contrato_cepibo
end type
type gb_4 from groupbox within w_rh406_rpt_gen_contrato_cepibo
end type
type gb_1 from groupbox within w_rh406_rpt_gen_contrato_cepibo
end type
type gb_5 from groupbox within w_rh406_rpt_gen_contrato_cepibo
end type
end forward

global type w_rh406_rpt_gen_contrato_cepibo from w_rpt
integer width = 3945
integer height = 3524
string title = "(RH406) Genera contrato"
string menuname = "m_impresion"
windowstate windowstate = maximized!
ddlb_contrato_tipo ddlb_contrato_tipo
sle_codigo sle_codigo
sle_nombre sle_nombre
st_1 st_1
ddlb_dia_mes ddlb_dia_mes
sle_tprueba sle_tprueba
cb_1 cb_1
st_3 st_3
sle_cod sle_cod
em_origen em_origen
dw_report dw_report
st_4 st_4
uo_fecha uo_fecha
sle_gerente sle_gerente
em_descripcion em_descripcion
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_1 gb_1
gb_5 gb_5
end type
global w_rh406_rpt_gen_contrato_cepibo w_rh406_rpt_gen_contrato_cepibo

type variables
string is_action = 'open'


string 	ls_cod_trabajador, ls_next_nro
date 		ld_f_inicio, ld_f_cese


//insert into contrato_rrhh values(:ls_next_nro, :ls_cod_trabajador, null, :ld_f_inicio, :ld_f_cese, null,1 );
end variables

forward prototypes
public function integer usf_obtiene_meses_de_trabajo (date ad_fecha_inicio)
public function integer of_set_numera ()
public function string of_tiempo_del_contrato (date ad_inicio, date ad_cese)
end prototypes

public function integer usf_obtiene_meses_de_trabajo (date ad_fecha_inicio);INTEGER LI_MESES_DE_TRABAJO;
//
//
//
//INSERT INTO EMPLOYEE ( SALARY )
//
//        VALUES ( 18900 ) ;
//
//The same statement using a PowerScript variable to reference the constant might look like this:
//
//int   Sal_var
//
//Sal_var = 18900
//
//INSERT INTO EMPLOYEE ( SALARY )
//
//        VALUES ( :Sal_var ) ;
//
//
//
//ll_currentrow = adw_datawindow.GetRow()
//
//IF ll_currentrow > 0 then
//	//change redraw to avoid flicker
//	adw_datawindow.setredraw(false)
//	
//	adw_datawindow.SelectRow(0,False)
//	adw_datawindow.SelectRow(ll_currentrow,True)
//	adw_datawindow.setfocus()
//
//	adw_datawindow.setredraw(true)
//END IF
//return ll_currentrow

return LI_MESES_DE_TRABAJO
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i, ll_item
String  	ls_lock_table, ls_mensaje

if dw_report.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_contrato_rrhh
	where origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE num_contrato_rrhh IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_contrato_rrhh
		values(:gs_origen, ll_count,'1');
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_contrato_rrhh
	where origen = :gs_origen for update;
	
	update num_contrato_rrhh
		set ult_nro = ult_nro + 1
	where origen = :gs_origen;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	ls_next_nro = string(year(today()))
	idw_1.Modify("t_numero.text = '" + ls_next_nro + "'")
END IF 	
return 1
end function

public function string of_tiempo_del_contrato (date ad_inicio, date ad_cese);Integer dias, li_mes, li_dia
String  ls_duracion

dias = DaysAfter(date(ad_inicio),date(ad_cese))
dias = dias + 1

if dias < 30 then
	li_mes 		= 0
	li_dia 		= dias
	ls_duracion = string(li_mes) + space(1) +  'mes(es) y' + space(1) + string(li_dia)+ space(1) +'días' 
else 
	li_mes 		= truncate(dias/30,0)
	li_dia 		= truncate(mod(dias,30),2)
	ls_duracion = string(li_mes) + space(1) +  'mes(es) y' + space(1) + string(li_dia)+ space(1) +'días' 
end if

Return ls_duracion





end function

on w_rh406_rpt_gen_contrato_cepibo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.ddlb_contrato_tipo=create ddlb_contrato_tipo
this.sle_codigo=create sle_codigo
this.sle_nombre=create sle_nombre
this.st_1=create st_1
this.ddlb_dia_mes=create ddlb_dia_mes
this.sle_tprueba=create sle_tprueba
this.cb_1=create cb_1
this.st_3=create st_3
this.sle_cod=create sle_cod
this.em_origen=create em_origen
this.dw_report=create dw_report
this.st_4=create st_4
this.uo_fecha=create uo_fecha
this.sle_gerente=create sle_gerente
this.em_descripcion=create em_descripcion
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_contrato_tipo
this.Control[iCurrent+2]=this.sle_codigo
this.Control[iCurrent+3]=this.sle_nombre
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.ddlb_dia_mes
this.Control[iCurrent+6]=this.sle_tprueba
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.sle_cod
this.Control[iCurrent+10]=this.em_origen
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.uo_fecha
this.Control[iCurrent+14]=this.sle_gerente
this.Control[iCurrent+15]=this.em_descripcion
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_3
this.Control[iCurrent+18]=this.gb_4
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_5
end on

on w_rh406_rpt_gen_contrato_cepibo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_contrato_tipo)
destroy(this.sle_codigo)
destroy(this.sle_nombre)
destroy(this.st_1)
destroy(this.ddlb_dia_mes)
destroy(this.sle_tprueba)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.sle_cod)
destroy(this.em_origen)
destroy(this.dw_report)
destroy(this.st_4)
destroy(this.uo_fecha)
destroy(this.sle_gerente)
destroy(this.em_descripcion)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.gb_5)
end on

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()

end event

event ue_retrieve;call super::ue_retrieve;integer 	li_numero, li_count, li_i,dias, li_dia, li_mes, li_periodo_prueba
string 	ls_origen, ls_area, ls_seccion, ls_estado, ls_flag_r, ls_duracion, &
			ls_tipo_trabajador, ls_fcese, ls_today, ls_tipo_contrato, &
			ls_partir, ls_namearray[], ls_cod_trab, &
			ls_modalidad_contrato, ls_dia_mes, ls_nom_ger, ls_dni_ger, ls_tiempo
date 		ld_cese, ld_fecha, ld_dias, ld_finicio, ld_fcese

idw_1.SetRedraw(true)
ls_origen				= 	em_origen.text
IF ls_origen = '' THEN
	messagebox('Recursos Humanos', 'Por favor seleccione un Origen')
	em_origen.SetFocus( )
 	return
END IF

ld_f_inicio		= 	uo_fecha.of_get_fecha1()
ld_f_cese	 	= 	uo_fecha.of_get_fecha2()

ld_fecha 		= 	today()

n_cst_numlet_lg lnv_numlet
lnv_numlet 	= 	CREATE n_cst_numlet_lg
ls_fcese 	= 	lnv_numlet.of_numfechlar(ld_cese)
ls_partir 	= 	lnv_numlet.of_numfechlar(ld_f_inicio)
ls_today 	= 	lnv_numlet.of_numfechlar(date(f_fecha_actual()))

//tiempo del contrato
ls_duracion = of_tiempo_del_contrato(ld_f_inicio, ld_f_cese)

if LEN(trim(sle_codigo.text)) = 0  then 
		MessageBox("Error", "Debe especificar un codigo de trabajador, por favor verifique")
		sle_codigo.setFocus( )
		return
end if

ls_cod_trab = trim(sle_codigo.text)

if ddlb_contrato_tipo.Text = "" then
	MessageBox('Error', 'Debe Seleccionar un tipo de contrato')
	ddlb_contrato_tipo.setFocus( )
	return
end if

ls_tipo_contrato = trim(ddlb_contrato_tipo.text)
	
// Indicando el periodo de pruebas
li_periodo_prueba = Integer(sle_tprueba.text)
ls_dia_mes			= mid(upper(ddlb_dia_mes.text),1,1)

if ls_tipo_contrato = 'Obrero' then
	idw_1.dataobject = 'd_contrato_cepibo_jor'
	idw_1.settransobject(sqlca)
	idw_1.Retrieve(ls_cod_trab, ld_f_inicio,ld_f_cese,sle_cod.text)
elseif ls_tipo_contrato = 'Administrativo' then
	idw_1.dataobject = 'd_contrato_cepibo'
	idw_1.settransobject(sqlca)
	ls_tiempo = "0" + sle_tprueba.text + " " + ddlb_dia_mes.text
	idw_1.Retrieve(ls_cod_trab, ld_f_inicio,ld_f_cese,sle_cod.text,ls_tiempo)
end if

/*
if ls_tipo_trabajador = 'TRI' then
	idw_1.dataobject = 'd_contrato_tripulante_varios'
	idw_1.settransobject(sqlca)
	idw_1.Retrieve(ls_cod_trab, ls_origen, ls_area, ls_seccion, ls_tipo_trabajador, ls_estado, ld_f_inicio,ld_f_cese, ls_duracion)
elseif ls_tipo_trabajador = 'JOR' then
	idw_1.dataobject = 'd_contrato_jornaleros_varios'
	idw_1.settransobject(sqlca)
	idw_1.Retrieve(ls_cod_trab, ls_origen, ls_area, ls_seccion, ls_tipo_trabajador, ls_estado, ld_f_inicio,ld_f_cese, ls_duracion)
else
	idw_1.dataobject = 'd_contrato_rrhh_contrato_lbl'
	idw_1.settransobject(sqlca)
	idw_1.Retrieve(ls_cod_trab, ls_origen, ls_area, ls_seccion, ls_tipo_trabajador, ls_estado, ld_f_inicio,ld_f_cese,ld_f_prueba)
end if
*/

idw_1.object.datawindow.Print.Orientation = 2
idw_1.object.datawindow.Print.Paper.size = 9

if idw_1.rowcount( ) < 1 then
	messagebox('Recursos Humanos','No existen datos')
	idw_1.Visible 						= 	FALSE
else
	idw_1.Visible 						= 	True
	//idw_1.Modify("p_logo.filename= '" +	gs_logo + "'")
	//idw_1.Modify("t_cese.text= '" +	ls_fcese + "'")
	//idw_1.Modify("t_fecha.text= '" +	ls_today + "'")
	//idw_1.Modify("t_duracion.text= '" +	ls_duracion + "'")
	//idw_1.Modify("t_partir.text= '" +	ls_partir + "'")

	//ls_namearray = idw_1.Object.maestro_cod_trabajador.Current
	
	/*
	for li_i = 1 to UpperBound(ls_namearray) 
		ls_cod_trab = ls_namearray[li_i]
		is_action = 'new'  //PARA ESPECIFICAR QUE SE CREARA UN NUEBO REGISTRO
		li_numero = of_set_numera()
		if ls_tipo_trabajador <> 'TRI' then
			//idw_1.object.codigo_c[li_i] = ls_next_nro
		end if
		insert into contrato_rrhh values(:ls_next_nro, :ls_namearray[li_i], null, :ld_f_inicio, :ld_f_cese, null,1 );
	next
	*/
end if
		
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
//IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

// Genera el numero del Parte Diario

//if of_set_numera() = 0 then return

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

//ib_update_check = true
	
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type ddlb_contrato_tipo from dropdownlistbox within w_rh406_rpt_gen_contrato_cepibo
integer x = 3040
integer y = 160
integer width = 411
integer height = 352
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"Administrativo","Obrero"}
borderstyle borderstyle = stylelowered!
end type

type sle_codigo from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
event dobleclick pbm_lbuttondblclk
integer x = 1061
integer y = 160
integer width = 293
integer height = 72
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 134217746
long backcolor = 33554431
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tipo, ls_origen, ls_area, ls_seccion

ls_origen = em_origen.text

if ls_origen = '' then
	MessageBox('Aviso', 'Debe Indicar un Origen de trabajador')
	return
end if

ls_sql = "SELECT  cod_trabajador as codigo, " & 
		 + " apel_paterno||' '||apel_materno||' '||nombre1||' '||nombre2 AS TRABAJADOR " &
		 + "FROM maestro " &
	  	 + "WHERE flag_estado = '1' " &
		 + "and cod_origen = '" + ls_origen + "' " &
		 + "and flag_cal_plnlla = '1' "

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_nombre.text = ls_data
end if
end event

event modified;String 	ls_cod_t, ls_nombre

ls_cod_t = this.text
if ls_cod_t = '' or IsNull(ls_cod_t) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Trabajador')
	this.text = ' '
	return
end if

SELECT apel_paterno||' '||apel_materno||' '||nombre1||' '||nombre2
	INTO :ls_nombre
FROM maestro
WHERE cod_trabajador = :ls_cod_t;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Trabajador no existe')
	this.text = ' '
	return
end if

sle_nombre.text = ls_nombre
end event

type sle_nombre from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
integer x = 1376
integer y = 160
integer width = 1106
integer height = 72
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_rh406_rpt_gen_contrato_cepibo
integer x = 2633
integer y = 152
integer width = 343
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_dia_mes from dropdownlistbox within w_rh406_rpt_gen_contrato_cepibo
integer x = 1911
integer y = 376
integer width = 411
integer height = 352
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"dias","meses"}
borderstyle borderstyle = stylelowered!
end type

type sle_tprueba from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
integer x = 1723
integer y = 376
integer width = 178
integer height = 84
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh406_rpt_gen_contrato_cepibo
integer x = 2807
integer y = 388
integer width = 699
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()
end event

type st_3 from statictext within w_rh406_rpt_gen_contrato_cepibo
integer x = 73
integer y = 36
integer width = 855
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Contrato para varios trabajadores"
boolean focusrectangle = false
end type

type sle_cod from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
event dobleclick pbm_lbuttondblclk
integer x = 279
integer y = 576
integer width = 293
integer height = 72
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 134217746
long backcolor = 33554431
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tipo, ls_origen, ls_area, ls_seccion

ls_origen = em_origen.text

ls_sql = "SELECT  cod_trabajador as codigo, " & 
		 + " apel_paterno||' '||apel_materno||' '||nombre1||' '||nombre2 AS TRABAJADOR " &
		 + "FROM maestro " &
	  	 + "WHERE flag_estado = '1' " 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_gerente.text = ls_data
end if
end event

event modified;String 	ls_cod_t, ls_nombre

ls_cod_t = this.text
if ls_cod_t = '' or IsNull(ls_cod_t) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Trabajador')
	this.text = ' '
	return
end if

SELECT apel_paterno||' '||apel_materno||' '||nombre1||' '||nombre2
	INTO :ls_nombre
FROM maestro
WHERE cod_trabajador = :ls_cod_t;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Trabajador no existe')
	this.text = ' '
	return
end if

sle_nombre.text = ls_nombre
end event

type em_origen from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
event dobleclick pbm_lbuttondblclk
integer x = 110
integer y = 188
integer width = 128
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	this.text = ' '
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	this.text = ' '
	return
end if

em_descripcion.text = ls_desc

end event

type dw_report from u_dw_rpt within w_rh406_rpt_gen_contrato_cepibo
integer y = 696
integer width = 3835
integer height = 1268
integer taborder = 0
boolean livescroll = false
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

//of_set_status_menu(this)
end event

type st_4 from statictext within w_rh406_rpt_gen_contrato_cepibo
integer x = 1518
integer y = 376
integer width = 197
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tiempo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas within w_rh406_rpt_gen_contrato_cepibo
integer x = 192
integer y = 376
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 
 of_get_fecha1()
 of_get_fecha2()
 



end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type sle_gerente from singlelineedit within w_rh406_rpt_gen_contrato_cepibo
integer x = 594
integer y = 576
integer width = 1778
integer height = 72
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type em_descripcion from editmask within w_rh406_rpt_gen_contrato_cepibo
integer x = 251
integer y = 188
integer width = 663
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type gb_2 from groupbox within w_rh406_rpt_gen_contrato_cepibo
integer x = 69
integer y = 112
integer width = 905
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh406_rpt_gen_contrato_cepibo
integer x = 178
integer y = 508
integer width = 2245
integer height = 168
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Gerente"
end type

type gb_4 from groupbox within w_rh406_rpt_gen_contrato_cepibo
integer x = 110
integer y = 308
integer width = 2272
integer height = 184
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Ingrese Rango de Fechas "
end type

type gb_1 from groupbox within w_rh406_rpt_gen_contrato_cepibo
integer x = 2610
integer y = 60
integer width = 1134
integer height = 224
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo y Modalidad de Contrato"
end type

type gb_5 from groupbox within w_rh406_rpt_gen_contrato_cepibo
integer x = 1010
integer y = 92
integer width = 1522
integer height = 180
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Trabajador "
end type

