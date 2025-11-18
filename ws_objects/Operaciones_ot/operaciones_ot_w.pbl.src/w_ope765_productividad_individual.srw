$PBExportHeader$w_ope765_productividad_individual.srw
forward
global type w_ope765_productividad_individual from w_report_smpl
end type
type cb_1 from commandbutton within w_ope765_productividad_individual
end type
type uo_1 from u_ingreso_rango_fechas within w_ope765_productividad_individual
end type
type cbx_trabajador from checkbox within w_ope765_productividad_individual
end type
type st_nombre from statictext within w_ope765_productividad_individual
end type
type pb_1 from picturebutton within w_ope765_productividad_individual
end type
type sle_trabajador from singlelineedit within w_ope765_productividad_individual
end type
type st_1 from statictext within w_ope765_productividad_individual
end type
type gb_1 from groupbox within w_ope765_productividad_individual
end type
end forward

global type w_ope765_productividad_individual from w_report_smpl
integer width = 3214
integer height = 1948
string title = "(OPE764) Costo por Actividad"
string menuname = "m_rpt_smpl"
long backcolor = 10789024
cb_1 cb_1
uo_1 uo_1
cbx_trabajador cbx_trabajador
st_nombre st_nombre
pb_1 pb_1
sle_trabajador sle_trabajador
st_1 st_1
gb_1 gb_1
end type
global w_ope765_productividad_individual w_ope765_productividad_individual

on w_ope765_productividad_individual.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
this.uo_1=create uo_1
this.cbx_trabajador=create cbx_trabajador
this.st_nombre=create st_nombre
this.pb_1=create pb_1
this.sle_trabajador=create sle_trabajador
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cbx_trabajador
this.Control[iCurrent+4]=this.st_nombre
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.sle_trabajador
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_ope765_productividad_individual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.cbx_trabajador)
destroy(this.st_nombre)
destroy(this.pb_1)
destroy(this.sle_trabajador)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = True

ib_preview = false
THIS.Event ue_preview()

end event

event ue_preview;call super::ue_preview;idw_1.Modify("datawindow.print.preview.zoom = " + String(100))
end event

type dw_report from w_report_smpl`dw_report within w_ope765_productividad_individual
integer x = 27
integer y = 456
integer width = 3109
integer height = 1284
string dataobject = "d_abc_rpt_prod_x_trabajdor_costo_tbl"
end type

type cb_1 from commandbutton within w_ope765_productividad_individual
integer x = 2743
integer y = 96
integer width = 384
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicial,ld_fecha_final
String ls_fecha,ls_prod,ls_codigo
Decimal {4} ldc_tasa_cambio


ld_fecha_inicial = uo_1.of_get_fecha1()
ld_fecha_final   = uo_1.of_get_fecha2()

////recupera codigo de producto
if cbx_trabajador.checked then
	ls_codigo = '%'
else
	if isnull(ls_codigo) or trim(ls_codigo) = ''  then
		Messagebox('Aviso','Debe Ingresar Un codigo de Trabajador')
		Return
	end if
end if	

SetPointer(hourglass!)


//ejecuta procedimeinto de asigancion de labores
DECLARE PB_usp_ope_destajo_efect_x_fechas PROCEDURE FOR usp_ope_destajo_efect_x_fechas
(:ld_fecha_inicial,:ld_fecha_final);
EXECUTE pb_usp_ope_destajo_efect_x_fechas ;
	
IF SQLCA.SQLCode = -1 THEN 
   MessageBox("SQL error", SQLCA.SQLErrText)

END IF



 

//buscar tipo de cambio

dw_report.retrieve(ld_fecha_inicial,ld_fecha_final,ls_codigo)


dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_user.text = gs_user
dw_report.object.t_empresa.text = gs_empresa


SetPointer(Arrow!)
end event

type uo_1 from u_ingreso_rango_fechas within w_ope765_productividad_individual
event destroy ( )
integer x = 55
integer y = 144
integer taborder = 60
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(),today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cbx_trabajador from checkbox within w_ope765_productividad_individual
integer x = 2254
integer y = 264
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_trabajador.text 	  = ''
	st_nombre.text			  = ''
	sle_trabajador.enabled = false
else
	sle_trabajador.text 	  = ''
	st_nombre.text			  = ''	
	sle_trabajador.enabled = true
end if	
end event

type st_nombre from statictext within w_ope765_productividad_individual
integer x = 937
integer y = 268
integer width = 1280
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 134217752
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ope765_productividad_individual
integer x = 818
integer y = 268
integer width = 91
integer height = 80
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "..."
boolean originalsize = true
string picturename = "C:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;if cbx_trabajador.checked = false then
	Str_seleccionar lstr_seleccionar
	Datawindow		 ldw	
				
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT M.COD_TRABAJADOR  AS CLIENTE,'&
			      				 +'M.APEL_PATERNO AS APELLIDO_PATERNO,'&
									 +'M.APEL_MATERNO AS APELLIDO_MATERNO, '&
									 +'M.NOMBRE1 AS NOMBRE1,'&
									 +'M.NOMBRE2 AS NOMBRE2,'&
									 +'M.COD_ORIGEN AS ORIGEN '&
				   				 +'FROM MAESTRO M '&
									 +'WHERE M.FLAG_ESTADO = '+"'"+'1'+"'"

				
	OpenWithParm(w_seleccionar,lstr_seleccionar)
				
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

	IF lstr_seleccionar.s_action = "aceptar" THEN
		if isnull(lstr_seleccionar.param2[1])  then
			lstr_seleccionar.param2[1] = ''
		end if

		if isnull(lstr_seleccionar.param3[1]) then
			lstr_seleccionar.param3[1] = ''
		end if
	
		if isnull(lstr_seleccionar.param4[1])  then
			lstr_seleccionar.param4[1] = ''
		end if
	
		if isnull(lstr_seleccionar.param5[1])  then
			lstr_seleccionar.param5[1] = ''
		end if
		sle_trabajador.text = lstr_seleccionar.param1[1]
		st_nombre.text		  = lstr_seleccionar.param2[1]+' '+lstr_seleccionar.param3[1]+' '+lstr_seleccionar.param4[1]+' '+lstr_seleccionar.param5[1]
	ELSE
		sle_trabajador.text = ''
		st_nombre.text		  = ''
	END IF
end if
end event

type sle_trabajador from singlelineedit within w_ope765_productividad_individual
integer x = 411
integer y = 268
integer width = 384
integer height = 84
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ope765_productividad_individual
integer x = 69
integer y = 276
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trabajador :"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_ope765_productividad_individual
integer x = 27
integer y = 72
integer width = 2642
integer height = 348
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

