$PBExportHeader$w_elegir_empresa.srw
forward
global type w_elegir_empresa from w_base
end type
type dw_master from u_dw_abc within w_elegir_empresa
end type
type st_1 from statictext within w_elegir_empresa
end type
type pb_1 from u_pb_aceptar within w_elegir_empresa
end type
type pb_2 from u_pb_cancelar within w_elegir_empresa
end type
type dw_detail from u_dw_abc within w_elegir_empresa
end type
end forward

global type w_elegir_empresa from w_base
integer width = 2505
integer height = 1860
string title = "Elegir la empresa"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
dw_master dw_master
st_1 st_1
pb_1 pb_1
pb_2 pb_2
dw_detail dw_detail
end type
global w_elegir_empresa w_elegir_empresa

type variables
u_dw_abc idw_1
boolean	ib_FirstTime
end variables

event ue_aceptar();str_parametros lstr_parm
string ls_Empresa, ls_origen

if dw_master.getRow() = 0 then return

ls_empresa = dw_master.object.cod_empresa[dw_master.getRow()]

gnvo_app.invo_empresa.of_load_datos( ls_empresa )

ls_origen = dw_detail.object.cod_origen [dw_detail.GetRow()]

gnvo_app.is_origen = ls_origen

lstr_parm.retorno = '1'
CloseWithReturn(this, lstr_parm)
end event

event ue_cancelar();str_parametros lstr_parm

lstr_parm.retorno = '0'
CloseWithReturn(this, lstr_parm)
end event

on w_elegir_empresa.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.st_1=create st_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.dw_detail
end on

on w_elegir_empresa.destroy
call super::destroy
destroy(this.dw_master)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_detail)
end on

event resize;call super::resize;st_1.width = newwidth - st_1.x - this.cii_Windowborder
dw_master.width = newwidth - dw_master.X - this.cii_Windowborder
dw_detail.width = newwidth - dw_detail.X - this.cii_Windowborder
dw_detail.height = p_pie.y - dw_detail.y - this.cii_Windowborder
end event

event open;call super::open;String ls_mensaje
str_parametros lstr_param

//Hay que verificar si la ventana se abre por primera vez, después de ingresar 
//usuario y contraseña; o lo estoy llamando por segunda vez para cambiar la
//unidad operativa

//por defecto si por primera vez
ib_FirstTime = true

//PAra que no sea la primera vez, debo haber enviado como parte del parametro
//la ventana que lo invocó
if not IsNull(Message.PowerObjectParm) and isValid(Message.PowerObjectParm) then
	if Message.PowerObjectParm.ClassName() = 'str_parametros' then
		lstr_param = Message.PowerObjectparm
		if not IsNull(lstr_param.w1) and IsValid(lstr_param.w1) then
			ib_FirstTime = false
		end if
	end if
end if

idw_1 = dw_master

dw_master.setTransobject( SQLCA )
dw_detail.setTransobject( SQLCA )

dw_master.retrieve(gnvo_app.is_user)


dw_master.setFocus( )

if idw_1.RowCount( ) = 0 then
	ls_mensaje = "El usuario " + gnvo_app.is_user + " no tiene asignado ninguna empresa"
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	this.post event ue_cancelar()
else
	//Si hay datos en la cabecera tambien busco datos en el detalle, si solamente tiene
	//asignado una sola unidad operativa entonces para que abrir la ventana, de frente
	//que tome los datos necesarios
	
	dw_master.SelectRow(1,true)
	dw_master.setRow(1)
	dw_master.il_row = 1
	dw_master.event ue_output( 1 )
	
	if dw_detail.rowCount( ) = 1 then
		gnvo_app.invo_empresa.is_empresa = dw_master.object.cod_empresa[dw_master.GetRow()]
		gnvo_app.is_origen					= dw_detail.object.cod_origen	[1]
		
		lstr_param.retorno = '1'
		if ib_FirstTime then
			//this.event ue_aceptar( )
		else
			dw_detail.selectRow(1, true)
		end if
	elseif dw_detail.rowCount() > 1 then
		dw_detail.SelectRow( 1, true)
		dw_detail.il_row = 1
		dw_detail.setRow( 1)
	end if
	
end if
end event

type p_pie from w_base`p_pie within w_elegir_empresa
integer x = 0
integer y = 1500
end type

type ole_skin from w_base`ole_skin within w_elegir_empresa
end type

type dw_master from u_dw_abc within w_elegir_empresa
integer y = 272
integer width = 2322
integer height = 636
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_list_empresas_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm' 	// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 3				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 3 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_output;call super::ue_output;gnvo_app.invo_empresa.is_empresa = this.object.cod_empresa[al_row]

dw_detail.Retrieve(gnvo_app.is_user, gnvo_app.invo_empresa.is_empresa)

if dw_detail.RowCount() > 0 then
	dw_detail.setRow(1)
	dw_detail.SelectRow( 1, true)
end if
end event

type st_1 from statictext within w_elegir_empresa
integer width = 2386
integer height = 228
boolean bringtotop = true
integer textsize = -28
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 32768
string text = "ELIGA LA EMPRESA: "
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from u_pb_aceptar within w_elegir_empresa
integer x = 759
integer y = 1512
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;parent.event ue_aceptar( )
end event

type pb_2 from u_pb_cancelar within w_elegir_empresa
integer x = 1285
integer y = 1512
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;parent.event ue_cancelar( )
end event

type dw_detail from u_dw_abc within w_elegir_empresa
integer y = 920
integer width = 2313
integer height = 480
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_list_origen_x_empresa_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	parent.event ue_aceptar( )
end if
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_output;call super::ue_output;gnvo_app.is_origen = this.object.cod_origen[al_row]
end event

