/***************************************************************************
                Reglas de calidad del componente temático
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
set search_path to 
	ladm_pot,	--Nombre del esquema LADM-POT
	public;
	
--Regla TM1
select	
	puc.t_id,
	puc.t_ili_tid,
	'El registro de Centro Poblado está relacionado con un registro de clasificación de suelo diferente al Rural' as mensaje
from pot_uab_centropobladorural puc 
join pot_uab_clasificacionsuelo pcs on puc.clasificacion_suelo = pcs.t_id 
where pcs.tipo_clasificacion_suelo in (select t_id from pot_clasificacionsuelotipo pc where ilicode not in ('Rural'));
	
--Regla TM2
select
	pua.t_id,
	pua.t_ili_tid,
	'La categoría de amenaza no puede ser NULL' as mensaje
from pot_uab_zonificacionamenazas pua
join pot_derecho pd on pua.t_id = pd.unidad_pot_uab_zonificacionamenazas 
join col_rrrfuente cr on pd.t_id = cr.rrr_pot_derecho 
join pot_fuenteadministrativa pf on pf.t_id = cr.fuente_administrativa
where pua.categoria_amenaza is null and 
(pf.fecha_documento_fuente >= to_date('2016-01-01', 'YYYY-MM-DD') or 
pf.tipo in (select t_id from col_fuenteadministrativatipo where ilicode not like 'Documento_Publico.Resolucion' and thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo'));

--Regla TM3
select 
	puz.t_id,
	puz.t_ili_tid,
	'El Uso principal rural no tiene relación con el tipo de categoría rural' as mensaje
from pot_uab_zonificacionsuelorural puz
where puz.tipo_categoria_rural  in (select t_id from pot_categoriaruraltipo where ilicode like 'Proteccion_Suelo_Rural.Conservacion_Proteccion_Ambiental.%')
and puz.uso_principal in (select t_id from pot_usosueloruraltipo where ilicode not like 'Conservacion_Proteccion_Ambiental.%');

--Regla TM4
select 
	puz.t_id,
	puz.t_ili_tid,
	'Cuando el tipo de uso principal es Centro Poblado, la categoria rural no puede ser diferente de (Desarrollo restringido) Centro poblado en la zona rural' as mensaje
from pot_uab_zonificacionsuelorural puz
where (puz.uso_principal in (select t_id from pot_usosueloruraltipo where ilicode like 'Centro_Poblado')
and puz.tipo_categoria_rural  in (select t_id from pot_categoriaruraltipo where ilicode not like 'Desarrollo_Restringido.Centro_Poblado_Rural'));