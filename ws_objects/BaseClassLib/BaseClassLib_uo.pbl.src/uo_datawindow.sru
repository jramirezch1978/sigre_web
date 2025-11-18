$PBExportHeader$uo_datawindow.sru
forward
global type uo_datawindow from datawindow
end type
end forward

global type uo_datawindow from datawindow
int Width=494
int Height=360
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type
global uo_datawindow uo_datawindow

type variables
String    is_orden = 'A'  // orden de la columna
Long     il_fila
end variables

forward prototypes
public function string uf_ordena (string as_nom_label)
public subroutine uf_seleccion (ref datawindow adw_origen, string as_indicador)
end prototypes

public function string uf_ordena (string as_nom_label);//*************************************************************************************//
// Objectivo  : Permite Ordernar una columna del datawindow                            //
// 																												//	
// Funcion    : uf_ordena(as_nom_label)																//	
// Argumentos : as_nom_label -> Nombre de la Columna.(Ej. columna_t  )                 //
// Retorna    : string           																		//
//																													//	
//*************************************************************************************//
	
string ls_columna, ls_newsort

ls_columna	=	Left(as_nom_label , Len(as_nom_label) - 2)
IF is_orden = 'A' THEN 
	is_orden = 'D'
ELSE
	is_orden = 'A'
END IF		
ls_newsort	=	ls_columna	+	' ' + is_orden
//************************************************************************************//
// Ordenar solo si se hizo click sobre una columna diferente a la anterior            //
//************************************************************************************//
Modify(as_nom_label+".Border='5'")

SetSort(ls_newsort)
Sort( )
Modify(ls_columna+'_t'+".Border='6'")

Return	ls_columna

end function

public subroutine uf_seleccion (ref datawindow adw_origen, string as_indicador);//****************************************************************************************//
// Objectivo : Codigo para la seleccion en bloque.                                        //
// Argumento : adw_origen   -> Datawindows Actual.                                        //
//             as_indicador -> 'S'   Selección Simple                                     //
//                             'M'   Selección Multiple                                   //
// Sintaxis  : uf_seleccion(adw_origen,as_indicador)
//****************************************************************************************//

Integer  li_inicio, li_fin
String   ls_campo

adw_origen.AcceptText()

IF adw_origen.getrow() <= 0 THEN RETURN


IF as_indicador = 'M' THEN
	IF KeyDown(KeyControl!) THEN
		il_fila = adw_origen.getrow()
		IF adw_origen.IsSelected(il_fila) THEN
			adw_origen.SelectRow(il_fila , False)
		ELSE
			adw_origen.SelectRow(il_fila , True)
		END IF
		RETURN
	END IF

	IF KeyDown(KeyShift!) THEN
		li_inicio = adw_origen.getrow()
		IF (il_fila - li_inicio) > 0 THEN
			FOR li_fin = il_fila TO li_inicio STEP -1 
				adw_origen.SelectRow( li_fin , True)
			NEXT
		ELSE
			FOR li_fin = il_fila TO li_inicio
				 adw_origen.SelectRow( li_fin , True)
			NEXT
		END IF
		RETURN
	END IF
END IF

il_fila = adw_origen.getrow()
adw_origen.setrow(il_fila)
adw_origen.SelectRow(0, False)
adw_origen.SelectRow(adw_origen.getrow() , True)


end subroutine

