$PBExportHeader$w_rh410_p_adelanto_quincena.srw
forward
global type w_rh410_p_adelanto_quincena from w_prc
end type
type sle_mes from singlelineedit within w_rh410_p_adelanto_quincena
end type
type sle_year from singlelineedit within w_rh410_p_adelanto_quincena
end type
type st_3 from statictext within w_rh410_p_adelanto_quincena
end type
type hpb_progreso from hprogressbar within w_rh410_p_adelanto_quincena
end type
type em_descripcion from editmask within w_rh410_p_adelanto_quincena
end type
type cb_origen from commandbutton within w_rh410_p_adelanto_quincena
end type
type em_origen from editmask within w_rh410_p_adelanto_quincena
end type
type st_2 from statictext within w_rh410_p_adelanto_quincena
end type
type st_4 from statictext within w_rh410_p_adelanto_quincena
end type
type em_ttrab from editmask within w_rh410_p_adelanto_quincena
end type
type cb_ttrab from commandbutton within w_rh410_p_adelanto_quincena
end type
type em_desc_ttrab from editmask within w_rh410_p_adelanto_quincena
end type
type dw_1 from datawindow within w_rh410_p_adelanto_quincena
end type
type cb_1 from commandbutton within w_rh410_p_adelanto_quincena
end type
type gb_1 from groupbox within w_rh410_p_adelanto_quincena
end type
end forward

global type w_rh410_p_adelanto_quincena from w_prc
integer width = 2729
integer height = 1672
string title = "(RH410) Calcula Adelanto de Quincena"
boolean center = true
sle_mes sle_mes
sle_year sle_year
st_3 st_3
hpb_progreso hpb_progreso
em_descripcion em_descripcion
cb_origen cb_origen
em_origen em_origen
st_2 st_2
st_4 st_4
em_ttrab em_ttrab
cb_ttrab cb_ttrab
em_desc_ttrab em_desc_ttrab
dw_1 dw_1
cb_1 cb_1
gb_1 gb_1
end type
global w_rh410_p_adelanto_quincena w_rh410_p_adelanto_quincena

type variables
n_cst_wait	invo_wait
end variables

forward prototypes
public subroutine of_set_fec_proceso ()
end prototypes

public subroutine of_set_fec_proceso ();string 	ls_origen, ls_tipo_trabaj
Integer	li_mes, li_count
date		ld_fec_proceso

ls_origen = trim(em_origen.text)
ls_tipo_trabaj = trim(em_ttrab.text)

li_mes = month(date(gnvo_app.of_fecha_actual()))

select count(*)
	into :li_count
from adelanto_quincena 	aq,
	  maestro				m
where aq.cod_trabajador = m.cod_trabajador
  and to_number(to_char(aq.fec_proceso, 'mm')) = :li_mes
  and m.tipo_trabajador = :ls_tipo_trabaj;

if li_count > 0 then
	
	if MessageBox('Aviso', 'Existe un calculo de adelanto de quincena correspondiente al mes ' + string(li_mes, '00') &
								+ '. ¿Desea tomar la fecha de calculo para un reproceso?', Information!, YesNo!, 2) = 1 then
		select aq.fec_proceso
			into :ld_fec_proceso
		from adelanto_quincena 	aq,
			  maestro				m
		where aq.cod_trabajador = m.cod_trabajador
		  and to_number(to_char(aq.fec_proceso, 'mm')) = :li_mes
		  and m.tipo_trabajador = :ls_tipo_trabaj;
	else
		ld_fec_proceso = date(gnvo_app.of_fecha_actual())
	end if
else
	ld_fec_proceso = date(gnvo_app.of_fecha_actual())
end if

//em_fecha.text = string(ld_fec_proceso, 'dd/mm/yyyy')



end subroutine

on w_rh410_p_adelanto_quincena.create
int iCurrent
call super::create
this.sle_mes=create sle_mes
this.sle_year=create sle_year
this.st_3=create st_3
this.hpb_progreso=create hpb_progreso
this.em_descripcion=create em_descripcion
this.cb_origen=create cb_origen
this.em_origen=create em_origen
this.st_2=create st_2
this.st_4=create st_4
this.em_ttrab=create em_ttrab
this.cb_ttrab=create cb_ttrab
this.em_desc_ttrab=create em_desc_ttrab
this.dw_1=create dw_1
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_mes
this.Control[iCurrent+2]=this.sle_year
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.hpb_progreso
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.cb_origen
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.em_ttrab
this.Control[iCurrent+11]=this.cb_ttrab
this.Control[iCurrent+12]=this.em_desc_ttrab
this.Control[iCurrent+13]=this.dw_1
this.Control[iCurrent+14]=this.cb_1
this.Control[iCurrent+15]=this.gb_1
end on

on w_rh410_p_adelanto_quincena.destroy
call super::destroy
destroy(this.sle_mes)
destroy(this.sle_year)
destroy(this.st_3)
destroy(this.hpb_progreso)
destroy(this.em_descripcion)
destroy(this.cb_origen)
destroy(this.em_origen)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.em_ttrab)
destroy(this.cb_ttrab)
destroy(this.em_desc_ttrab)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;call super::open;
Date	ld_hoy

invo_wait = create n_cst_wait

ld_hoy = Date(gnvo_app.of_fecha_actual())

sle_year.text = string(ld_hoy, 'yyyy')
sle_mes.text = string(ld_hoy, 'mm')

dw_1.settransobject(SQLCA)

gnvo_app.empresa.of_load_origen(gs_origen)
em_origen.text = gs_origen
em_descripcion.text = gnvo_app.empresa.is_nom_origen
end event

event close;call super::close;destroy invo_wait
end event

type sle_mes from singlelineedit within w_rh410_p_adelanto_quincena
integer x = 2181
integer y = 108
integer width = 155
integer height = 76
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
end type

type sle_year from singlelineedit within w_rh410_p_adelanto_quincena
integer x = 1934
integer y = 108
integer width = 229
integer height = 76
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
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_rh410_p_adelanto_quincena
integer x = 1673
integer y = 108
integer width = 251
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_progreso from hprogressbar within w_rh410_p_adelanto_quincena
integer y = 368
integer width = 2665
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
end type

type em_descripcion from editmask within w_rh410_p_adelanto_quincena
integer x = 663
integer y = 108
integer width = 983
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_origen from commandbutton within w_rh410_p_adelanto_quincena
integer x = 576
integer y = 108
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

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
		  + "nombre AS nombre_origen " &
		  + "FROM origen " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_origen.text 		= ls_codigo
	em_descripcion.text 	= ls_data
	
	of_set_fec_proceso()
	
end if

end event

type em_origen from editmask within w_rh410_p_adelanto_quincena
integer x = 389
integer y = 108
integer width = 183
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_null, ls_texto
SetNull(ls_null)

ls_texto = this.text

select nombre
	into :ls_data
from origen
where cod_origen = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('RRHH', "CODIGO DE ORIGEN NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text = ls_null
	em_descripcion.text = ls_null
end if

em_descripcion.text = ls_data


end event

type st_2 from statictext within w_rh410_p_adelanto_quincena
integer x = 64
integer y = 120
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_rh410_p_adelanto_quincena
integer x = 64
integer y = 220
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ttrab from editmask within w_rh410_p_adelanto_quincena
integer x = 389
integer y = 212
integer width = 183
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_null, ls_texto
SetNull(ls_null)

ls_texto = this.text

select desc_tipo_tra
	into :ls_data
from tipo_trabajador
where tipo_trabajador = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('RRHH', "TIPO DE TRABAJADOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text = ls_null
	em_desc_ttrab.text = ls_null
end if

em_desc_ttrab.text = ls_data

end event

type cb_ttrab from commandbutton within w_rh410_p_adelanto_quincena
integer x = 576
integer y = 212
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

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT TIPO_TRABAJADOR AS CODIGO_origen, " &
		  + "DESC_TIPO_TRA AS descripcion_tipo " &
		  + "FROM tipo_trabajador " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_ttrab.text = ls_codigo
	em_desc_ttrab.text = ls_data
	
	of_set_fec_proceso()
	
end if
end event

type em_desc_ttrab from editmask within w_rh410_p_adelanto_quincena
integer x = 663
integer y = 212
integer width = 983
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type dw_1 from datawindow within w_rh410_p_adelanto_quincena
integer y = 448
integer width = 2670
integer height = 1096
string dataobject = "d_lista_adelanto_quincena_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh410_p_adelanto_quincena
integer x = 1902
integer y = 200
integer width = 370
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String 	ls_origen, ls_codtra, ls_tipo_trabaj, ls_mensaje
date   	ld_fec_proceso
Long 		ln_reg_act, ln_reg_tot
Integer 	li_year, li_mes

try 
	invo_wait.of_mensaje('Procesando Adelanto de Quincena')
	
	ls_origen      = string(em_origen.text)
	li_year			= Integer(sle_year.text)
	li_mes			= Integer(sle_mes.text)


	ld_fec_proceso = date('15/' + string(li_mes, '00') + '/' + string(li_year, '0000'))
	
	ls_tipo_trabaj = trim(em_ttrab.text)
	dw_1.dataobject = 'd_lista_adelanto_quincena_tbl'
	dw_1.settransobject(sqlca)
	ln_reg_tot = dw_1.Retrieve(ls_origen, ls_tipo_trabaj, ld_fec_proceso) 
	
		
	// Elimino El documento de Pago de quincena
	//create or replace procedure usp_rh_del_doc_quincena(
	//       asi_ttrab       in maestro.tipo_trabajador%type,
	//       asi_origen      in maestro.cod_origen%type     ,
	//       adi_fec_proceso in date                        
	//) is
	DECLARE usp_rh_del_doc_quincena PROCEDURE FOR 
		usp_rh_del_doc_quincena(:ls_tipo_trabaj,
										:ls_origen,
										:ld_fec_proceso) ;
	EXECUTE usp_rh_del_doc_quincena ;
	
	//busco errores
	if sqlca.sqlcode = -1 then
		ls_mensaje = sqlca.sqlerrtext
	  
		Rollback ;
		Messagebox('Error usp_rh_del_doc_quincena',ls_mensaje)
		Return
	end if
	
	CLOSE usp_rh_del_doc_quincena ;
	
	// Elimino la quincena generada
	delete from adelanto_quincena t
		 where t.cod_trabajador in ( select cod_trabajador from maestro
											 where tipo_trabajador = :ls_tipo_trabaj 
												and cod_origen = :ls_origen ) 
			and trunc(t.fec_proceso) = :ld_fec_proceso;
	
	//busco errores
	if sqlca.sqlcode = -1 then
		ls_mensaje = sqlca.sqlerrtext
	  
		Rollback ;
		Messagebox('Error al eliminar tabla adelanto_quincena',ls_mensaje)
		Return
	end if
	
	// Calculo la quincena
	
	DECLARE USP_RH_ADEL_QUINCENA PROCEDURE FOR 
		USP_RH_ADEL_QUINCENA( :ls_codtra, 
									 :ld_fec_proceso ) ;
	
	hpb_progreso.MaxPosition = dw_1.RowCount()
	hpb_progreso.Position = 0
	
	FOR ln_reg_act = 1 TO ln_reg_tot
		yield()
		dw_1.ScrollToRow (ln_reg_act)
		dw_1.SelectRow (0, false)
		dw_1.SelectRow (ln_reg_act, true)
		
		hpb_progreso.Position = ln_reg_act
		
		ls_codtra = dw_1.GetItemString (ln_reg_act, "cod_trabajador")
		
		EXECUTE USP_RH_ADEL_QUINCENA ;
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = sqlca.sqlerrtext
			rollback ;
			Parent.SetMicroHelp('Proceso no se realizó con Exito')
			MessageBox("Error USP_RH_ADEL_QUINCENA", ls_mensaje, StopSign!)
			return
		end if
	NEXT
	
	commit;
	
	//ejecuto procesos de generacion de documentos de pago
	/*
	create or replace procedure usp_rh_gen_doc_pago_quin(
			 asi_tipo_trab    in maestro.tipo_trabajador%type ,
			 asi_origen       in origen.cod_origen%Type       ,
			 adi_fec_proceso  in date                         ,
			 asi_cod_usr      in usuario.cod_usr%type         
	) is
	*/
	DECLARE usp_rh_gen_doc_pago_quin PROCEDURE FOR 
		usp_rh_gen_doc_pago_quin(	:ls_tipo_trabaj,
											:ls_origen,
											:ld_fec_proceso,
											:gs_user) ;
	EXECUTE usp_rh_gen_doc_pago_quin ;
	
	//busco errores
	if sqlca.sqlcode = -1 then
		ls_mensaje = sqlca.sqlerrtext
	  
		Rollback ;
		Messagebox('Error', 'Error al ejecutar procedure usp_rh_gen_doc_pago_quin. Mensaje: ' + ls_mensaje, Exclamation!)
		Return
	end if
	commit ;
	
	CLOSE usp_rh_gen_doc_pago_quin ;
	
	
	Parent.SetMicroHelp('Proceso ha concluído Satisfactoriamente')
	MessageBox('RRHH', 'Proceso de quincena realizado satisfactoriamente')



catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al procesar la quincena')
	
finally
	invo_wait.of_close()
end try


end event

type gb_1 from groupbox within w_rh410_p_adelanto_quincena
integer width = 2670
integer height = 364
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Ingrese Datos"
end type

