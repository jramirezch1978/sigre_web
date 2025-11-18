$PBExportHeader$w_rh900_asiento_planilla.srw
forward
global type w_rh900_asiento_planilla from w_prc
end type
type st_3 from statictext within w_rh900_asiento_planilla
end type
type sle_year from singlelineedit within w_rh900_asiento_planilla
end type
type sle_mes from singlelineedit within w_rh900_asiento_planilla
end type
type st_2 from statictext within w_rh900_asiento_planilla
end type
type st_1 from statictext within w_rh900_asiento_planilla
end type
type cbx_veda from checkbox within w_rh900_asiento_planilla
end type
type cb_1 from commandbutton within w_rh900_asiento_planilla
end type
type em_descripcion from editmask within w_rh900_asiento_planilla
end type
type em_origen from editmask within w_rh900_asiento_planilla
end type
type em_tipo from editmask within w_rh900_asiento_planilla
end type
type cb_2 from commandbutton within w_rh900_asiento_planilla
end type
type cb_3 from commandbutton within w_rh900_asiento_planilla
end type
type em_desc_tipo from editmask within w_rh900_asiento_planilla
end type
type gb_1 from groupbox within w_rh900_asiento_planilla
end type
end forward

global type w_rh900_asiento_planilla from w_prc
integer width = 1893
integer height = 696
string title = "(RH900) Asientos por Pagos de Remuenraciones CONSOLIDADO"
boolean maxbox = false
boolean center = true
st_3 st_3
sle_year sle_year
sle_mes sle_mes
st_2 st_2
st_1 st_1
cbx_veda cbx_veda
cb_1 cb_1
em_descripcion em_descripcion
em_origen em_origen
em_tipo em_tipo
cb_2 cb_2
cb_3 cb_3
em_desc_tipo em_desc_tipo
gb_1 gb_1
end type
global w_rh900_asiento_planilla w_rh900_asiento_planilla

on w_rh900_asiento_planilla.create
int iCurrent
call super::create
this.st_3=create st_3
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.st_2=create st_2
this.st_1=create st_1
this.cbx_veda=create cbx_veda
this.cb_1=create cb_1
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.cb_3=create cb_3
this.em_desc_tipo=create em_desc_tipo
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.sle_year
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cbx_veda
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.em_descripcion
this.Control[iCurrent+9]=this.em_origen
this.Control[iCurrent+10]=this.em_tipo
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cb_3
this.Control[iCurrent+13]=this.em_desc_tipo
this.Control[iCurrent+14]=this.gb_1
end on

on w_rh900_asiento_planilla.destroy
call super::destroy
destroy(this.st_3)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cbx_veda)
destroy(this.cb_1)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.em_desc_tipo)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;sle_year.text = string(gnvo_app.of_Fecha_actual(), 'yyyy')
sle_mes.text = string(gnvo_app.of_Fecha_actual(), 'mm')
end event

type st_3 from statictext within w_rh900_asiento_planilla
integer x = 37
integer y = 428
integer width = 251
integer height = 72
integer textsize = -8
integer weight = 700
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

type sle_year from singlelineedit within w_rh900_asiento_planilla
integer x = 297
integer y = 424
integer width = 210
integer height = 76
integer taborder = 50
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

type sle_mes from singlelineedit within w_rh900_asiento_planilla
integer x = 512
integer y = 424
integer width = 137
integer height = 76
integer taborder = 60
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

type st_2 from statictext within w_rh900_asiento_planilla
integer x = 37
integer y = 320
integer width = 251
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "T.Trab. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh900_asiento_planilla
integer x = 37
integer y = 208
integer width = 251
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_veda from checkbox within w_rh900_asiento_planilla
integer x = 59
integer y = 96
integer width = 695
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Temporada de Veda"
end type

type cb_1 from commandbutton within w_rh900_asiento_planilla
integer x = 1426
integer y = 72
integer width = 320
integer height = 92
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String 	ls_origen, ls_tipo, ls_mensaje,ls_veda
Long	 	ll_count
Integer	li_year, li_mes

Parent.SetMicroHelp('Procesando Asientos Contables por Pagos de Remuneraciones')

SetPointer(HourGlass!)

ls_origen	= String (em_origen.text)
ls_tipo     = String (em_tipo.text)
li_year		= Integer(sle_year.text)
li_mes		= Integer(sle_mes.text)

If Isnull(ls_origen) or ls_origen = '' Then
	Messagebox('Aviso','Debe Ingresar Algun Origen ,Verifique!')
	SetPointer(Arrow!)
	Return
else
   select count(*) into :ll_count from origen
	 where (cod_origen  = :ls_origen ) and
	 		 (flag_estado = '1'        ) ;
			  
   if ll_count = 0 then
		Messagebox('Aviso','Origen No Existe ,Verifique!')
		SetPointer(Arrow!)		
		Return
	end if
end if 

If Isnull(ls_tipo) or ls_tipo = '' Then
	Messagebox('Aviso','Debe Ingresar Algun Tipo de Trabajador ,Verifique!')
	SetPointer(Arrow!)
	Return
else
	select count(*) into :ll_count from tipo_trabajador 
	 where (tipo_trabajador = :ls_tipo ) and
	 		 (flag_estado		= '1'      ) ;
			  
   if ll_count = 0 then
		Messagebox('Aviso','Tipo de Trabajador No Existe ,Verifique!')
		SetPointer(Arrow!)
		Return
	end if
end if 




if cbx_veda.checked then //temporada de veda escogera otras cuentas
	ls_veda = '1'
else
	ls_veda = '0'
end if	

delete tt_rh_inc_asientos;
commit;

//create or replace procedure usp_rh_asiento_remuneraciones(
//       asi_ttrab       in maestro.tipo_trabajador%TYPE ,
//       asi_origen      in origen.cod_origen%TYPE,
//       asi_usuario     in usuario.cod_usr%TYPE         ,
//       li_year         in number,
//       li_mes          in number,
//       asi_veda        in varchar2
//) is

DECLARE usp_rh_asiento_remuneraciones PROCEDURE FOR 
	usp_rh_asiento_remuneraciones( :ls_tipo, 
											 :ls_origen, 
											 :gs_user, 
											 :li_year ,
											 :li_mes,
											 :ls_veda) ;
EXECUTE usp_rh_asiento_remuneraciones ;

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback;
  MessageBox("SQL error", "Error al ejecutar el procedimiento usp_rh_asiento_remuneraciones. Mensaje: " + ls_mensaje, StopSign!)
  return
end if

COMMIT;

CLOSE usp_rh_asiento_remuneraciones;

SetPointer(Arrow!)

select Count(*) into :ll_count from tt_rh_inc_asientos ;

if ll_count > 0 then
	OpenSheet(w_rh623_rpt_validacion_contable,parent, 2, Layered!)	
else
	MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)	
end if









end event

type em_descripcion from editmask within w_rh900_asiento_planilla
integer x = 590
integer y = 208
integer width = 1143
integer height = 80
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

type em_origen from editmask within w_rh900_asiento_planilla
integer x = 297
integer y = 208
integer width = 210
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh900_asiento_planilla
integer x = 297
integer y = 320
integer width = 210
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh900_asiento_planilla
integer x = 503
integer y = 208
integer width = 87
integer height = 80
integer taborder = 20
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

type cb_3 from commandbutton within w_rh900_asiento_planilla
integer x = 503
integer y = 320
integer width = 87
integer height = 80
integer taborder = 50
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

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_tiptra, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_tipo.text      = sl_param.field_ret[1]
	em_desc_tipo.text = sl_param.field_ret[2]
END IF

end event

type em_desc_tipo from editmask within w_rh900_asiento_planilla
integer x = 590
integer y = 320
integer width = 1143
integer height = 80
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

type gb_1 from groupbox within w_rh900_asiento_planilla
integer x = 18
integer y = 4
integer width = 1824
integer height = 564
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Ingrese Datos "
end type

