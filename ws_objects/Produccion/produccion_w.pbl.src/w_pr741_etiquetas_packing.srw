$PBExportHeader$w_pr741_etiquetas_packing.srw
forward
global type w_pr741_etiquetas_packing from w_report_smpl
end type
type cb_1 from commandbutton within w_pr741_etiquetas_packing
end type
type cbx_todos from checkbox within w_pr741_etiquetas_packing
end type
type st_3 from statictext within w_pr741_etiquetas_packing
end type
type ddlb_nro from dropdownlistbox within w_pr741_etiquetas_packing
end type
type cb_listado from commandbutton within w_pr741_etiquetas_packing
end type
type gb_5 from groupbox within w_pr741_etiquetas_packing
end type
end forward

global type w_pr741_etiquetas_packing from w_report_smpl
integer width = 3506
integer height = 1636
string title = "(PR741) Etiquetas para Seleccionadoras de Packing"
string menuname = "m_reporte"
long backcolor = 79741120
cb_1 cb_1
cbx_todos cbx_todos
st_3 st_3
ddlb_nro ddlb_nro
cb_listado cb_listado
gb_5 gb_5
end type
global w_pr741_etiquetas_packing w_pr741_etiquetas_packing

type variables
string is_codigo
end variables

on w_pr741_etiquetas_packing.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.cbx_todos=create cbx_todos
this.st_3=create st_3
this.ddlb_nro=create ddlb_nro
this.cb_listado=create cb_listado
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_todos
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.ddlb_nro
this.Control[iCurrent+5]=this.cb_listado
this.Control[iCurrent+6]=this.gb_5
end on

on w_pr741_etiquetas_packing.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_todos)
destroy(this.st_3)
destroy(this.ddlb_nro)
destroy(this.cb_listado)
destroy(this.gb_5)
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
	select seleccionadora, supervisora, pesadora
	from packing_sel_sup_pes;
	  
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error en insert', 'No se pudo insertar datos en tt_datos_campo: ' &
							+ ls_mensaje)
		return
	end if
end if
	
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

type dw_report from w_report_smpl`dw_report within w_pr741_etiquetas_packing
integer x = 9
integer y = 276
integer width = 3451
integer height = 1160
integer taborder = 70
string dataobject = "d_etiquetas_packing_lbl"
end type

type cb_1 from commandbutton within w_pr741_etiquetas_packing
integer x = 2272
integer y = 64
integer width = 402
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

type cbx_todos from checkbox within w_pr741_etiquetas_packing
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

type st_3 from statictext within w_pr741_etiquetas_packing
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

type ddlb_nro from dropdownlistbox within w_pr741_etiquetas_packing
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

type cb_listado from commandbutton within w_pr741_etiquetas_packing
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
lstr_param.dw1      		= 'd_list_seleccionadora_supervisor_grd'
lstr_param.titulo    	= 'Seleccionadora - Supervisor'
lstr_param.tipo		 	= ''     // con un parametro del tipo string
	
lstr_param.opcion    	= 3

OpenWithParm( w_abc_seleccion, lstr_param)

end event

type gb_5 from groupbox within w_pr741_etiquetas_packing
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

