$PBExportHeader$u_dw.sru
$PBExportComments$Base DataWindow object
forward
global type u_dw from datawindow
end type
end forward

global type u_dw from datawindow
int Width=494
int Height=360
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type
global u_dw u_dw

type variables
Boolean ib_selectrow
end variables

forward prototypes
public subroutine of_set_selectrow (boolean ab_selectrow)
end prototypes

public subroutine of_set_selectrow (boolean ab_selectrow);ib_selectrow = ab_selectrow

end subroutine

event rowfocuschanged;If ib_selectrow Then
	this.SelectRow(0, False)
	this.SelectRow(currentrow, True)
End If

end event

