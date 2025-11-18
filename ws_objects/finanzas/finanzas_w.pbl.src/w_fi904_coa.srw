$PBExportHeader$w_fi904_coa.srw
forward
global type w_fi904_coa from w_prc
end type
type dw_report from datawindow within w_fi904_coa
end type
type cb_3 from commandbutton within w_fi904_coa
end type
type cb_1 from commandbutton within w_fi904_coa
end type
type cb_2 from commandbutton within w_fi904_coa
end type
type st_3 from statictext within w_fi904_coa
end type
type sle_1 from singlelineedit within w_fi904_coa
end type
type dw_1 from u_dw_cns within w_fi904_coa
end type
type st_1 from statictext within w_fi904_coa
end type
type st_2 from statictext within w_fi904_coa
end type
type rb_1 from radiobutton within w_fi904_coa
end type
type rb_2 from radiobutton within w_fi904_coa
end type
type rb_3 from radiobutton within w_fi904_coa
end type
type em_ano from editmask within w_fi904_coa
end type
type ddlb_mes from dropdownlistbox within w_fi904_coa
end type
type gb_1 from groupbox within w_fi904_coa
end type
end forward

global type w_fi904_coa from w_prc
integer width = 3429
integer height = 2268
string title = "Generacion de COA (FI904)"
string menuname = "m_proceso_salida"
dw_report dw_report
cb_3 cb_3
cb_1 cb_1
cb_2 cb_2
st_3 st_3
sle_1 sle_1
dw_1 dw_1
st_1 st_1
st_2 st_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
em_ano em_ano
ddlb_mes ddlb_mes
gb_1 gb_1
end type
global w_fi904_coa w_fi904_coa

event open;call super::open;dw_1.settransobject(sqlca)
dw_report.settransobject(sqlca)

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user

end event

on w_fi904_coa.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_salida" then this.MenuID = create m_proceso_salida
this.dw_report=create dw_report
this.cb_3=create cb_3
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_3=create st_3
this.sle_1=create sle_1
this.dw_1=create dw_1
this.st_1=create st_1
this.st_2=create st_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.em_ano=create em_ano
this.ddlb_mes=create ddlb_mes
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.rb_2
this.Control[iCurrent+12]=this.rb_3
this.Control[iCurrent+13]=this.em_ano
this.Control[iCurrent+14]=this.ddlb_mes
this.Control[iCurrent+15]=this.gb_1
end on

on w_fi904_coa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.cb_3)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_3)
destroy(this.sle_1)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.em_ano)
destroy(this.ddlb_mes)
destroy(this.gb_1)
end on

type dw_report from datawindow within w_fi904_coa
boolean visible = false
integer x = 69
integer y = 524
integer width = 2866
integer height = 1140
integer taborder = 50
boolean titlebar = true
string title = "Reporte de Verificacion"
string dataobject = "d_rpt058_coa_verificacion_tbl"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_fi904_coa
integer x = 1129
integer y = 1900
integer width = 402
integer height = 112
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;String ls_msj_err
Long   ll_ano,ll_mes

if rb_2.checked then //genera reporte

	//d_rpt058_coa_verificacion_tbl
	
	ll_ano = long(trim(em_ano.text))
	ll_mes = long(trim(LEFT(ddlb_mes.text,2)))

	if Isnull(ll_ano) or ll_ano = 0 then
		Messagebox('Aviso','Debe Ingresar algun Año Valido ,Verifique!')
		Return
	end if

	if Isnull(ll_mes) or ll_mes = 0 then
		Messagebox('Aviso','Debe Ingresar algun Mes Valido ,Verifique!')
		Return
	end if
	
	
	DECLARE PB_USP_FIN_COA_X58_rpt PROCEDURE FOR USP_FIN_COA_X58_rpt
	(:ll_ano, :ll_mes);
	EXECUTE PB_USP_FIN_COA_X58_rpt ;

	IF SQLCA.SQLCode = -1 THEN
	   ls_msj_err = SQLCA.SQLErrText
      MessageBox('SQL error', ls_msj_err)
		Rollback ;
	END IF

	CLOSE PB_USP_FIN_COA_X58_rpt ;
	
	//recuperar informacion 
	
	dw_report.retrieve(ll_ano,ll_mes)
	dw_report.Visible = TRUE
end if
end event

type cb_1 from commandbutton within w_fi904_coa
integer x = 1129
integer y = 1764
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_msj_err
String ls_ttcoa_prov = 'N', ls_ttcoa_ndnc = 'N',ls_ttcoa_cp = 'N'
Long   ll_ano ,ll_mes,ll_count


//LIMPIAR DW
dw_1.reset()
sle_1.text = '0'


ll_ano = long(trim(em_ano.text))
ll_mes = long(trim(LEFT(ddlb_mes.text,2)))



if Isnull(ll_ano) or ll_ano = 0 then
	Messagebox('Aviso','Debe Ingresar algun Año Valido ,Verifique!')
	Return
end if

if Isnull(ll_mes) or ll_mes = 0 then
	Messagebox('Aviso','Debe Ingresar algun Mes Valido ,Verifique!')
	Return
end if


IF rb_1.checked = TRUE THEN
	ls_ttcoa_prov = 'S'
ELSEIF rb_2.checked = TRUE THEN
	ls_ttcoa_cp = 'S'
ELSEIF rb_3.checked = TRUE THEN	
   ls_ttcoa_ndnc = 'S'
END IF


DECLARE PB_USP_FIN_COA PROCEDURE FOR USP_FIN_COA
(:ls_ttcoa_prov ,:ls_ttcoa_cp ,:ls_ttcoa_ndnc , :ll_ano, :ll_mes);
EXECUTE PB_USP_FIN_COA ;

IF SQLCA.SQLCode = -1 THEN
    ls_msj_err = SQLCA.SQLErrText
    MessageBox('SQL error', ls_msj_err)
END IF

CLOSE PB_USP_FIN_COA ;

dw_1.retrieve()

cb_2.enabled = true

ll_count = dw_1.rowcount()
sle_1.text = Trim(String(ll_count))
end event

type cb_2 from commandbutton within w_fi904_coa
integer x = 1586
integer y = 1764
integer width = 571
integer height = 112
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Genera Archivo TXT"
end type

event clicked;String  ls_nomb_arch ,ls_path
Integer li_filenum


ls_path='/COA' //NOMBRE DE DIRECTORIO

if rb_1.checked then
	ls_nomb_arch = 'X61COAPR.ASC'
elseif rb_2.checked then
	ls_nomb_arch = 'X58CPCOA.ASC'
elseif rb_3.checked then
	ls_nomb_arch = 'X68CPCOA.ASC'
end if


If DirectoryExists ( ls_path ) Then
	//ya existe directorio

Else
	//CREACION DE CARPETA
	CreateDirectory ( ls_path )

	li_filenum = ChangeDirectory( ls_path )

	if li_filenum = -1 then
		Messagebox('Aviso','Fallo Creacion de Directorio COA')
		RETURN
	end if	

End If



dw_1.SaveAs("\COA\"+ls_nomb_arch,TEXT!, FALSE)


Messagebox('Aviso','Se Genero Archivo COA '+ls_nomb_arch)
end event

type st_3 from statictext within w_fi904_coa
integer x = 87
integer y = 1784
integer width = 526
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Total de Registros :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_fi904_coa
integer x = 635
integer y = 1776
integer width = 370
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 65535
borderstyle borderstyle = stylelowered!
end type

type dw_1 from u_dw_cns within w_fi904_coa
integer x = 18
integer y = 416
integer width = 3054
integer height = 1272
integer taborder = 40
string dataobject = "d_abc_coa_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez


 ii_ck[1] = 1         // columnas de lectrua de este dw

	
end event

type st_1 from statictext within w_fi904_coa
integer y = 64
integer width = 215
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi904_coa
integer x = 562
integer y = 72
integer width = 224
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
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_fi904_coa
integer x = 96
integer y = 244
integer width = 777
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferencia Proveedores"
end type

event clicked;if this.checked then
	cb_2.enabled = false
	dw_1.reset()
end if
	
end event

type rb_2 from radiobutton within w_fi904_coa
integer x = 969
integer y = 240
integer width = 1042
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferencia Comprobante de Pago"
end type

event clicked;if this.checked then
	cb_2.enabled = false
	dw_1.reset()
end if
	
end event

type rb_3 from radiobutton within w_fi904_coa
integer x = 2057
integer y = 240
integer width = 896
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferencia de NC y NDebito"
end type

event clicked;if this.checked then
	cb_2.enabled = false
	dw_1.reset()
end if
	
end event

type em_ano from editmask within w_fi904_coa
integer x = 233
integer y = 60
integer width = 174
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type ddlb_mes from dropdownlistbox within w_fi904_coa
integer x = 823
integer y = 52
integer width = 517
integer height = 856
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_fi904_coa
integer x = 5
integer y = 172
integer width = 3077
integer height = 196
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferencia a COA"
end type

