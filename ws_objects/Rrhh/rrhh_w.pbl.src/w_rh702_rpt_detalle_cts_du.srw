$PBExportHeader$w_rh702_rpt_detalle_cts_du.srw
forward
global type w_rh702_rpt_detalle_cts_du from w_report_smpl
end type
type cb_1 from commandbutton within w_rh702_rpt_detalle_cts_du
end type
type st_1 from statictext within w_rh702_rpt_detalle_cts_du
end type
type em_origen from editmask within w_rh702_rpt_detalle_cts_du
end type
type em_tipo from editmask within w_rh702_rpt_detalle_cts_du
end type
type st_2 from statictext within w_rh702_rpt_detalle_cts_du
end type
type cb_2 from commandbutton within w_rh702_rpt_detalle_cts_du
end type
type cb_4 from commandbutton within w_rh702_rpt_detalle_cts_du
end type
type em_desc_origen from editmask within w_rh702_rpt_detalle_cts_du
end type
type em_desc_tipo from editmask within w_rh702_rpt_detalle_cts_du
end type
type em_fecha from editmask within w_rh702_rpt_detalle_cts_du
end type
type st_3 from statictext within w_rh702_rpt_detalle_cts_du
end type
type st_4 from statictext within w_rh702_rpt_detalle_cts_du
end type
type sle_titulo from singlelineedit within w_rh702_rpt_detalle_cts_du
end type
type gb_2 from groupbox within w_rh702_rpt_detalle_cts_du
end type
end forward

global type w_rh702_rpt_detalle_cts_du from w_report_smpl
integer width = 3497
integer height = 2232
string title = "(RH702) Detalle deLiquidación de C.T.S. Mensual"
string menuname = "m_impresion"
cb_1 cb_1
st_1 st_1
em_origen em_origen
em_tipo em_tipo
st_2 st_2
cb_2 cb_2
cb_4 cb_4
em_desc_origen em_desc_origen
em_desc_tipo em_desc_tipo
em_fecha em_fecha
st_3 st_3
st_4 st_4
sle_titulo sle_titulo
gb_2 gb_2
end type
global w_rh702_rpt_detalle_cts_du w_rh702_rpt_detalle_cts_du

on w_rh702_rpt_detalle_cts_du.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_1=create st_1
this.em_origen=create em_origen
this.em_tipo=create em_tipo
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_4=create cb_4
this.em_desc_origen=create em_desc_origen
this.em_desc_tipo=create em_desc_tipo
this.em_fecha=create em_fecha
this.st_3=create st_3
this.st_4=create st_4
this.sle_titulo=create sle_titulo
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_tipo
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.em_desc_origen
this.Control[iCurrent+9]=this.em_desc_tipo
this.Control[iCurrent+10]=this.em_fecha
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.sle_titulo
this.Control[iCurrent+14]=this.gb_2
end on

on w_rh702_rpt_detalle_cts_du.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_origen)
destroy(this.em_tipo)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_4)
destroy(this.em_desc_origen)
destroy(this.em_desc_tipo)
destroy(this.em_fecha)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_titulo)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String ls_origen, ls_tipo, ls_mensaje
Long	 ll_count
Date ld_fec_proceso


This.SetMicroHelp('Procesando Transferencia de CTS')
SetPointer(HourGlass!)





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











dw_report.retrieve(ls_origen,ls_tipo,ld_fec_proceso)

dw_report.object.p_logo.filename   = gs_logo
dw_report.object.t_nombre.text     = gs_empresa
dw_report.object.t_user.text 		  = gs_user
dw_report.object.t_tit_report.text = sle_titulo.text
SetPointer(Arrow!)
end event

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = true
end event

type dw_report from w_report_smpl`dw_report within w_rh702_rpt_detalle_cts_du
integer x = 32
integer y = 496
integer width = 3410
integer height = 1512
integer taborder = 50
string dataobject = "d_cts_dec_urg_tbl"
end type

type cb_1 from commandbutton within w_rh702_rpt_detalle_cts_du
integer x = 2999
integer y = 20
integer width = 421
integer height = 116
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type st_1 from statictext within w_rh702_rpt_detalle_cts_du
integer x = 73
integer y = 104
integer width = 539
integer height = 80
boolean bringtotop = true
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

type em_origen from editmask within w_rh702_rpt_detalle_cts_du
integer x = 635
integer y = 104
integer width = 151
integer height = 80
integer taborder = 20
boolean bringtotop = true
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

type em_tipo from editmask within w_rh702_rpt_detalle_cts_du
integer x = 635
integer y = 204
integer width = 151
integer height = 80
integer taborder = 50
boolean bringtotop = true
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

type st_2 from statictext within w_rh702_rpt_detalle_cts_du
integer x = 73
integer y = 204
integer width = 539
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh702_rpt_detalle_cts_du
integer x = 805
integer y = 204
integer width = 87
integer height = 80
integer taborder = 60
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

type cb_4 from commandbutton within w_rh702_rpt_detalle_cts_du
integer x = 805
integer y = 104
integer width = 87
integer height = 80
integer taborder = 30
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
	em_desc_origen.text = sl_param.field_ret[2]
END IF

end event

type em_desc_origen from editmask within w_rh702_rpt_detalle_cts_du
integer x = 919
integer y = 104
integer width = 1143
integer height = 80
integer taborder = 30
boolean bringtotop = true
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

type em_desc_tipo from editmask within w_rh702_rpt_detalle_cts_du
integer x = 919
integer y = 204
integer width = 1143
integer height = 80
integer taborder = 60
boolean bringtotop = true
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

type em_fecha from editmask within w_rh702_rpt_detalle_cts_du
integer x = 635
integer y = 296
integer width = 347
integer height = 76
integer taborder = 90
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

type st_3 from statictext within w_rh702_rpt_detalle_cts_du
integer x = 73
integer y = 300
integer width = 539
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

type st_4 from statictext within w_rh702_rpt_detalle_cts_du
integer x = 73
integer y = 388
integer width = 539
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
string text = "Titulo de Reporte :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_titulo from singlelineedit within w_rh702_rpt_detalle_cts_du
integer x = 635
integer y = 380
integer width = 2286
integer height = 72
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
integer limit = 80
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_rh702_rpt_detalle_cts_du
integer x = 32
integer y = 24
integer width = 2935
integer height = 464
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Ingrese Datos"
end type

