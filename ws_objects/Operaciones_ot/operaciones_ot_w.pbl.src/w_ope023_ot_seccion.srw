$PBExportHeader$w_ope023_ot_seccion.srw
forward
global type w_ope023_ot_seccion from w_abc
end type
type cb_2 from commandbutton within w_ope023_ot_seccion
end type
type st_1 from statictext within w_ope023_ot_seccion
end type
type cb_1 from commandbutton within w_ope023_ot_seccion
end type
type sle_1 from singlelineedit within w_ope023_ot_seccion
end type
type dw_master from u_dw_abc within w_ope023_ot_seccion
end type
end forward

global type w_ope023_ot_seccion from w_abc
integer width = 2834
integer height = 1224
string title = "OT x Tipo de Secciones"
string menuname = "m_master_sin_lista"
cb_2 cb_2
st_1 st_1
cb_1 cb_1
sle_1 sle_1
dw_master dw_master
end type
global w_ope023_ot_seccion w_ope023_ot_seccion

on w_ope023_ot_seccion.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.cb_2=create cb_2
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_1=create sle_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.dw_master
end on

on w_ope023_ot_seccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente



end event

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION DE seccion
IF f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type cb_2 from commandbutton within w_ope023_ot_seccion
integer x = 1042
integer y = 44
integer width = 155
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN         AS CODIGO_ORIGEN       ,'&
								+' NRO_OT         AS NRO_ORDEN_TRABAJO 		  ,'&
						  	   +'ADMINISTRACION AS ADMINISTRACION	   		  ,'&
								+'TIPO           AS TIPO_OT				 		  ,'&
								+'CENCOS_SOLIC   AS CC_SOLICITANTE	 			  ,'&
								+'DESC_CC_SOLICITANTE  AS DESC_CC_SOLICITANTE  ,'&
								+'CENCOS_RESP    AS CC_RESPONSABLE	 			  ,'&
								+'DESC_CC_RESPONSABLE  AS DESC_CC_RESPONSABLE  ,'&
								+'USUARIO        AS CODIGO_USUARIO	 			  ,'&
								+'CODIGO_RESPONSABLE   AS CODIGO_RESPONSABLE   ,'&
								+'NOMBRE_RESPONSABLE   AS NOMBRES_RESPONSABLES ,'&
							  	+'FECHA_INICIO         AS FECHA_INICIO 		  ,'&		
								+'TITULO_ORDEN_TRABAJO AS TITULO_ORDEN_TRABAJO  '&
								+'FROM VW_OPE_CONSULTA_ORDEN_TRABAJO '

				
OpenWithParm(w_seleccionar_op,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN

		sle_1.text = lstr_seleccionar.param2[1]
	END IF

end event

type st_1 from statictext within w_ope023_ot_seccion
integer x = 46
integer y = 60
integer width = 384
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro. OT :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope023_ot_seccion
integer x = 2423
integer y = 28
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_nro_ot

ls_nro_ot = sle_1.text

dw_master.retrieve(ls_nro_ot)
end event

type sle_1 from singlelineedit within w_ope023_ot_seccion
integer x = 462
integer y = 44
integer width = 530
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type dw_master from u_dw_abc within w_ope023_ot_seccion
integer x = 27
integer y = 168
integer width = 2752
integer height = 848
string dataobject = "d_abc_ot_seccion_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String ls_tipo
Long   ll_count

Accepttext()




choose case dwo.name
				
		 case 'seccion_tipo'
				select Count(*) into :ll_count
				  from ot_seccion_tipo
				 where (seccion_tipo = :data) ;
				 
				 
				IF ll_count = 0 THEN
					Messagebox('Aviso','Tipo de Seccion No Existe ,Verifique')
					SetNull(ls_tipo)
					This.Object.seccion_tipo [row] = ls_tipo
					Return 1
				END IF
end choose

end event

event constructor;call super::constructor;is_mastdet = 'm'		
is_dwform = 'tabular'


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

idw_mst = dw_master

end event

event doubleclicked;call super::doubleclicked;String ls_name,ls_prot
Str_seleccionar lStr_seleccionar



ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if




lstr_seleccionar.s_seleccion = 'S'



choose case dwo.name
	  	 case 'seccion_tipo'
				lstr_seleccionar.s_sql = 'select seccion_tipo as codigo                    ,' &
												      +' descripcion  as descripcion_tipo_seccion  ' & 
										 				+' from ot_seccion_tipo '
				
				OpenWithParm(w_seleccionar_op,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.seccion_tipo 					 [row] = lstr_seleccionar.param1[1]
					this.object.ot_seccion_tipo_descripcion [row] = lstr_seleccionar.param2[1]
				END IF
				
end choose







end event

event ue_insert_pre;call super::ue_insert_pre;
This.object.nro_orden [al_row] = sle_1.text
end event

event itemerror;call super::itemerror;Return 1
end event

