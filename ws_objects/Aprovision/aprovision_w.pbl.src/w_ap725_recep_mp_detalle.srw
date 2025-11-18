$PBExportHeader$w_ap725_recep_mp_detalle.srw
$PBExportComments$Record de pesca de embarcaciones
forward
global type w_ap725_recep_mp_detalle from w_rpt
end type
type rb_2 from radiobutton within w_ap725_recep_mp_detalle
end type
type rb_1 from radiobutton within w_ap725_recep_mp_detalle
end type
type st_2 from statictext within w_ap725_recep_mp_detalle
end type
type cb_prov_mp from commandbutton within w_ap725_recep_mp_detalle
end type
type st_prov_mp from statictext within w_ap725_recep_mp_detalle
end type
type st_4 from statictext within w_ap725_recep_mp_detalle
end type
type sle_prov_mp from singlelineedit within w_ap725_recep_mp_detalle
end type
type sle_prov_transp from singlelineedit within w_ap725_recep_mp_detalle
end type
type st_3 from statictext within w_ap725_recep_mp_detalle
end type
type st_prov_transp from statictext within w_ap725_recep_mp_detalle
end type
type cb_prov_transp from commandbutton within w_ap725_recep_mp_detalle
end type
type cb_2 from commandbutton within w_ap725_recep_mp_detalle
end type
type st_descrip_especie from statictext within w_ap725_recep_mp_detalle
end type
type st_1 from statictext within w_ap725_recep_mp_detalle
end type
type sle_materia from singlelineedit within w_ap725_recep_mp_detalle
end type
type cb_1 from commandbutton within w_ap725_recep_mp_detalle
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap725_recep_mp_detalle
end type
type dw_report from u_dw_rpt within w_ap725_recep_mp_detalle
end type
type gb_1 from groupbox within w_ap725_recep_mp_detalle
end type
type gb_2 from groupbox within w_ap725_recep_mp_detalle
end type
type gb_3 from groupbox within w_ap725_recep_mp_detalle
end type
type gb_4 from groupbox within w_ap725_recep_mp_detalle
end type
end forward

global type w_ap725_recep_mp_detalle from w_rpt
integer width = 3753
integer height = 2016
string title = "[AP725] Recepcion de Materia Prima Detallado"
string menuname = "m_rpt"
windowstate windowstate = maximized!
event ue_query_retrieve ( )
rb_2 rb_2
rb_1 rb_1
st_2 st_2
cb_prov_mp cb_prov_mp
st_prov_mp st_prov_mp
st_4 st_4
sle_prov_mp sle_prov_mp
sle_prov_transp sle_prov_transp
st_3 st_3
st_prov_transp st_prov_transp
cb_prov_transp cb_prov_transp
cb_2 cb_2
st_descrip_especie st_descrip_especie
st_1 st_1
sle_materia sle_materia
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_ap725_recep_mp_detalle w_ap725_recep_mp_detalle

type variables
String  isa_cod_origen[]
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

event ue_query_retrieve();This.Event Dynamic ue_retrieve()
end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

boolean	lb_ok
return lb_ok

end function

on w_ap725_recep_mp_detalle.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_2=create st_2
this.cb_prov_mp=create cb_prov_mp
this.st_prov_mp=create st_prov_mp
this.st_4=create st_4
this.sle_prov_mp=create sle_prov_mp
this.sle_prov_transp=create sle_prov_transp
this.st_3=create st_3
this.st_prov_transp=create st_prov_transp
this.cb_prov_transp=create cb_prov_transp
this.cb_2=create cb_2
this.st_descrip_especie=create st_descrip_especie
this.st_1=create st_1
this.sle_materia=create sle_materia
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_prov_mp
this.Control[iCurrent+5]=this.st_prov_mp
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.sle_prov_mp
this.Control[iCurrent+8]=this.sle_prov_transp
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_prov_transp
this.Control[iCurrent+11]=this.cb_prov_transp
this.Control[iCurrent+12]=this.cb_2
this.Control[iCurrent+13]=this.st_descrip_especie
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.sle_materia
this.Control[iCurrent+16]=this.cb_1
this.Control[iCurrent+17]=this.uo_fecha
this.Control[iCurrent+18]=this.dw_report
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
this.Control[iCurrent+22]=this.gb_4
end on

on w_ap725_recep_mp_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_2)
destroy(this.cb_prov_mp)
destroy(this.st_prov_mp)
destroy(this.st_4)
destroy(this.sle_prov_mp)
destroy(this.sle_prov_transp)
destroy(this.st_3)
destroy(this.st_prov_transp)
destroy(this.cb_prov_transp)
destroy(this.cb_2)
destroy(this.st_descrip_especie)
destroy(this.st_1)
destroy(this.sle_materia)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;long ll_row

idw_1 = dw_report

THIS.Event ue_preview()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;date    ld_fecha_ini, ld_fecha_fin
String  ls_empresa, ls_nombre, ls_especie, ls_prov_mp, ls_prov_transp, ls_flag
Integer li_verifica

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))
ls_especie		= sle_materia.text

if rb_1.checked then
	ls_flag = '1'
else
	ls_flag = '2'
end if

If ls_especie =' ' or ls_especie = '' Then
	ls_especie ='%'
Else
	Select Count(*) Into :li_verifica
	  From tg_especies tg 
	 Where tg.especie = :ls_especie
	   and Nvl(tg.flag_estado,'0') ='1';
	If li_verifica = 0 Then
		MessageBox("Error","La Especie Ingresada no existe o esta Inactiva")
		Return
	End If;
End If;
	
ls_prov_transp	= sle_prov_transp.text

li_verifica = 0

If ls_prov_transp =' ' or ls_prov_transp = '' Then
	ls_prov_transp ='%'
Else
	Select Count(*) Into :li_verifica
     from ap_transp_prov atp
    Where atp.proveedor = :ls_prov_transp;
	 
	If li_verifica = 0 Then
		MessageBox("Error","El Proveedor de Transporte Ingresado no existe ")
		Return
	End If;
End If;

ls_prov_mp		= sle_prov_mp.text
li_verifica		= 0

If ls_prov_mp =' ' or ls_prov_mp = '' Then
	ls_prov_mp ='%'
Else
	Select Count(*) Into :li_verifica
     from ap_proveedor_mp apm
    Where apm.proveedor = :ls_prov_mp;
	 
	If li_verifica = 0 Then
		MessageBox("Error","El Proveedor de Materia Prima Ingresado no existe ")
		Return
	End If;
End If;

idw_1.SetTransObject(SQLCA)

Select g.cod_empresa Into :ls_empresa from genparam g where g.reckey = '1';
Select e.nombre Into :ls_nombre from empresa e where e.cod_empresa = :ls_empresa;

//idw_1.SetRedraw(false)

//Recupera los datos del reporte
idw_1.Retrieve(ls_flag, ld_fecha_ini, ld_fecha_fin, ls_prov_mp, ls_prov_transp, ls_especie)
idw_1.object.t_user.text 		= gs_user
idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.t_desde.text 		= String(ld_fecha_ini)
idw_1.object.t_hasta.text 		= String(ld_fecha_fin)
idw_1.object.t_nombre.text		= ls_nombre
idw_1.Visible = True
//idw_1.SetRedraw(true)


end event

type rb_2 from radiobutton within w_ap725_recep_mp_detalle
integer x = 969
integer y = 172
integer width = 512
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parte de recepcion"
end type

type rb_1 from radiobutton within w_ap725_recep_mp_detalle
integer x = 411
integer y = 172
integer width = 549
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inicio de descarga"
boolean checked = true
end type

type st_2 from statictext within w_ap725_recep_mp_detalle
integer x = 23
integer y = 180
integer width = 384
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtro de Fecha :"
boolean focusrectangle = false
end type

type cb_prov_mp from commandbutton within w_ap725_recep_mp_detalle
integer x = 2094
integer y = 76
integer width = 78
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;String ls_codigo, ls_sql, ls_data
str_seleccionar lstr_seleccionar
Datawindow ldw
dwobject   dwo1
ls_sql = "Select apm.proveedor as codigo, p.nom_proveedor as nombre, p.ruc as ruc "&
			+ "from ap_proveedor_mp apm, proveedor p Where apm.proveedor = p.proveedor "&
			+ "Order by p.nom_proveedor"
	
if ls_sql <> '' then
	f_lista(ls_sql, ls_codigo, ls_data, '1')
	if ls_codigo = '' then return 
end if

sle_prov_mp.text = ls_codigo
st_prov_mp.text = ls_data


end event

type st_prov_mp from statictext within w_ap725_recep_mp_detalle
integer x = 2176
integer y = 76
integer width = 992
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_ap725_recep_mp_detalle
integer x = 1536
integer y = 80
integer width = 229
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Código:"
boolean focusrectangle = false
end type

type sle_prov_mp from singlelineedit within w_ap725_recep_mp_detalle
integer x = 1769
integer y = 80
integer width = 320
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_prov_transp from singlelineedit within w_ap725_recep_mp_detalle
integer x = 1778
integer y = 320
integer width = 320
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_ap725_recep_mp_detalle
integer x = 1545
integer y = 316
integer width = 229
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Código"
boolean focusrectangle = false
end type

type st_prov_transp from statictext within w_ap725_recep_mp_detalle
integer x = 2185
integer y = 320
integer width = 992
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_prov_transp from commandbutton within w_ap725_recep_mp_detalle
integer x = 2103
integer y = 320
integer width = 78
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;String ls_codigo, ls_sql, ls_data
str_seleccionar lstr_seleccionar
Datawindow ldw
dwobject   dwo1
ls_sql = "Select apt.proveedor as codigo, p.nom_proveedor as nombre, p.ruc as ruc "&
 			+ "from ap_transp_prov apt, proveedor p Where apt.proveedor = p.proveedor "&
			+ "Order by p.nom_proveedor"
	
if ls_sql <> '' then
	f_lista(ls_sql, ls_codigo, ls_data, '1')
	if ls_codigo = '' then return 
end if

sle_prov_transp.text = ls_codigo
st_prov_transp.text = ls_data


end event

type cb_2 from commandbutton within w_ap725_recep_mp_detalle
integer x = 553
integer y = 320
integer width = 78
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;String ls_codigo, ls_sql, ls_data
str_seleccionar lstr_seleccionar
Datawindow ldw
dwobject   dwo1
ls_sql = "Select Distinct apd.especie as codigo, " &
		 + "te.descr_especie as descripcion, " &
		 + "te.flag_estado as estado " &
		 + "From tg_especies te, " &
		 + "ap_pd_descarga_det apd "&
		 + "Where te.especie = apd.especie " &
		 + "and Nvl(te.flag_estado,'0')='1'"
	
if ls_sql <> '' then
	f_lista(ls_sql, ls_codigo, ls_data, '1')
	if ls_codigo = '' then return 
end if

sle_materia.text = ls_codigo
st_descrip_especie.text = ls_data


end event

type st_descrip_especie from statictext within w_ap725_recep_mp_detalle
integer x = 640
integer y = 320
integer width = 681
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ap725_recep_mp_detalle
integer x = 32
integer y = 316
integer width = 215
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Código:"
boolean focusrectangle = false
end type

type sle_materia from singlelineedit within w_ap725_recep_mp_detalle
integer x = 256
integer y = 320
integer width = 293
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ap725_recep_mp_detalle
integer x = 3328
integer y = 64
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;parent.event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_ap725_recep_mp_detalle
integer x = 32
integer y = 72
integer height = 96
integer taborder = 10
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(RelativeDate(today(),-7) , today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_ap725_recep_mp_detalle
integer y = 464
integer width = 3470
integer height = 1304
integer taborder = 80
string dataobject = "d_rpt_recepcion_mp_detalle_tbl"
end type

type gb_1 from groupbox within w_ap725_recep_mp_detalle
integer y = 260
integer width = 1486
integer height = 192
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Especie:"
end type

type gb_2 from groupbox within w_ap725_recep_mp_detalle
integer x = 1504
integer width = 1687
integer height = 252
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor Materia Prima"
end type

type gb_3 from groupbox within w_ap725_recep_mp_detalle
integer width = 1486
integer height = 252
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas:"
end type

type gb_4 from groupbox within w_ap725_recep_mp_detalle
integer x = 1504
integer y = 260
integer width = 1687
integer height = 192
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor de Transportes"
end type

