$PBExportHeader$w_rh370_rpt_retencion_quinta.srw
forward
global type w_rh370_rpt_retencion_quinta from w_report_smpl
end type
type cb_1 from commandbutton within w_rh370_rpt_retencion_quinta
end type
type cb_3 from commandbutton within w_rh370_rpt_retencion_quinta
end type
type em_descripcion from editmask within w_rh370_rpt_retencion_quinta
end type
type em_origen from editmask within w_rh370_rpt_retencion_quinta
end type
type em_desc_tipo from editmask within w_rh370_rpt_retencion_quinta
end type
type em_tipo from editmask within w_rh370_rpt_retencion_quinta
end type
type cb_2 from commandbutton within w_rh370_rpt_retencion_quinta
end type
type em_year from editmask within w_rh370_rpt_retencion_quinta
end type
type gb_2 from groupbox within w_rh370_rpt_retencion_quinta
end type
type gb_3 from groupbox within w_rh370_rpt_retencion_quinta
end type
type gb_1 from groupbox within w_rh370_rpt_retencion_quinta
end type
end forward

global type w_rh370_rpt_retencion_quinta from w_report_smpl
integer width = 3429
integer height = 1500
string title = "(RH370) Acumulado de Retenciones Afectas a Quinta Categoría"
string menuname = "m_impresion"
cb_1 cb_1
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
em_year em_year
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_rh370_rpt_retencion_quinta w_rh370_rpt_retencion_quinta

on w_rh370_rpt_retencion_quinta.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.em_year=create em_year
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.em_desc_tipo
this.Control[iCurrent+6]=this.em_tipo
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.em_year
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.gb_1
end on

on w_rh370_rpt_retencion_quinta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.em_year)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_tiptra, ls_descripcion, ls_mensaje
Long		ll_year

ls_origen = string(em_origen.text)
ll_year	 = Long(em_year.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)

//create or replace procedure usp_rh_rpt_retencion_quinta (
//  asi_tipo_trabajador in tipo_trabajador.tipo_trabajador%TYPE, 
//  asi_origen          in origen.cod_origen%TYPE, 
//  ani_year            in number 
//) is

DECLARE USP_RH_RPT_RETENCION_QUINTA PROCEDURE FOR 
	USP_RH_RPT_RETENCION_QUINTA( :ls_tiptra, 
										  :ls_origen, 
										  :ll_year ) ;
EXECUTE USP_RH_RPT_RETENCION_QUINTA ;

if sqlca.SQlCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MEssageBox('Error', 'Ha ocurrido un error al ejecutar el procedimiento USP_RH_RPT_RETENCION_QUINTA. Mensaje: ' + ls_mensaje, StopSign!)
	return
end if

dw_report.retrieve()

CLOSE USP_RH_RPT_RETENCION_QUINTA ;

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.st_sit.text = ls_descripcion

end event

event ue_open_pre;call super::ue_open_pre;em_year.text = string(gnvo_app.of_fecha_Actual(), 'yyyy')
end event

type dw_report from w_report_smpl`dw_report within w_rh370_rpt_retencion_quinta
integer x = 0
integer y = 184
integer width = 3369
integer height = 1012
integer taborder = 50
string dataobject = "d_rpt_retencion_quinta_tbl"
end type

type cb_1 from commandbutton within w_rh370_rpt_retencion_quinta
integer x = 2766
integer y = 56
integer width = 293
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type cb_3 from commandbutton within w_rh370_rpt_retencion_quinta
integer x = 165
integer y = 76
integer width = 87
integer height = 68
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

type em_descripcion from editmask within w_rh370_rpt_retencion_quinta
integer x = 288
integer y = 72
integer width = 718
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh370_rpt_retencion_quinta
integer x = 50
integer y = 72
integer width = 96
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_tipo from editmask within w_rh370_rpt_retencion_quinta
integer x = 1413
integer y = 72
integer width = 667
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh370_rpt_retencion_quinta
integer x = 1115
integer y = 72
integer width = 151
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh370_rpt_retencion_quinta
integer x = 1285
integer y = 76
integer width = 87
integer height = 68
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

type em_year from editmask within w_rh370_rpt_retencion_quinta
integer x = 2208
integer y = 60
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
double increment = 1
end type

type gb_2 from groupbox within w_rh370_rpt_retencion_quinta
integer width = 1056
integer height = 172
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh370_rpt_retencion_quinta
integer x = 2135
integer width = 480
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Año de Retención"
end type

type gb_1 from groupbox within w_rh370_rpt_retencion_quinta
integer x = 1070
integer width = 1056
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

