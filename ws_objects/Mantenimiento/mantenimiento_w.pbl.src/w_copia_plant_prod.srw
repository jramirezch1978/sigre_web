$PBExportHeader$w_copia_plant_prod.srw
forward
global type w_copia_plant_prod from window
end type
type dw_1 from datawindow within w_copia_plant_prod
end type
type pb_1 from picturebutton within w_copia_plant_prod
end type
type pb_2 from picturebutton within w_copia_plant_prod
end type
end forward

global type w_copia_plant_prod from window
integer width = 1669
integer height = 736
boolean titlebar = true
string title = "Copia de Plantillas"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_salir ( )
event ue_aceptar ( )
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
end type
global w_copia_plant_prod w_copia_plant_prod

type variables


end variables

forward prototypes
public function boolean of_genera_copia_plantilla (string as_new_plantilla, string as_desc_plantilla, string as_ot_adm, string as_old_plantilla)
end prototypes

event ue_salir();sg_parametros sl_param
sl_param.titulo = 'n'

CloseWithReturn(this, sl_param)

end event

event ue_aceptar();string ls_new_plantilla, ls_desc_plantilla, ls_ot_adm, ls_old_plantilla
sg_parametros sl_param

dw_1.AcceptText( )

if f_row_processing( dw_1, 'tabular') = false then return

ls_new_plantilla 	= dw_1.object.new_plantilla	[1]
ls_desc_plantilla = dw_1.object.desc_plantilla	[1]
ls_ot_adm 			= dw_1.object.ot_adm				[1]
ls_old_plantilla 	= dw_1.object.old_plantilla	[1]

if this.of_genera_copia_plantilla( ls_new_plantilla, &
	ls_desc_plantilla, ls_ot_adm, ls_old_plantilla) = FALSE then return

sl_param.titulo = 's'
sl_param.string1 = ls_new_plantilla
sl_param.string2 = ls_desc_plantilla

CloseWithReturn(this, sl_param)



end event

public function boolean of_genera_copia_plantilla (string as_new_plantilla, string as_desc_plantilla, string as_ot_adm, string as_old_plantilla);String  ls_mensaje

if IsNull( as_new_plantilla ) then
	MessageBox('Error', 'Nuevo Codigo de Plantilla no puede estar en blanco')
	RETURN FALSE
end if

//GENERAR CABECERA DE PLANTILLA //
insert into plant_prod(
	cod_plantilla,desc_plantilla,flag_estado,ot_adm)
select :as_new_plantilla,:as_desc_plantilla,flag_estado,:as_ot_adm 
FROM plant_prod 
where cod_plantilla = :as_old_plantilla ;
	
IF SQLCA.SQLCode = -1 THEN 
   ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', ls_mensaje)
	RETURN FALSE
END IF
	
//GENERA DETALLE DE PLANTILLA//
insert into plant_prod_oper
(nro_operacion   ,flag_pre      ,nro_precedencia,nro_dias_inicio,
 dias_duracion   ,desc_operacion,cantidad       ,cod_plantilla  ,
 flag_dias_inicio,cod_labor     ,cod_ejecutor   ,dias_holgura   )
select nro_operacion   ,flag_pre      ,nro_precedencia,nro_dias_inicio  ,
		 dias_duracion   ,desc_operacion,cantidad       ,:as_new_plantilla,
 		 flag_dias_inicio,cod_labor     ,cod_ejecutor   ,dias_holgura     
from plant_prod_oper 
where cod_plantilla = :as_old_plantilla ;
	
	
IF SQLCA.SQLCode = -1 THEN 
   ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', ls_mensaje)
	RETURN FALSE
END IF
	
//GENERA INSUMOS 
insert into plant_prod_mov(
	cod_plantilla,nro_operacion,cod_art,cantidad)
select :as_new_plantilla,nro_operacion,cod_art,cantidad 
from plant_prod_mov 
where cod_plantilla = :as_old_plantilla ;

IF SQLCA.SQLCode = -1 THEN 
   ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', ls_mensaje)
	RETURN FALSE
END IF

//GENERA PRODUCTOS TERMINADOS
insert into plant_prod_mov_ingreso(
	cod_plantilla,nro_operacion,cod_art,cantidad)
select :as_new_plantilla,nro_operacion,cod_art,cantidad 
from plant_prod_mov_ingreso 
where cod_plantilla = :as_old_plantilla ;

IF SQLCA.SQLCode = -1 THEN 
   ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', ls_mensaje)
	RETURN FALSE
END IF

//GENERA DESEMBOLSOS
insert into plant_prod_desembolso(
	cod_plantilla,nro_desembolso,cod_moneda,concepto,importe,nro_operacion)
select :as_new_plantilla,nro_desembolso,cod_moneda,concepto,importe,nro_operacion 
from plant_prod_desembolso 
where cod_plantilla = :as_old_plantilla ;

IF SQLCA.SQLCode = -1 THEN 
   ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', ls_mensaje)
	RETURN FALSE
END IF

//GRABA
COMMIT ;
Messagebox('Aviso','Se Culmino Generación de Plantilla '+as_new_plantilla)

RETURN TRUE
end function

on w_copia_plant_prod.create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.Control[]={this.dw_1,&
this.pb_1,&
this.pb_2}
end on

on w_copia_plant_prod.destroy
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;sg_parametros sl_param

dw_1.InsertRow(0)
dw_1.SetColumn( 'ot_adm' )

sl_param = Message.PowerObjectParm

dw_1.object.ot_adm [1] = sl_param.string1
end event

type dw_1 from datawindow within w_copia_plant_prod
event ue_display ( string as_columna,  long al_row )
integer y = 16
integer width = 1623
integer height = 364
integer taborder = 10
string title = "none"
string dataobject = "d_abc_plantilla_ext_ff"
boolean border = false
boolean livescroll = true
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_ot_adm

choose case upper(as_columna)
		
	case "OT_ADM"
		ls_sql = "select a.ot_adm as ot_adm, a.descripcion as desc_ot_adm " &
				 + "from ot_administracion a, " &
				 + "ot_adm_usuario    b " &
				 + "where a.ot_adm = b.ot_adm " &
				 + "and b.cod_usr = '" + gs_user + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
		end if
		
	case "OLD_PLANTILLA"
		
		ls_ot_adm = this.object.ot_adm [al_row]
		
		if IsNull(ls_ot_adm) or ls_ot_adm = '' then
			MessageBox('Aviso', 'Debe Indicar un ot_adm')
			return 
		end if
		
		ls_sql = "select cod_plantilla as codigo, " &
				 + "desc_plantilla as descripcion, " &
				 + "ot_adm as cod_ot_adm " &
				 + "from plant_prod " &
				 + "where ot_adm = '" + ls_ot_adm + "' " &
				 + "and flag_estado = '1'"
				 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.old_plantilla	[al_row] = ls_codigo
			this.object.desc_plantilla	[al_row] = ls_data
		end if
		
end choose

end event

event doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event itemerror;return 1
end event

type pb_1 from picturebutton within w_copia_plant_prod
integer x = 448
integer y = 448
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type pb_2 from picturebutton within w_copia_plant_prod
integer x = 823
integer y = 448
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

