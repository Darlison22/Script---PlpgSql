


SELECT * FROM pje_jt.tb_municipio_ibge;

SELECT id_municipio FROM pje_jt.tb_municipio_ibge  where id_municipio_ibge = '2307650';

select * from pje.tb_municipio tm where tm.id_municipio =  8295;
select * from pje.tb_municipio tm where tm.id_municipio =  8213;

select * from pje.tb_estado te ;

select * from pje_jt.tb_atividade_economica tae ;


/*
 * Passando o nome do municipio no campo ds_munipio e o id_estado = 6 (id do ceará na tabela tb_estado) é possivel
 * receber as informações sem precisar ir no site do ibge. Ou pelo menos, certificar que as informações trazidas
 * pelo script são iguais as pesquisadas.
 * 
  Caso o select retorne null é porque provavelmente o nome do municipio digitado no 
  campo tm.ds_municipio está diferente do nome no banco de dados. Então, é necessário verificar se o nome
  digitado está correto. É preferivel que o nome seja digitado todo em maiusculo e caso tenha acentos, colocar.
  
  ------------------------------------------------------------------------------------
  
  Informações do script:
  
  São relacionadas tres tabelas, uma que tá no schema pje_jt e outras duas que estão no schema pje.
  
  É utilizado lef outer join para retornar possiveis registros nulos no campo do id_municipio_ibge 
  
  É necessário relacionar a tabela tb_estado com as outras duas porque tem alguns municipios de mesmo nome e o estado 
  serve para diferencia-las.
  
  te.in_ativo = 'S' é necessario porque tem alguns registros na tabela tb_municipio que estão desativados
*/

select 
	tm.id_municipio,
	tm.ds_municipio ,
	tmi.id_municipio_ibge ,
	te.ds_estado 
from pje.tb_municipio tm 
left outer join pje_jt.tb_municipio_ibge tmi on tmi.id_municipio = tm.id_municipio 
left outer join pje.tb_estado te on tm.id_estado = te.id_estado 
	where tm.ds_municipio ilike 'MARACANAÚ'
	and te.id_estado = 6
	and tm.in_ativo = 'S';

select * from pje.tb_municipio tm where tm.id_estado = 6 and tm.in_ativo = 'S';
