$PBExportHeader$w_pr738_etiquetas_campo.srw
forward
global type w_pr738_etiquetas_campo from w_report_smpl
end type
type cb_1 from commandbutton within w_pr738_etiquetas_campo
end type
type cbx_todos from checkbox within w_pr738_etiquetas_campo
end type
type st_3 from statictext within w_pr738_etiquetas_campo
end type
type ddlb_nro from dropdownlistbox within w_pr738_etiquetas_campo
end type
type sle_lote from singlelineedit within w_pr738_etiquetas_campo
end type
type cb_listado from commandbutton within w_pr738_etiquetas_campo
end type
type gb_5 from groupbox within w_pr738_etiquetas_campo
end type
type gb_3 from groupbox within w_pr738_etiquetas_campo
end type
end forward

global type w_pr738_etiquetas_campo from w_report_smpl
integer width = 3506
integer height = 1636
string title = "(PR737) Etiquetas para producción"
string menuname = "m_reporte"
long backcolor = 79741120
cb_1 cb_1
cbx_todos cbx_todos
st_3 st_3
ddlb_nro ddlb_nro
sle_lote sle_lote
cb_listado cb_listado
gb_5 gb_5
gb_3 gb_3
end type
global w_pr738_etiquetas_campo w_pr738_etiquetas_campo

type variables
string is_codigo
end variables

on w_pr738_etiquetas_campo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.cbx_todos=create cbx_todos
this.st_3=create st_3
this.ddlb_nro=create ddlb_nro
this.sle_lote=create sle_lote
this.cb_listado=create cb_listado
this.gb_5=create gb_5
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_todos
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.ddlb_nro
this.Control[iCurrent+5]=this.sle_lote
this.Control[iCurrent+6]=this.cb_listado
this.Control[iCurrent+7]=this.gb_5
this.Control[iCurrent+8]=this.gb_3
end on

on w_pr738_etiquetas_campo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_todos)
destroy(this.st_3)
destroy(this.ddlb_nro)
destroy(this.sle_lote)
destroy(this.cb_listado)
destroy(this.gb_5)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;string  	ls_mensaje
integer	li_nro_trabaj, li_i

li_nro_trabaj = integer(ddlb_nro.text)

if li_nro_trabaj <= 0 then
	MEssageBox('Error', 'Debe seleccionar una cantidad de etiquetas por trabajador')
	return
end if

delete tt_telecredito;
for li_i = 1 to li_nro_trabaj
	insert into tt_telecredito(col_telecredito) values ('1');
next

//Inserto los trabajadores
if cbx_todos.checked then
	delete tt_datos_campo;
	
	insert into tt_datos_campo(supervisor, cosechador1, cosechador2)
	select supervisor, cosechador1, cosechador2
	from superv_campo;
	  
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en insert', 'No se pudo insertar datos en tt_datos_campo: ' &
							+ ls_mensaje)
		return
	end if
end if
	
dw_report.object.nro_lote_t.text = sle_lote.text
dw_report.retrieve()


end event

event open;call super::open;String ls_Dir = "C:\WINDOWS\Fonts\", ls_fileFont = "IDAutomationHC39M_Free.ttf"


if not FileExists(ls_dir + ls_FileFont) then
	FileCopy(ls_fileFont, ls_dir + ls_FileFont, false)
	MessageBox('Error', 'No tiene instalado la fuente ' + ls_dir + ls_FileFont &
				+ "~r~nLa aplicación está copiando la fuente en " + ls_dir &
				+ "~r~nLa Aplicación se cerrará, debe volverla a cargar nuevamente ")
	Halt Close
end if
end event

type dw_report from w_report_smpl`dw_report within w_pr738_etiquetas_campo
integer x = 9
integer y = 276
integer width = 3451
integer height = 1160
integer taborder = 70
string dataobject = "d_etiquetas_campo2_lbl"
end type

type cb_1 from commandbutton within w_pr738_etiquetas_campo
integer x = 2898
integer y = 92
integer width = 279
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.Event ue_retrieve()

end event

type cbx_todos from checkbox within w_pr738_etiquetas_campo
integer x = 119
integer y = 92
integer width = 256
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if not this.checked then
	cb_listado.enabled = true
else
	cb_listado.enabled = false
end if
end event

type st_3 from statictext within w_pr738_etiquetas_campo
integer x = 1655
integer y = 44
integer width = 571
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Cantidad por trabajador"
boolean focusrectangle = false
end type

type ddlb_nro from dropdownlistbox within w_pr738_etiquetas_campo
integer x = 1655
integer y = 132
integer width = 571
integer height = 680
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"1","10","20","30","40","50","60","100","200","300","400"}
borderstyle borderstyle = stylelowered!
end type

type sle_lote from singlelineedit within w_pr738_etiquetas_campo
integer x = 2313
integer y = 76
integer width = 517
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
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type cb_listado from commandbutton within w_pr738_etiquetas_campo
integer x = 407
integer y = 88
integer width = 955
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Listado de trabajadores"
end type

event clicked;str_parametros lstr_param
string ls_area, ls_seccion

if isnull(ls_area) or trim(ls_area) = '' then ls_area = '%%'
if isnull(ls_seccion) or trim(ls_seccion) = '' then ls_seccion = '%%'


// Si es una salida x consumo interno
lstr_param.w1				= parent
lstr_param.dw1      		= 'd_list_supervisor_jornalero_grd'
lstr_param.titulo    	= 'Supervisor / Jornalero'
lstr_param.tipo		 	= ''     // con un parametro del tipo string
	
lstr_param.opcion    	= 3

OpenWithParm( w_abc_seleccion, lstr_param)

end event

type gb_5 from groupbox within w_pr738_etiquetas_campo
integer x = 73
integer y = 12
integer width = 1536
integer height = 252
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Rango de Trabajadores"
end type

type gb_3 from groupbox within w_pr738_etiquetas_campo
integer x = 2263
integer y = 8
integer width = 613
integer height = 232
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro de Lote/Cuartel"
end type

