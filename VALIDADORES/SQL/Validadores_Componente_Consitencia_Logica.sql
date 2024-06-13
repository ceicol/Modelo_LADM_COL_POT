/***************************************************************************
                Validadores del componente de consistencia lógica
              ----------------------------------------------------------
        begin           : 2024-05-04
        git sha         : :%H$
        copyright       : (C) 2024 by Leo Cardona (CEICOL SAS)
                          (C) 2024 by Camilo Rodriguez (CEICOL SAS)        
        email           : contacto@ceicol.com
                          ccrodriguezo@ceicol.com
                        Funded by SwissTierras Colombia
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License v3.0 as          *
 *   published by the Free Software Foundation.                            *
 *                                                                         *
 ***************************************************************************/
 
-- Establecer los esquemas de trabajo
set search_path to 
	ladm_pot_new,	--Nombre del esquema LADM-POT
	public;

--Regla CL1
select
	pm.t_id,
	pm.t_ili_tid,
	'El tipo de documento del municipio no puede ser diferente de NIT' as mensaje
from pot_municipio as pm
where pm.tipo_documento not in (select t_id from col_documentotipo where ilicode like 'NIT');

--Regla CL2
select
	pcp.t_id,
	pcp.t_ili_tid,
	case
		when pcp.codigo is null then 'El código del centro poblado no puede ser NULL'
		when length(pcp.codigo) != 8 and pcp.codigo !~ '^[0-9]*$' then 'El código del centro poblado solo puede tener caracteres numéricos y debe tener solo ocho dígitos'
		when length(pcp.codigo) != 8  then 'El código del centro poblado solo ocho dígitos'
		when pcp.codigo !~ '^[0-9]*$' then 'El código del centro poblado solo puede tener caracteres numéricos'
	end as mensaje
from pot_uab_centropobladorural as pcp
where pcp.codigo is null or length(pcp.codigo) != 8 or pcp.codigo !~ '^[0-9]*$';

--Regla CL3
select 
	paa.t_id,
	paa.t_ili_tid,
	'El registro de la clase pot_ue_areacondicionamenaza no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_areacondicionamenaza  as paa 
join col_areavalor ca on paa.t_id = ca.pot_ue_areacondcnmnaza_area
where ca.area <=0 
union
select 
	pua.t_id,
	pua.t_ili_tid,
	'El registro de la clase pot_ue_areacondicionriesgo no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_areacondicionriesgo  as pua 
join col_areavalor ca on pua.t_id = ca.pot_ue_areacondicnrsgo_area 
where ca.area <=0
union
select 
	par.t_id,
	par.t_ili_tid,
	'El registro de la clase pot_ue_areasactividad no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_areasactividad as par 
join col_areavalor ca on par.t_id = ca.pot_ue_areasactividad_area 
where ca.area <=0
union
select 
	puc.t_id,
	puc.t_ili_tid,
	'El registro de la clase pot_ue_centropobladorural no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_centropobladorural as puc 
join col_areavalor ca on puc.t_id = ca.pot_ue_centropobldrral_area 
where ca.area <=0
union
select 
	pcc.t_id,
	pcc.t_ili_tid,
	'El registro de la clase pot_ue_clasificacionsuelo no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_clasificacionsuelo as pcc
join col_areavalor ca on pcc.t_id = ca.pot_ue_clasificacnselo_area
where ca.area <=0
union
select 
	psg.t_id,
	psg.t_ili_tid,
	'El registro de la clase pot_ue_sistemasgenerales no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_sistemasgenerales as psg
join col_areavalor ca on psg.t_id = ca.pot_ue_sistemasgenrles_area
where psg.geometria is not null and ca.area <=0
union
select 
	ptu.t_id,
	ptu.t_ili_tid,
	'El registro de la clase pot_ue_tratamientourbanistico no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_tratamientourbanistico as ptu
join col_areavalor ca on ptu.t_id = ca.pot_ue_tratmntrbnstico_area
where ca.area <=0
union
select 
	pza.t_id,
	pza.t_ili_tid,
	'El registro de la clase pot_ue_zonificacionamenaza no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_zonificacionamenaza as pza
join col_areavalor ca on pza.t_id = ca.pot_ue_zonificacnmnaza_area 
where ca.area <=0
union
select 
	pzr.t_id,
	pzr.t_ili_tid,
	'El registro de la clase pot_ue_zonificacionsuelorural no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_zonificacionsuelorural as pzr
join col_areavalor ca on pzr.t_id = ca.pot_ue_zonificcnslrral_area 
where ca.area <=0
union
select 
	psp.t_id,
	psp.t_ili_tid,
	'El registro de la clase pot_ue_sueloproteccionurbano no puede tener un valor de área igual o menor a 0' as mensaje
from pot_ue_sueloproteccionurbano as psp
join col_areavalor ca on psp.t_id = ca.pot_ue_suelprtccnrbano_area
where ca.area <=0;

--Regla CL4
select
	pr.t_id,
	pr.t_ili_tid,
	'La longitud del registro debe ser diferente de 0' as mensaje
from pot_referencialineasistemasgenerales pr 
where st_length(pr.geometria) = 0;

--Regla CL5
select
	pr.t_id,
	pr.t_ili_tid,
	'El registro se encuentra por los límites establecidos por el modelo LADM-COL' as mensaje
from pot_referenciapuntosistemasgenerales pr 
where st_disjoint(pr.geometria,st_geomfromtext('POLYGON ((3980000.000 1080000.000, 5700000.000 1080000.000, 5700000.000 3100000.000, 3980000.000 3100000.000, 3980000.000 1080000.000))',9377)) = True;

--Regla CL6
select
	pm.t_id,
	pm.t_ili_tid,
	case
		when (length(pm.codigo_departamento) != 2 and pm.codigo_departamento !~ '^[0-9]*$')
			then 'El código de departamento solo puede tener caracteres numéricos y debe tener solo dos dígitos'
		when length(pm.codigo_departamento) != 2
			then 'El código de departamento solo debe tener solo dos dígitos'
		when pm.codigo_departamento !~ '^[0-9]*$'
			then 'El código de departamento solo puede tener caracteres numéricos'
	end as mensaje
from pot_municipio as pm
where length(pm.codigo_departamento) != 2 or pm.codigo_departamento !~ '^[0-9]*$';

--Regla CL7
select
	pm.t_id,
	pm.t_ili_tid,
	case
		when (length(pm.codigo_municipio) != 3 and pm.codigo_municipio  !~ '^[0-9]*$')
			then 'El código de municipio solo puede tener caracteres numéricos y debe tener solo tres dígitos'
		when length(pm.codigo_municipio) != 3
			then 'El código de municipio solo debe tener solo tres dígitos'
		when pm.codigo_municipio  !~ '^[0-9]*$'
			then 'El código de municipio solo puede tener caracteres numéricos'
	end as mensaje
from pot_municipio as pm
where length(pm.codigo_municipio) != 3 or pm.codigo_municipio  !~ '^[0-9]*$';

--Regla CL8
select
	pm.t_id,
	pm.t_ili_tid,
	'El nombre de municipio no puede ser NULL o no corresponde a los listados por parte del DANE' as mensaje 
from pot_municipio as pm
where pm.nombre_municipio is null or upper(pm.nombre_municipio) not in ('MEDELLÍN','ABEJORRAL','ABRIAQUÍ','ALEJANDRÍA','AMAGÁ','AMALFI','ANDES','ANGELÓPOLIS','ANGOSTURA','ANORÍ','SANTA FÉ DE ANTIOQUIA','ANZÁ','APARTADÓ','ARBOLETES','ARGELIA','ARMENIA','BARBOSA','BELMIRA','BELLO','BETANIA','BETULIA','CIUDAD BOLÍVAR','BRICEÑO','BURITICÁ','CÁCERES','CAICEDO','CALDAS','CAMPAMENTO','CAÑASGORDAS','CARACOLÍ','CARAMANTA','CAREPA','EL CARMEN DE VIBORAL','CAROLINA','CAUCASIA','CHIGORODÓ','CISNEROS','COCORNÁ','CONCEPCIÓN','CONCORDIA','COPACABANA','DABEIBA','DONMATÍAS','EBÉJICO','EL BAGRE','ENTRERRÍOS','ENVIGADO','FREDONIA','FRONTINO','GIRALDO','GIRARDOTA','GÓMEZ PLATA','GRANADA','GUADALUPE','GUARNE','GUATAPÉ','HELICONIA','HISPANIA','ITAGÜÍ','ITUANGO','JARDÍN','JERICÓ','LA CEJA','LA ESTRELLA','LA PINTADA','LA UNIÓN','LIBORINA','MACEO','MARINILLA','MONTEBELLO','MURINDÓ','MUTATÁ','NARIÑO','NECOCLÍ','NECHÍ','OLAYA','PEÑOL','PEQUE','PUEBLORRICO','PUERTO BERRÍO','PUERTO NARE','PUERTO TRIUNFO','REMEDIOS','RETIRO','RIONEGRO','SABANALARGA','SABANETA','SALGAR','SAN ANDRÉS DE CUERQUÍA','SAN CARLOS','SAN FRANCISCO','SAN JERÓNIMO','SAN JOSÉ DE LA MONTAÑA','SAN JUAN DE URABÁ','SAN LUIS','SAN PEDRO DE LOS MILAGROS','SAN PEDRO DE URABÁ','SAN RAFAEL','SAN ROQUE','SAN VICENTE FERRER','SANTA BÁRBARA','SANTA ROSA DE OSOS','SANTO DOMINGO','EL SANTUARIO','SEGOVIA','SONSÓN','SOPETRÁN','TÁMESIS','TARAZÁ','TARSO','TITIRIBÍ','TOLEDO','TURBO','URAMITA','URRAO','VALDIVIA','VALPARAÍSO','VEGACHÍ','VENECIA','VIGÍA DEL FUERTE','YALÍ','YARUMAL','YOLOMBÓ','YONDÓ','ZARAGOZA','BARRANQUILLA','BARANOA','CAMPO DE LA CRUZ','CANDELARIA','GALAPA','JUAN DE ACOSTA','LURUACO','MALAMBO','MANATÍ','PALMAR DE VARELA','PIOJÓ','POLONUEVO','PONEDERA','PUERTO COLOMBIA','REPELÓN','SABANAGRANDE','SABANALARGA','SANTA LUCÍA','SANTO TOMÁS','SOLEDAD','SUAN','TUBARÁ','USIACURÍ','BOGOTÁ. D.C.','CARTAGENA DE INDIAS','ACHÍ','ALTOS DEL ROSARIO','ARENAL','ARJONA','ARROYOHONDO','BARRANCO DE LOBA','CALAMAR','CANTAGALLO','CICUCO','CÓRDOBA','CLEMENCIA','EL CARMEN DE BOLÍVAR','EL GUAMO','EL PEÑÓN','HATILLO DE LOBA','MAGANGUÉ','MAHATES','MARGARITA','MARÍA LA BAJA','MONTECRISTO','SANTA CRUZ DE MOMPOX','MORALES','NOROSÍ','PINILLOS','REGIDOR','RÍO VIEJO','SAN CRISTÓBAL','SAN ESTANISLAO','SAN FERNANDO','SAN JACINTO','SAN JACINTO DEL CAUCA','SAN JUAN NEPOMUCENO','SAN MARTÍN DE LOBA','SAN PABLO','SANTA CATALINA','SANTA ROSA','SANTA ROSA DEL SUR','SIMITÍ','SOPLAVIENTO','TALAIGUA NUEVO','TIQUISIO','TURBACO','TURBANÁ','VILLANUEVA','ZAMBRANO','TUNJA','ALMEIDA','AQUITANIA','ARCABUCO','BELÉN','BERBEO','BETÉITIVA','BOAVITA','BOYACÁ','BRICEÑO','BUENAVISTA','BUSBANZÁ','CALDAS','CAMPOHERMOSO','CERINZA','CHINAVITA','CHIQUINQUIRÁ','CHISCAS','CHITA','CHITARAQUE','CHIVATÁ','CIÉNEGA','CÓMBITA','COPER','CORRALES','COVARACHÍA','CUBARÁ','GUAPI','CUCAITA','CUÍTIVA','CHÍQUIZA','CHIVOR','DUITAMA','EL COCUY','EL ESPINO','FIRAVITOBA','FLORESTA','GACHANTIVÁ','GÁMEZA','GARAGOA','GUACAMAYAS','GUATEQUE','GUAYATÁ','GÜICÁN DE LA SIERRA','IZA','JENESANO','JERICÓ','LABRANZAGRANDE','LA CAPILLA','LA VICTORIA','LA UVITA','VILLA DE LEYVA','MACANAL','MARIPÍ','MIRAFLORES','MONGUA','MONGUÍ','MONIQUIRÁ','MOTAVITA','MUZO','NOBSA','NUEVO COLÓN','OICATÁ','OTANCHE','PACHAVITA','PÁEZ','PAIPA','PAJARITO','PANQUEBA','PAUNA','PAYA','PAZ DE RÍO','PESCA','PISBA','PUERTO BOYACÁ','QUÍPAMA','RAMIRIQUÍ','RÁQUIRA','RONDÓN','SABOYÁ','SÁCHICA','SAMACÁ','SAN EDUARDO','SAN JOSÉ DE PARE','SAN LUIS DE GACENO','SAN MATEO','SAN MIGUEL DE SEMA','SAN PABLO DE BORBUR','SANTANA','SANTA MARÍA','SANTA ROSA DE VITERBO','SANTA SOFÍA','SATIVANORTE','SATIVASUR','SIACHOQUE','SOATÁ','SOCOTÁ','SOCHA','SOGAMOSO','SOMONDOCO','SORA','SOTAQUIRÁ','SORACÁ','SUSACÓN','SUTAMARCHÁN','SUTATENZA','TASCO','TENZA','TIBANÁ','TIBASOSA','TINJACÁ','TIPACOQUE','TOCA','TOGÜÍ','TÓPAGA','TOTA','TUNUNGUÁ','TURMEQUÉ','TUTA','TUTAZÁ','ÚMBITA','VENTAQUEMADA','VIRACACHÁ','ZETAQUIRA','MANIZALES','AGUADAS','ANSERMA','ARANZAZU','BELALCÁZAR','CHINCHINÁ','FILADELFIA','LA DORADA','LA MERCED','MANZANARES','MARMATO','MARQUETALIA','MARULANDA','NEIRA','NORCASIA','PÁCORA','PALESTINA','PENSILVANIA','RIOSUCIO','RISARALDA','SALAMINA','SAMANÁ','SAN JOSÉ','SUPÍA','VICTORIA','VILLAMARÍA','VITERBO','FLORENCIA','ALBANIA','BELÉN DE LOS ANDAQUÍES','CARTAGENA DEL CHAIRÁ','CURILLO','EL DONCELLO','EL PAUJÍL','LA MONTAÑITA','MILÁN','MORELIA','PUERTO RICO','SAN JOSÉ DEL FRAGUA','SAN VICENTE DEL CAGUÁN','SOLANO','SOLITA','VALPARAÍSO','POPAYÁN','ALMAGUER','ARGELIA','BALBOA','BOLÍVAR','BUENOS AIRES','CAJIBÍO','CALDONO','CALOTO','CORINTO','EL TAMBO','FLORENCIA','GUACHENÉ','INZÁ','JAMBALÓ','LA SIERRA','LA VEGA','LÓPEZ DE MICAY','MERCADERES','MIRANDA','MORALES','PADILLA','PÁEZ','PATÍA','PIAMONTE','PIENDAMÓ - TUNÍA','PUERTO TEJADA','PURACÉ','ROSAS','SAN SEBASTIÁN','SANTANDER DE QUILICHAO','SANTA ROSA','SILVIA','SOTARÁ PAISPAMBA','SUÁREZ','SUCRE','TIMBÍO','TIMBIQUÍ','TORIBÍO','TOTORÓ','VILLA RICA','VALLEDUPAR','AGUACHICA','AGUSTÍN CODAZZI','ASTREA','BECERRIL','BOSCONIA','CHIMICHAGUA','CHIRIGUANÁ','CURUMANÍ','EL COPEY','EL PASO','GAMARRA','GONZÁLEZ','LA GLORIA','LA JAGUA DE IBIRICO','MANAURE BALCÓN DEL CESAR','PAILITAS','PELAYA','PUEBLO BELLO','RÍO DE ORO','LA PAZ','SAN ALBERTO','SAN DIEGO','SAN MARTÍN','TAMALAMEQUE','MONTERÍA','AYAPEL','BUENAVISTA','CANALETE','CERETÉ','CHIMÁ','CHINÚ','CIÉNAGA DE ORO','COTORRA','LA APARTADA','LORICA','LOS CÓRDOBAS','MOMIL','MONTELÍBANO','MOÑITOS','PLANETA RICA','PUEBLO NUEVO','PUERTO ESCONDIDO','PUERTO LIBERTADOR','PURÍSIMA DE LA CONCEPCIÓN','SAHAGÚN','SAN ANDRÉS DE SOTAVENTO','SAN ANTERO','SAN BERNARDO DEL VIENTO','SAN CARLOS','SAN JOSÉ DE URÉ','SAN PELAYO','TIERRALTA','TUCHÍN','VALENCIA','AGUA DE DIOS','ALBÁN','ANAPOIMA','ANOLAIMA','ARBELÁEZ','BELTRÁN','BITUIMA','BOJACÁ','CABRERA','CACHIPAY','CAJICÁ','CAPARRAPÍ','CÁQUEZA','CARMEN DE CARUPA','CHAGUANÍ','CHÍA','CHIPAQUE','CHOACHÍ','CHOCONTÁ','COGUA','COTA','CUCUNUBÁ','EL COLEGIO','EL PEÑÓN','EL ROSAL','FACATATIVÁ','FÓMEQUE','FOSCA','FUNZA','FÚQUENE','FUSAGASUGÁ','GACHALÁ','GACHANCIPÁ','GACHETÁ','GAMA','GIRARDOT','GRANADA','GUACHETÁ','GUADUAS','GUASCA','GUATAQUÍ','GUATAVITA','GUAYABAL DE SÍQUIMA','GUAYABETAL','GUTIÉRREZ','JERUSALÉN','JUNÍN','LA CALERA','LA MESA','LA PALMA','LA PEÑA','LA VEGA','LENGUAZAQUE','MACHETÁ','MADRID','MANTA','MEDINA','MOSQUERA','NARIÑO','NEMOCÓN','NILO','NIMAIMA','NOCAIMA','VENECIA','PACHO','PAIME','PANDI','PARATEBUENO','PASCA','PUERTO SALGAR','PULÍ','QUEBRADANEGRA','QUETAME','QUIPILE','APULO','RICAURTE','SAN ANTONIO DEL TEQUENDAMA','SAN BERNARDO','SAN CAYETANO','SAN FRANCISCO','SAN JUAN DE RIOSECO','SASAIMA','SESQUILÉ','SIBATÉ','SILVANIA','SIMIJACA','SOACHA','SOPÓ','SUBACHOQUE','SUESCA','SUPATÁ','SUSA','SUTATAUSA','TABIO','TAUSA','TENA','TENJO','TIBACUY','TIBIRITA','TOCAIMA','TOCANCIPÁ','TOPAIPÍ','UBALÁ','UBAQUE','VILLA DE SAN DIEGO DE UBATÉ','UNE','ÚTICA','VERGARA','VIANÍ','VILLAGÓMEZ','VILLAPINZÓN','VILLETA','VIOTÁ','YACOPÍ','ZIPACÓN','ZIPAQUIRÁ','QUIBDÓ','ACANDÍ','ALTO BAUDÓ','ATRATO','BAGADÓ','BAHÍA SOLANO','BAJO BAUDÓ','BOJAYÁ','EL CANTÓN DEL SAN PABLO','CARMEN DEL DARIÉN','CÉRTEGUI','CONDOTO','EL CARMEN DE ATRATO','EL LITORAL DEL SAN JUAN','ISTMINA','JURADÓ','LLORÓ','MEDIO ATRATO','MEDIO BAUDÓ','MEDIO SAN JUAN','NÓVITA','NUQUÍ','RÍO IRÓ','RÍO QUITO','RIOSUCIO','SAN JOSÉ DEL PALMAR','SIPÍ','TADÓ','UNGUÍA','UNIÓN PANAMERICANA','NEIVA','ACEVEDO','AGRADO','AIPE','ALGECIRAS','ALTAMIRA','BARAYA','CAMPOALEGRE','COLOMBIA','ELÍAS','GARZÓN','GIGANTE','GUADALUPE','HOBO','ÍQUIRA','ISNOS','LA ARGENTINA','LA PLATA','NÁTAGA','OPORAPA','PAICOL','PALERMO','PALESTINA','PITAL','PITALITO','RIVERA','SALADOBLANCO','SAN AGUSTÍN','SANTA MARÍA','SUAZA','TARQUI','TESALIA','TELLO','TERUEL','TIMANÁ','VILLAVIEJA','YAGUARÁ','RIOHACHA','ALBANIA','BARRANCAS','DIBULLA','DISTRACCIÓN','EL MOLINO','FONSECA','HATONUEVO','LA JAGUA DEL PILAR','MAICAO','MANAURE','SAN JUAN DEL CESAR','URIBIA','URUMITA','VILLANUEVA','SANTA MARTA','ALGARROBO','ARACATACA','ARIGUANÍ','CERRO DE SAN ANTONIO','CHIVOLO','CIÉNAGA','CONCORDIA','EL BANCO','EL PIÑÓN','EL RETÉN','FUNDACIÓN','GUAMAL','NUEVA GRANADA','PEDRAZA','PIJIÑO DEL CARMEN','PIVIJAY','PLATO','PUEBLOVIEJO','REMOLINO','SABANAS DE SAN ÁNGEL','SALAMINA','SAN SEBASTIÁN DE BUENAVISTA','SAN ZENÓN','SANTA ANA','SANTA BÁRBARA DE PINTO','SITIONUEVO','TENERIFE','ZAPAYÁN','ZONA BANANERA','VILLAVICENCIO','ACACÍAS','BARRANCA DE UPÍA','CABUYARO','CASTILLA LA NUEVA','CUBARRAL','CUMARAL','EL CALVARIO','EL CASTILLO','EL DORADO','FUENTE DE ORO','GRANADA','GUAMAL','MAPIRIPÁN','MESETAS','LA MACARENA','URIBE','LEJANÍAS','PUERTO CONCORDIA','PUERTO GAITÁN','PUERTO LÓPEZ','PUERTO LLERAS','PUERTO RICO','RESTREPO','SAN CARLOS DE GUAROA','SAN JUAN DE ARAMA','SAN JUANITO','SAN MARTÍN','VISTAHERMOSA','PASTO','ALBÁN','ALDANA','ANCUYA','ARBOLEDA','BARBACOAS','BELÉN','BUESACO','COLÓN','CONSACÁ','CONTADERO','CÓRDOBA','CUASPUD CARLOSAMA','CUMBAL','CUMBITARA','CHACHAGÜÍ','EL CHARCO','EL PEÑOL','EL ROSARIO','EL TABLÓN DE GÓMEZ','EL TAMBO','FUNES','GUACHUCAL','GUAITARILLA','GUALMATÁN','ILES','IMUÉS','IPIALES','LA CRUZ','LA FLORIDA','LA LLANADA','LA TOLA','LA UNIÓN','LEIVA','LINARES','LOS ANDES','MAGÜÍ','MALLAMA','MOSQUERA','NARIÑO','OLAYA HERRERA','OSPINA','FRANCISCO PIZARRO','POLICARPA','POTOSÍ','PROVIDENCIA','PUERRES','PUPIALES','RICAURTE','ROBERTO PAYÁN','SAMANIEGO','SANDONÁ','SAN BERNARDO','SAN LORENZO','SAN PABLO','SAN PEDRO DE CARTAGO','SANTA BÁRBARA','SANTACRUZ','SAPUYES','TAMINANGO','TANGUA','SAN ANDRÉS DE TUMACO','TÚQUERRES','YACUANQUER','SAN JOSÉ DE CÚCUTA','ÁBREGO','ARBOLEDAS','BOCHALEMA','BUCARASICA','CÁCOTA','CÁCHIRA','CHINÁCOTA','CHITAGÁ','CONVENCIÓN','CUCUTILLA','DURANIA','EL CARMEN','EL TARRA','EL ZULIA','GRAMALOTE','HACARÍ','HERRÁN','LABATECA','LA ESPERANZA','LA PLAYA','LOS PATIOS','LOURDES','MUTISCUA','OCAÑA','PAMPLONA','PAMPLONITA','PUERTO SANTANDER','RAGONVALIA','SALAZAR','SAN CALIXTO','SAN CAYETANO','TONA','SANTIAGO','SARDINATA','SILOS','TEORAMA','TIBÚ','TOLEDO','VILLA CARO','VILLA DEL ROSARIO','ARMENIA','BUENAVISTA','CALARCÁ','CIRCASIA','CÓRDOBA','FILANDIA','GÉNOVA','LA TEBAIDA','MONTENEGRO','PIJAO','QUIMBAYA','SALENTO','PEREIRA','APÍA','BALBOA','BELÉN DE UMBRÍA','DOSQUEBRADAS','GUÁTICA','LA CELIA','LA VIRGINIA','MARSELLA','MISTRATÓ','PUEBLO RICO','QUINCHÍA','SANTA ROSA DE CABAL','SANTUARIO','BUCARAMANGA','AGUADA','ALBANIA','ARATOCA','BARBOSA','BARICHARA','BARRANCABERMEJA','BETULIA','BOLÍVAR','CABRERA','CALIFORNIA','CAPITANEJO','CARCASÍ','CEPITÁ','CERRITO','CHARALÁ','CHARTA','CHIMA','CHIPATÁ','CIMITARRA','CONCEPCIÓN','CONFINES','CONTRATACIÓN','COROMORO','CURITÍ','EL CARMEN DE CHUCURI','EL GUACAMAYO','EL PEÑÓN','EL PLAYÓN','ENCINO','ENCISO','FLORIÁN','FLORIDABLANCA','GALÁN','GÁMBITA','GIRÓN','GUACA','GUADALUPE','GUAPOTÁ','GUAVATÁ','GÜEPSA','HATO','JESÚS MARÍA','JORDÁN','LA BELLEZA','LANDÁZURI','LA PAZ','LEBRIJA','LOS SANTOS','MACARAVITA','MÁLAGA','MATANZA','MOGOTES','MOLAGAVITA','OCAMONTE','OIBA','ONZAGA','PALMAR','PALMAS DEL SOCORRO','PÁRAMO','PIEDECUESTA','PINCHOTE','PUENTE NACIONAL','PUERTO PARRA','PUERTO WILCHES','RIONEGRO','SABANA DE TORRES','SAN ANDRÉS','SAN BENITO','SAN GIL','SAN JOAQUÍN','SAN JOSÉ DE MIRANDA','SAN MIGUEL','SAN VICENTE DE CHUCURÍ','SANTA BÁRBARA','SANTA HELENA DEL OPÓN','SIMACOTA','SOCORRO','SUAITA','SUCRE','SURATÁ','VALLE DE SAN JOSÉ','VÉLEZ','VETAS','VILLANUEVA','ZAPATOCA','SINCELEJO','BUENAVISTA','CAIMITO','COLOSÓ','COROZAL','COVEÑAS','CHALÁN','EL ROBLE','GALERAS','GUARANDA','LA UNIÓN','LOS PALMITOS','MAJAGUAL','MORROA','OVEJAS','PALMITO','SAMPUÉS','SAN BENITO ABAD','SAN JUAN DE BETULIA','SAN MARCOS','SAN ONOFRE','SAN PEDRO','SAN LUIS DE SINCÉ','SUCRE','SANTIAGO DE TOLÚ','SAN JOSÉ DE TOLUVIEJO','IBAGUÉ','ALPUJARRA','ALVARADO','AMBALEMA','ANZOÁTEGUI','ARMERO','ATACO','CAJAMARCA','CARMEN DE APICALÁ','CASABIANCA','CHAPARRAL','COELLO','COYAIMA','CUNDAY','DOLORES','ESPINAL','FALAN','FLANDES','FRESNO','GUAMO','HERVEO','HONDA','ICONONZO','LÉRIDA','LÍBANO','SAN SEBASTIÁN DE MARIQUITA','MELGAR','MURILLO','NATAGAIMA','ORTEGA','PALOCABILDO','PIEDRAS','PLANADAS','PRADO','PURIFICACIÓN','RIOBLANCO','RONCESVALLES','ROVIRA','SALDAÑA','SAN ANTONIO','SAN LUIS','SANTA ISABEL','SUÁREZ','VALLE DE SAN JUAN','VENADILLO','VILLAHERMOSA','VILLARRICA','CALI','ALCALÁ','ANDALUCÍA','ANSERMANUEVO','ARGELIA','BOLÍVAR','BUENAVENTURA','GUADALAJARA DE BUGA','BUGALAGRANDE','CAICEDONIA','CALIMA','CANDELARIA','CARTAGO','DAGUA','EL ÁGUILA','EL CAIRO','EL CERRITO','EL DOVIO','FLORIDA','GINEBRA','GUACARÍ','JAMUNDÍ','LA CUMBRE','LA UNIÓN','LA VICTORIA','OBANDO','PALMIRA','PRADERA','RESTREPO','RIOFRÍO','ROLDANILLO','SAN PEDRO','SEVILLA','TORO','TRUJILLO','TULUÁ','ULLOA','VERSALLES','VIJES','YOTOCO','YUMBO','ZARZAL','ARAUCA','ARAUQUITA','CRAVO NORTE','FORTUL','PUERTO RONDÓN','SARAVENA','TAME','YOPAL','AGUAZUL','CHÁMEZA','HATO COROZAL','LA SALINA','MANÍ','MONTERREY','NUNCHÍA','OROCUÉ','PAZ DE ARIPORO','PORE','RECETOR','SABANALARGA','SÁCAMA','SAN LUIS DE PALENQUE','TÁMARA','TAURAMENA','TRINIDAD','VILLANUEVA','MOCOA','COLÓN','ORITO','PUERTO ASÍS','PUERTO CAICEDO','PUERTO GUZMÁN','PUERTO LEGUÍZAMO','SIBUNDOY','SAN FRANCISCO','SAN MIGUEL','SANTIAGO','VALLE DEL GUAMUEZ','VILLAGARZÓN','SAN ANDRÉS','PROVIDENCIA','LETICIA','EL ENCANTO','LA CHORRERA','LA PEDRERA','LA VICTORIA','MIRITÍ - PARANÁ','PUERTO ALEGRÍA','PUERTO ARICA','PUERTO NARIÑO','PUERTO SANTANDER','TARAPACÁ','INÍRIDA','BARRANCOMINAS','SAN FELIPE','PUERTO COLOMBIA','LA GUADALUPE','CACAHUAL','PANA PANA','MORICHAL','SAN JOSÉ DEL GUAVIARE','CALAMAR','EL RETORNO','MIRAFLORES','MITÚ','CARURÚ','PACOA','TARAIRA','PAPUNAHUA','YAVARATÉ','PUERTO CARREÑO','LA PRIMAVERA','SANTA ROSALÍA','CUMARIBO');

-- Regla CL9
select
	pua.t_id,
	pua.t_ili_tid,
	'El uso principal no puede ser NULL' as mensaje
from pot_uab_areasactividad pua
where pua.uso_principal is null;


--Regla CL10
select
	pua.t_id,
	pua.t_ili_tid,
	'El detalle de uso principal no puede ser NULL' as mensaje
from pot_uab_areasactividad pua
where pua.detalle_uso_principal is null;

--Regla CL11
select 
	pua.t_id,
	pua.t_ili_tid,
	'El registro debe asociar un registro en la estructura de uso compatible o complementario' as mensaje
from pot_uab_areasactividad pua 
left join pot_usocompatiblecomplementariovalor pu on pua.t_id = pu.pot_uab_areasactividad_uso_compatible_complementario 
where pu.pot_uab_areasactividad_uso_compatible_complementario  is null;

--Regla CL12
select 
	pua.t_id,
	pua.t_ili_tid,
	'El registro debe asociar un registro en la estructura de uso condicionado o restringido' as mensaje
from pot_uab_areasactividad as pua 
left join pot_usocondicionadorestringidovalor pu on pua.t_id = pu.pot_uab_areasactividad_uso_condicionado_restringido 
where pu.pot_uab_areasactividad_uso_condicionado_restringido is null;

--Regla CL13
select 
	pua.t_id,
	pua.t_ili_tid,
	'El registro debe asociar un registro en la estructura de uso prohibido' as mensaje
from pot_uab_areasactividad as pua 
left join pot_usoprohibidovalor pu on pua.t_id = pu.pot_uab_areasactividad_uso_prohibido  
where pu.pot_uab_areasactividad_uso_prohibido is null;

--Regla CL14
select
	put.t_id,
	put.t_ili_tid,
	'El tipo de tratamiento urbanístico no puede ser NULL' as mensaje
from pot_uab_tratamientourbanistico as put
where put.tipo_tratamiento_urbanistico  is null;

--Regla CL15
select
	puc.t_id,
	puc.t_ili_tid,
	'El tipo de clasificación del suelo no puede ser NULL' as mensaje
from pot_uab_clasificacionsuelo as puc
where puc.tipo_clasificacion_suelo is null;

--Regla C16
select
	puz.t_id,
	puz.t_ili_tid,
	'La categoría de suelo rural no puede ser NULL si la fecha de la fuente espacial es superior al 20 de septiembre de 2007' as mensaje
from pot_uab_zonificacionsuelorural as puz 
join pot_derecho as pd on puz.t_id = pd.unidad_pot_uab_zonificacionsuelorural
join col_rrrfuente as cr on pd.t_id = cr.rrr_pot_derecho
join pot_fuenteadministrativa as pf on pf.t_id = cr.fuente_administrativa  
where puz.tipo_categoria_rural is null and pf.fecha_documento_fuente  > to_date('2007-09-20', 'YYYY-MM-DD');

--Regla C17
select
	puz.t_id,
	puz.t_ili_tid,
	'El uso principal no puede ser NULL' as mensaje
from pot_uab_zonificacionsuelorural as puz
where puz.uso_principal is null;

--Regla C18
select
	puz.t_id,
	puz.t_ili_tid,
	'El detalle de uso principal no puede ser NULL' as mensaje
from pot_uab_zonificacionsuelorural as puz
where puz.detalle_uso_principal is null;

--Regla CL19
select 
	puz.t_id,
	puz.t_ili_tid,
	'El registro debe asociar un registro en la estructura de uso compatible o complementario' as mensaje
from pot_uab_zonificacionsuelorural puz 
left join pot_usocompatiblecomplementariovalor pu on puz.t_id = pu.pot_uab_zonifccnslrral_uso_compatible_complementario
where pu.pot_uab_zonifccnslrral_uso_compatible_complementario is null;

--Regla CL20
select
	puz.t_id,
	puz.t_ili_tid,
	'El registro debe asociar un registro en la estructura de uso condicionado o restringido' as mensaje
from pot_uab_zonificacionsuelorural puz 
left join pot_usocondicionadorestringidovalor pu on puz.t_id = pu.pot_uab_zonifccnslrral_uso_condicionado_restringido 
where pu.pot_uab_zonifccnslrral_uso_condicionado_restringido is null;

--Regla CL21
select 
	puz.t_id,
	puz.t_ili_tid,
	'El registro debe asociar un registro en la estructura de uso prohibido' as mensaje
from pot_uab_zonificacionsuelorural puz  
left join pot_usoprohibidovalor pu on puz.t_id = pu.pot_uab_zonifccnslrral_uso_prohibido 
where pu.pot_uab_zonifccnslrral_uso_prohibido is null;

--Regla CL22
select
	pst.t_id,
	pst.t_ili_tid,
	'El tipo de sistema general no puede ser NULL' as mensaje
from pot_uab_sistemasgenerales as pst
where pst.tipo_sistema_general is null;

--Regla CL23
select
	pst.t_id,
	pst.t_ili_tid,
	'El detalle del sistema general no puede ser NULL' as mensaje
from pot_uab_sistemasgenerales as pst
where pst.detalle_sistema_general is null;

--Regla CL24
select
	pst.t_id,
	pst.t_ili_tid,
	'El nivel del sistema general no puede ser NULL' as mensaje
from pot_uab_sistemasgenerales as pst
where pst.nivel is null;

--Regla CL25
select
	pst.t_id,
	pst.t_ili_tid,
	'El estado del sistema general no puede ser NULL' as mensaje
from pot_uab_sistemasgenerales as pst
where pst.estado is null;

--Regla CL26
select
	pz.t_id,
	pz.t_ili_tid,
	'El tipo de fenómeno de amenaza no puede ser NULL' as mensaje
from pot_uab_zonificacionamenaza as pz
where pz.fenomeno is null;

--Regla CL27
select
	pm.t_id,
	pm.t_ili_tid,
	'La categoria de amenaza no esta contenida en su totalidad por zonificación de amenaza de cetegoria media y alta' as mensaje
from (
select 
	st_union(st_makevalid(pua.geometria)) as geometria
from pot_ue_zonificacionamenaza as pua
join col_uebaunit as cu on pua.t_id = cu.ue_pot_ue_zonificacionamenaza
join pot_uab_zonificacionamenaza as puz on puz.t_id =cu.baunit_pot_uab_zonificacionamenaza 
where puz.categoria_amenaza in (select t_id from pot_categoriaamenazatipo pc where ilicode in ('Alta','Media'))) as zon
join pot_ue_areacondicionamenaza as pm on not st_contains(zon.geometria,pm.geometria);

--Regla CL28
select
	pua.t_id,
	pua.t_ili_tid,
	'El fenómeno no puede ser NULL' as mensaje
from pot_uab_areacondicionamenaza pua 
where pua.fenomeno is null;

--Regla CL29
select
	pua.t_id,
	pua.t_ili_tid,
	'La categoría de amenaza no puede ser NULL' as mensaje
from pot_uab_areacondicionamenaza pua
join pot_derecho pd on pua.t_id = pd.unidad_pot_uab_areacondicionamenaza
join col_rrrfuente cr on pd.t_id = cr.rrr_pot_derecho 
join pot_fuenteadministrativa pf on pf.t_id = cr.fuente_administrativa
where pua.categoria_amenaza is null and pf.fecha_documento_fuente >= to_date('2014-09-19', 'YYYY-MM-DD'); 


--Regla CL30
select
	pua.t_id,
	pua.t_ili_tid
	'El campo si es priorizado no puede se NULL' as mensaje
from pot_uab_areacondicionriesgo pua 
where pua.es_priorizado is null;