$PBExportHeader$w_rh420_p_calcula_cts_semestral.srw
forward
global type w_rh420_p_calcula_cts_semestral from w_prc
end type
type sle_mes from singlelineedit within w_rh420_p_calcula_cts_semestral
end type
type sle_year from singlelineedit within w_rh420_p_calcula_cts_semestral
end type
type st_3 from statictext within w_rh420_p_calcula_cts_semestral
end type
type st_mensaje from statictext within w_rh420_p_calcula_cts_semestral
end type
type hpb_1 from hprogressbar within w_rh420_p_calcula_cts_semestral
end type
type dw_master from datawindow within w_rh420_p_calcula_cts_semestral
end type
type cb_1 from commandbutton within w_rh420_p_calcula_cts_semestral
end type
type em_origen from editmask within w_rh420_p_calcula_cts_semestral
end type
type em_descripcion from editmask within w_rh420_p_calcula_cts_semestral
end type
type cb_3 from commandbutton within w_rh420_p_calcula_cts_semestral
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh420_p_calcula_cts_semestral
end type
type gb_1 from groupbox within w_rh420_p_calcula_cts_semestral
end type
end forward

global type w_rh420_p_calcula_cts_semestral from w_prc
integer width = 3543
integer height = 1584
string title = "(RH420) Cálculo de Compensación Tiempo de Servicio Semestral"
boolean resizable = false
boolean center = true
event ue_procesar ( )
sle_mes sle_mes
sle_year sle_year
st_3 st_3
st_mensaje st_mensaje
hpb_1 hpb_1
dw_master dw_master
cb_1 cb_1
em_origen em_origen
em_descripcion em_descripcion
cb_3 cb_3
uo_1 uo_1
gb_1 gb_1
end type
global w_rh420_p_calcula_cts_semestral w_rh420_p_calcula_cts_semestral

type variables
n_cst_wait	invo_wait
end variables

event ue_procesar();
string 	ls_origen, ls_codtra, ls_mensaje, ls_tipo_trabaj
date   	ld_fec_proceso
Long 		ln_reg_act, ln_reg_tot
Integer	li_year, li_mes

try 
	invo_wait.of_mensaje('Cálculo de Provisiones y C.T.S. Semestral')

	if trim(sle_year.text) = '' then
		gnvo_app.of_mensaje_error("Debe seleccionar un ano para procesar")
		sle_year.setFocus()
		return
	end if
	
	if trim(sle_mes.text) = '' then
		gnvo_app.of_mensaje_error("Debe seleccionar un mes para procesar")
		sle_mes.setFocus()
		return
	end if
	
	li_year 	= Integer(sle_year.text)
	li_mes	= Integer(sle_mes.text)
	
	ls_origen = string(em_origen.text)
	ld_fec_proceso = date('15/' + trim(string(li_mes, '00')) + '/' +  trim(string(li_year, '0000')))
	
	ls_tipo_trabaj = uo_1.of_get_value()
	
	invo_wait.of_mensaje('Eliminaciones de CALCULOS Anteriores')
	
	
	//Elimino lo que este calculado
  	delete CTS_DECRETO_URGENCIA
    where tipo_trabajador 	like :ls_tipo_trabaj
      and fec_proceso    	= :ld_fec_proceso
		and cod_origen			= :ls_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = sqlca.sqlerrtext
		rollback ;
		gnvo_app.of_mensaje_error("Error al eliminar los registros de la tabla CTS_DECRETO_URGENCIA. Mensaje: " + ls_mensaje)
		return
	end if
	
	commit;
	
	invo_wait.of_mensaje('Procesando CALCULOS de CTS Semestral')
	
	//Obtengo el total de registros
	ln_reg_tot = dw_master.Retrieve(ls_origen, ls_tipo_trabaj) 
	
	//create or replace procedure usp_rh_cts_calculo_semestral (
	//  asi_codtra       in maestro.cod_trabajador%TYPE,
	//  adi_fec_proceso  in date
	//) is
	//
	DECLARE usp_rh_cts_calculo_semestral PROCEDURE FOR 
		usp_rh_cts_calculo_semestral( :ls_codtra, 
												:ld_fec_proceso) ;
	
	FOR ln_reg_act = 1 TO ln_reg_tot
		dw_master.ScrollToRow (ln_reg_act)
		dw_master.SelectRow (0, false)
		dw_master.SelectRow (ln_reg_act, true)
		
		ls_codtra = dw_master.object.cod_trabajador [ln_reg_act]
		
		EXECUTE usp_rh_cts_calculo_semestral ;
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = sqlca.sqlerrtext
			rollback ;
			gnvo_app.of_mensaje_error("Error en procedimiento USP_RH_CTS_CALCULO_SEMESTRAL. Mensaje: " + ls_mensaje)
			return
		end if
	
		hpb_1.position = ln_reg_act / ln_reg_tot * 100
		//st_3.Text = String(ln_reg_act / ln_reg_tot * 100, '##0.00') + '%'
		//st_3.x = r_2.x + r_2.width
	NEXT
	
	commit ;
	close usp_rh_cts_calculo_semestral ;
	
	
	invo_wait.of_mensaje('Generando documento por Pagar Directo de CTS')
	
	//Generando el documento de pago del CTS
	//	create or replace procedure usp_rh_gen_doc_pago_cts(
	//			 asi_tipo_trab    in maestro.tipo_trabajador%type ,
	//			 ani_year         in number                       ,
	//			 ani_mes          in number                       ,                       
	//			 asi_cod_usr      in usuario.cod_usr%type         
	//	) is
	
	DECLARE usp_rh_gen_doc_pago_cts PROCEDURE FOR 
		usp_rh_gen_doc_pago_cts( :ls_tipo_trabaj, 
										 :li_year,
										 :li_mes,
										 :gs_user) ;
	
	EXECUTE usp_rh_gen_doc_pago_cts ;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = sqlca.sqlerrtext
		rollback ;
		gnvo_app.of_mensaje_Error("Error en procedimiento usp_rh_gen_doc_pago_cts. Mensaje: " + ls_mensaje)
		return
	end if
	
	commit ;
	
	close usp_rh_gen_doc_pago_cts ;
	
	
	
	MessageBox('Information', 'Proceso de CTS ha concluído Satisfactoriamente', Information!)


catch ( Exception ex )
	
	gnvo_app.of_Catch_Exception(Ex, 'Error al procesar CTS')
	
finally
	invo_wait.of_close()
end try
	

end event

on w_rh420_p_calcula_cts_semestral.create
int iCurrent
call super::create
this.sle_mes=create sle_mes
this.sle_year=create sle_year
this.st_3=create st_3
this.st_mensaje=create st_mensaje
this.hpb_1=create hpb_1
this.dw_master=create dw_master
this.cb_1=create cb_1
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.cb_3=create cb_3
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_mes
this.Control[iCurrent+2]=this.sle_year
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_mensaje
this.Control[iCurrent+5]=this.hpb_1
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.em_descripcion
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.uo_1
this.Control[iCurrent+12]=this.gb_1
end on

on w_rh420_p_calcula_cts_semestral.destroy
call super::destroy
destroy(this.sle_mes)
destroy(this.sle_year)
destroy(this.st_3)
destroy(this.st_mensaje)
destroy(this.hpb_1)
destroy(this.dw_master)
destroy(this.cb_1)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.cb_3)
destroy(this.uo_1)
destroy(this.gb_1)
end on

event open;call super::open;date	ld_today

dw_master.settransobject(SQLCA)

ld_today = date(gnvo_app.of_fecha_Actual())

sle_year.text = string(ld_today, 'yyyy')
sle_mes.text = string(ld_today, 'mm')

invo_wait = create n_cst_Wait



end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

hpb_1.width  = newwidth  - hpb_1.x - 10
st_mensaje.width  = newwidth  - st_mensaje.x - 10
end event

event close;call super::close;destroy invo_Wait
end event

type sle_mes from singlelineedit within w_rh420_p_calcula_cts_semestral
integer x = 2743
integer y = 96
integer width = 137
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_year from singlelineedit within w_rh420_p_calcula_cts_semestral
integer x = 2519
integer y = 96
integer width = 210
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_rh420_p_calcula_cts_semestral
integer x = 2519
integer y = 4
integer width = 379
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Periodo"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_mensaje from statictext within w_rh420_p_calcula_cts_semestral
integer y = 228
integer width = 3488
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_rh420_p_calcula_cts_semestral
integer y = 288
integer width = 3488
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
end type

type dw_master from datawindow within w_rh420_p_calcula_cts_semestral
integer y = 376
integer width = 3351
integer height = 1096
string dataobject = "d_lista_trabaj_all_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh420_p_calcula_cts_semestral
integer x = 2921
integer width = 293
integer height = 180
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;parent.event dynamic ue_procesar()
end event

type em_origen from editmask within w_rh420_p_calcula_cts_semestral
integer x = 50
integer y = 80
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

type em_descripcion from editmask within w_rh420_p_calcula_cts_semestral
integer x = 352
integer y = 80
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

type cb_3 from commandbutton within w_rh420_p_calcula_cts_semestral
integer x = 233
integer y = 80
integer width = 87
integer height = 76
integer taborder = 10
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

type uo_1 from u_ddlb_tipo_trabajador within w_rh420_p_calcula_cts_semestral
integer x = 1573
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh420_p_calcula_cts_semestral
integer y = 8
integer width = 1550
integer height = 192
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

