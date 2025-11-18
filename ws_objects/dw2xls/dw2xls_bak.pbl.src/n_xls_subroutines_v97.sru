$PBExportHeader$n_xls_subroutines_v97.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_xls_subroutines_v97 from n_xls_subroutines_v5
end type
end forward

global type n_xls_subroutines_v97 from n_xls_subroutines_v5
end type
global n_xls_subroutines_v97 n_xls_subroutines_v97

type variables
public n_cst_unicode invo_uc
end variables

forward prototypes
public function string to_ansi (blob ab_value)
public function string to_ansi (blob ab_value,uint ai_codepage)
public function string to_ansi (blob ab_value,uint ai_codepage,char ac_defaultchar)
public function blob to_unicode (string as_value)
public function blob to_unicode (string as_value,uint ai_codepage)
end prototypes

public function string to_ansi (blob ab_value);return invo_uc.of_unicode2ansi(ab_value)
end function

public function string to_ansi (blob ab_value,uint ai_codepage);return invo_uc.of_unicode2ansi(ab_value,ai_codepage)
end function

public function string to_ansi (blob ab_value,uint ai_codepage,char ac_defaultchar);return invo_uc.of_unicode2ansi(ab_value,ai_codepage,ac_defaultchar)
end function

public function blob to_unicode (string as_value);return invo_uc.of_ansi2unicode(as_value)
end function

public function blob to_unicode (string as_value,uint ai_codepage);return invo_uc.of_ansi2unicode(as_value,ai_codepage)
end function

on n_xls_subroutines_v97.create
triggerevent("constructor")
end on

on n_xls_subroutines_v97.destroy
triggerevent("destructor")
end on

