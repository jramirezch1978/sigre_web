$PBExportHeader$w_rh907_transferencia_gratificaciones.srw
forward
global type w_rh907_transferencia_gratificaciones from w_prc
end type
type st_2 from statictext within w_rh907_transferencia_gratificaciones
end type
type st_1 from statictext within w_rh907_transferencia_gratificaciones
end type
type cb_1 from commandbutton within w_rh907_transferencia_gratificaciones
end type
type em_descripcion from editmask within w_rh907_transferencia_gratificaciones
end type
type em_origen from editmask within w_rh907_transferencia_gratificaciones
end type
type em_tipo from editmask within w_rh907_transferencia_gratificaciones
end type
type em_fecha from editmask within w_rh907_transferencia_gratificaciones
end type
type st_3 from statictext within w_rh907_transferencia_gratificaciones
end type
type cb_2 from commandbutton within w_rh907_transferencia_gratificaciones
end type
type cb_3 from commandbutton within w_rh907_transferencia_gratificaciones
end type
type em_desc_tipo from editmask within w_rh907_transferencia_gratificaciones
end type
type gb_1 from groupbox within w_rh907_transferencia_gratificaciones
end type
end forward

global type w_rh907_transferencia_gratificaciones from w_prc
integer width = 1929
integer height = 724
string title = "(RH907) Transferencia de Gratificaciones"
st_2 st_2
st_1 st_1
cb_1 cb_1
em_descripcion em_descripcion
em_origen em_origen
em_tipo em_tipo
em_fecha em_fecha
st_3 st_3
cb_2 cb_2
cb_3 cb_3
em_desc_tipo em_desc_tipo
gb_1 gb_1
end type
global w_rh907_transferencia_gratificaciones w_rh907_transferencia_gratificaciones

on w_rh907_transferencia_gratificaciones.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.cb_1=create cb_1
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_tipo=create em_tipo
this.em_fecha=create em_fecha
this.st_3=create st_3
this.cb_2=create cb_2
this.cb_3=create cb_3
this.em_desc_tipo=create em_desc_tipo
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.em_descripcion
this.Control[iCurrent+5]=this.em_origen
this.Control[iCurrent+6]=this.em_tipo
this.Control[iCurrent+7]=this.em_fecha
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.em_desc_tipo
this.Control[iCurrent+12]=this.gb_1
end on

on w_rh907_transferencia_gratificaciones.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_tipo)
destroy(this.em_fecha)
destroy(this.st_3)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.em_desc_tipo)
destroy(this.gb_1)
end on

event open;call super::open;
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type st_2 from statictext within w_rh907_transferencia_gratificaciones
integer x = 27
integer y = 320
integer width = 238
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

type st_1 from statictext within w_rh907_transferencia_gratificaciones
integer x = 27
integer y = 208
integer width = 238
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

type cb_1 from commandbutton within w_rh907_transferencia_gratificaciones
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

event clicked;String ls_origen, ls_tipo, ls_mensaje,ls_veda,ls_tipo_trip
Long	 ll_count
Date ld_fec_proceso


Parent.SetMicroHelp('Procesando Transferencia de Gratificaciones')
SetPointer(HourGlass!)


//recupero datos de parametros
select tipo_trab_tripulante into :ls_tipo_trip from rrhhparam where reckey = '1' ;


ls_origen      = String (em_origen.text)
ls_tipo        = String (em_tipo.text)
ld_fec_proceso = Date   (em_fecha.text)


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



//procesos de acuerdo a tipo de trabajador
if ls_tipo <> ls_tipo_trip then
	Messagebox('Aviso','El Tipo de Tranajador tiene que ser Tripulante ,Verifique!')
else
	
	DECLARE pb_USP_RRHH_CALCULO_GRAT_MENSUAL PROCEDURE FOR USP_RRHH_CALCULO_GRAT_MENSUAL
	        (:ld_fec_proceso , :ls_tipo, :ls_origen) ;
	EXECUTE pb_USP_RRHH_CALCULO_GRAT_MENSUAL ;


	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		rollback ;
		MessageBox("SQL error", ls_mensaje)
		Parent.SetMicroHelp('Proceso no se llegó a realizar')
	ELSE
		Commit ;
	   MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
	END IF


	CLOSE pb_USP_RRHH_CALCULO_GRAT_MENSUAL ;
end if	






SetPointer(Arrow!)

end event

type em_descripcion from editmask within w_rh907_transferencia_gratificaciones
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

type em_origen from editmask within w_rh907_transferencia_gratificaciones
integer x = 283
integer y = 200
integer width = 151
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

type em_tipo from editmask within w_rh907_transferencia_gratificaciones
integer x = 283
integer y = 320
integer width = 151
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

type em_fecha from editmask within w_rh907_transferencia_gratificaciones
integer x = 590
integer y = 444
integer width = 347
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_3 from statictext within w_rh907_transferencia_gratificaciones
integer x = 41
integer y = 448
integer width = 535
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
string text = "F. de Proceso :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh907_transferencia_gratificaciones
integer x = 453
integer y = 184
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

type cb_3 from commandbutton within w_rh907_transferencia_gratificaciones
integer x = 453
integer y = 304
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

type em_desc_tipo from editmask within w_rh907_transferencia_gratificaciones
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

type gb_1 from groupbox within w_rh907_transferencia_gratificaciones
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

