$PBExportHeader$w_ma510_costos_mantenimiento_x_grp.srw
forward
global type w_ma510_costos_mantenimiento_x_grp from w_rpt
end type
type dw_ext from datawindow within w_ma510_costos_mantenimiento_x_grp
end type
type cb_3 from commandbutton within w_ma510_costos_mantenimiento_x_grp
end type
type uo_1 from u_ingreso_rango_fechas within w_ma510_costos_mantenimiento_x_grp
end type
type dw_report from u_dw_rpt within w_ma510_costos_mantenimiento_x_grp
end type
type dw_grp from u_dw_grf within w_ma510_costos_mantenimiento_x_grp
end type
type gb_1 from groupbox within w_ma510_costos_mantenimiento_x_grp
end type
end forward

global type w_ma510_costos_mantenimiento_x_grp from w_rpt
integer width = 3639
integer height = 2024
string title = "Costos de Mantenimiento (MA510)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
integer ii_x = 0
dw_ext dw_ext
cb_3 cb_3
uo_1 uo_1
dw_report dw_report
dw_grp dw_grp
gb_1 gb_1
end type
global w_ma510_costos_mantenimiento_x_grp w_ma510_costos_mantenimiento_x_grp

type variables

end variables

forward prototypes
public function integer of_new_sheet (str_cns_pop astr_1)
public subroutine of_close_sheet ()
end prototypes

public function integer of_new_sheet (str_cns_pop astr_1);Integer li_rc
w_cns_pop	lw_sheet
					
li_rc = OpenSheetWithParm(lw_sheet, astr_1, this, 0, Original!)
ii_x ++
iw_sheet[ii_x]  = lw_sheet
					
RETURN li_rc     		

end function

public subroutine of_close_sheet ();
Integer	 li_x

FOR li_x = 1 to ii_x							// eliminar todas las ventanas pop
	IF IsValid(iw_sheet[li_x]) THEN close(iw_sheet[li_x])
NEXT
end subroutine

event resize;call super::resize;dw_report.height = newheight - dw_report.y
dw_grp.height = newheight - dw_grp.y
dw_grp.width = newwidth - dw_grp.x
end event

event ue_open_pre();call super::ue_open_pre;of_position(0,0)
idw_1 = dw_report
idw_1.SetTransObject(sqlca)
dw_grp.SetTransObject(sqlca)
idw_1.ii_zoom_actual = 100
Trigger Event ue_preview()


// ii_help = 101           // help topic

end event

on w_ma510_costos_mantenimiento_x_grp.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_ext=create dw_ext
this.cb_3=create cb_3
this.uo_1=create uo_1
this.dw_report=create dw_report
this.dw_grp=create dw_grp
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ext
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.dw_grp
this.Control[iCurrent+6]=this.gb_1
end on

on w_ma510_costos_mantenimiento_x_grp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ext)
destroy(this.cb_3)
destroy(this.uo_1)
destroy(this.dw_report)
destroy(this.dw_grp)
destroy(this.gb_1)
end on

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

type dw_ext from datawindow within w_ma510_costos_mantenimiento_x_grp
integer x = 64
integer y = 224
integer width = 1486
integer height = 208
integer taborder = 60
string title = "none"
string dataobject = "d_ext_grupo_maquina_tab"
boolean border = false
boolean livescroll = true
end type

event constructor;SettransObject(sqlca)
InsertRow(0)
end event

event itemchanged;Accepttext()
end event

event itemerror;Return 1
end event

type cb_3 from commandbutton within w_ma510_costos_mantenimiento_x_grp
integer x = 3104
integer y = 344
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_cod_grupo,ls_tip_costo
Date   ld_fecha_inicio, ld_fecha_final

dw_ext.Accepttext()
ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()  



ls_cod_grupo = dw_ext.object.cod_grupo [1]
ls_tip_costo = dw_ext.object.tip_costo [1]

IF Isnull(ls_cod_grupo) OR Trim(ls_cod_grupo) = '' THEN
	ls_cod_grupo = '%'	
END IF

IF Isnull(ls_tip_costo) OR Trim(ls_tip_costo) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Costo')		
	Return 
END IF

ROLLBACK ;

DECLARE pb_usp_cal_op_ot PROCEDURE FOR USP_MTT_CAL_OP_OT_X_GRP_MAQ
(:ls_cod_grupo,:ld_fecha_inicio,:ld_fecha_final,:ls_tip_costo)  ;
EXECUTE pb_usp_cal_op_ot;	


IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
	RETURN
END IF

dw_report.Retrieve(gs_empresa,gs_user)
dw_grp.Retrieve()
dw_report.Object.p_logo.filename = gs_logo
end event

type uo_1 from u_ingreso_rango_fechas within w_ma510_costos_mantenimiento_x_grp
integer x = 64
integer y = 140
integer width = 1431
integer taborder = 40
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(today(), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_ma510_costos_mantenimiento_x_grp
integer x = 23
integer y = 484
integer width = 2423
integer height = 720
integer taborder = 20
string dataobject = "d_rpt_ot_operaciones_x_grp_maq_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_tipo_ot
str_cns_pop  lstr_1

CHOOSE CASE dwo.name
		 CASE 'des_tipo_ot'
				ls_tipo_ot = This.Object.tipo_ot[row]
				lstr_1.DataObject = 'd_rpt_ot_operaciones_det_grupo_maq_tbl' // asignar datawindow
				lstr_1.title	   = 'Ordenes de Trabajo'				 // asignar titulo de la ventana
				lstr_1.width 		= 2500		// asignar ancho y altura de ventana
				lstr_1.height 		= 1300		//
				lstr_1.arg[1] 		= ls_tipo_ot	
				
				of_new_sheet(lstr_1)
						
END CHOOSE




end event

type dw_grp from u_dw_grf within w_ma510_costos_mantenimiento_x_grp
integer x = 2459
integer y = 484
integer width = 1001
integer height = 720
string dataobject = "d_rpt_ot_operaciones_grp"
end type

type gb_1 from groupbox within w_ma510_costos_mantenimiento_x_grp
integer x = 18
integer y = 32
integer width = 1577
integer height = 432
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Datos :"
borderstyle borderstyle = stylelowered!
end type

