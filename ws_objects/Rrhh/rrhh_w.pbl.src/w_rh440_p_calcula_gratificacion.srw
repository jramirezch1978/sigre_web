$PBExportHeader$w_rh440_p_calcula_gratificacion.srw
forward
global type w_rh440_p_calcula_gratificacion from w_prc
end type
type em_year from editmask within w_rh440_p_calcula_gratificacion
end type
type ddlb_mes from dropdownlistbox within w_rh440_p_calcula_gratificacion
end type
type st_3 from statictext within w_rh440_p_calcula_gratificacion
end type
type st_avance from statictext within w_rh440_p_calcula_gratificacion
end type
type hpb_progreso from hprogressbar within w_rh440_p_calcula_gratificacion
end type
type cbx_montos from checkbox within w_rh440_p_calcula_gratificacion
end type
type dw_1 from datawindow within w_rh440_p_calcula_gratificacion
end type
type cb_1 from commandbutton within w_rh440_p_calcula_gratificacion
end type
type cb_2 from commandbutton within w_rh440_p_calcula_gratificacion
end type
type em_origen from editmask within w_rh440_p_calcula_gratificacion
end type
type em_descripcion from editmask within w_rh440_p_calcula_gratificacion
end type
type rb_1 from radiobutton within w_rh440_p_calcula_gratificacion
end type
type rb_2 from radiobutton within w_rh440_p_calcula_gratificacion
end type
type st_4 from statictext within w_rh440_p_calcula_gratificacion
end type
type em_porcentaje from editmask within w_rh440_p_calcula_gratificacion
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh440_p_calcula_gratificacion
end type
type gb_1 from groupbox within w_rh440_p_calcula_gratificacion
end type
end forward

global type w_rh440_p_calcula_gratificacion from w_prc
integer width = 2615
integer height = 2112
string title = "(RH440) Proceso de Cálculo de Gratificaciones"
boolean resizable = false
boolean center = true
em_year em_year
ddlb_mes ddlb_mes
st_3 st_3
st_avance st_avance
hpb_progreso hpb_progreso
cbx_montos cbx_montos
dw_1 dw_1
cb_1 cb_1
cb_2 cb_2
em_origen em_origen
em_descripcion em_descripcion
rb_1 rb_1
rb_2 rb_2
st_4 st_4
em_porcentaje em_porcentaje
uo_1 uo_1
gb_1 gb_1
end type
global w_rh440_p_calcula_gratificacion w_rh440_p_calcula_gratificacion

type variables
n_cst_wait	invo_Wait
end variables

on w_rh440_p_calcula_gratificacion.create
int iCurrent
call super::create
this.em_year=create em_year
this.ddlb_mes=create ddlb_mes
this.st_3=create st_3
this.st_avance=create st_avance
this.hpb_progreso=create hpb_progreso
this.cbx_montos=create cbx_montos
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_4=create st_4
this.em_porcentaje=create em_porcentaje
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_year
this.Control[iCurrent+2]=this.ddlb_mes
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_avance
this.Control[iCurrent+5]=this.hpb_progreso
this.Control[iCurrent+6]=this.cbx_montos
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.em_origen
this.Control[iCurrent+11]=this.em_descripcion
this.Control[iCurrent+12]=this.rb_1
this.Control[iCurrent+13]=this.rb_2
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.em_porcentaje
this.Control[iCurrent+16]=this.uo_1
this.Control[iCurrent+17]=this.gb_1
end on

on w_rh440_p_calcula_gratificacion.destroy
call super::destroy
destroy(this.em_year)
destroy(this.ddlb_mes)
destroy(this.st_3)
destroy(this.st_avance)
destroy(this.hpb_progreso)
destroy(this.cbx_montos)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_4)
destroy(this.em_porcentaje)
destroy(this.uo_1)
destroy(this.gb_1)
end on

event open;call super::open;//Override
Date 	ld_hoy

dw_1.settransobject(SQLCA)

ld_hoy = Date(gnvo_app.of_fecha_actual())

em_year.text = string(ld_hoy, 'yyyy')
ddlb_mes.SelectItem(1)
end event

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10

hpb_progreso.width  = newwidth  - hpb_progreso.x - 10

end event

type em_year from editmask within w_rh440_p_calcula_gratificacion
integer x = 1545
integer y = 300
integer width = 261
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
double increment = 1
string minmax = "0~~9999"
end type

type ddlb_mes from dropdownlistbox within w_rh440_p_calcula_gratificacion
integer x = 965
integer y = 300
integer width = 567
integer height = 352
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string item[] = {"07. Julio","12. Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_rh440_p_calcula_gratificacion
integer x = 951
integer y = 208
integer width = 855
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "PERIODO"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_avance from statictext within w_rh440_p_calcula_gratificacion
integer x = 2025
integer y = 408
integer width = 485
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_progreso from hprogressbar within w_rh440_p_calcula_gratificacion
integer y = 480
integer width = 2464
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type cbx_montos from checkbox within w_rh440_p_calcula_gratificacion
integer x = 37
integer y = 396
integer width = 923
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "No Generar Monto de Adelantos"
end type

type dw_1 from datawindow within w_rh440_p_calcula_gratificacion
integer y = 560
integer width = 2533
integer height = 832
string dataobject = "d_lista_calculo_gratificacion_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh440_p_calcula_gratificacion
integer x = 2281
integer y = 192
integer width = 293
integer height = 200
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;

String  ls_origen, ls_codtra, ls_mensaje, ls_tipo_calculo, ls_tipo_trabaj, &
		  ls_flag_monto, ls_year
date    ld_fec_proceso
double  ln_porcentaje
Long    ll_i



try 
	invo_wait = create n_cst_wait
	if trim(em_year.text) = '' then
		MessageBox('Error', 'Debe indicar el año de la gratificacion para el proceso', StopSign!)
		em_year.setFocus()
		return
	end if

	invo_wait.of_mensaje('Procesando Cálculo de Gratificaciones')

	ls_origen 		= string(em_origen.text)
	ln_porcentaje 	= double(em_porcentaje.text)
	ls_year 			= em_year.text
	
	if left(ddlb_mes.text, 2) = '07' then
		ld_fec_proceso = date('15/07/' + ls_year)
	else
		ld_fec_proceso = date('15/12/' + ls_year)
	end if
	
	if rb_1.checked = true then
		ls_tipo_calculo = '1'
	elseif rb_2.checked = true then
		ls_tipo_calculo = '2'
	end if
	
	ls_tipo_trabaj = uo_1.of_get_value()
	
	dw_1.Retrieve(ls_origen, ls_tipo_trabaj) 
	
	
	//Elimino lo calculo
	invo_wait.of_mensaje('Eliminando detalle de gratificacion')
	
	delete from gratificacion_det g
	 where g.cod_trabajador in (select m.cod_trabajador 
											from maestro m
										  where m.tipo_trabajador like :ls_tipo_trabaj 
											 and m.cod_origen      = :ls_origen	)
		and trunc(g.fec_proceso) = trunc(:ld_fec_proceso);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al eliminar datos en tabla GRATIFICACION_DET. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
	//if gnvo_app.of_existsError(SQLCA, "Error al eliminar en tabla GRATIFICACION_DET") then
	//	rollback ;
	//	return
	//end if
		
		
	invo_wait.of_mensaje('Eliminando CABECERA de gratificacion')
	delete from gratificacion g
	 where g.cod_trabajador     in (select m.cod_trabajador 
												 from maestro m
												where m.tipo_trabajador like :ls_tipo_trabaj 
												  and m.cod_origen      = :ls_origen		    ) 
		and trunc(g.fec_proceso) = trunc(:ld_fec_proceso);
	
	if gnvo_app.of_existsError(SQLCA, "Error al eliminar en tabla GRATIFICACION") then
		rollback ;
		return
	end if
	
	//genera monto adelanto
	if cbx_montos.checked then
		ls_flag_monto = '1' // no genera monto de adelanto
	else
		ls_flag_monto = '0' // genera monto de adelanto
	end if 	
	
	
	invo_wait.of_mensaje('Procesando nueva GRATIFICACION')
	//create or replace procedure usp_rh_calcula_gratificacion (
	//    as_codtra       in maestro.cod_trabajador%TYPE   ,
	//    ad_fec_proceso  in date   ,
	//    an_porcentaje   in number ,
	//    ac_flag_monto   in VARCHAR2
	//) is
	//  Genera proceso para el cálculo de gratificaciones
	DECLARE USP_RH_CALCULA_GRATIFICACION PROCEDURE FOR 
		USP_RH_CALCULA_GRATIFICACION( :ls_codtra, 
												:ld_fec_proceso, 
												:ln_porcentaje, 
												:ls_flag_monto) ;
	
	
	FOR ll_i = 1 TO dw_1.RowCount()
		dw_1.ScrollToRow (ll_i)
		dw_1.SelectRow (0, false)
		dw_1.SelectRow (ll_i, true)
		
		ls_codtra = dw_1.object.cod_trabajador [ll_i]
		EXECUTE USP_RH_CALCULA_GRATIFICACION ;
		
		if gnvo_app.of_existsError(SQLCA, "Proceso de cálculo de Gratificacion USP_RH_CALCULA_GRATIFICACION") then
			rollback ;
			return
		end if
		
		st_avance.Text = String(ll_i / dw_1.RowCount() * 100, '##0.00') + '%'
		
		hpb_progreso.Position = ll_i / dw_1.RowCount() * 100
		
		yield()
	NEXT
	
	commit ;
	CLOSE USP_RH_CALCULA_GRATIFICACION;
	
	invo_wait.of_mensaje('Generando documento de pago de GRATIFICACION')
	//GEnero el documento de pago de la grati
	//create or replace procedure usp_rh_gen_doc_pago_grati(
	//       asi_tipo_trab       in maestro.tipo_trabajador%type ,
	//       asi_origen          in origen.cod_origen%Type       ,
	//       adi_fec_proceso     in date                         ,
	//       asi_cod_usr         in usuario.cod_usr%type
	//) is
	
	DECLARE usp_rh_gen_doc_pago_grati PROCEDURE FOR 
		usp_rh_gen_doc_pago_grati( :ls_tipo_trabaj, 
											:ls_origen,
											:ld_fec_proceso, 
											:gs_user);
	
	EXECUTE usp_rh_gen_doc_pago_grati ;
	if gnvo_app.of_existsError(SQLCA, "Proceso de cálculo de Gratificacion usp_rh_gen_doc_pago_grati") then
		rollback ;
		return
	end if
	
	close usp_rh_gen_doc_pago_grati;
	commit ;
	
	MessageBox("Aviso", 'Proceso ha concluído Satisfactoriamente')


catch ( exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al procesar gratificacion')
	
finally
	invo_wait.of_close()
	destroy invo_wait
end try

end event

type cb_2 from commandbutton within w_rh440_p_calcula_gratificacion
integer x = 1189
integer y = 76
integer width = 87
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_origen from editmask within w_rh440_p_calcula_gratificacion
integer x = 1006
integer y = 76
integer width = 151
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_descripcion from editmask within w_rh440_p_calcula_gratificacion
integer x = 1312
integer y = 76
integer width = 1143
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type rb_1 from radiobutton within w_rh440_p_calcula_gratificacion
integer x = 46
integer y = 28
integer width = 649
integer height = 56
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Adelanto de Gratificación"
end type

type rb_2 from radiobutton within w_rh440_p_calcula_gratificacion
integer x = 46
integer y = 92
integer width = 649
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cálculo de Fin de Mes"
end type

type st_4 from statictext within w_rh440_p_calcula_gratificacion
integer x = 1801
integer y = 208
integer width = 430
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "% de Adelanto"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_porcentaje from editmask within w_rh440_p_calcula_gratificacion
integer x = 1801
integer y = 300
integer width = 430
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "100"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "###.00"
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh440_p_calcula_gratificacion
integer x = 32
integer y = 172
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh440_p_calcula_gratificacion
integer x = 946
integer y = 8
integer width = 1568
integer height = 168
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

