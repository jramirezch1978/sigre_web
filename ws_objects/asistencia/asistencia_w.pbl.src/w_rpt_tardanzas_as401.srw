$PBExportHeader$w_rpt_tardanzas_as401.srw
forward
global type w_rpt_tardanzas_as401 from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_rpt_tardanzas_as401
end type
type cb_1 from commandbutton within w_rpt_tardanzas_as401
end type
type rb_1 from radiobutton within w_rpt_tardanzas_as401
end type
type rb_2 from radiobutton within w_rpt_tardanzas_as401
end type
type rb_3 from radiobutton within w_rpt_tardanzas_as401
end type
type sle_codtra from singlelineedit within w_rpt_tardanzas_as401
end type
type st_cod_trabajador from statictext within w_rpt_tardanzas_as401
end type
type gb_3 from groupbox within w_rpt_tardanzas_as401
end type
type gb_2 from groupbox within w_rpt_tardanzas_as401
end type
type gb_trabajador from groupbox within w_rpt_tardanzas_as401
end type
type st_1 from statictext within w_rpt_tardanzas_as401
end type
end forward

global type w_rpt_tardanzas_as401 from w_report_smpl
int Width=3461
int Height=1644
boolean TitleBar=true
string Title="Minutos Acumulados de Tardanzas (AS401)"
string MenuName="m_reporte"
long BackColor=79741120
uo_1 uo_1
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
sle_codtra sle_codtra
st_cod_trabajador st_cod_trabajador
gb_3 gb_3
gb_2 gb_2
gb_trabajador gb_trabajador
st_1 st_1
end type
global w_rpt_tardanzas_as401 w_rpt_tardanzas_as401

on w_rpt_tardanzas_as401.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.sle_codtra=create sle_codtra
this.st_cod_trabajador=create st_cod_trabajador
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_trabajador=create gb_trabajador
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.sle_codtra
this.Control[iCurrent+7]=this.st_cod_trabajador
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_trabajador
this.Control[iCurrent+11]=this.st_1
end on

on w_rpt_tardanzas_as401.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.sle_codtra)
destroy(this.st_cod_trabajador)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_trabajador)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_tipo_trabajador
String ls_sit
String ls_codigo
ls_codigo = String(sle_codtra.text)

If rb_1.checked = true then
	ls_tipo_trabajador = 'OBR'
	ls_sit = 'O B R E R O S'
ElseIf rb_2.checked = true then
	ls_tipo_trabajador = 'EMP'
	ls_sit = 'E M P L E A D O S'
Else
	ls_tipo_trabajador = '   '
End if

If rb_3.checked = true then
  Select tipo_trabajador
    into :ls_tipo_trabajador
    from maestro 
    where cod_trabajador = :ls_codigo ;
    If ls_tipo_trabajador = 'OBR' then
      ls_sit = 'O B R E R O S'
    End if
    If ls_tipo_trabajador = 'EMP' then
	   ls_sit = 'E M P L E A D O S'
    End if
End if

date ld_fec_desde
date ld_fec_hasta
ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

dw_report.settransobject(sqlca)
choose case dw_report.DataObject
	case 'd_rpt_tardanzas_tbl'
		  DECLARE pb_usp_rpt_tardanzas PROCEDURE FOR USP_RPT_TARDANZAS
          (:ld_fec_desde, :ld_fec_hasta, :ls_tipo_trabajador) ;
		  Execute pb_usp_rpt_tardanzas ;
		  dw_report.retrieve(ld_fec_desde,ld_fec_hasta,ls_tipo_trabajador)
	case 'd_rpt_tardanzas_t_tbl'
		  DECLARE pb_usp_rpt_tardanzas_t PROCEDURE FOR USP_RPT_TARDANZAS_T
          (:ld_fec_desde, :ld_fec_hasta, :ls_codigo) ;
		  Execute pb_usp_rpt_tardanzas_t ;
		  dw_report.retrieve(ld_fec_desde,ld_fec_hasta,ls_codigo)
end choose

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.st_sit.text = ls_sit

end event

type dw_report from w_report_smpl`dw_report within w_rpt_tardanzas_as401
int X=9
int Y=476
int Width=3410
int Height=984
int TabOrder=50
boolean BringToTop=true
end type

type uo_1 from u_ingreso_rango_fechas within w_rpt_tardanzas_as401
int X=1691
int Y=280
int Height=96
int TabOrder=10
boolean BringToTop=true
end type

event constructor;call super::constructor;string ls_inicio, ls_fec 
date ld_fec
uo_1.of_set_label('Desde','Hasta')

// Obtiene primer día del mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 uo_1.of_set_fecha(date(ls_inicio),today())
 uo_1.of_set_rango_inicio(date('01/01/1900'))   // rango inicial
 uo_1.of_set_rango_fin(date('31/12/9999'))      // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_rpt_tardanzas_as401
int X=3099
int Y=276
int Width=274
int Height=80
int TabOrder=60
boolean BringToTop=true
string Text="Aceptar"
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;w_rpt_tardanzas_as401.Event ue_retrieve()
end event

type rb_1 from radiobutton within w_rpt_tardanzas_as401
int X=274
int Y=204
int Width=411
int Height=76
boolean BringToTop=true
string Text="Obreros"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//  Mantiene selección desactivada del código
gb_trabajador.enabled     = false
gb_trabajador.visible     = true
st_cod_trabajador.visible = true
sle_codtra.enabled        = false
sle_codtra.visible        = true

dw_report.DataObject= 'd_rpt_tardanzas_tbl'
end event

type rb_2 from radiobutton within w_rpt_tardanzas_as401
int X=274
int Y=276
int Width=411
int Height=76
boolean BringToTop=true
string Text="Empleados"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//  Mantiene selección desactivada del código
gb_trabajador.enabled     = false
gb_trabajador.visible     = true
st_cod_trabajador.visible = true
sle_codtra.enabled        = false
sle_codtra.visible        = true

dw_report.DataObject= 'd_rpt_tardanzas_tbl'
end event

type rb_3 from radiobutton within w_rpt_tardanzas_as401
int X=274
int Y=348
int Width=411
int Height=76
boolean BringToTop=true
string Text="Código"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//  Activa selección de código del trabajador
gb_trabajador.enabled     = true
gb_trabajador.visible     = true
st_cod_trabajador.visible = true
sle_codtra.enabled        = true
sle_codtra.visible        = true

sle_codtra.setfocus()

dw_report.DataObject= 'd_rpt_tardanzas_t_tbl'
end event

type sle_codtra from singlelineedit within w_rpt_tardanzas_as401
int X=1115
int Y=284
int Width=329
int Height=80
int TabOrder=20
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
TextCase TextCase=Upper!
long TextColor=16711680
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_cod_trabajador from statictext within w_rpt_tardanzas_as401
int X=878
int Y=288
int Width=219
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Código"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_3 from groupbox within w_rpt_tardanzas_as401
int X=1618
int Y=204
int Width=1422
int Height=204
int TabOrder=20
string Text=" Ingrese Rango de Fechas "
BorderStyle BorderStyle=StyleRaised!
long TextColor=255
long BackColor=79741120
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_2 from groupbox within w_rpt_tardanzas_as401
int X=197
int Y=140
int Width=544
int Height=304
int TabOrder=30
string Text=" Opción "
BorderStyle BorderStyle=StyleRaised!
long TextColor=255
long BackColor=79741120
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_trabajador from groupbox within w_rpt_tardanzas_as401
int X=800
int Y=204
int Width=750
int Height=204
int TabOrder=40
string Text=" Identificación Trabajador "
BorderStyle BorderStyle=StyleRaised!
long TextColor=255
long BackColor=79741120
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_rpt_tardanzas_as401
int X=201
int Y=36
int Width=3182
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="REPORTE DIARIO DE TARDANZAS"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=67108864
int TextSize=-12
int Weight=700
string FaceName="Century Gothic"
boolean Underline=true
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

