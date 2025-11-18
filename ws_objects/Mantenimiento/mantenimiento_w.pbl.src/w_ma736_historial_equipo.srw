$PBExportHeader$w_ma736_historial_equipo.srw
forward
global type w_ma736_historial_equipo from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_ma736_historial_equipo
end type
type cb_1 from commandbutton within w_ma736_historial_equipo
end type
type rb_1 from radiobutton within w_ma736_historial_equipo
end type
type rb_2 from radiobutton within w_ma736_historial_equipo
end type
type rb_3 from radiobutton within w_ma736_historial_equipo
end type
type rb_4 from radiobutton within w_ma736_historial_equipo
end type
type gb_2 from groupbox within w_ma736_historial_equipo
end type
type gb_4 from groupbox within w_ma736_historial_equipo
end type
end forward

global type w_ma736_historial_equipo from w_report_smpl
integer width = 3744
integer height = 3192
string title = "Historial de Equipos (MA736)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fecha uo_fecha
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
gb_2 gb_2
gb_4 gb_4
end type
global w_ma736_historial_equipo w_ma736_historial_equipo

on w_ma736_historial_equipo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.gb_2=create gb_2
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_4
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_4
end on

on w_ma736_historial_equipo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.gb_2)
destroy(this.gb_4)
end on

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_Fecha2
string ls_mensaje

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

//create or replace procedure USP_MTO_RPT_HISTORIAL(
//       adi_fecha1   in date,
//       adi_fecha2   in date
//) is

DECLARE 	USP_MTO_RPT_HISTORIAL PROCEDURE FOR
			USP_MTO_RPT_HISTORIAL( :ld_fecha1,
										  :ld_fecha2);

EXECUTE 	USP_MTO_RPT_HISTORIAL;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_MTO_RPT_HISTORIAL: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE USP_MTO_RPT_HISTORIAL;

COMMIT;

idw_1.Retrieve()

idw_1.Object.p_logo.filename  = gs_logo
idw_1.Object.t_usuario.text	= gs_user
idw_1.Object.t_empresa.text	= gs_empresa
idw_1.object.titulo_1.text = 'Desde ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha2, 'dd/mm/yyyy')

end event

type dw_report from w_report_smpl`dw_report within w_ma736_historial_equipo
integer x = 0
integer y = 356
integer width = 2807
integer height = 1268
string dataobject = "d_rpt_historial_equipo_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;sg_parametros sl_param
date ld_fecha1, ld_Fecha2
w_ma522_detalle_consulta lw_1

if lower(dwo.name) = 'costo_terceros' then
	ld_Fecha1 = uo_fecha.of_get_fecha1( )
	ld_Fecha2 = uo_fecha.of_get_fecha2( )
	
	
	// Asigna valores a structura 
	sl_param.dw1 = "d_rpt_os_costo_os_x_maq_tbl"	
	sl_param.tipo = '1S1D2D'
	sl_param.string1 = this.object.cod_maquina[row]
	sl_param.date1	  = ld_Fecha1
	sl_param.date2	  = ld_Fecha2
	sl_param.titulo1 = 'Maquina: ' + this.object.cod_maquina[row] + '-' + this.object.desc_maq[row]
	sl_param.titulo2 = 'Desde: ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta: ' + string(ld_fecha2, 'dd/mm/yyyy')
	
	openSheetWithParm(lw_1, sl_param, w_main, 0, Layered!)
	
elseif lower(dwo.name) = 'costo_material' then
	
	ld_Fecha1 = uo_fecha.of_get_fecha1( )
	ld_Fecha2 = uo_fecha.of_get_fecha2( )
	
	
	// Asigna valores a structura 
	sl_param.dw1 = "d_rpt_costo_material_x_maq"	
	sl_param.tipo = '1S1D2D'
	sl_param.string1 = this.object.cod_maquina[row]
	sl_param.date1	  = ld_Fecha1
	sl_param.date2	  = ld_Fecha2
	sl_param.titulo1 = 'Maquina: ' + this.object.cod_maquina[row] + '-' + this.object.desc_maq[row]
	sl_param.titulo2 = 'Desde: ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta: ' + string(ld_fecha2, 'dd/mm/yyyy')
	
	openSheetWithParm(lw_1, sl_param, w_main, 0, Layered!)
	
elseif lower(dwo.name) = 'costo_jornal' then
	
	ld_Fecha1 = uo_fecha.of_get_fecha1( )
	ld_Fecha2 = uo_fecha.of_get_fecha2( )
	
	
	// Asigna valores a structura 
	sl_param.dw1 = "d_rpt_costo_jornal_x_maq"	
	sl_param.tipo = '1S1D2D'
	sl_param.string1 = this.object.cod_maquina[row]
	sl_param.date1	  = ld_Fecha1
	sl_param.date2	  = ld_Fecha2
	sl_param.titulo1 = 'Maquina: ' + this.object.cod_maquina[row] + '-' + this.object.desc_maq[row]
	sl_param.titulo2 = 'Desde: ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta: ' + string(ld_fecha2, 'dd/mm/yyyy')
	
	openSheetWithParm(lw_1, sl_param, w_main, 0, Layered!)
	
end if
end event

type uo_fecha from u_ingreso_rango_fechas within w_ma736_historial_equipo
integer x = 5
integer y = 20
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 
of_set_rango_fin(date('31/12/9999')) 
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_ma736_historial_equipo
integer x = 1582
integer y = 36
integer width = 343
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;setpointer(HourGlass!)
Event ue_retrieve()
setpointer(Arrow!)
end event

type rb_1 from radiobutton within w_ma736_historial_equipo
integer x = 23
integer y = 224
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal
String ls_mensaje

Delete from tt_mtt_equipos;

insert into tt_mtt_equipos (cod_maquina) 
	SELECT cod_maquina
	FROM maquina
	WHERE flag_Estado <> '0';

if SQLCA.SQLcode = -1 then
	ls_mensaje = SQLCA.SQLerrtext
	ROLLBACK;
	MessageBox('Error', ls_mensaje)
	return
end if

Commit;
end event

type rb_2 from radiobutton within w_ma736_historial_equipo
integer x = 329
integer y = 224
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;sg_parametros sl_param

// Asigna valores a structura 
sl_param.dw1 = "d_list_equipos_grid"	
sl_param.tipo = ''	
sl_param.titulo = "Lista de Equipos"
sl_param.opcion = 2

OpenWithParm( w_abc_seleccion, sl_param)
end event

type rb_3 from radiobutton within w_ma736_historial_equipo
integer x = 754
integer y = 224
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal
String ls_mensaje

Delete from tt_mtt_ejecutor;

insert into tt_mtt_ejecutor (COD_EJECUTOR) 
	SELECT distinct COD_EJECUTOR
	FROM ejecutor;

if SQLCA.SQLcode = -1 then
	ls_mensaje = SQLCA.SQLerrtext
	ROLLBACK;
	MessageBox('Error', ls_mensaje)
	return
end if

Commit;
end event

type rb_4 from radiobutton within w_ma736_historial_equipo
integer x = 1047
integer y = 224
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;//d_lista_ot_adm_usuario_grd
sg_parametros sl_param

// Asigna valores a structura 
sl_param.dw1 = "d_lista_ejecutor_grd"	
sl_param.tipo = '1S'
sl_param.titulo = "Lista de Ejecutores"
sl_param.opcion = 5

OpenWithParm( w_abc_seleccion, sl_param)
end event

type gb_2 from groupbox within w_ma736_historial_equipo
integer y = 140
integer width = 736
integer height = 192
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Maquina"
end type

type gb_4 from groupbox within w_ma736_historial_equipo
integer x = 736
integer y = 140
integer width = 727
integer height = 192
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ejecutor"
end type

