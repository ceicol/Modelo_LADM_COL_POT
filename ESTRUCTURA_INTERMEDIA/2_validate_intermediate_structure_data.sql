/***************************************************************************
                Validadores de estructura de datos intermedia
              ----------------------------------------------------------
        begin           : 2024-05-25
        git sha         : :%H$
        copyright       : (C) 2024 by Leo Cardona (CEICOL SAS)
                          (C) 2024 by Camilo Rodriguez (CEICOL SAS)        
        email           : contacto@ceicol.com
                          ccrodriguezo@ceicol.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License v3.0 as          *
 *   published by the Free Software Foundation.                            *
 *                                                                         *
 ***************************************************************************/

--========================================
--Fijar esquema
--========================================
set search_path to	
	data_intermedia, 	-- Esquema de estructura de datos intermedia
	ladm_pot;		-- Esquema modelo LADM-POT
	
--=========================================
--1 Áreas de actividad
--=========================================

--1.1 Uso principal
select 
	'El valor de uso principal no se puede homologar con el dominio pot_areaactividadtipo' as mensaje,
	dt.uso_principal  as valor
from areas_actividad dt 
where dt.uso_principal not in (select ilicode from pot_areaactividadtipo);

--1.2 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from areas_actividad dt
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--1.3 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from areas_actividad as dt  
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--1.4 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from areas_actividad as dt  
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--1.5 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from areas_actividad as dt  
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--1.6 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from areas_actividad as dt  
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--1.7 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from areas_actividad as dt  
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--1.8 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from areas_actividad as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;

--=========================================
--2 Tratamientos urbanisticos
--=========================================

--2.1 Tipo de tratatmiento urbanístico
select 
	'El valor de tipo de tratamiento urbanístico no se puede homologar con el dominio pot_tratamientourbanisticotipo' as mensaje,
	dt.tipo_tratamiento_urbanistico  as valor
from tratamiento_urbanistico as dt 
where dt.tipo_tratamiento_urbanistico not in (select ilicode from pot_tratamientourbanisticotipo) ;

--2.2 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from tratamiento_urbanistico as dt 
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--2.3 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from tratamiento_urbanistico as dt  
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--2.4 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from tratamiento_urbanistico as dt   
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--2.5 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from tratamiento_urbanistico as dt 
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--2.6 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from tratamiento_urbanistico as dt  
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--2.7 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from tratamiento_urbanistico as dt 
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--2.8 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from tratamiento_urbanistico as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;

--=========================================
--3 Clasificación del suelo
--=========================================

--3.1 tipo de clasificación de suelo
select 
	'El valor de tipo de clasificación de suelo no se puede homologar con el dominio pot_clasificacionsuelotipo' as mensaje,
	dt.tipo_clasificacion_suelo as valor
from clasificacion_suelo as dt 
where dt.tipo_clasificacion_suelo not in (select ilicode from pot_clasificacionsuelotipo);

--3.2 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from clasificacion_suelo as dt 
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--3.3 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from clasificacion_suelo as dt  
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--3.4 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from clasificacion_suelo as dt   
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--3.5 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from clasificacion_suelo as dt 
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--3.6 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from clasificacion_suelo as dt  
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--3.7 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from clasificacion_suelo as dt 
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--3.8 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from clasificacion_suelo as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;

--=========================================
--4 Zonificación suelo rural
--=========================================

--4.1 tipo de uso principal
select 
	'El valor de uso principal de la zonificación de suelo rural no se puede homologar con el dominio pot_usosueloruraltipo' as mensaje,
	dt.uso_principal as valor
from zonificacion_suelo_rural as dt 
where dt.uso_principal not in (select ilicode from pot_usosueloruraltipo);

--4.2 tipo de categoria de suelo rural
select 
	'El valor de categoria rural de la zonificación de suelo rural no se puede homologar con el dominio pot_categoriaruraltipo' as mensaje,
	dt.tipo_categoria_rural as valor
from zonificacion_suelo_rural as dt 
where dt.tipo_categoria_rural not in (select ilicode from pot_categoriaruraltipo);

--4.3 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from zonificacion_suelo_rural as dt 
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--4.4 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from zonificacion_suelo_rural as dt  
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--4.5 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from zonificacion_suelo_rural as dt   
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--4.6 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from zonificacion_suelo_rural as dt 
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--4.7 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from zonificacion_suelo_rural as dt  
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--4.8 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad  as valor
from zonificacion_suelo_rural as dt 
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--4.9 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from zonificacion_suelo_rural as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;

--=========================================
--5 Sistemas generales (poligono)
--=========================================

--5.1 tipo de sistema general
select 
	'El valor de tipo de sistema general no se puede homologar con el dominio pot_sistemasgeneralestipo' as mensaje,
	dt.tipo_sistema_general as valor
from sistemas_generales_poligono as dt 
where dt.tipo_sistema_general not in (select ilicode from pot_sistemasgeneralestipo);

--5.2 tipo de nivel de sistema general
select 
	'El valor de tipo de nivel del sistema general no se puede homologar con el dominio pot_sistemasgeneralestipo' as mensaje,
	dt.nivel as valor
from sistemas_generales_poligono as dt 
where dt.nivel not in (select ilicode from pot_sistemasgeneralesniveltipo);

--5.3 tipo de nivel de sistema general
select 
	'El valor de tipo de estado del sistema general no se puede homologar con el dominio pot_sistemasgeneralestipo' as mensaje,
	dt.estado as valor
from sistemas_generales_poligono as dt 
where dt.estado not in (select ilicode from pot_sistemasgeneralesestadotipo);

--5.4 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from sistemas_generales_poligono as dt 
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--5.5 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from sistemas_generales_poligono as dt  
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--5.6 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from sistemas_generales_poligono as dt   
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--5.7 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from sistemas_generales_poligono as dt 
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--5.8 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from sistemas_generales_poligono as dt  
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--5.9 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from sistemas_generales_poligono as dt 
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--5.10 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from sistemas_generales_poligono as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;


--=========================================
--6 Sistemas generales (linea)
--=========================================

--6.1 tipo de sistema general
select 
	'El valor de tipo de sistema general no se puede homologar con el dominio pot_sistemasgeneralestipo' as mensaje,
	dt.tipo_sistema_general as valor
from sistemas_generales_linea as dt 
where dt.tipo_sistema_general not in (select ilicode from pot_sistemasgeneralestipo);

--6.2 tipo de nivel de sistema general
select 
	'El valor de tipo de nivel del sistema general no se puede homologar con el dominio pot_sistemasgeneralestipo' as mensaje,
	dt.nivel as valor
from sistemas_generales_linea as dt 
where dt.nivel not in (select ilicode from pot_sistemasgeneralesniveltipo);

--6.3 tipo de estado de sistema general
select 
	'El valor de tipo de estado del sistema general no se puede homologar con el dominio pot_sistemasgeneralestipo' as mensaje,
	dt.estado as valor
from sistemas_generales_linea as dt 
where dt.estado not in (select ilicode from pot_sistemasgeneralesestadotipo);

--6.4 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from sistemas_generales_linea as dt 
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--6.5 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from sistemas_generales_linea as dt  
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--6.6 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from sistemas_generales_linea as dt   
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--6.7 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from sistemas_generales_linea as dt 
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--6.8 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from sistemas_generales_linea as dt  
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--6.9 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from sistemas_generales_linea as dt 
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--6.10 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from sistemas_generales_linea as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;

--=========================================
--7 Sistemas generales (punto)
--=========================================

--7.1 tipo de sistema general
select 
	'El valor de tipo de sistema general no se puede homologar con el dominio pot_sistemasgeneralestipo' as mensaje,
	dt.tipo_sistema_general as valor
from sistemas_generales_punto as dt
where dt.tipo_sistema_general not in (select ilicode from pot_sistemasgeneralestipo);

--7.2 tipo de nivel de sistema general
select 
	'El valor de tipo de nivel del sistema general no se puede homologar con el dominio pot_sistemasgeneralestipo' as mensaje,
	dt.nivel as valor
from sistemas_generales_punto as dt
where dt.nivel not in (select ilicode from pot_sistemasgeneralesniveltipo);

--7.3 tipo de nivel de sistema general
select 
	'El valor de tipo de estado del sistema general no se puede homologar con el dominio pot_sistemasgeneralestipo' as mensaje,
	dt.estado as valor
from sistemas_generales_punto as dt
where dt.estado not in (select ilicode from pot_sistemasgeneralesestadotipo);

--7.4 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from sistemas_generales_punto as dt
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--7.5 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from sistemas_generales_punto as dt 
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--7.6 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from sistemas_generales_punto as dt  
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--7.7 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from sistemas_generales_punto as dt
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--7.8 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from sistemas_generales_punto as dt 
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--7.9 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from sistemas_generales_punto as dt
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--7.10 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from sistemas_generales_punto as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;


--=========================================
--8 Centro poblado rural
--=========================================

--8.1 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from centro_poblado_rural as dt
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--8.2 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from centro_poblado_rural as dt 
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--8.3 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from centro_poblado_rural as dt  
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--8.4 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from centro_poblado_rural as dt
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--8.5 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from centro_poblado_rural as dt 
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--8.6 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from centro_poblado_rural as dt
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--8.7 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from centro_poblado_rural as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;

--=========================================
--9 Área en condición se riesgo
--=========================================

--9.1 Tipo de fenómeno de amenaza
select 
	'El valor del tipo de fenomeno amenaza no se puede homologar con el dominio pot_fenomenoamenazatipo' as mensaje,
	dt.fenomeno  as valor
from area_condicion_riesgo as dt
where dt.fenomeno not in (select ilicode from pot_fenomenoamenazatipo);

--9.2 Tipo de priorización 
select 
	'El valor del tipo de priorización no se puede homologar con el dominio pot_priorizaciontipo' as mensaje,
	dt.priorizacion  as valor
from area_condicion_riesgo as dt
where dt.priorizacion not in (select ilicode from pot_priorizaciontipo);

--9.3 Tipo de medida de intervención
select 
	'El valor del tipo de medida de intervensión no se puede homologar con el dominio pot_medidaintervenciontipo' as mensaje,
	dt.medida_intervencion  as valor
from area_condicion_riesgo as dt
where dt.medida_intervencion not in (select ilicode from pot_medidaintervenciontipo);

--9.4 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from area_condicion_riesgo as dt
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--9.5 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from area_condicion_riesgo as dt
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--9.6 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from area_condicion_riesgo as dt 
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--9.7 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from area_condicion_riesgo  as dt
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--9.8 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from area_condicion_riesgo as dt
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--9.9 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from area_condicion_riesgo as dt
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--9.10 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from area_condicion_riesgo as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;

--=========================================
--10 Área en condición se amenaza
--=========================================

--10.1 Tipo de fenómeno de amenaza
select 
	'El valor del tipo de fenomeno amenaza no se puede homologar con el dominio pot_fenomenoamenazatipo' as mensaje,
	dt.fenomeno  as valor
from area_condicion_amenaza as dt
where dt.fenomeno not in (select ilicode from pot_fenomenoamenazatipo);

--10.2 Tipo de categoría de amenaza
select 
	'El valor del tipo de categoría amenaza no se puede homologar con el dominio pot_categoriaamenazatipo' as mensaje,
	dt.categoria_amenaza  as valor
from area_condicion_amenaza as dt
where dt.categoria_amenaza not in (select ilicode from pot_categoriaamenazatipo);

--10.3 Tipo de priorización 
select 
	'El valor del tipo de priorización no se puede homologar con el dominio pot_priorizaciontipo' as mensaje,
	dt.priorizacion  as valor
from area_condicion_amenaza as dt
where dt.priorizacion not in (select ilicode from pot_priorizaciontipo);

--10.4 Tipo de medida de intervención
select 
	'El valor del tipo de medida de intervensión no se puede homologar con el dominio pot_medidaintervenciontipo' as mensaje,
	dt.medida_intervencion  as valor
from area_condicion_amenaza as dt
where dt.medida_intervencion not in (select ilicode from pot_medidaintervenciontipo);

--10.5 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from area_condicion_amenaza as dt
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--10.6 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from area_condicion_amenaza as dt
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--10.7 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from area_condicion_amenaza as dt 
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--10.8 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from area_condicion_amenaza as dt
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--10.9 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from area_condicion_amenaza as dt
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--10.10 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from area_condicion_amenaza as dt
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--10.11 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from area_condicion_amenaza as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;


--=========================================
--11 Zonificación de amenaza
--=========================================

--11.1 Tipo de fenómeno de amenaza
select 
	'El valor del tipo de fenomeno amenaza no se puede homologar con el dominio pot_fenomenoamenazatipo' as mensaje,
	dt.fenomeno  as valor
from zonificacion_amenaza as dt
where dt.fenomeno not in (select ilicode from pot_fenomenoamenazatipo);

--11.2 Tipo de categoría de amenaza
select 
	'El valor del tipo de categoría amenaza no se puede homologar con el dominio pot_categoriaamenazatipo' as mensaje,
	dt.categoria_amenaza  as valor
from zonificacion_amenaza as dt
where dt.categoria_amenaza not in (select ilicode from pot_categoriaamenazatipo);

--11.3 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from zonificacion_amenaza as dt
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--11.4 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from zonificacion_amenaza as dt
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--11.5 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from zonificacion_amenaza as dt 
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--11.6 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from zonificacion_amenaza as dt
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--11.7 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from zonificacion_amenaza as dt
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--11.8 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from zonificacion_amenaza as dt
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--11.9 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from zonificacion_amenaza as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;

--=========================================
--12 Suelo de protección urbano
--=========================================

--12.1 Uso principal
select 
	'El valor de uso principal no se puede homologar con el dominio pot_areaactividadtipo' as mensaje,
	dt.uso_principal  as valor
from suelo_proteccion_urbano dt 
where dt.uso_principal not in (select ilicode from pot_sueloproteccionurbanotipo);

--12.2 Tipo de fuente administrativa
select 
	'El valor de tipo de fuente administrativa no se puede homologar con el dominio col_fuenteadministrativatipo' as mensaje,
	dt.fuente_administrativa_tipo  as valor
from suelo_proteccion_urbano dt
where dt.fuente_administrativa_tipo not in (select ilicode from col_fuenteadministrativatipo where thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo');

--12.3 Tipo de pot 
select 
	'El valor de tipo POT de fuente administrativa no se puede homologar con el dominio pot_planordenamientoterritorialtipo' as mensaje,
	dt.fuente_administrativa_tipo_pot as valor
from suelo_proteccion_urbano as dt  
where dt.fuente_administrativa_tipo_pot not in (select ilicode from pot_planordenamientoterritorialtipo);

--12.4 Tipo de revisión de fuente administrativa
select 
	'El valor de tipo de revision de la fuente administrativa no se puede homologar con el dominio pot_revisiontipo' as mensaje,
	dt.fuente_administrativa_tipo_revision as valor
from suelo_proteccion_urbano as dt  
where dt.fuente_administrativa_tipo_revision not in (select ilicode from pot_revisiontipo);

--12.5 Tipo de estado de disponibilidad de fuente administrativa
select 
	'El valor de tipo de estado de disponibilidad de la fuente administrativa no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_administrativa_estado_disponibilidad as valor
from suelo_proteccion_urbano as dt  
where dt.fuente_administrativa_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--12.6 Tipo de fuente espacial 
select 
	'El valor de tipo de fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_tipo  as valor
from suelo_proteccion_urbano as dt  
where dt.fuente_espacial_tipo not in (select ilicode from col_fuenteespacialtipo);

--12.7 Tipo de estado de disponibilidad de la fuente espacial
select 
	'El valor de tipo de estado de disponibilidad de la fuente espacial no se puede homologar con el dominio col_estadodisponibilidadtipo' as mensaje,
	dt.fuente_espacial_estado_disponibilidad as valor
from suelo_proteccion_urbano as dt  
where dt.fuente_espacial_estado_disponibilidad not in (select ilicode from col_estadodisponibilidadtipo);

--12.8 Validación de las DRR  
select 	
	'Debe ser diferente de NULL alguno de los campos de la descripción de derecho, restricción y responsabilidad' as mensaje
from suelo_proteccion_urbano as dt  
where dt.descripcion_derecho is null and dt.descripcion_restriccion is null and dt.descripcion_responsabilidad is null;