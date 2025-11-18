$PBExportHeader$w_ma507_gastos_mntto_maq.srw
forward
global type w_ma507_gastos_mntto_maq from w_cns
end type
type dw_consulta from u_dw_cns within w_ma507_gastos_mntto_maq
end type
type uo_fechas from u_ingreso_rango_fechas within w_ma507_gastos_mntto_maq
end type
type st_1 from statictext within w_ma507_gastos_mntto_maq
end type
type cb_1 from commandbutton within w_ma507_gastos_mntto_maq
end type
type cb_2 from commandbutton within w_ma507_gastos_mntto_maq
end type
type dw_grafico from datawindow within w_ma507_gastos_mntto_maq
end type
end forward

global type w_ma507_gastos_mntto_maq from w_cns
integer width = 2898
integer height = 1684
string title = "Gastos de mantenimientos de máquina (MA507)"
string menuname = "m_cns"
dw_consulta dw_consulta
uo_fechas uo_fechas
st_1 st_1
cb_1 cb_1
cb_2 cb_2
dw_grafico dw_grafico
end type
global w_ma507_gastos_mntto_maq w_ma507_gastos_mntto_maq

on w_ma507_gastos_mntto_maq.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.dw_consulta=create dw_consulta
this.uo_fechas=create uo_fechas
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_grafico=create dw_grafico
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_consulta
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.dw_grafico
end on

on w_ma507_gastos_mntto_maq.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_consulta)
destroy(this.uo_fechas)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_grafico)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)
//Help
ii_help = 507

dw_consulta.SettransObject(SQLCA)
dw_grafico.SettransObject(SQLCA)

dw_grafico.visible = FALSE
uo_fechas.of_set_label("Desde","Hasta")
uo_fechas.of_set_fecha(TODAY(),TODAY())
uo_fechas.of_set_rango_inicio(DATE('01/01/1900'))
uo_fechas.of_set_rango_fin(DATE('31/12/9999'))
end event

type dw_consulta from u_dw_cns within w_ma507_gastos_mntto_maq
integer x = 9
integer y = 224
integer width = 2839
integer height = 1344
boolean bringtotop = true
string dataobject = "d_cons_gastos_equipos"
end type

event doubleclicked;call super::doubleclicked;integer li_gastos
STR_CNS_POP lstr_1

If row = 0 THEN RETURN

CHOOSE CASE dwo.name
	CASE "monto_oper_pre"
        lstr_1.DataObject = 'd_cons_gastos_ope_tbl'
        lstr_1.Width = 3000
        lstr_1.Height= 1300
        lstr_1.Title = 'Detalle de Gastos de operaciones preventivo'
        lstr_1.Arg[1] = String(GetItemNumber(row,'nro_orden'))
		  lstr_1.Arg[2] = GetItemstring(row,"flag_tipo_ot")
        lstr_1.NextCol = 'xx'
        of_new_sheet(lstr_1)
	CASE "monto_ins_pre"
	     lstr_1.DataObject = 'd_cons_gastos_ins_tbl'
        lstr_1.Width = 3000
        lstr_1.Height= 1300
        lstr_1.Title = 'Detalle de Gastos de insumos preventivo'
        lstr_1.Arg[1] = String(GetItemNumber(row,'nro_orden'))
		  lstr_1.Arg[2] = GetItemstring(row,"flag_tipo_ot")
        lstr_1.NextCol = 'xx'
        of_new_sheet(lstr_1)
	CASE "monto_oper_cor"
        lstr_1.DataObject = 'd_cons_gastos_ope_tbl'
        lstr_1.Width = 3000
        lstr_1.Height= 1300
        lstr_1.Title = 'Detalle de Gastos de operaciones Correctivo'
        lstr_1.Arg[1] = String(GetItemNumber(row,'nro_orden'))
        lstr_1.NextCol = 'xx'
        of_new_sheet(lstr_1)
	CASE "monto_ins_cor"
	     lstr_1.DataObject = 'd_cons_gastos_ins_tbl'
        lstr_1.Width = 3000
        lstr_1.Height= 1300
        lstr_1.Title = 'Detalle de Gastos de insumos preventivo'
        lstr_1.Arg[1] = String(GetItemNumber(row,'nro_orden'))
		  lstr_1.Arg[2] = GetItemstring(row,"flag_tipo_ot")
        lstr_1.NextCol = 'xx'
        of_new_sheet(lstr_1)
END CHOOSE		
end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

type uo_fechas from u_ingreso_rango_fechas within w_ma507_gastos_mntto_maq
integer x = 27
integer y = 132
integer taborder = 20
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type st_1 from statictext within w_ma507_gastos_mntto_maq
integer x = 539
integer y = 28
integer width = 1632
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "GASTOS DE MANTENIMIENTO DE EQUIPOS"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ma507_gastos_mntto_maq
integer x = 1335
integer y = 140
integer width = 357
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;DATE ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

DECLARE usp_gastos_equipos PROCEDURE FOR USP_MTT_GASTOS_MANTEN(  
        :ld_fec_ini, :ld_fec_fin);
execute usp_gastos_equipos;	
dw_consulta.retrieve() 
ROLLBACK;
end event

type cb_2 from commandbutton within w_ma507_gastos_mntto_maq
integer x = 2464
integer y = 132
integer width = 357
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grafico"
end type

event clicked;DATE ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

dw_grafico.visible = TRUE

DECLARE usp_gastos_graf PROCEDURE FOR USP_GASTOS_MANTEN_GRAF(  
        :ld_fec_ini, :ld_fec_fin);
execute usp_gastos_graf;	
dw_grafico.retrieve()
ROLLBACK;

end event

type dw_grafico from datawindow within w_ma507_gastos_mntto_maq
integer x = 14
integer y = 228
integer width = 2834
integer height = 1336
integer taborder = 30
string dataobject = "d_cons_gastos_manten_gr"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_grafico.visible = FALSE
end event

