$PBExportHeader$w_empresa_und_op.srw
forward
global type w_empresa_und_op from w_base
end type
type dw_master from u_dw_abc within w_empresa_und_op
end type
type dw_detail from u_dw_abc within w_empresa_und_op
end type
type pb_cancelar from u_pb_cancelar within w_empresa_und_op
end type
type pb_ok from u_pb_aceptar within w_empresa_und_op
end type
end forward

global type w_empresa_und_op from w_base
integer width = 2021
integer height = 1832
string title = "Elija la empresa y la unidad operativa"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
event ue_close ( )
event ue_aceptar ( )
dw_master dw_master
dw_detail dw_detail
pb_cancelar pb_cancelar
pb_ok pb_ok
end type
global w_empresa_und_op w_empresa_und_op

type variables
u_dw_abc idw_1
boolean 	ib_FirstTime
end variables

event ue_close();str_parametros lstr_parm

lstr_parm.retorno = '0'
CloseWithReturn(this, lstr_parm)
end event

event ue_aceptar();str_parametros lstr_parm

lstr_parm.retorno = '1'
CloseWithReturn(this, lstr_parm)
end event

on w_empresa_und_op.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.dw_detail=create dw_detail
this.pb_cancelar=create pb_cancelar
this.pb_ok=create pb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.pb_cancelar
this.Control[iCurrent+4]=this.pb_ok
end on

on w_empresa_und_op.destroy
call super::destroy
destroy(this.dw_master)
destroy(this.dw_detail)
destroy(this.pb_cancelar)
destroy(this.pb_ok)
end on

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

dw_master.setTransobject( SQLCA )
dw_detail.setTransobject( SQLCA )

dw_master.retrieve(gnvo_app.is_user)

idw_1 = dw_master

if idw_1.RowCount( ) = 0 then
	ls_mensaje = "El usuario " + gnvo_app.is_user + " no tiene asignado ninguna unidad operativa"
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
	this.post event ue_close()
else
	//Si hay datos en la cabecera tambien busco datos en el detalle, si solamente tiene
	//asignado una sola unidad operativa entonces para que abrir la ventana, de frente
	//que tome los datos necesarios
	
	dw_master.SelectRow(1,true)
	dw_master.setRow(1)
	dw_master.il_row = 1
	dw_master.event ue_output( 1 )
	
	if dw_detail.rowCount( ) = 1 then
		gnvo_app.invo_empresa.is_empresa 		= dw_master.object.empresa		[dw_master.GetRow()]
		gnvo_app.is_und_operat 	= dw_detail.object.und_operat	[1]
		gnvo_app.is_origen		= dw_detail.object.origen		[1]
		lstr_param.retorno = '1'
		if ib_FirstTime then
			CloseWithReturn(this, lstr_param)
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

type p_pie from w_base`p_pie within w_empresa_und_op
integer x = 0
integer y = 1476
end type

type ole_skin from w_base`ole_skin within w_empresa_und_op
end type

type dw_master from u_dw_abc within w_empresa_und_op
integer width = 1993
integer height = 676
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_list_empresas_user_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_output;call super::ue_output;gnvo_app.invo_empresa.is_empresa = this.object.empresa[al_row]

dw_detail.Retrieve(gnvo_app.is_user, gnvo_app.invo_empresa.is_empresa)
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm' 	// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  dw_detail
end event

type dw_detail from u_dw_abc within w_empresa_und_op
integer y = 700
integer width = 1993
integer height = 776
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_lis_und_operativa_user_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_output;call super::ue_output;gnvo_app.is_und_operat = this.object.und_operat[al_row]
gnvo_app.is_origen = this.object.origen[al_row]
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

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

type pb_cancelar from u_pb_cancelar within w_empresa_und_op
integer x = 1024
integer y = 1516
integer taborder = 80
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;parent.event ue_close( )
end event

type pb_ok from u_pb_aceptar within w_empresa_und_op
integer x = 517
integer y = 1516
integer taborder = 90
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;parent.event ue_aceptar( )
end event

