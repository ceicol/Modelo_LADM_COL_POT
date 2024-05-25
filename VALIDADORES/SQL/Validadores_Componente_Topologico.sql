/***************************************************************************
                Reglas de calidad del componente de topológico
              ----------------------------------------------------------
        begin           : 2024-05-17
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
	
--Regla T1
select
	puc1.t_id,
	puc2.t_ili_tid,
	concat('El registro ',puc1.t_id,' se superpone con el registro ',puc2.t_id) as mensaje
from pot_ue_clasificacionsuelo as puc1
join pot_ue_clasificacionsuelo as puc2 on st_overlaps(puc1.geometria,puc2.geometria)
where puc1.t_id != puc2.t_id;

	
--Regla T5
select
	tbl1.t_id,
	tbl1.t_ili_tid,
	'El insumo presenta superposición con insumos del mismo tipo de categoría rural' as mensaje
from (select
	puz1.t_id,
	puz1.t_ili_tid,
	ps.tipo_categoria_rural,
	puz1.geometria
from pot_ue_zonificacionsuelorural puz1
join col_uebaunit cu on puz1.t_id = cu.ue_pot_ue_zonificacionsuelorural 
join pot_uab_zonificacionsuelorural ps on ps.t_id =cu.baunit_pot_uab_zonificacionsuelorural) as tbl1
join (select
	puz1.t_id,
	ps.tipo_categoria_rural,
	puz1.geometria
from pot_ue_zonificacionsuelorural puz1
join col_uebaunit cu on puz1.t_id = cu.ue_pot_ue_zonificacionsuelorural 
join pot_uab_zonificacionsuelorural ps on ps.t_id =cu.baunit_pot_uab_zonificacionsuelorural) as tbl2
on st_overlaps(tbl1.geometria,tbl2.geometria)
where tbl1.t_id != tbl2.t_id and tbl1.tipo_categoria_rural =tbl2.tipo_categoria_rural;

--Regla T6
select
	puc1.t_id,
	puc1.t_ili_tid,
	concat('El tratamiento urbanitico ',puc1.t_id,' se superpone con el registro ',puc2.t_id) as mensaje
from pot_ue_tratamientourbanistico as puc1
join pot_ue_tratamientourbanistico as puc2 on st_overlaps(puc1.geometria,puc2.geometria)
where puc1.t_id != puc2.t_id;

--Regla T8
select
	puc1.t_id,
	puc1.t_ili_tid,
	concat('El área de actividad ',puc1.t_id,' se superpone con el registro ',puc2.t_id) as mensaje
from pot_ue_areasactividad as puc1
join pot_ue_areasactividad as puc2 on st_overlaps(puc1.geometria,puc2.geometria)
where puc1.t_id != puc2.t_id;


--Regla T10
select
	'La siguiente zona del perimetro urbano no está cubierta por registros de las áreas de actividad' as mensaje,
	st_difference(ctc.geometria,arc.geometria) as geometria
from
(select
	st_union(pua.geometria) as geometria
from pot_ue_areasactividad pua) as arc
join
(select
	st_union(puc.geometria) as geometria 
from pot_ue_clasificacionsuelo as puc 
join col_uebaunit as cu on puc.t_id = cu.ue_pot_ue_clasificacionsuelo
join pot_uab_clasificacionsuelo as pc on pc.t_id  = cu.baunit_pot_uab_clasificacionsuelo
where pc.tipo_clasificacion_suelo in (select t_id from pot_clasificacionsuelotipo where ilicode like 'Urbano')) as ctc
on st_intersects(arc.geometria, ctc.geometria);

--Regla T12
select
	'La siguiente zona del perimetro urbano y de expansión urbana no está cubierta por registros de tratamientos urbanos' as mensaje,
	st_difference(ctc.geometria,ttu.geometria) as geometria
from
(select
	st_union(pua.geometria) as geometria
from pot_ue_tratamientourbanistico pua) as ttu
join
(select
	st_union(puc.geometria) as geometria 
from pot_ue_clasificacionsuelo as puc 
join col_uebaunit as cu on puc.t_id = cu.ue_pot_ue_clasificacionsuelo
join pot_uab_clasificacionsuelo as pc on pc.t_id  = cu.baunit_pot_uab_clasificacionsuelo
where pc.tipo_clasificacion_suelo in (select t_id from pot_clasificacionsuelotipo where ilicode in ('Urbano','Expansion_Urbana'))) as ctc
on st_intersects(ttu.geometria, ctc.geometria);

--Regla T13
select
	st1.t_id,
	st1.t_ili_tid,
	concat('El registro ',st1.t_id,' presenta superposición con el registro ',st2.t_id) as mensaje
from 
(select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referencialineasistemasgenerales pr on pr.sistemasgenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Vias.%')) as st1
join (select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referencialineasistemasgenerales pr on pr.sistemasgenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Vias.%')) as st2 on st_intersects(st1.geometria,st2.geometria)
where st1.t_id != st2.t_id and  not st_touches(st1.geometria,st2.geometria)
order by st1.t_id  asc;

--Regla T15
select
	st1.t_id, 
	st1.t_ili_tid,
	'El registro presenta superposición con otros registros' as mensaje
from 
(select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria 
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referenciapuntosistemasgenerales pr on pr.sistemagenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Servicios_Publicos.%' or ilicode like 'Vias.%' or ilicode like 'Infraestructura_Transporte.%')) as st1
join pot_referenciapuntosistemasgenerales as st2
on st_intersects(st1.geometria,st2.geometria)
where st1.t_id != st2.t_id;


--Regla T16
select
	st1.t_id, 
	st1.t_ili_tid,
	'El registro de geometria punto de la tabla pot_referenciapuntosistemasgenerales no está contenido por la unidad espacial de clasificación de suelo' as mensaje
from 
(select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referenciapuntosistemasgenerales pr on pr.sistemagenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Servicios_Publicos.%' or ilicode like 'Vias.%' or ilicode like 'Infraestructura_Transporte.%')) as st1
join (select st_union(cs.geometria) as geometria from pot_ue_clasificacionsuelo as cs) as cs1
on st_contains(cs1.geometria,st1.geometria) = false
union
select
	st1.t_id, 
	st1.t_ili_tid,
	'El registro de geometria linea de la tabla pot_referencialineasistemasgenerales no está contenido por la unidad espacial de clasificación de suelo' as mensaje
from 
(select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referencialineasistemasgenerales pr on pr.sistemasgenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Servicios_Publicos.%' or ilicode like 'Vias.%' or ilicode like 'Infraestructura_Transporte.%')) as st1
join (select st_union(cs.geometria) as geometria from pot_ue_clasificacionsuelo as cs) as cs1
on st_contains(cs1.geometria,st1.geometria) = false
union
select
	st1.t_id, 
	st1.t_ili_tid,
	'El registro de geometria poligono  la tabla pot_ue_sistemasgenerales no está contenido por la unidad espacial de clasificación de suelo' as mensaje
from 
(select
	pus2.t_id,
	pus2.t_ili_tid,
	pus2.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Servicios_Publicos.%' or ilicode like 'Vias.%' or ilicode like 'Infraestructura_Transporte.%')
and pus2.geometria is not null) as st1
join (select st_union(cs.geometria) as geometria from pot_ue_clasificacionsuelo as cs) as cs1
on st_contains(cs1.geometria,st1.geometria) = false
order by mensaje desc;

--Regla T17
select
	puc.t_id,
	puc.t_ili_tid,
	'El centro poblado no esta contenido por la clasificación del suelo rural' as mensaje
from pot_ue_centropobladorural puc 
join 
(select
	st_union(puc.geometria) as geometria 
from pot_ue_clasificacionsuelo as puc 
join col_uebaunit as cu on puc.t_id = cu.ue_pot_ue_clasificacionsuelo
join pot_uab_clasificacionsuelo as pc on pc.t_id  = cu.baunit_pot_uab_clasificacionsuelo
where pc.tipo_clasificacion_suelo in (select t_id from pot_clasificacionsuelotipo where ilicode in ('Rural'))) as ctc
on st_contains(ctc.geometria,puc.geometria) = false;

--Regla T18
select 
	puc.t_id,
	puc.t_ili_tid,
	'El centro poblado no tiene un registro de zonificación rural con equivalencia geométrica' as mensaje
from pot_ue_centropobladorural puc 
where puc.t_id not in (
select puc.t_id  
from pot_uab_zonificacionsuelorural puz
join col_uebaunit cu on puz.t_id = cu.baunit_pot_uab_zonificacionsuelorural
join pot_ue_zonificacionsuelorural ps on ps.t_id = cu.ue_pot_ue_zonificacionsuelorural 
join pot_ue_centropobladorural puc on st_equals(ps.geometria,puc.geometria)
where puz.uso_principal in (select t_id from pot_usosueloruraltipo pu where ilicode like 'Centro_Poblado'));