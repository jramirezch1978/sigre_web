$PBExportHeader$w_cm507_proveedor_especif.srw
forward
global type w_cm507_proveedor_especif from w_report_smpl
end type
end forward

global type w_cm507_proveedor_especif from w_report_smpl
integer width = 2267
integer height = 1576
string title = "Reporte Especializado Por Proveedor (CM507)"
string menuname = "m_impresion"
long backcolor = 12632256
end type
global w_cm507_proveedor_especif w_cm507_proveedor_especif

type variables
str_seleccionar  istr_1
end variables

forward prototypes
public function long of_retrieve (string as[])
end prototypes

public function long of_retrieve (string as[]);Long	 ll_row
//String ls_cadena[]

//FOR i=1 TO UpperBound(as)
//NEXT	
ll_row = idw_1.Retrieve(as[1],as[2], as[3], as[4], as[5], as[6])

Return ll_row

end function

event ue_open_pre;call super::ue_open_pre;Long	ll_row, ll_total
String lx_1[]

idw_1 = dw_report
istr_1 = Message.PowerObjectParm					// lectura de parametros

THIS.title  = istr_1.title							// asignar titulo de la ventana
THIS.width  = istr_1.width							// asignar ancho y altura de ventana
THIS.height = istr_1.height
idw_1.Visible = True

ll_row = of_retrieve(istr_1.s)

IF ll_row = 0 THEN 
	Close(This)
END IF
//idw_1.Object.p_logo.filename = is_logo
// ii_help = 101           // help topic


end event

on w_cm507_proveedor_especif.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_cm507_proveedor_especif.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_report from w_report_smpl`dw_report within w_cm507_proveedor_especif
string dataobject = "d_rpt_especializado_x_proveedor_com"
end type

