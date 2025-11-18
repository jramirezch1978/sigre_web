$PBExportHeader$w_rpt_consolidado_as406.srw
forward
global type w_rpt_consolidado_as406 from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_rpt_consolidado_as406
end type
type cb_1 from commandbutton within w_rpt_consolidado_as406
end type
type sle_codtra from singlelineedit within w_rpt_consolidado_as406
end type
type st_cod_trabajador from statictext within w_rpt_consolidado_as406
end type
type gb_3 from groupbox within w_rpt_consolidado_as406
end type
type gb_trabajador from groupbox within w_rpt_consolidado_as406
end type
type st_1 from statictext within w_rpt_consolidado_as406
end type
end forward

global type w_rpt_consolidado_as406 from w_report_smpl
int Width=3461
int Height=1644
boolean TitleBar=true
string Title="Resúmen de Marcaciones (AS406)"
string MenuName="m_reporte"
long BackColor=79741120
uo_1 uo_1
cb_1 cb_1
sle_codtra sle_codtra
st_cod_trabajador st_cod_trabajador
gb_3 gb_3
gb_trabajador gb_trabajador
st_1 st_1
end type
global w_rpt_consolidado_as406 w_rpt_consolidado_as406

on w_rpt_consolidado_as406.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_1=create cb_1
this.sle_codtra=create sle_codtra
this.st_cod_trabajador=create st_cod_trabajador
this.gb_3=create gb_3
this.gb_trabajador=create gb_trabajador
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_codtra
this.Control[iCurrent+4]=this.st_cod_trabajador
this.Control[iCurrent+5]=this.gb_3
this.Control[iCurrent+6]=this.gb_trabajador
this.Control[iCurrent+7]=this.st_1
end on

on w_rpt_consolidado_as406.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.sle_codtra)
destroy(this.st_cod_trabajador)
destroy(this.gb_3)
destroy(this.gb_trabajador)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_codigo
ls_codigo = String(sle_codtra.text)

date ld_fec_desde
date ld_fec_hasta
ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

dw_report.retrieve(ld_fec_desde,ld_fec_hasta,ls_codigo)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rpt_consolidado_as406
int X=9
int Y=400
int Width=3410
int Height=1060
int TabOrder=50
boolean BringToTop=true
string DataObject="d_rpt_consolidado_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_rpt_consolidado_as406
int X=1458
int Y=228
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

type cb_1 from commandbutton within w_rpt_consolidado_as406
int X=2866
int Y=224
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

event clicked;w_rpt_consolidado_as406.Event ue_retrieve()
end event

type sle_codtra from singlelineedit within w_rpt_consolidado_as406
int X=882
int Y=232
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

type st_cod_trabajador from statictext within w_rpt_consolidado_as406
int X=645
int Y=236
int Width=219
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Carnet"
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

type gb_3 from groupbox within w_rpt_consolidado_as406
int X=1385
int Y=152
int Width=1422
int Height=204
int TabOrder=30
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

type gb_trabajador from groupbox within w_rpt_consolidado_as406
int X=567
int Y=152
int Width=750
int Height=204
int TabOrder=40
string Text=" Número de "
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

type st_1 from statictext within w_rpt_consolidado_as406
int X=535
int Y=36
int Width=2619
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="REPORTE DEL CONSOLIDADO DE MARCACIONES DIARIAS"
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

