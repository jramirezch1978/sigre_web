$PBExportHeader$w_ap318_imp_liq_comp.srw
forward
global type w_ap318_imp_liq_comp from w_abc
end type
type cb_1 from commandbutton within w_ap318_imp_liq_comp
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap318_imp_liq_comp
end type
type pb_2 from picturebutton within w_ap318_imp_liq_comp
end type
type pb_1 from picturebutton within w_ap318_imp_liq_comp
end type
type dw_master from u_dw_abc within w_ap318_imp_liq_comp
end type
end forward

global type w_ap318_imp_liq_comp from w_abc
integer width = 3730
integer height = 2140
string title = "[AP318] Impresión de Liquidación de Compras"
string menuname = "m_salir"
cb_1 cb_1
uo_fecha uo_fecha
pb_2 pb_2
pb_1 pb_1
dw_master dw_master
end type
global w_ap318_imp_liq_comp w_ap318_imp_liq_comp

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

on w_ap318_imp_liq_comp.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_master
end on

on w_ap318_imp_liq_comp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 200
pb_1.y = newheight -  100
pb_2.y = newheight -  100

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones

/*Inicialización de DataSotre Boleta*/
ids_print = Create Datastore
ids_print.DataObject = 'd_rpt_liquidacion_compra_cepibo'
ids_print.SettransObject(sqlca)
end event

type cb_1 from commandbutton within w_ap318_imp_liq_comp
integer x = 1307
integer y = 28
integer width = 393
integer height = 88
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar "
end type

event clicked;date   ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

dw_master.SetTransObject(SQLCA)
dw_master.Retrieve(ld_fecha_ini, ld_fecha_fin)

end event

type uo_fecha from u_ingreso_rango_fechas within w_ap318_imp_liq_comp
integer y = 32
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

type pb_2 from picturebutton within w_ap318_imp_liq_comp
integer x = 3163
integer y = 1632
integer width = 142
integer height = 116
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\Exit.bmp"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;Close (Parent)
end event

type pb_1 from picturebutton within w_ap318_imp_liq_comp
integer x = 3008
integer y = 1632
integer width = 142
integer height = 116
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\Printer.bmp"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;Long   ll_row
String ls_tipo, ls_nro_doc, ls_prov

ll_row = dw_master.GetSelectedRow(0)

Do While ll_row > 0
	//Impresión de Documento
	ls_prov = dw_master.object.cod_relacion [ll_row]	
	ls_tipo = dw_master.object.tipo_doc[ll_row]	
	ls_nro_doc = dw_master.object.nro_doc  [ll_row]

	wf_print(ls_prov, ls_tipo, ls_nro_doc)
	Update cntas_pagar set fec_impresion = sysdate
		where tipo_doc = :ls_tipo and nro_doc = :ls_nro_doc and cod_relacion = :ls_prov ;
	ll_row = dw_master.GetSelectedRow(ll_row)
	
Loop
Commit;
end event

type dw_master from u_dw_abc within w_ap318_imp_liq_comp
integer y = 144
integer width = 3579
integer height = 1464
string dataobject = "d_listas_liq_comp"
boolean vscrollbar = true
end type

event clicked;//override

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

idw_mst = dw_master // dw_master

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

