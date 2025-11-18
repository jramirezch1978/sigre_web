$PBExportHeader$w_ap733_rpt_prod_mp.srw
forward
global type w_ap733_rpt_prod_mp from w_rpt
end type
type st_descripcion from statictext within w_ap733_rpt_prod_mp
end type
type sle_proveedor from singlelineedit within w_ap733_rpt_prod_mp
end type
type cbx_prov_mp from checkbox within w_ap733_rpt_prod_mp
end type
type cb_reporte from commandbutton within w_ap733_rpt_prod_mp
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap733_rpt_prod_mp
end type
type dw_report from u_dw_rpt within w_ap733_rpt_prod_mp
end type
end forward

global type w_ap733_rpt_prod_mp from w_rpt
integer width = 3730
integer height = 2140
string title = "[AP733] Reporte de Producción x Proveedor de Materia Prima"
string menuname = "m_rpt"
st_descripcion st_descripcion
sle_proveedor sle_proveedor
cbx_prov_mp cbx_prov_mp
cb_reporte cb_reporte
uo_fecha uo_fecha
dw_report dw_report
end type
global w_ap733_rpt_prod_mp w_ap733_rpt_prod_mp

type variables
Long 		 il_fila
Datastore ids_print
end variables

forward prototypes
public function integer wf_print (string as_cod, string as_origen, string as_nro_guia)
end prototypes

public function integer wf_print (string as_cod, string as_origen, string as_nro_guia);// Impresion de la guia 
date	 ld_fecha
String ls_fecha_let
n_cst_numlet lnv_num_let
lnv_num_let = CREATE n_cst_numlet

ids_print.Retrieve(as_cod,as_origen, as_nro_guia)
ids_print.object.t_dir_prov.text = f_direccion_proveedor(as_cod, '0')
this.ids_print.Object.DataWindow.Print.Paper.Size = 256 
this.ids_print.Object.DataWindow.Print.CustomPage.Width = 250
this.ids_print.Object.DataWindow.Print.CustomPage.Length = 140
ld_fecha			= date(ids_print.object.fecha_emision[1])
ls_fecha_let	= lnv_num_let.of_numfech(ld_fecha)
ids_print.object.t_fecha.text = ls_fecha_let

ids_print.print()
return 1

end function

on w_ap733_rpt_prod_mp.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_descripcion=create st_descripcion
this.sle_proveedor=create sle_proveedor
this.cbx_prov_mp=create cbx_prov_mp
this.cb_reporte=create cb_reporte
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_descripcion
this.Control[iCurrent+2]=this.sle_proveedor
this.Control[iCurrent+3]=this.cbx_prov_mp
this.Control[iCurrent+4]=this.cb_reporte
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.dw_report
end on

on w_ap733_rpt_prod_mp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_descripcion)
destroy(this.sle_proveedor)
destroy(this.cbx_prov_mp)
destroy(this.cb_reporte)
destroy(this.uo_fecha)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 200

end event

event ue_open_pre;call super::ue_open_pre;dw_report.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_report              				// asignar dw corriente
								// 0 = menu (default), 1 = botones, 2 = menu + botones

/*Inicialización de DataSotre Boleta*/
ids_print = Create Datastore
ids_print.DataObject = 'd_rpt_liquidacion_compra_cepibo'
ids_print.SettransObject(sqlca)
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type st_descripcion from statictext within w_ap733_rpt_prod_mp
integer x = 1070
integer y = 40
integer width = 1038
integer height = 92
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_proveedor from singlelineedit within w_ap733_rpt_prod_mp
event dobleclick pbm_lbuttondblclk
integer x = 782
integer y = 40
integer width = 265
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT APM.PROVEEDOR AS CODIGO, " &
			+ "P.NOM_PROVEEDOR AS NOMBRE " &
			+ "FROM AP_PROVEEDOR_MP  APM, " &
			+ "PROVEEDOR P " &
			+ "WHERE APM.PROVEEDOR = P.PROVEEDOR AND " &
			+ "APM.FLAG_ESTADO = '1' AND " &
			+ "P.FLAG_ESTADO = '1' "
			  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
IF ls_codigo <> '' THEN
	This.text 			  = ls_codigo
	st_descripcion.text = ls_data
END IF

end event

event modified;String 	ls_proveedor, ls_desc

ls_proveedor = sle_proveedor.text

IF ls_proveedor = '' OR IsNull(ls_proveedor) THEN
	MessageBox('Aviso', 'Debe Ingresar un codigo de Proveedor')
	RETURN
END IF

SELECT P.NOM_PROVEEDOR
  INTO :ls_desc
  FROM AP_PROVEEDOR_MP  APM,
       PROVEEDOR P
  WHERE APM.PROVEEDOR = P.PROVEEDOR AND
  	   P.PROVEEDOR = :ls_proveedor AND
        APM.FLAG_ESTADO = '1' AND
        P.FLAG_ESTADO = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Proveedor no existe')
	st_descripcion.text = ''
	This.Text			  = ''
	RETURN
END IF

st_descripcion.text = ls_desc

end event

type cbx_prov_mp from checkbox within w_ap733_rpt_prod_mp
integer x = 50
integer y = 44
integer width = 681
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los Proveedores"
boolean checked = true
end type

event clicked;IF CBX_prov_mp.CHecked = TRUE THEN
	SLE_proveedor.Enabled = FALSE
	sle_proveedor.text = ""
	st_descripcion.text = ""
ELSE
	SLE_PRoveedor.Enabled = TRUE
END IF
end event

type cb_reporte from commandbutton within w_ap733_rpt_prod_mp
integer x = 2213
integer y = 40
integer width = 416
integer height = 164
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;date   ld_fecha_ini, ld_fecha_fin
string ls_proveedor

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

IF CBX_prov_mp.CHecked = TRUE THEN
	ls_proveedor = "%"
ELSE
	IF sle_proveedor.text = ""  THEN
		MessageBox("Aviso SIGRE","Debe Seleccionar un Proveedor")
		return
	END IF
	ls_proveedor = sle_proveedor.text
END IF

dw_report.SetTransObject(SQLCA)
dw_report.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_proveedor)

end event

type uo_fecha from u_ingreso_rango_fechas within w_ap733_rpt_prod_mp
integer x = 32
integer y = 148
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date ld_fecini, ld_fecfin
string ls_fecha


ld_fecini = Date('01/'+string(Today(),'mm/yyyy') )

if string(Today(), 'mm' ) <> '12' then
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Today(), 'yyyy')), -1)
else
	ld_fecfin = RelativeDate(Date('01/' + '01' + '/' + string( Integer( string(Today(), 'yyyy') ) +1 ) ), -1)

end if

of_set_label('Desde:','Hasta:') 				// para setear el titulo del boton
of_set_fecha( ld_fecini, ld_fecfin)			// para setear la fecha
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type dw_report from u_dw_rpt within w_ap733_rpt_prod_mp
integer y = 268
integer width = 3579
integer height = 1464
string dataobject = "d_rpt_prod_prov_mp"
boolean vscrollbar = true
end type

event clicked;//override

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;
//is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


//ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_ck[2] = 2

//idw_mst = dw_report // dw_master

end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;//****************************************************************************************//
// Objectivo : Codigo para la seleccion en bloque.                                        //
// Argumento : This   -> Datawindows Actual.                                        //
//             as_indicador -> 'S'   Selección Simple                                     //
//                             'M'   Selección Multiple                                   //
// Sintaxis  : uf_seleccion(This,as_indicador)
//****************************************************************************************//

Integer  li_inicio, li_fin
String   ls_campo

This.AcceptText()

IF This.getrow() <= 0 THEN RETURN


IF KeyDown(KeyControl!) THEN
	il_fila = This.getrow()
	
//	Messagebox('il_fila',il_fila)
	
	IF This.IsSelected(il_fila) THEN
		This.SelectRow(il_fila , False)
	ELSE
		This.SelectRow(il_fila , True)
	END IF
	RETURN
END IF

IF KeyDown(KeyShift!) THEN
	li_inicio = This.getrow()
	IF (il_fila - li_inicio) > 0 THEN
		FOR li_fin = il_fila TO li_inicio STEP -1 
			This.SelectRow( li_fin , True)
		NEXT
	ELSE
		FOR li_fin = il_fila TO li_inicio
			 This.SelectRow( li_fin , True)
		NEXT
	END IF
	RETURN
END IF

il_fila = This.getrow()
This.setrow(il_fila)
This.SelectRow(0, False)
This.SelectRow(This.getrow() , True)
end event

