$PBExportHeader$w_pr732_genera_contrato.srw
forward
global type w_pr732_genera_contrato from w_rpt
end type
type sle_basico from editmask within w_pr732_genera_contrato
end type
type cb_3 from commandbutton within w_pr732_genera_contrato
end type
type cb_1 from commandbutton within w_pr732_genera_contrato
end type
type st_3 from statictext within w_pr732_genera_contrato
end type
type st_1 from statictext within w_pr732_genera_contrato
end type
type p_1 from picture within w_pr732_genera_contrato
end type
type cb_2 from commandbutton within w_pr732_genera_contrato
end type
type em_tipo_t from editmask within w_pr732_genera_contrato
end type
type em_tipo from singlelineedit within w_pr732_genera_contrato
end type
type em_seccion from singlelineedit within w_pr732_genera_contrato
end type
type em_area from singlelineedit within w_pr732_genera_contrato
end type
type sle_codigo from singlelineedit within w_pr732_genera_contrato
end type
type em_origen from singlelineedit within w_pr732_genera_contrato
end type
type rb_inactivos from radiobutton within w_pr732_genera_contrato
end type
type rb_activos from radiobutton within w_pr732_genera_contrato
end type
type st_2 from statictext within w_pr732_genera_contrato
end type
type dw_report from u_dw_rpt within w_pr732_genera_contrato
end type
type uo_prueba from u_ingreso_fecha within w_pr732_genera_contrato
end type
type st_4 from statictext within w_pr732_genera_contrato
end type
type em_desc_seccion from editmask within w_pr732_genera_contrato
end type
type uo_fecha from u_ingreso_rango_fechas within w_pr732_genera_contrato
end type
type em_desc_area from editmask within w_pr732_genera_contrato
end type
type sle_nombre from singlelineedit within w_pr732_genera_contrato
end type
type em_descripcion from editmask within w_pr732_genera_contrato
end type
type gb_2 from groupbox within w_pr732_genera_contrato
end type
type gb_3 from groupbox within w_pr732_genera_contrato
end type
type gb_5 from groupbox within w_pr732_genera_contrato
end type
type gb_4 from groupbox within w_pr732_genera_contrato
end type
type gb_1 from groupbox within w_pr732_genera_contrato
end type
type gb_6 from groupbox within w_pr732_genera_contrato
end type
end forward

global type w_pr732_genera_contrato from w_rpt
integer width = 4379
integer height = 3524
string title = "Genera contrato(PR406) "
string menuname = "m_reporte"
windowstate windowstate = maximized!
long backcolor = 67108864
sle_basico sle_basico
cb_3 cb_3
cb_1 cb_1
st_3 st_3
st_1 st_1
p_1 p_1
cb_2 cb_2
em_tipo_t em_tipo_t
em_tipo em_tipo
em_seccion em_seccion
em_area em_area
sle_codigo sle_codigo
em_origen em_origen
rb_inactivos rb_inactivos
rb_activos rb_activos
st_2 st_2
dw_report dw_report
uo_prueba uo_prueba
st_4 st_4
em_desc_seccion em_desc_seccion
uo_fecha uo_fecha
em_desc_area em_desc_area
sle_nombre sle_nombre
em_descripcion em_descripcion
gb_2 gb_2
gb_3 gb_3
gb_5 gb_5
gb_4 gb_4
gb_1 gb_1
gb_6 gb_6
end type
global w_pr732_genera_contrato w_pr732_genera_contrato

type variables
string is_action = 'open'


string 	ls_cod_trabajador, ls_next_nro
date 		ld_f_inicio, ld_f_cese


//insert into contrato_rrhh values(:ls_next_nro, :ls_cod_trabajador, null, :ld_f_inicio, :ld_f_cese, null,1 );
end variables

forward prototypes
public function integer usf_obtiene_meses_de_trabajo (date ad_fecha_inicio)
public function integer of_set_numera ()
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

on w_pr732_genera_contrato.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_basico=create sle_basico
this.cb_3=create cb_3
this.cb_1=create cb_1
this.st_3=create st_3
this.st_1=create st_1
this.p_1=create p_1
this.cb_2=create cb_2
this.em_tipo_t=create em_tipo_t
this.em_tipo=create em_tipo
this.em_seccion=create em_seccion
this.em_area=create em_area
this.sle_codigo=create sle_codigo
this.em_origen=create em_origen
this.rb_inactivos=create rb_inactivos
this.rb_activos=create rb_activos
this.st_2=create st_2
this.dw_report=create dw_report
this.uo_prueba=create uo_prueba
this.st_4=create st_4
this.em_desc_seccion=create em_desc_seccion
this.uo_fecha=create uo_fecha
this.em_desc_area=create em_desc_area
this.sle_nombre=create sle_nombre
this.em_descripcion=create em_descripcion
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_basico
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.em_tipo_t
this.Control[iCurrent+9]=this.em_tipo
this.Control[iCurrent+10]=this.em_seccion
this.Control[iCurrent+11]=this.em_area
this.Control[iCurrent+12]=this.sle_codigo
this.Control[iCurrent+13]=this.em_origen
this.Control[iCurrent+14]=this.rb_inactivos
this.Control[iCurrent+15]=this.rb_activos
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.dw_report
this.Control[iCurrent+18]=this.uo_prueba
this.Control[iCurrent+19]=this.st_4
this.Control[iCurrent+20]=this.em_desc_seccion
this.Control[iCurrent+21]=this.uo_fecha
this.Control[iCurrent+22]=this.em_desc_area
this.Control[iCurrent+23]=this.sle_nombre
this.Control[iCurrent+24]=this.em_descripcion
this.Control[iCurrent+25]=this.gb_2
this.Control[iCurrent+26]=this.gb_3
this.Control[iCurrent+27]=this.gb_5
this.Control[iCurrent+28]=this.gb_4
this.Control[iCurrent+29]=this.gb_1
this.Control[iCurrent+30]=this.gb_6
end on

on w_pr732_genera_contrato.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_basico)
destroy(this.cb_3)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.p_1)
destroy(this.cb_2)
destroy(this.em_tipo_t)
destroy(this.em_tipo)
destroy(this.em_seccion)
destroy(this.em_area)
destroy(this.sle_codigo)
destroy(this.em_origen)
destroy(this.rb_inactivos)
destroy(this.rb_activos)
destroy(this.st_2)
destroy(this.dw_report)
destroy(this.uo_prueba)
destroy(this.st_4)
destroy(this.em_desc_seccion)
destroy(this.uo_fecha)
destroy(this.em_desc_area)
destroy(this.sle_nombre)
destroy(this.em_descripcion)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.gb_6)
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

event ue_retrieve;call super::ue_retrieve;integer 	li_numero, li_count, li_i,dias, li_dia, li_mes
string 	ls_origen, ls_area, ls_seccion, ls_estado, ls_flag_r, ls_duracion, &
			ls_tipo_trabajador, ls_fcese, ls_today, ls_tipo_contrato, ls_partir, &
			ls_namearray[], ls_cod_traba
date 		ld_f_prueba, ld_cese, ld_fecha, ld_dias, ld_finicio, ld_fcese

is_action = 'new'

idw_1.SetRedraw(true)
ls_origen				= 	em_origen.text

IF rb_activos.Checked = true THEN
	ls_estado = '1'
END IF

IF rb_inactivos.Checked = true THEN
	ls_estado = '0'
END IF

ld_f_inicio		= 	uo_fecha.of_get_fecha1()
ld_f_cese	 	= 	uo_fecha.of_get_fecha2()
ld_f_prueba		= 	uo_prueba.of_get_fecha()

ld_cese 			= 	uo_fecha.of_get_fecha2()
ld_fecha 		= 	today()

n_cst_numlet_lg lnv_numlet
lnv_numlet 	= 	CREATE n_cst_numlet_lg
ls_fcese 	= 	lnv_numlet.of_numfechlar(ld_cese)
ls_partir 	= 	lnv_numlet.of_numfechlar(ld_f_inicio)
ls_today 	= 	lnv_numlet.of_numfechlar(today())

//tiempo del contrato

ld_finicio	= 	uo_fecha.of_get_fecha1()
ld_fcese	 	= 	uo_fecha.of_get_fecha2()

dias = DaysAfter(date(ld_finicio),date(ld_fcese))
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

//tiempo del contrato
ls_tipo_trabajador = em_tipo.text
IF ls_tipo_trabajador = '' THEN
	messagebox('Recursos Humanos', 'Por favor seleccione un Tipo de Trabajador')
 	return
END IF

IF ls_origen = '' THEN
	messagebox('Recursos Humanos', 'Por favor seleccione un Origen')
 	return
END IF

if LEN(sle_codigo.text) <> 0  then 
		
	ls_cod_trabajador 	= 	string(sle_codigo.text)
	if ls_tipo_trabajador = 'TRI' then
		idw_1.dataobject 		= 	'd_contrato_prueba'
	else
		idw_1.dataobject 		= 	'd_contrato_rrhh_unico'
	end if
	idw_1.settransobject(sqlca)
	
	idw_1.object.datawindow.Print.Orientation = 2
	idw_1.object.datawindow.Print.Paper.size = 9
	
	if ls_tipo_trabajador = 'TRI' then
		idw_1.Retrieve(ls_cod_trabajador, ld_f_inicio, ld_f_cese, ls_origen)
	else
		idw_1.Retrieve(ls_cod_trabajador, ld_f_inicio, ld_f_cese, ld_f_prueba)
	end if
		
	idw_1.Visible 						= 	True
	idw_1.Modify("p_logo.filename= '" +	gs_logo + "'")
	idw_1.Modify("t_cese.text= '" +	ls_fcese + "'")
	idw_1.Modify("t_fecha.text= '" +	ls_today + "'")
	idw_1.Modify("t_duracion.text= '" +	ls_duracion + "'")
	idw_1.Modify("t_partir.text= '" +	ls_partir + "'")
	
	//is_action = 'new'  //PARA ESPECIFICAR QUE SE CREARA UN NUEVO REGISTRO
	li_numero = of_set_numera()	
	
 else
	
	ls_area 	   			= 	em_area.text
	ls_seccion 				= 	em_seccion.text
		
	IF em_area.Text = '' THEN
		messagebox('Recursos Humanos', 'Por favor seleccione una Area')
	 return
 	END IF

	IF em_seccion.Text = '' THEN
		messagebox('Recursos Humanos', 'Por favor seleccione una Seccion')
	 	return
	END IF
		
	IF rb_activos.Checked = false AND rb_activos.Checked 		= true then 
		messagebox('Recursos Humanos', 'Por favor seleccione estado de los Trabajadores')
		 return
		if rb_inactivos.Checked = true and rb_activos.Checked = false THEN
			messagebox('Recursos Humanos', 'Por favor seleccione estado de los Trabajadores')
		    return
		end if 
	END IF
	
	if ls_tipo_trabajador = 'TRI' then
		idw_1.dataobject = 'd_contrato_prueba_varios'
		idw_1.settransobject(sqlca)
		idw_1.Retrieve(ls_origen, ls_area, ls_seccion, ls_tipo_trabajador, ls_estado, ld_f_inicio,ld_f_cese)
	else
		idw_1.dataobject = 'd_contrato_rrhh_contrato_lbl'
		idw_1.settransobject(sqlca)
		idw_1.Retrieve(ls_origen, ls_area, ls_seccion, ls_tipo_trabajador, ls_estado, ld_f_inicio,ld_f_cese,ld_f_prueba)
	end if
	
	idw_1.object.datawindow.Print.Orientation = 2
	idw_1.object.datawindow.Print.Paper.size = 9

	if idw_1.rowcount( ) < 1 then
		messagebox('Recursos Humanos','No existen datos')
		idw_1.Visible 						= 	FALSE
	else
		idw_1.Visible 						= 	True
		idw_1.Modify("p_logo.filename= '" +	gs_logo + "'")
		idw_1.Modify("t_cese.text= '" +	ls_fcese + "'")
		idw_1.Modify("t_fecha.text= '" +	ls_today + "'")
		idw_1.Modify("t_duracion.text= '" +	ls_duracion + "'")
		idw_1.Modify("t_partir.text= '" +	ls_partir + "'")

		ls_namearray = idw_1.Object.maestro_cod_trabajador.Current
 						
		for li_i = 1 to UpperBound(ls_namearray) 
		   ls_cod_traba = ls_namearray[li_i]
			//is_action = 'new'  //PARA ESPECIFICAR QUE SE CREARA UN NUEBO REGISTRO
			li_numero = of_set_numera()
			if ls_tipo_trabajador <> 'TRI' then
				idw_1.object.codigo_c[li_i] = ls_next_nro
			end if
			insert into contrato_rrhh values(:ls_next_nro, :ls_namearray[li_i], null, :ld_f_inicio, :ld_f_cese, null,1 );
		next
	end if
end if
		
end event

event open;call super::open;//of_datawindows()
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

// Genera el numero del Parte Diario

//if of_set_numera() = 0 then return

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

//ib_update_check = true
	
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type sle_basico from editmask within w_pr732_genera_contrato
integer x = 3803
integer y = 124
integer width = 402
integer height = 84
integer taborder = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_pr732_genera_contrato
integer x = 3808
integer y = 244
integer width = 402
integer height = 88
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;Dec 		ldc_basico, ldc_ganancia, ldc_new_ganancia
Integer	ll_i

IF dw_report.getrow( ) < 1 then return

if trim(em_tipo.text) <> 'DES' THEN
	MESSAGEBOX('Producción', 'Esta opción solo funciona para trabajadores tipo Destajeros')
	Return 0
end if

ldc_basico 	= dec(sle_basico.text)

IF ldc_basico <= 0 THEN
	
	Messagebox('Producción', 'No ha ingresado Ninguna Remuneración')
	RETURN 1
END IF

ldc_new_ganancia = 0.00
ldc_new_ganancia	= ldc_basico / 30

IF LEN(sle_codigo.text) <> 0  THEN  

	ldc_ganancia	= dw_report.object.t_diaomes [dw_report.GetRow()] 

	dw_report.object.t_diaomes [dw_report.GetRow()] = ldc_ganancia + ldc_new_ganancia

ELSE

	FOR ll_i = 1 TO dw_report.rowcount( )
		
		ldc_ganancia	= dw_report.object.t_gdiaomes [ll_i] 
		dw_report.object.t_gdiaomes [ll_i] = ldc_ganancia + ldc_new_ganancia

	NEXT
	
END IF
end event

type cb_1 from commandbutton within w_pr732_genera_contrato
integer x = 3205
integer y = 244
integer width = 402
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

type st_3 from statictext within w_pr732_genera_contrato
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
long backcolor = 12632256
string text = "Contrato para varios trabajadores"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pr732_genera_contrato
integer x = 73
integer y = 408
integer width = 855
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Contrato para un solo trabajador"
boolean focusrectangle = false
end type

type p_1 from picture within w_pr732_genera_contrato
integer x = 3031
integer y = 540
integer width = 69
integer height = 84
string pointer = "H:\source\Gif\HAND.CUR"
string picturename = "H:\source\Gif\disco_anim_bf16.gif"
boolean focusrectangle = false
end type

event clicked;string ls_duracion
date ld_finicio, ld_fcese
INTEGER dias, li_dia, li_mes


ld_finicio	= 	uo_fecha.of_get_fecha1()
ld_fcese	 	= 	uo_fecha.of_get_fecha2()

dias = DaysAfter(date(ld_finicio),date(ld_fcese))
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
MESSAGEBOX('Tiempo de Contrato',ls_duracion)
//dw_1.object.t_1.text = ls_duracion


end event

type cb_2 from commandbutton within w_pr732_genera_contrato
boolean visible = false
integer x = 3182
integer y = 44
integer width = 494
integer height = 144
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\PUTMGET.CUR"
boolean enabled = false
string text = "Guardar Contrato"
end type

event clicked;
if LEN(sle_codigo.text) > 1  then 
insert into contrato_rrhh values(:ls_next_nro, :ls_cod_trabajador, null, :ld_f_inicio, :ld_f_cese, null,1 );
end if
commit;

//long ll_i
//String ls_pta_origen, ls_sep,ls_mensaje
//
//is_cod_origen = ''
//ls_separador  = ''

//if len(sle_codigo.text) > 1 then
//	parent.event ue_open_pre()
//else
//parent.event ue_retrieve()
//date ld_f_inicio, ld_f_cese
//INTEGER li_count,I
//STRING ls_cod_t
//ld_f_inicio		= uo_fecha.of_get_fecha1()
//ld_f_cese	 	= uo_fecha.of_get_fecha2()

// leer el dw_origen con los origenes seleccionados

//For ll_i = 1 To dw_origen.RowCount()
//	If dw_origen.Object.Chec[ll_i] = '1' Then
//		if is_cod_origen <>'' THEN ls_separador = ', '
//		is_cod_origen = is_cod_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
//		if is_planta <> '' THEN  ls_sep = ' y '
//		is_planta = is_planta + ls_sep + dw_origen.object.nombre[ll_i]
//	end if
//Next






end event

type em_tipo_t from editmask within w_pr732_genera_contrato
integer x = 2286
integer y = 268
integer width = 859
integer height = 76
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from singlelineedit within w_pr732_genera_contrato
event dobleclick pbm_lbuttondblclk
integer x = 2149
integer y = 268
integer width = 128
integer height = 76
integer taborder = 90
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
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  TIPO_TRABAJADOR as CODIGO, " & 
		  +"DESC_TIPO_TRA AS DESCRIPCION " &
		  + "FROM tipo_trabajador " &
		  + "WHERE FLAG_ESTADO = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = upper(ls_codigo)
	em_tipo_t.text = upper(ls_data)
end if


end event

event modified;String 	ls_tipo_traba, ls_desc_t

ls_tipo_traba = this.text
if ls_tipo_traba = '' or IsNull(ls_tipo_traba) then
	MessageBox('Aviso', 'Debe Ingresar un Tipo de Trabajador')
	this.text = ' '
	return
end if

SELECT desc_tipo_tra
	INTO :ls_desc_t
FROM tipo_trabajador
WHERE tipo_trabajador = :ls_tipo_Traba;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Tipo de Trabajador no existe')
	this.text = ' '
	return
end if

em_tipo_t.text = ls_desc_t
end event

type em_seccion from singlelineedit within w_pr732_genera_contrato
event dobleclick pbm_lbuttondblclk
integer x = 1029
integer y = 276
integer width = 128
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_seccion as CODIGO, " & 
		  +"DESC_SECCION AS DESCRIPCION " &
		  + "FROM SECCION " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_desc_seccion.text = ls_data
end if

end event

event modified;String 	ls_seccion, ls_desc

ls_seccion = this.text
if ls_seccion = '' or IsNull(ls_seccion) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Secciòn')
	return
end if

SELECT desc_seccion
	INTO :ls_desc
FROM seccion
WHERE cod_seccion = :ls_seccion;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Seccion no existe')
	this.text = ' '
	return
end if

em_desc_seccion.text = ls_desc

end event

type em_area from singlelineedit within w_pr732_genera_contrato
event dobleclick pbm_lbuttondblclk
integer x = 1033
integer y = 176
integer width = 128
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_area as CODIGO, " & 
		  +"DESC_AREA AS DESCRIPCION " &
		  + "FROM AREA " &
		  + "WHERE FLAG_REPLICACION = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_desc_area.text = ls_data
end if

end event

event modified;String 	ls_area, ls_desc_a

ls_area = em_area.text
if ls_area = '' or IsNull(ls_area) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Area')
	this.text = ' '
	return
end if

SELECT desc_area
	INTO :ls_desc_a
FROM area
WHERE cod_area = :ls_area;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo Area no existe')
	this.text = ' '
	return
end if

em_desc_area.text = ls_desc_a
end event

type sle_codigo from singlelineedit within w_pr732_genera_contrato
event dobleclick pbm_lbuttondblclk
integer x = 114
integer y = 544
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
string ls_codigo, ls_data, ls_sql, ls_tipo, ls_origen

ls_tipo = em_tipo.text
ls_origen = em_origen.text

if ls_tipo = '' then
	MessageBox('Aviso', 'Debe Indicar un tipo de trabajador')
	return
end if

if ls_origen = '' then
	MessageBox('Aviso', 'Debe Indicar un Origen de trabajador')
	return
end if

ls_sql = "SELECT  cod_trabajador as codigo, " & 
		 + " apel_paterno||' '||apel_materno||' '||nombre1||' '||nombre2 AS TRABAJADOR " &
		 + "FROM maestro " &
	  	 + "WHERE flag_estado = '1' " &
		 + "and tipo_trabajador = '" + ls_tipo + "' " &
		 + "and cod_origen = '" + ls_origen + "'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
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

type em_origen from singlelineedit within w_pr732_genera_contrato
event dobleclick pbm_lbuttondblclk
integer x = 110
integer y = 228
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

type rb_inactivos from radiobutton within w_pr732_genera_contrato
integer x = 2674
integer y = 136
integer width = 315
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inactivos"
end type

type rb_activos from radiobutton within w_pr732_genera_contrato
integer x = 2386
integer y = 136
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Activos"
boolean checked = true
end type

type st_2 from statictext within w_pr732_genera_contrato
integer x = 2135
integer y = 144
integer width = 219
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estado"
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_pr732_genera_contrato
integer x = 73
integer y = 672
integer width = 4000
integer height = 1304
integer taborder = 0
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

//of_set_status_menu(this)
end event

type uo_prueba from u_ingreso_fecha within w_pr732_genera_contrato
event destroy ( )
integer x = 3136
integer y = 576
end type

on uo_prueba.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Hasta:') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
//of_get_fecha()  para leer las fechas


 
end event

type st_4 from statictext within w_pr732_genera_contrato
integer x = 3118
integer y = 496
integer width = 617
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Periodo de Prueba"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_desc_seccion from editmask within w_pr732_genera_contrato
integer x = 1198
integer y = 276
integer width = 859
integer height = 72
integer taborder = 80
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

type uo_fecha from u_ingreso_rango_fechas within w_pr732_genera_contrato
integer x = 1687
integer y = 544
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

type em_desc_area from editmask within w_pr732_genera_contrato
integer x = 1202
integer y = 180
integer width = 859
integer height = 72
integer taborder = 60
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

type sle_nombre from singlelineedit within w_pr732_genera_contrato
integer x = 430
integer y = 544
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

type em_descripcion from editmask within w_pr732_genera_contrato
integer x = 251
integer y = 228
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

type gb_2 from groupbox within w_pr732_genera_contrato
integer x = 69
integer y = 112
integer width = 905
integer height = 264
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_pr732_genera_contrato
integer x = 64
integer y = 476
integer width = 1522
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Trabajador "
end type

type gb_5 from groupbox within w_pr732_genera_contrato
integer x = 983
integer y = 112
integer width = 1129
integer height = 264
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Area y  Sección "
end type

type gb_4 from groupbox within w_pr732_genera_contrato
integer x = 1600
integer y = 476
integer width = 1426
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

type gb_1 from groupbox within w_pr732_genera_contrato
integer x = 2121
integer y = 208
integer width = 1061
integer height = 168
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona Tipo de Trabajador"
end type

type gb_6 from groupbox within w_pr732_genera_contrato
integer x = 3739
integer y = 48
integer width = 539
integer height = 308
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Remuneración"
end type

