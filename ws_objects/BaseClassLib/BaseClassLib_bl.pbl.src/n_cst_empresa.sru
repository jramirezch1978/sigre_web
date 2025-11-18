$PBExportHeader$n_cst_empresa.sru
forward
global type n_cst_empresa from nonvisualobject
end type
end forward

global type n_cst_empresa from nonvisualobject
end type
global n_cst_empresa n_cst_empresa

type variables
Public:

String is_desc_empresa, is_empresa, is_sigla, is_RUC
end variables

forward prototypes
public function boolean of_load_datos (string as_empresa)
end prototypes

public function boolean of_load_datos (string as_empresa);is_empresa = as_empresa

if gnvo_app.ib_new_struct then
	// Por implementar
else
	/*
	Name                Type          Nullable Default Comments             
------------------- ------------- -------- ------- -------------------- 
COD_EMPRESA         CHAR(8)                        Codigo Empresa       
NOMBRE              VARCHAR2(200) Y                Nombre               
PERSONERIA          CHAR(1)       Y                Personeria           
RUC                 CHAR(11)      Y                RUC                  
TIPO_IDENTIF        CHAR(1)       Y                tipo identif         
IDENTIFICACION      CHAR(10)      Y                Identificacion       
DIR_CALLE           VARCHAR2(300) Y                Dir Calle            
DIR_NUMERO          CHAR(8)       Y                Dir Numero           
DIR_LOTE            CHAR(4)       Y                Dir Lote             
DIR_MNZ             CHAR(4)       Y                Dir Mnz              
DIR_COD_POSTAL      CHAR(10)      Y                Dir Cod Postal       
DIR_URBANIZACION    CHAR(20)      Y                Dir Urbanizacion     
DIR_DISTRITO        CHAR(20)      Y                Dir Distrito         
COD_CIUDAD          CHAR(3)       Y                Cod Ciudad           
CIU_COD_PAIS        CHAR(4)       Y                CIU_cod pais         
CIU_COD_DPTO        CHAR(3)       Y                CIU_cod departamento 
CIU_COD_PROV        CHAR(3)       Y                CIU_cod provincia    
LOGO                VARCHAR2(300) Y                logo                 
REPRESENTANTE       VARCHAR2(60)  Y                representante        
FLAG_REPLICACION    CHAR(1)       Y        '1'     flag_replicacion     
SIGLA               VARCHAR2(20)  Y                sigla                
FLAG_CNTRL_CD       CHAR(1)       Y        '0'     flag_cntrl_cd        
REPRES_LEGAL        CHAR(8)       Y                REPRES_LEGAL         
CIU_COD_DISTR       CHAR(4)       Y                CIU_COD_DISTR        
COD_ACTIVIDAD       CHAR(6)       Y                cod_actividad        
FLAG_ENVIA_PERSONAL CHAR(1)       Y                flag_envia_personal  
DIR_INTERIOR        VARCHAR2(10)  Y                                     
DIR_DPTO            VARCHAR2(10)  Y   
*/
	select nombre, ruc, logo, SIGLA
	  into :is_desc_empresa, :is_RUC, :gnvo_app.is_logo, :is_SIGLA
	from empresa
	where cod_empresa = :is_empresa;
end if



if not gnvo_app.of_valida_transaccion( "No se pudo Consultar el maestro de empresas", SQLCA) then
	SetNull(is_desc_empresa)
	SetNull(is_RUC)
	setNull(gnvo_app.is_logo)
	setNull(is_SIGLA)
	
	gnvo_log.of_Tracelog("No se pudo Consultar el maestro de empresas: " +	is_empresa)
	return false
end if

return true
end function

on n_cst_empresa.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_empresa.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

