$PBExportHeader$w_ap703_decl_jur_men_tolva.srw
forward
global type w_ap703_decl_jur_men_tolva from w_rpt
end type
type st_5 from statictext within w_ap703_decl_jur_men_tolva
end type
type st_4 from statictext within w_ap703_decl_jur_men_tolva
end type
type st_tolva from statictext within w_ap703_decl_jur_men_tolva
end type
type st_6 from statictext within w_ap703_decl_jur_men_tolva
end type
type st_balanza from statictext within w_ap703_decl_jur_men_tolva
end type
type sle_maquina from singlelineedit within w_ap703_decl_jur_men_tolva
end type
type st_3 from statictext within w_ap703_decl_jur_men_tolva
end type
type mle_1 from multilineedit within w_ap703_decl_jur_men_tolva
end type
type pb_1 from picturebutton within w_ap703_decl_jur_men_tolva
end type
type dw_uso_mp from datawindow within w_ap703_decl_jur_men_tolva
end type
type dw_origen from u_dw_abc within w_ap703_decl_jur_men_tolva
end type
type em_year from editmask within w_ap703_decl_jur_men_tolva
end type
type st_2 from statictext within w_ap703_decl_jur_men_tolva
end type
type st_1 from statictext within w_ap703_decl_jur_men_tolva
end type
type ddlb_mes from dropdownlistbox within w_ap703_decl_jur_men_tolva
end type
type dw_report from u_dw_rpt within w_ap703_decl_jur_men_tolva
end type
end forward

global type w_ap703_decl_jur_men_tolva from w_rpt
integer width = 3552
integer height = 2384
string title = "Declaracion Jurada Mensual de Tolva  (AP703)"
string menuname = "m_rpt"
long backcolor = 67108864
boolean center = true
event ue_query_retrieve ( )
st_5 st_5
st_4 st_4
st_tolva st_tolva
st_6 st_6
st_balanza st_balanza
sle_maquina sle_maquina
st_3 st_3
mle_1 mle_1
pb_1 pb_1
dw_uso_mp dw_uso_mp
dw_origen dw_origen
em_year em_year
st_2 st_2
st_1 st_1
ddlb_mes ddlb_mes
dw_report dw_report
end type
global w_ap703_decl_jur_men_tolva w_ap703_decl_jur_men_tolva

type variables
string is_cod_origen, is_cod_uso_mp
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

event ue_query_retrieve();this.event dynamic ue_retrieve()
end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i
String 	ls_separador
boolean	lb_ok

is_cod_origen = ''
ls_separador  = ''
is_cod_uso_mp = ''
lb_ok			  = True

IF ISNull(sle_maquina.text) OR LEN(TRIM(sle_maquina.text)) = 0 THEN
	Messagebox('Aviso', 'Debe ingresar una balanza para el Reporte')
	return lb_ok = False
END IF

// leer el dw_origen con los origenes seleccionados
For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		if is_cod_origen <>'' THEN ls_separador = ', '
		is_cod_origen = is_cod_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
	end if
Next

IF LEN(is_cod_origen) = 0 THEN
	messagebox('Aprovisionamiento', 'Debe seleccionar al menos un origen para el Reporte')
	return lb_ok = False
END IF

//Seleccionar Usos de la Materia Prima
For ll_i = 1 To dw_uso_mp.RowCount()
	If dw_uso_mp.Object.Chec[ll_i] = '1' Then
		if is_cod_uso_mp <>'' THEN ls_separador = ', '
		is_cod_uso_mp = is_cod_uso_mp + ls_separador + dw_uso_mp.Object.cod_uso[ll_i]
	end if
Next

IF LEN(is_cod_uso_mp) = 0 THEN
	messagebox('Aprovisionamiento', 'Debe seleccionar al menos un Destino de MP para el Reporte')
	return lb_ok = False
END IF

RETURN lb_ok
end function

on w_ap703_decl_jur_men_tolva.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_5=create st_5
this.st_4=create st_4
this.st_tolva=create st_tolva
this.st_6=create st_6
this.st_balanza=create st_balanza
this.sle_maquina=create sle_maquina
this.st_3=create st_3
this.mle_1=create mle_1
this.pb_1=create pb_1
this.dw_uso_mp=create dw_uso_mp
this.dw_origen=create dw_origen
this.em_year=create em_year
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_mes=create ddlb_mes
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_tolva
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.st_balanza
this.Control[iCurrent+6]=this.sle_maquina
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.mle_1
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.dw_uso_mp
this.Control[iCurrent+11]=this.dw_origen
this.Control[iCurrent+12]=this.em_year
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.ddlb_mes
this.Control[iCurrent+16]=this.dw_report
end on

on w_ap703_decl_jur_men_tolva.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_tolva)
destroy(this.st_6)
destroy(this.st_balanza)
destroy(this.sle_maquina)
destroy(this.st_3)
destroy(this.mle_1)
destroy(this.pb_1)
destroy(this.dw_uso_mp)
destroy(this.dw_origen)
destroy(this.em_year)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_mes)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_retrieve;call super::ue_retrieve;string ls_year, ls_mes, ls_razsoc, ls_ruc, &
		 ls_direccion, ls_mnz, ls_lote 
date	 ld_fecha

IF NOT of_verificar() THEN RETURN

ls_mes  = left(ddlb_mes.text,2)
ls_year = em_year.text

if ls_mes = '' or IsNull(ls_mes) then
	MessageBox('APROVISIONAMIENTO', 'EL MES ESTA VACIO, POR FAVOR VERIFIQUE',StopSign!)
	return
end if

if ls_year = '' or IsNull(ls_year) then
	MessageBox('APROVISIONAMIENTO', 'EL AÑO ESTA VACIO, POR FAVOR VERIFIQUE',StopSign!)
	return
end if

idw_1.SetRedraw(false)
idw_1.Retrieve(ls_year, ls_mes, is_cod_origen, is_cod_uso_mp)

select nombre, ruc
	into :ls_razsoc, :ls_ruc
from empresa
where cod_empresa = :gs_empresa;

select dir_calle, dir_lote, dir_mnz
	into :ls_direccion, :ls_lote, :ls_mnz
from origen
where cod_origen = :gs_origen;

ls_direccion = trim(ls_direccion)

if ls_mnz <> '' and not IsNull(ls_mnz) then
	ls_direccion = ls_direccion + ' MZ ' + ls_mnz
end if

if ls_lote <> '' and not IsNull(ls_lote) then
	ls_direccion = ls_direccion + ' LOTE ' + ls_lote
end if

// Construye la fecha para el reporte
ld_fecha = Relativedate(date(String('01'+'/'+string(dec(ls_mes)+1)+'/'+ls_year)),-1)

idw_1.object.t_ruc.text		   = ls_ruc
idw_1.object.p_logo.filename 	= 'H:\source\Jpg\produce.jpg'
idw_1.object.t_razsoc.text    = ls_razsoc
idw_1.object.t_tolva.text    	= Trim(st_tolva.text)
idw_1.object.t_balanza.text	= Trim(st_balanza.text)
idw_1.object.t_direccion.text = ls_direccion
idw_1.object.t_fecha.text     = '01 AL ' + String(ld_fecha)
idw_1.object.t_observaciones.text  = Trim(mle_1.text)

idw_1.Visible = True
idw_1.SetRedraw(true)

end event

event ue_open_pre;call super::ue_open_pre;long ll_row

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

// Para el uso de materia Prima
dw_uso_mp.SetTransObject(sqlca)
dw_uso_mp.Retrieve()

// Para mostrar los origenes
dw_origen.SetTransObject(sqlca)
dw_origen.Retrieve()
  
ll_row = dw_origen.Find ("cod_origen = '" + gs_origen +"'", 1, dw_origen.RowCount())

dw_origen.object.chec[ll_row] = '1'
//

THIS.Event ue_preview()

em_year.text 	= string(Today(), 'yyyy')
ddlb_mes.text 	= string(Today(), 'mm')

end event

event ue_preview;IF ib_preview THEN
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

event ue_saveas;call super::ue_saveas;////Overrding
//string ls_path, ls_file
//int li_rc
//
//li_rc = GetFileSaveName ( "Select File", &
//   ls_path, ls_file, "XLS", &
//   "XLS Files (*.XLS),*.XLS" , "C:\", 32770)
//
//IF li_rc = 1 Then
//   uf_save_dw_as_excel ( dw_report, ls_file )
//End If
// 
end event

type st_5 from statictext within w_ap703_decl_jur_men_tolva
integer x = 37
integer y = 28
integer width = 375
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cod_Balanza"
boolean focusrectangle = false
end type

type st_4 from statictext within w_ap703_decl_jur_men_tolva
integer x = 37
integer y = 252
integer width = 338
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Balanza:"
boolean focusrectangle = false
end type

type st_tolva from statictext within w_ap703_decl_jur_men_tolva
integer x = 402
integer y = 132
integer width = 370
integer height = 84
integer textsize = -9
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

type st_6 from statictext within w_ap703_decl_jur_men_tolva
integer x = 37
integer y = 132
integer width = 375
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tolva Nº"
boolean focusrectangle = false
end type

type st_balanza from statictext within w_ap703_decl_jur_men_tolva
integer x = 402
integer y = 240
integer width = 370
integer height = 84
integer textsize = -9
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

type sle_maquina from singlelineedit within w_ap703_decl_jur_men_tolva
event dobleclick pbm_lbuttondblclk
integer x = 402
integer y = 20
integer width = 370
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tolva, ls_balanza

ls_sql = "SELECT B.COD_MAQUINA AS COD_MAQUINA, "  &
       + "B.DESCRIPCION    AS DESCRIPCION, "  &
       + "B.COD_PRODUCE AS TOLVA,  "  &
       + "M.NRO_CHASIS  AS BALANZA "  &
		 + "FROM   BALANZA  B, "  &
       + "MAQUINA  M  "  &
		 + "WHERE  B.COD_MAQUINA  = M.COD_MAQUINA "
				  
lb_ret = f_lista_4ret_text(ls_sql, ls_codigo, ls_data, ls_tolva, ls_balanza,'1')
	
if ls_codigo <> '' then
	this.text 		 = ls_codigo
	st_tolva.text 	 = ls_tolva
	st_balanza.text = ls_balanza
end if




end event

event modified;String 	ls_maquina, ls_tolva, ls_balanza

ls_maquina = sle_maquina.text

IF ls_maquina = '' OR IsNull(ls_maquina) THEN
	MessageBox('Aviso', 'Debe Ingresar un codigo de Balanza')
	RETURN
END IF

SELECT B.COD_PRODUCE, M.NRO_CHASIS
  INTO :ls_tolva, :ls_balanza
FROM   BALANZA  B,
       MAQUINA  M
WHERE  B.COD_MAQUINA  = M.COD_MAQUINA
  AND  B.COD_MAQUINA = :ls_maquina;


IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Balanza no existe')
	st_tolva.text 		= ''
	st_balanza.text 	= ''
	return
end if

st_tolva.text   = ls_tolva
st_balanza.text = ls_balanza

end event

type st_3 from statictext within w_ap703_decl_jur_men_tolva
integer x = 59
integer y = 368
integer width = 407
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Observaciones:"
boolean focusrectangle = false
end type

type mle_1 from multilineedit within w_ap703_decl_jur_men_tolva
integer x = 558
integer y = 340
integer width = 2176
integer height = 168
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ap703_decl_jur_men_tolva
integer x = 2985
integer y = 272
integer width = 306
integer height = 148
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve()
end event

type dw_uso_mp from datawindow within w_ap703_decl_jur_men_tolva
integer x = 1879
integer y = 12
integer width = 960
integer height = 304
integer taborder = 10
string dataobject = "d_ap_uso_materia_prima_liq_pesca_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_origen from u_dw_abc within w_ap703_decl_jur_men_tolva
integer x = 818
integer y = 12
integer width = 992
integer height = 308
integer taborder = 20
string dataobject = "d_ap_origen_liq_pesca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type em_year from editmask within w_ap703_decl_jur_men_tolva
integer x = 3022
integer y = 24
integer width = 448
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
string minmax = "1900~~3000"
end type

type st_2 from statictext within w_ap703_decl_jur_men_tolva
integer x = 2866
integer y = 136
integer width = 142
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_ap703_decl_jur_men_tolva
integer x = 2871
integer y = 40
integer width = 137
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type ddlb_mes from dropdownlistbox within w_ap703_decl_jur_men_tolva
integer x = 3022
integer y = 124
integer width = 448
integer height = 388
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"01-Enero","02-Febrero","03-Marzo","04-Abril","05-Mayo","06-Junio","07-Julio","08-Agosto","09-Setiembre","10-Octubre","11-Noviembre","12-Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type dw_report from u_dw_rpt within w_ap703_decl_jur_men_tolva
integer x = 32
integer y = 532
integer width = 2871
integer height = 1284
integer taborder = 40
string dataobject = "d_ap_rpt_declara_jur_men_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;// Override
end event

