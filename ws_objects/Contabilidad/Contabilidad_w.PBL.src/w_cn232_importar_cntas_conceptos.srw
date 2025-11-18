$PBExportHeader$w_cn232_importar_cntas_conceptos.srw
forward
global type w_cn232_importar_cntas_conceptos from w_abc_master
end type
type st_1 from statictext within w_cn232_importar_cntas_conceptos
end type
type em_ano from uo_ingreso_numerico within w_cn232_importar_cntas_conceptos
end type
type st_2 from statictext within w_cn232_importar_cntas_conceptos
end type
type cb_1 from commandbutton within w_cn232_importar_cntas_conceptos
end type
end forward

global type w_cn232_importar_cntas_conceptos from w_abc_master
integer width = 1033
integer height = 584
string title = "[CN232] Importar Conceptos"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
em_ano em_ano
st_2 st_2
cb_1 cb_1
end type
global w_cn232_importar_cntas_conceptos w_cn232_importar_cntas_conceptos

on w_cn232_importar_cntas_conceptos.create
int iCurrent
call super::create
this.st_1=create st_1
this.em_ano=create em_ano
this.st_2=create st_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_1
end on

on w_cn232_importar_cntas_conceptos.destroy
call super::destroy
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.st_2)
destroy(this.cb_1)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_nota.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_nota")
END IF

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master`dw_master within w_cn232_importar_cntas_conceptos
boolean visible = false
integer x = 1152
integer y = 32
integer width = 297
integer height = 264
string title = "Tipo de Notas (CN001)"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type st_1 from statictext within w_cn232_importar_cntas_conceptos
integer x = 64
integer y = 340
integer width = 133
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from uo_ingreso_numerico within w_cn232_importar_cntas_conceptos
integer x = 219
integer y = 328
integer width = 242
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
string text = "2004"
string mask = "####"
double increment = 1
end type

event constructor;call super::constructor;this.text = string(today(),'yyyy')
end event

type st_2 from statictext within w_cn232_importar_cntas_conceptos
integer x = 37
integer y = 32
integer width = 942
integer height = 196
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Ingrese el año en el cual se ingresaran los Conceptos con sus respectivas Cuentas"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn232_importar_cntas_conceptos
integer x = 613
integer y = 320
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;integer li_ano
long ll_cont = 0
string ls_cnta, ls_concep, ls_cnta_p

li_ano = integer(em_ano.text)

delete from cnt_concepto_anexo where ano = :li_ano;

declare c_general cursor for
 Select cc.cnta_ctbl, cc.concepto_cnt
   From cnt_concepto cc
  Group By cc.cnta_ctbl, cc.concepto_cnt;

open c_general;

fetch c_general into :ls_cnta, :ls_concep;
ls_cnta_p = ls_cnta //para el primer registro
DO WHILE sqlca.sqlCode = 0
	
	if ls_cnta_p = ls_cnta then
		ll_cont++
	else
		ls_cnta_p = ls_cnta
		ll_cont = 1
	end if
	
	INsert into cnt_concepto_anexo ( ano, nro_item, cnta_ctbl, concepto_cnt, flag_replicacion )
		  values (:li_ano, :ll_cont, :ls_cnta, :ls_concep, '1');
	
	FETCH c_general into :ls_cnta, :ls_concep;
LOOP

close c_general;

if sqlca.sqlcode <> 0 then
	messagebox('Aviso',string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext))
	rollback;
	close(parent)
else
	commit;
	messagebox('Aviso','Registros Importados Exitosamente')
	closewithreturn(parent,string(li_ano))
end if
end event

