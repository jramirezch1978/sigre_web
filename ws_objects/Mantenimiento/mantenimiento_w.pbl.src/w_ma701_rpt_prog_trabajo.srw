$PBExportHeader$w_ma701_rpt_prog_trabajo.srw
forward
global type w_ma701_rpt_prog_trabajo from w_report_smpl
end type
type cb_generar from commandbutton within w_ma701_rpt_prog_trabajo
end type
type dw_1 from datawindow within w_ma701_rpt_prog_trabajo
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ma701_rpt_prog_trabajo
end type
type gb_1 from groupbox within w_ma701_rpt_prog_trabajo
end type
end forward

global type w_ma701_rpt_prog_trabajo from w_report_smpl
integer width = 3456
integer height = 1788
string title = "Programacion semanal de labores de mantenimiento (MA701)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
cb_generar cb_generar
dw_1 dw_1
uo_fecha uo_fecha
gb_1 gb_1
end type
global w_ma701_rpt_prog_trabajo w_ma701_rpt_prog_trabajo

type variables

end variables

on w_ma701_rpt_prog_trabajo.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_generar=create cb_generar
this.dw_1=create dw_1
this.uo_fecha=create uo_fecha
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generar
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.gb_1
end on

on w_ma701_rpt_prog_trabajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_generar)
destroy(this.dw_1)
destroy(this.uo_fecha)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;idw_1.Visible = True


ib_preview = false
this.event ue_preview()


idw_1.Object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_ma701_rpt_prog_trabajo
integer x = 0
integer y = 452
integer width = 3378
integer height = 1108
string dataobject = "d_rpt_prog_trabajo_tbl"
end type

type cb_generar from commandbutton within w_ma701_rpt_prog_trabajo
integer x = 2985
integer y = 268
integer width = 402
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String ls_cencos, ls_tipo, ls_texto
Long   ll_count, ll_row
Date   ld_fini, ld_ffin

cb_generar.enabled = false

dw_1.Accepttext()

ld_fini   = uo_fecha.of_get_fecha1()
ld_ffin   = uo_fecha.of_get_fecha2()
ls_cencos = dw_1.object.cencos     [1]

ls_texto = 'Del ' + string(ld_fini,'dd/mm/yyyy') + ' al ' + string(ld_ffin,'dd/mm/yyyy')

IF Isnull(ls_cencos) OR Trim(ls_cencos) = '' THEN
	Messagebox('Aviso','Debe Ingresar Centro de Costo')
	Return
END IF



/*Eliminacion de Infomación Temporal*/
delete from tt_man_prog_trabajo ;
/**/

DECLARE PB_USP_MTT_PROG_TRABAJO PROCEDURE FOR USP_MTT_PROG_TRABAJO ( :ls_cencos,  :ld_fini, :ld_ffin ,:ls_tipo) ;
execute PB_USP_MTT_PROG_TRABAJO ;

IF sqlca.sqlcode = -1 THEN
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	ROLLBACK ;
	Return
END IF

dw_report.Object.t_texto.text = ls_texto
dw_report.Object.t_empresa.text = gs_empresa

dw_report.retrieve()
ib_preview = false
parent.event ue_preview()

cb_generar.enabled = true

end event

type dw_1 from datawindow within w_ma701_rpt_prog_trabajo
integer x = 55
integer y = 100
integer width = 2030
integer height = 104
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_ext_cencos_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;SetTransObject(sqlca)
InsertRow(0)
end event

event doubleclicked;IF Getrow() = 0 THEN Return
String ls_name ,ls_prot ,ls_nombre
str_seleccionar lstr_seleccionar
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
  return
end if

IF dwo.name = 'cencos' THEN 
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS ,'&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESC_CENCOS  '&
									   				 +'FROM CENTROS_COSTO '

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cencos',lstr_seleccionar.param2[1])
				END IF
END IF
end event

event itemchanged;String ls_nombre,ls_codigo
Long   ll_count

Accepttext()

IF dwo.name = 'cencos' THEN 
	SELECT Count(*)
	  INTO :ll_count
	  FROM centros_costo
	 WHERE (cencos = :data );
	
	IF ll_count > 0 THEN
		SELECT desc_cencos
   	  INTO :ls_nombre
		  FROM centros_costo
		 WHERE (cencos = :data );
	
		This.Object.desc_cencos [row] =  ls_nombre
	ELSE

		Setnull(ls_codigo)
		Setnull(ls_nombre)

		Messagebox('Aviso','Debe Ingresar Un Centro de Costo Valido')
		This.Object.cencos 	   [row] =  ls_codigo
		This.Object.desc_cencos [row] =  ls_nombre
		Return 2
	END IF
END IF
end event

event itemerror;Return 1
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_ma701_rpt_prog_trabajo
integer x = 2199
integer y = 28
integer taborder = 60
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;of_set_label("Desde :","Hasta :")
of_set_fecha(TODAY(),TODAY())
of_set_rango_inicio(DATE('01/01/1900'))
of_set_rango_fin(DATE('31/12/9999'))
end event

type gb_1 from groupbox within w_ma701_rpt_prog_trabajo
integer x = 23
integer y = 20
integer width = 2121
integer height = 224
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo Responsable"
end type

