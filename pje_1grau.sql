select * from pje.tb_usuario_login tul where tul.ds_nome like 'FRANCISCO ALVES DE MENDONCA JUNIOR';
select u.id_usuario, u.ds_nome, u.ds_login from pje.tb_usuario_login u where u.ds_nome like 'YALIS%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'ISABEL MAIRA GUEDES DE SOUZA EICKMANN';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'ANDRE CARLOS DARLEY DE SOUSA CARNEIRO';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'LIA MOREIRA DOS SANTOS';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'RAFAEL FURTADO MORAIS';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'MICAEL LUIZ SANTOS AMORIM';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'TIAGO BRASIL%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'ANTONIO THIRSO RIBEIRO GONCALVES MEDEIROS%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'ANA PAULA LOPES DUARTE%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'CANDIDO AUGUSTO DE CASTRO PONTE FILHO%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'ANA PAULA LOPES DUARTE%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'LEYARA MENDONCA ROCHA%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'SINEZIO%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'MARCUS VINICIUS DE ALBUQUERQUE COSTA%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'GISELLE RAMOS HOLANDA%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'DEMETRIUS DE CASTRO MARTINS SILVEIRA%';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'RAIMUNDO DIAS DE OLIVEIRA NETO%';
select * from pje.tb_usuario_login tul where tul.ds_login = '25857061334';
select * from pje.tb_usuario_login tul where tul.ds_email = 'ericafeitosa@hotmail.com';
select * from pje.tb_usuario_login tul where tul.ds_nome like 'FRANCISCO OTAVIO COSTA%';

select tul.id_usuario from pje.tb_usuario_papel tup  join pje.tb_usuario_login tul 
on tup.id_usuario = tul.id_usuario where tul.ds_login like '09447022367';

select * from pje.tb_usuario_papel tup  where tup.id_usuario = 195275;
insert into pje.tb_usuario_papel (id_usuario, id_papel) values (195275, 5251);

--delete from pje.tb_usuario_papel where id_usuario = 221609;


select * from pje.tb_usuario_localizacao tul where tul.id_usuario = 9044; -- juNIOR
select * from pje.tb_usuario_localizacao tul where tul.id_usuario = 63925; -- Yalis
select * from pje.tb_usuario_localizacao tul where tul.id_usuario = 9067; -- Isabel
update pje.tb_usuario_localizacao set in_responsavel_localizacao = 'S' where id_usuario = 195275;

----------------------------------------------------------------------------
insert into pje.tb_usuario_localizacao (id_usuario, in_responsavel_localizacao, id_localizacao, id_papel, id_estrutura) 
values (63925, 'N', 919, 5251, null);
insert into pje.tb_usuario_localizacao (id_usuario, in_responsavel_localizacao, id_localizacao, id_papel, id_estrutura) 
values (63925, 'N', 60449, 5251, null);
-------------------------------------------------------------------

insert into pje.tb_usuario_localizacao (id_usuario, in_responsavel_localizacao, id_localizacao, id_papel, id_estrutura) 
values (9067, 'N', 6, 5197, null);




insert into tb_usuario_localizacao ( id_usuario, in_responsavel_localizacao, id_localizacao, id_papel, id_estrutura) 
values ( 422576, 'N', <NULL>, 5435, 1194);

select * from pje.tb_localizacao tl where id_localizacao  = 422576;




select * from pje.vs_painel_usuario u where u.nr_processo = '0001691-15.2017.5.07.0008';





-------------------------------------------------------------------------------------------------------------------------
-- Tentar mais tarde

select * from pje.tb_endereco te where te.cd_uf = 'CE';

select 
	te.id_endereco ,
	te.nm_logradouro ,
	te.nm_bairro ,
	te.nr_endereco ,
	tc.id_cep ,
	tc.nr_cep ,
	tc.nm_localidade 
from pje.tb_endereco te left outer join pje.tb_cep tc 
on te.id_cep = tc.id_cep where tc.nr_cep = '60765-145';


select 
	tpd.ds_processo_documento ,
	tpd.id_localizacao ,
	l.ds_localizacao ,
	tpd.id_papel ,
	tp2.ds_nome 
from pje.tb_processo_documento tpd left outer join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo join pje.tb_localizacao l
on l.id_localizacao = tpd.id_localizacao join pje.tb_papel tp2 
on tp2.id_papel = tpd.id_papel where tp.nr_processo like '0000739-14.2024.5.07.0033';



select 
	tl.id_localizacao ,
	tl.ds_localizacao as localizacao,
	tp.id_papel ,
	tp.ds_nome as papel
from pje.tb_usuario_localizacao tul left outer join pje.tb_usuario_login tul2 
on tul.id_usuario = tul2.id_usuario left join pje.tb_localizacao tl 
on tl.id_localizacao = tul.id_localizacao left outer join pje.tb_papel tp 
on tp.id_papel = tul.id_papel where tul2.ds_nome = 'FRANCISCO ALVES DE MENDONCA JUNIOR';

----------------------------------------------------------------------------------------------

delete from pje.tb_usuario_localizacao where id_usuario_localizacao = 3478;

select * from pje.tb_usu_local_mgtdo_servdor tulms left outer join pje.tb_usuario_localizacao tul 
on tulms.id_usu_local_mgstrado_servidor = tul.id_usuario_localizacao where tul.id_usuario = 12825 and tul.id_localizacao = 313;


select * from pje.tb_usu_local_mgtdo_servdor tulms where tulms.id_usu_local_mgstrado_servidor = 3479;

delete from pje.tb_usu_local_mgtdo_servdor where id_usu_local_mgstrado_servidor = 3478;


select * from pje.tb_orgao_julgador_cargo tojc where id_orgao_julgador_cargo = 7;






select * from pje.tb_papel tp where tp.id_papel = 5435;

---------------------  DOCMENTAÇÃO ---------------------------------------
-- Achar o id do papel que o usuario irá utilizar
select id_papel, ds_nome from pje.tb_papel tp;

--Achar o id da localição que o ususario irá utilizar
select id_localizacao, ds_localizacao from pje.tb_localizacao tl;

--Em seguida, será feito o cadastro do usuario na tabela usuario_localizacao passando como parametros o id_localizacao e id_papel
--para que o mesmo tenha acesso a um novo papel no sistema.
insert into pje.tb_usuario_localizacao (id_usuario, in_responsavel_localizacao, id_localizacao, id_papel, id_estrutura) 
values (id_usuario , 'N', id_localizacao, id_papel , null);

---------------------- DOCUMENTAÇÃO ------------------------------------



--0000820-20.2024.5.07.0014


select * from pje.tb_processo tp where tp.nr_processo = '0000820-20.2024.5.07.0014';


select * from pje.tb_processo_parte tpp left outer join pje.tb_processo_trf tpt 
on tpp.id_processo_trf = tpt.id_processo_trf join pje.tb_processo tp 
on tp.id_processo = tpt.id_processo_trf where tp.nr_processo like '0000820-20.2024.5.07.0014';

select * from pje.tb_processo_trf tpt ;


select * from pje.vs_processo_painel vpp where vpp.nr_processo like '0000820-20.2024.5.07.0014';


select * from pje.tb_processo_parte tpp ;

/* SELECT u.ds_nome
           FROM tb_processo_parte pp
             JOIN tb_usuario_login u ON u.id_usuario = pp.id_pessoa::integer
          WHERE pp.id_processo_trf::integer = proc.id_processo::integer AND pp.in_parte_principal::bpchar = 'S'::bpchar AND pp.in_participacao = 'P'::bpchar AND pp.in_situacao = 'A'::bpchar AND pp.nr_ordem = 1
         LIMIT 1) AS nm_pessoa_reu;*/
        
        
 select u.ds_nome, u.id_usuario from tb_processo_parte pp join tb_usuario_login u on u.id_usuario = pp.id_pessoa
join pje.tb_processo tp on tp.id_processo = pp.id_processo_trf where tp.nr_processo like '0000820-20.2024.5.07.0014';



select * from pje.tb_usuario_login tul where tul.ds_login like 'SPUTNIK BAR E RESTAURANTE LTDA - EPP';
select * from pje.tb_usuario_login tul where tul.id_usuario = 54858;

update pje.tb_usuario_login set ds_nome = 'LPG FORTALEZA EVENTOS LTDA' where id_usuario = 54858;



------------------------------------------------------------------------------------
select
	tul.id_usuario ,
	tul.ds_nome ,
	ttpd.id_tipo_processo_documento ,
	ttpd.ds_tipo_processo_documento ,
	p.id_papel ,
	p.ds_nome ,
	tl.id_localizacao ,
	tl.ds_localizacao ,
	tpd.*
from pje.tb_processo_documento tpd left outer join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo inner join pje.tb_usuario_login tul 
on tul.id_usuario  = tpd.id_usuario_inclusao inner join pje.tb_tipo_processo_documento ttpd
on ttpd.id_tipo_processo_documento  = tpd.id_tipo_processo_documento inner join pje.tb_papel p
on p.id_papel = tpd.id_papel inner join pje.tb_localizacao tl
on tl.id_localizacao = tpd.id_localizacao where tp.nr_processo = '0000265-88.2024.5.07.0018'; --38987963


select * from pje.tb_usuario_login tul where tul.ds_login = '25857061334';

select * from pje.tb_usuario_localizacao tul where tul.id_usuario = 3112;
select * from pje.tb_localizacao tl where tl.id_localizacao = 461;
select * from pje.tb_papel tp where tp.id_papel = 1005;

select tpt.* from pje.tb_processo tp inner join pje.tb_processo_trf tpt 
on tpt.id_processo_trf = tp.id_processo where tp.nr_processo = '0000265-88.2024.5.07.0018';

 select tpt.* from pje.tb_processo tp inner join pje.tb_processo_trf tpt 
on tpt.id_processo_trf = tp.id_processo where tp.nr_processo = '0001225-78.2023.5.07.0018';
 
 
 ------------------------------------------------------------------------------------------------
 
 
 
 select ds_login from pje.tb_usuario_login tul where ds_email = 'candido.ponte@trt7.jus.br' ;
 select ds_login from pje.tb_usuario_login tul where ds_nome = 'CRISTIANO CARVALHO FIALHO' ;

 
 

select 
	tpt.id_processo_trf 
from pje.tb_processo_documento tpd inner join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo inner join pje.tb_processo_trf tpt 
on tpt.id_processo_trf = tp.id_processo where tp.nr_processo = '0000424-76.2024.5.07.0003';

select * from pje.tb_usuario_login tul where tul.id_usuario = 8538;


select * from pje.vs_painel_usuario_localizacao vpul ;




-------------------------------------------------------------------------------------


select 
	tpd.*
from pje.tb_processo_documento tpd inner join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo where tp.nr_processo = '0000424-76.2024.5.07.0003';

select * from pje.tb_tipo_processo_documento ttpd where ttpd.id_tipo_processo_documento = 81;

update pje.tb_processo_documento set id_tipo_processo_documento = 2 where id_processo_documento =39028848;

select * from pje.tb_usuario_login tul where tul.id_usuario = 8538;






select 
	tul.ds_nome ,
	tpd.*
from pje.tb_processo_documento tpd inner join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo inner join pje.tb_usuario_login tul
on tpd.id_usuario_alteracao = tul.id_usuario where tp.nr_processo = '0000569-69.2024.5.07.0024';

select * from pje.tb_localizacao tl where tl.id_localizacao = 7755;


select * from pje.tb_usuario_login tul where id_usuario = 1718 or id_usuario = 8545 or id_usuario = 8739;

---------------------------------------------------------------------------------------------------------

select 
	tpd.* 
from pje.tb_processo_documento tpd inner join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo where nr_processo = '0000569-69.2024.5.07.0024';



select 
	tpt.* 
from pje.tb_processo_tarefa tpt 
inner join pje.tb_processo_trf tpt2 on tpt.id_processo_trf = tpt2.id_processo_trf 
inner join pje.tb_processo tp on tpt.id_processo_trf = tp.id_processo 
	where tp.nr_processo = '0000569-69.2024.5.07.0024';


select 
	tpt.* 
from pje.tb_processo_trf tpt 
inner join pje.tb_processo tp on tpt.id_processo_trf = tp.id_processo 
inner join pje.tb_orgao_julgador toj on tpt.id_orgao_julgador = toj.id_orgao_julgador 
	where tp.nr_processo = '0000569-69.2024.5.07.0024';

update pje.tb_processo_trf set id_cargo = 1  where id_processo_trf = 833388;
update pje.tb_processo_trf set id_orgao_julgador_cargo = 72 where id_processo_trf = 833388;

delete from pje.tb_usu_local_mgtdo_servdor where id_usu_local_mgstrado_servidor = 14736;
delete from pje.tb_usuario_localizacao where id_usuario_localizacao = 14736;


select * from pje.tb_orgao_julgador_cargo tojc where ds_cargo ilike '%Sobral%'; --id_cargo = 2

select 
	tul.*,
	tulms.*,
	tulv.*
from pje.tb_pessoa_magistrado tpm 
left outer join pje.tb_usuario_localizacao tul on tpm.id = tul.id_usuario 
left outer join pje.tb_usu_local_mgtdo_servdor tulms on tulms.id_usu_local_mgstrado_servidor = tul.id_usuario_localizacao 
left outer join pje.tb_usu_local_visibilidade tulv on tulv.id_usu_local_mgstrado_servidor = tulms.id_usu_local_mgstrado_servidor 
	where tpm.id = 
	(select id_usuario from pje.tb_usuario_login tul where tul.ds_nome like 'RAIMUNDO DIAS DE OLIVEIRA NETO%')
	and tul.id_localizacao = 7755;




select * from pje.tb_usu_local_mgtdo_servdor tulms where tulms.id_orgao_julgador_cargo = 72;

select * from pje.tb_usuario_localizacao tul where tul.id_usuario_localizacao in (10548, 10346, 15989, 18227, 61232, 67008, 105299, 112109);

select * from pje.tb_usuario_login tul where tul.id_usuario in (10548, 10346, 15989, 18227, 61232, 67008, 105299, 112109);


---------------------------------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.id_usuario = 8538; -- 96256;

update pje.tb_processo_documento set id_usuario_inclusao = 8538 where id_processo_documento = 39170010;
update pje.tb_processo_documento set id_usuario_alteracao = 8538 where id_processo_documento = 39170010;
--update pje.tb_processo_documento set dt_alteracao = null where id_processo_documento = 39170010;

select 
	tpd.* 
from pje.tb_processo_documento tpd inner join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo where nr_processo = '0000569-69.2024.5.07.0024';

select * from pje.tb_tipo_processo_documento ttpd where ttpd.id_tipo_processo_documento = 62;
select * from pje.tb_papel tp where tp.id_papel = 1469;
select * from pje.tb_localizacao tl where tl.id_localizacao = 7755;

select 
	tpt.id_processo_trf ,
	tp.nr_processo ,
	toj.id_orgao_julgador ,
	toj.ds_orgao_julgador ,
	tojc.id_orgao_julgador_cargo ,
	tojc.ds_cargo,
	tul2.ds_nome,
	tul2.ds_login ,
	tul2.id_usuario 
from pje.tb_processo_trf tpt 
left outer join pje.tb_processo tp on tpt.id_processo_trf = tp.id_processo 
left outer join pje.tb_orgao_julgador toj on tpt.id_orgao_julgador = toj.id_orgao_julgador 
left outer join pje.tb_orgao_julgador_cargo tojc on tpt.id_orgao_julgador_cargo = tojc.id_orgao_julgador_cargo
left outer join pje.tb_usu_local_mgtdo_servdor tulms on tulms.id_orgao_julgador_cargo = tojc.id_orgao_julgador_cargo 
left outer join pje.tb_usuario_localizacao tul on tulms.id_usu_local_mgstrado_servidor = tul.id_usuario_localizacao 
left outer join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario  
	where tp.nr_processo = '0000569-69.2024.5.07.0024' 
	and tojc.id_orgao_julgador_cargo  = tojc.id_orgao_julgador_cargo + 1;


update pje.tb_processo_documento set in_ativo = 'N' where id_processo_documento = 39054386;

select * from pje.tb_pessoa_magistrado tpm where tpm.id = 8538;

select * from pje.tb_processo_trf tpt where tpt.id_processo_trf = 833388;

update pje.tb_processo_trf set id_orgao_julgador_cargo = 72 where id_processo_trf = 833388;


select
	s.id_usu_local_mgstrado_servidor ,
	s.id_orgao_julgador ,
	s.id_orgao_julgador_cargo ,        --id_orgao_julgador = 37 and id_orgao_julgador_cargo = 72
	tul2.ds_nome ,
	tul.id_usuario_localizacao 
from pje.tb_usu_local_mgtdo_servdor s 
left outer join pje.tb_usuario_localizacao tul on s.id_usu_local_mgstrado_servidor = tul.id_usuario_localizacao
left outer join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario where tul2.id_usuario = 8538 and id_orgao_julgador_cargo = 73 and id_orgao_julgador = 37;


select * from pje.tb_orgao_julgador_cargo tojc where tojc.id_orgao_julgador_cargo = 72;

select * from pje.tb_usu_local_visibilidade tulv where id_usu_local_mgstrado_servidor = 70287;
select * from pje.tb_usu_local_visibilidade tulv where id_usu_local_mgstrado_servidor = 14736;

select * from pje.tb_usuario_localizacao tul where tul.id_usuario_localizacao = 70287;
select * from pje.tb_usuario_localizacao tul where tul.id_usuario_localizacao = 14736;

select * from pje.tb_usuario_localizacao tul where tul.id_usuario = 8538;


delete from pje.tb_usu_local_mgtdo_servdor where id_usu_local_mgstrado_servidor = 14736;
delete from pje.tb_usuario_localizacao where id_usuario_localizacao = 14736;

 
 
 
 
----------------------------------------------------------------------------------------------



select * from pje.tb_tarefa tt where tt.ds_tarefa ilike 'Aguardando Prazo' ;


select 
	tpe.*
from pje.tb_processo tp 
inner join pje.tb_processo_trf tpt on tpt.id_processo_trf = tp.id_processo  
inner join pje.tb_processo_tarefa tpt2 on tpt2.id_processo_trf = tpt.id_processo_trf 
inner join pje.tb_processo_expediente tpe on tpe.id_processo_trf = tpt.id_processo_trf 
where tp.nr_processo = '0000576-79.2024.5.07.0018';

update pje.tb_processo_expediente set id_orgao_julgador = null, in_tipo_localizacao_processo = null where id_processo_expediente =5506040;
update pje.tb_processo_expediente set id_orgao_julgador = null, in_tipo_localizacao_processo = null where id_processo_expediente =5539933;
update pje.tb_processo_expediente set id_orgao_julgador = null, in_tipo_localizacao_processo = null where id_processo_expediente =5539934;

select * from pje.tb_orgao_julgador toj where toj.id_orgao_julgador = 23;

select 
	tpd.*
from pje.tb_processo tp inner join pje.tb_processo_documento tpd 
on tpd.id_processo = tp.id_processo where tp.nr_processo = '0001244-26.2024.5.07.0026';

select * from pje.tb_tipo_expediente tte ;


select 
	tpj.*
from pje_jt.tb_processo_jt tpj inner join pje.tb_processo_trf tpt 
on tpj.id_processo_trf = tpt.id_processo_trf inner join pje.tb_processo tp 
on tpt.id_processo_trf = tp.id_processo where tp.nr_processo = '0001244-26.2024.5.07.0026';





------------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_nome = 'DEMETRIUS DE CASTRO MARTINS SILVEIRA';



select * from pje.vs_tarefa_painel vtp where vtp.id_processo_trf = (select id_processo from pje.tb_processo tp
where tp.nr_processo = '0009800-10.1992.5.07.0003');





select 
	tdth.*
from pje_jt.tb_dbto_trblhsta_historico tdth
        inner join pje.tb_processo_parte tpp on tdth.id_processo_parte = tpp.id_processo_parte
        inner join pje.tb_processo tp on tp.id_processo = tpp.id_processo_trf
        inner join pje.tb_usuario_login tul on tul.id_usuario = tpp.id_pessoa
    	where 1=1
        and tp.nr_processo = '0009800-10.1992.5.07.0003'
        and tdth.in_tipo_operacao = 'I'; 
 
         
select 
	*
from pje_jt.tb_debito_trabalhista tdt
        inner join pje.tb_processo_parte tpp on tdt.id_processo_parte = tpp.id_processo_parte
        inner join pje.tb_processo tp on tp.id_processo = tpp.id_processo_trf
   		where 1=1
        and tp.nr_processo = '0009800-10.1992.5.07.0003';
         
     
-----------------------------------------------------------------------------------------
       
select * from pje.tb_usuario_login tul where tul.ds_nome like '%ROSA DE LOURDES AZEVEDO BRINGEL%';

select * from pje.tb_usuario_login tul where tul.id_usuario = 37383;



select 
	tpd.*
from pje.tb_processo_documento tpd inner join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo where tp.nr_processo = '0000408-60.2023.5.07.0035';

select 
	tpt.*
from pje.tb_processo tp inner join pje.tb_processo_trf tpt
on tp.id_processo = tpt.id_processo_trf where tp.nr_processo = '0000408-60.2023.5.07.0035';

select * from pje.tb_orgao_julgador toj where toj.ds_orgao_julgador = 'Gab. Des. Rosa de Lourdes%';





select 
	tul.id_usuario ,
	tul.ds_nome ,
	tulms.*
from pje.tb_pessoa_magistrado tpm 
inner join pje.tb_usuario_login tul on tpm.id = tul.id_usuario 
inner join pje.tb_usuario_localizacao tul2 on tul2.id_usuario= tul.id_usuario 
inner join pje.tb_usu_local_mgtdo_servdor tulms on tulms.id_usu_local_mgstrado_servidor = tul2.id_usuario_localizacao 
where tul.ds_email = 'rosala@trt7.jus.br';



-------------------------------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_email = 'ericafeitosa@hotmail.com';

select * from pje.tb_pessoa_imp_suspeicao tpis where tpis.id_pessoa = 8576;



select 
	tpp.*
from pje.tb_processo_push tpp inner join pje.tb_processo tp 
on tpp.id_processo_trf = tp.id_processo where tp.nr_processo in('0000462-93.2017.5.07.0016');

select * from pje.tb_processo_push tpp where tpp.id_pessoa = 104355;

select * from pje.tb_pessoa_advogado tpa where tpa.id = 104355;

update pje.tb_pessoa_advogado set in_incluir_processo_push = 'S' where id = 104355;


select * from pje.tb_pessoa_push tpp ;



select 
	tpt.*
from pje.tb_processo tp 
inner join pje.tb_processo_trf tpt on tpt.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0000823-63.2024.5.07.0017';







select 
	tpd.id_processo_documento ,
	tpd.ds_processo_documento ,
	tpd.id_usuario_inclusao ,
	tpd.id_usuario_alteracao ,
	tpd.in_ativo ,
	tpd.dt_juntada ,
	tpd.id_papel ,
	tpd.id_localizacao 
from pje.tb_processo tp 
inner join pje.tb_processo_documento tpd on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0000823-63.2024.5.07.0017';

-- id_usuario_inclusao = 8976, id_usuario_alteracao = 8976, id_papel = 5186
update pje.tb_processo_documento set id_usuario_inclusao = 353532, id_usuario_alteracao = 353532,  id_papel = 1469 where id_processo_documento = 39447767;

UPDATE pje.tb_processo_documento
    SET in_ativo='S'
    WHERE id_processo_documento=39447767;

select * from pje.tb_usuario_login tul where tul.ds_nome = 'JORGEANA LOPES DE LIMA';
select * from pje.tb_papel tp ;

select 
	tul2.*
from pje.tb_usu_local_mgtdo_servdor tulms
inner join pje.tb_usuario_localizacao tul on tul.id_usuario_localizacao = tulms.id_usu_local_mgstrado_servidor 
inner join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario where tulms.id_orgao_julgador = 22;

select 
	*
from pje.tb_processo tp 
left outer join pje.tb_processo_trf tpt on tpt.id_processo_trf = tp.id_processo 
left outer join pje_jt.tb_pauta_sessao tps on tps.id_processo_trf = tpt.id_processo_trf 
left outer join pje_jt.tb_jt_sessao tjs on tps.id_sessao = tjs.id_sessao 
where tp.nr_processo = '0146900-75.1990.5.07.0003';

select 
	tpa.* 
from pje.tb_processo_audiencia tpa inner join pje.tb_processo tp 
on tpa.id_processo_trf = tp.id_processo where tp.nr_processo = '0000823-63.2024.5.07.0017';

select * from pje.tb_usuario_login tul where tul.ds_nome = 'SILAH DE NOROES MILFONT';


UPDATE tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 147856;
UPDATE tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 147856;
UPDATE tb_processo set id_caixa = null where id_processo = 147856;


select 
	 tpt.id_processo_trf ,
	 tp.id_caixa ,
	 tpj.id_pessoa_revisor_processo ,
	 tpt.id_orgao_julgador_revisor 
from pje.tb_processo_trf tpt 
inner join pje.tb_processo tp on tpt.id_processo_trf = tp.id_processo 
inner join pje_jt.tb_processo_jt tpj on tpj.id_processo_trf = tpt.id_processo_trf 
where tp.nr_processo = '0000823-63.2024.5.07.0017';


select * from pje.tb_caixa;
select * from pje.tb_orgao_julgador toj 

UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = 2 where id_processo_trf = 848001;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = 1 where id_processo_trf = 848001;
UPDATE pje.tb_processo set id_caixa = 84 where id_processo = 848001;


UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 848001;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 848001;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 848001;


------------------------------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_nome = 'ADRIANO ALISSON RENAUX LOPES';





select * from pje.vs_consulta_processo_audiencia vcpa where vcpa.nr_processo in ('0000680-35.2024.5.07.0030', '0000679-50.2024.5.07.0030');.





select * from pje_jt.tb_aud_importacao tai where id_processo in(
	select id_processo from pje.tb_processo tp where tp.nr_processo in('0000680-35.2024.5.07.0030', '0000679-50.2024.5.07.0030'));


select * from pje_jt.tb_aud_parte_importacao tapi where tapi.id_aud_importacao in(813995, 813996) ;
select * from pje_jt.tb_aud_verba_importacao tavi where tavi.id_aud_importacao in(813995, 813996);

select * from pje.tb_audiencia_andamento taa ;

select * from pje.tb_result_sentenca_parte trsp ;

select * from pje.tb_resultado_sentenca trs where trs.id_processo_trf in (
	select id_processo from pje.tb_processo tp where tp.nr_processo in('0000680-35.2024.5.07.0030', '0000679-50.2024.5.07.0030'));

select * from pje.tb_hist_proc_doc_visibilidade_sigilo thpdvs where id_documento =  39395681;

select * from pje.tb_proc_doc_visibilidade_sigilo tpdvs where id_processo_documento = 39395681;


select * from pje.tb_processo_documento tpd where tpd.id_processo_documento = 39395681;

select * from pje.tb_processo_audiencia tpa where id_processo_audiencia in (995325, 995326);

update pje.tb_processo_audiencia set cd_status_audiencia = 'M' where id_processo_audiencia in(995325, 995326);


select * from pje.tb_audiencia_andamento taa where taa.id_processo_audiencia in(995325, 995326);

delete from pje.tb_audiencia_andamento where id_audiencia_andamento in(484981,485601,485583,485068,485603,485585);


---------------------------------------------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_nome ='ADRIANO ALISSON RENAUX LOPES';


select * from pje_jt.tb_aud_importacao tai where tai.id_processo in (
select id_processo from pje.tb_processo p where p.nr_processo in ('0000680-35.2024.5.07.0030', '0000679-50.2024.5.07.0030'));


select * from pje_jt.vs_aud_pauta vap where vap.id_processo_trf in(
select id_processo from pje.tb_processo p where p.nr_processo in ('0000680-35.2024.5.07.0030', '0000679-50.2024.5.07.0030'));


select * from pje_jt.vs_aud_parte vap where id_processo_trf in(
select id_processo from pje.tb_processo p where p.nr_processo in ('0000680-35.2024.5.07.0030', '0000679-50.2024.5.07.0030'));


select * from pje_jt.vs_aud_parte vap where id_processo_trf  = (
select id_processo from pje.tb_processo p where p.nr_processo = '0000680-35.2024.5.07.0030');


select * from pje_jt.vs_aud_conf vac where id_processo_trf in (
select id_processo from pje.tb_processo p where p.nr_processo in ('0000680-35.2024.5.07.0030', '0000679-50.2024.5.07.0030'));

select * from pje_jt.vs_aud_conf vac where vac.id_processo_trf = (select id_processo from pje.tb_processo p where p.nr_processo = '0000680-35.2024.5.07.0030');
select * from pje_jt.vs_aud_conf vac where vac.id_processo_trf = (select id_processo from pje.tb_processo p where p.nr_processo = '0000679-50.2024.5.07.0030');
select * from pje_jt.vs_aud_conf vac where vac.id_processo_trf = (select id_processo from pje.tb_processo p where p.nr_processo = '0000823-63.2024.5.07.0017');
select * from pje_jt.vs_aud_conf vac;
select * from pje_jt.tb_municipio_ibge tmi where tmi.id_municipio_ibge = '1100015';
select * from pje_jt.tb_municipio_ibge tmi where tmi.id_municipio = 8184;

select * from pje.tb_municipio tm where tm.ds_municipio = 'FORTALEZA'; --2304400

select * from pje.tb_localizacao tl ;
select * from pje.tb_orgao_julgador toj ;
select * from pje.tb_cep;
select * from pje.tb_estado te ;

select * from pje.tb_processo_trf tpt where tpt.id_processo_trf = (select id_processo from pje.tb_processo p where p.nr_processo = '0000679-50.2024.5.07.0030');


select * from pje.tb_endereco te ;


select * from pje_jt.vs_aud_juizes_oj vajo where vajo.nm_magistrado = 'ANTONIO GONCALVES PEREIRA';
select * from pje_jt.vs_aud_juizes vajo where vajo.ds_nome = 'ANTONIO GONCALVES PEREIRA';

select * from pje.tb_usuario_login tul where tul.ds_nome = 'ANTONIO GONCALVES PEREIRA';



------------------------------- AQUI AQUI AQUI --------------------------------------------------


select 
	tpd.*
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0000680-35.2024.5.07.0030'
and id_processo_documento in (39653755, 39653750);

delete from pje.tb_processo_documento where id_processo_documento = 39653755;



update pje.tb_processo_documento set id_usuario_inclusao = 
(select id_usuario from pje.tb_usuario_login u where u.ds_nome = 'ANTONIO GONCALVES PEREIRA' and u.ds_email is not null)
where id_processo = (select id_processo from pje.tb_processo where nr_processo = '0000680-35.2024.5.07.0030')
and dt_juntada is null;

update pje.tb_processo_documento set id_papel = (select id_papel from pje.tb_papel where ds_nome = 'Magistrado')
where id_processo = (select id_processo from pje.tb_processo where nr_processo = '0000680-35.2024.5.07.0030')
and dt_juntada is null;

update pje.tb_processo_documento set in_ativo = 'N' 
where id_processo_documento = 20850452;



select 
	jn.*
from pje.tb_processo_instance tpi 
inner join pje_jbpm.jbpm_processinstance jp on tpi.id_proc_inst = jp.id_ 
inner join pje_jbpm.jbpm_processdefinition jp2 on jp.processdefinition_ = jp2.id_ 
inner join pje_jbpm.jbpm_taskinstance jt2 on jt2.procinst_ = jp.id_ 
inner join pje_jbpm.jbpm_node jn on (jn.processdefinition_ = jp2.id_ and jt2.name_ = jn.name_ )
where tpi.id_processo = (select id_processo from pje.tb_processo tp where tp.nr_processo = '0000679-50.2024.5.07.0030')
and tpi.in_ativo = 'S' order by jn.id_ desc;

select * from pje_jbpm.jbpm_task jt ;
select * from pje_jbpm.jbpm_processinstance jp where jp.id_ = 284685869;
select * from pje_jbpm.jbpm_processinstance jp where jp.id_ = 287089404;
select * from pje_jbpm.jbpm_taskinstance jt ;
select * from pje_jbpm.jbpm_node jn ;
select * from pje_jbpm.jbpm_processdefinition jp ;


---------------------------------------------- AQUI AQUI AQUI ----------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_nome = 'LUIS EDUARDO FREITAS GOULART';




select * from pje.tb_pess_doc_identificacao tpdi ;

select * from pje.tb_usuario_login tul where tul.ds_login = '05364846350';



select * from pje.tb_usuario_login tul where tul.ds_email = 'demetrius.silveira@trt7.jus.br';



select 
	tpt.* 
from pje.tb_processo_trf tpt 
inner join pje.tb_processo tp on tpt.id_processo_trf = tp.id_processo 
where tp.nr_processo in ('0000679-50.2024.5.07.0030', '0000680-35.2024.5.07.0030');

select 
	--tpt.*
	jt.* 
from pje.tb_processo_tarefa tpt 
inner join pje.tb_processo tp on tpt.id_processo_trf = tp.id_processo 
inner join pje_jbpm.jbpm_processinstance jp on tpt.id_processinstance = jp.id_
inner join pje_jbpm.jbpm_task jt on tpt.id_task = jt.id_ 
inner join pje_jbpm.jbpm_token jt2 on tpt.id_token = jt2.id_ 
inner join pje_jbpm.jbpm_taskinstance jt3 on tpt.id_taskinstance = jt3.id_ 
where tp.nr_processo in ('0000679-50.2024.5.07.0030', '0000680-35.2024.5.07.0030');




select * from pje.tb_usuario_login tul where tul.ds_nome = 'LEYARA MENDONCA ROCHA';






select 
	*
	--thpp.*
	--tpp3.*
from pje.tb_perito_profissao tpp 
inner join pje.tb_usuario_login tul on tpp.id_pessoa_perito = tul.id_usuario 
inner join pje.tb_processo_pericia tpp2 on tpp2.id_pessoa_perito = tpp.id_pessoa_perito 
inner join pje.tb_processo tp on tpp2.id_processo_trf = tp.id_processo
--inner join pje.tb_historico_processo_pericia thpp on thpp.id_processo_pericia = tpp2.id_processo_pericia 
where tul.ds_nome = 'FREDERICO SERGIO UCHOA FEITOSA'
and tp.nr_processo = '0000991-87.2018.5.07.0013';

select * from pje.tb_profissao_ajjt tpa ;

select * from pje.tb_processo_pericia_pagamento tppp where tppp.id_processo_pericia in(19451, 20487);

select * from pje.tb_processo_pericia tpp where tpp.id_processo_pericia in (19451, 20487);


select * from pje.tb_usuario_login tul where tul.ds_nome = 'GILSON GONDIM LIMA VIANA';

select * from pje.tb_usuario_login tul where tul.ds_email = 'carlalms@trt7.jus.br';

select * from pje.tb_proc_localizacao_ibpm tpli where tpli.id_processo = (select id_processo from pje.tb_processo where nr_processo = '0000020-53.2019.5.07.0018');


select 
	tulms.* 
from pje.tb_usu_local_mgtdo_servdor tulms  
inner join pje.tb_orgao_julgador toj on tulms.id_orgao_julgador = toj.id_orgao_julgador 
where toj.ds_orgao_julgador = '18ª Vara do Trabalho de Fortaleza' and tulms.id_orgao_julgador_cargo != 49;

select * from pje.vs_tarefa_painel vtp where vtp.id_processo_trf = 
(select tp.id_processo from pje.tb_processo tp where tp.nr_processo = '0000020-53.2019.5.07.0018');
select * from pje.vs_fluxo_tarefa_processo vftp where vftp.id_processo_trf = 
(select tp.id_processo from pje.tb_processo tp where tp.nr_processo = '0000020-53.2019.5.07.0018');

select * from pje.vs_tarefa_anterior vta where vta.id_processo = (select tp.id_processo from pje.tb_processo tp where tp.nr_processo = '0000020-53.2019.5.07.0018');

--287272805
select * from pje.vs_painel_usuario_localizacao vpul where vpul.id_processo_trf = 
(select tp.id_processo from pje.tb_processo tp where tp.nr_processo = '0000020-53.2019.5.07.0018');

select * from pje.tb_tarefa tt  where tt.ds_tarefa ilike '%definitivo%' ;

select * from pje.tb_processo_tarefa tpt ;

select * from pje.tb_res_escaninho tre ;-- where tre.id_processo = (select tp.id_processo from pje.tb_processo tp where tp.nr_processo = '0000020-53.2019.5.07.0018');




select * from pje.tb_processo_trf tpt 
inner join pje.tb_processo tp on tpt.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0160900-89.2004.5.07.0003';

select * from pje.tb_processo tp where tp.nr_processo = '0160900-89.2004.5.07.0003';

select * from pje.tb_processo_documento tpd 
where tpd.id_processo = (select id_processo from pje.tb_processo tp where tp.nr_processo = '0001025-37.2024.5.07.0018')
and tpd.dt_juntada is  not null; --1469

select * from pje.tb_processo_documento tpd 
where tpd.id_processo = (select id_processo from pje.tb_processo tp where tp.nr_processo = '0001025-37.2024.5.07.0018')
and tpd.dt_juntada is  null; --1469

select  * from pje.tb_papel tp ;

update tb_processo_documento
set id_papel = 1469
where id_processo_documento = 39655073 
and id_usuario_inclusao = 681500;

update tb_processo_documento set in_ativo = 'S' where id_processo_documento = 39645009;

select * from pje.tb_usuario_login tul where tul.id_usuario = 681500;

select 
	jp2.*,
	jt.*
from pje.tb_processo_instance tpi
inner join pje_jbpm.jbpm_processinstance jp on tpi.id_proc_inst = jp.id_ 
inner join pje_jbpm.jbpm_processdefinition jp2 on jp.processdefinition_ = jp2.id_ 
inner join pje_jbpm.jbpm_taskinstance jt on jt.procinst_ = jp.id_ 
where tpi.id_processo = (select id_processo from pje.tb_processo tp where tp.nr_processo = '0001288-22.2013.5.07.0029');


select * from pje.tb_usuario_login tul where tul.ds_nome = 'CARLOS AUGUSTO GONCALVES DA SILVA';

select * from pje.tb_processo_parte tpp 
where tpp.id_processo_trf  = (select id_processo from pje.tb_processo where nr_processo = '0001288-22.2013.5.07.0029')
and tpp.id_pessoa in (224312, 50);

select * from pje.tb_municipio tm where tm.ds_municipio ilike '%TIANGUA%';


update pje.tb_processo_parte set in_situacao = 'I'  where id_processo_parte = 1263628;

select * from pje.tb_usuario_login tul where tul.ds_nome = 'RODRIGO RAMOS FREIRE DE CASTRO';

--select * from pje.tb_proc_parte_historico tpph  order by tpph.id_processo_parte_historico desc;

select * from pje.vs_processo_parte_webservice vppw where id_processo_trf = (select id_processo from pje.tb_processo where nr_processo = '0001288-22.2013.5.07.0029') ;


select * from pje.tb_usuario_login tul where tul.ds_nome = 'MARLEY CISNE DE MORAIS JUNIOR';

select * from pje.vs_proc_documento_webservice vpdw where vpdw.id_processo = 
(select id_processo from pje.tb_processo tp where nr_processo = '0001137-47.2021.5.07.0006') ;

select * from pje.vs_consulta_processo vcp  where id_processo_trf  = (select id_processo from pje.tb_processo tp where nr_processo = '0001137-47.2021.5.07.0006');


select 
	tpd.*
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0001137-47.2021.5.07.0006' and tpd.id_localizacao = 11;


select * from pje.tb_proc_localizacao_ibpm tpli  where id_processo =(select id_processo from pje.tb_processo tp where nr_processo = '0001137-47.2021.5.07.0006') ;

select * from pje_jbpm.jbpm_processdefinition jp where jp.name_ ilike '%Remessa%'

select 
	* 
from pje.tb_proc_localizacao_ibpm tpli 
inner join pje_jbpm.jbpm_task jt  on tpli.id_task_jbpm = jt.id_ 
inner join pje_jbpm.jbpm_processinstance jp on tpli.id_processinstance_jbpm = jp.id_ ;


-------------------------------------------------------- Inicio - Tentativa de assinar atas de audiencia --------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_nome = 'ALEXANDRE FRANCO VIEIRA';

select 
	tulms.*
from pje.tb_usu_local_mgtdo_servdor tulms 
inner join pje.tb_usuario_localizacao tul on tulms.id_usu_local_mgstrado_servidor = tul.id_usuario_localizacao 
inner join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario 
inner join pje.tb_orgao_julgador toj on tulms.id_orgao_julgador = toj.id_orgao_julgador 
where tul2.ds_email = 'alexandre.vieira@trt7.jus.br'
and toj.ds_orgao_julgador ilike '%1ª Vara do Trabalho da Região do Cariri%';

update pje.tb_usu_local_mgtdo_servdor set id_pessoa_magistrado = (select id_usuario from pje.tb_usuario_login where ds_email = 'alexandre.vieira@trt7.jus.br' )
where id_usu_local_mgstrado_servidor  = 
(select  id_usuario_localizacao from pje.tb_usuario_localizacao where id_usuario = 
	(select id_usuario from pje.tb_usuario_login where ds_email = 'alexandre.vieira@trt7.jus.br')  and id_localizacao = 6600)
and  id_orgao_julgador = 31;

select  * from pje.tb_usuario_localizacao where id_usuario = 
	(select id_usuario from pje.tb_usuario_login where ds_email = 'alexandre.vieira@trt7.jus.br') ;

select * from pje.tb_orgao_julgador toj where toj.ds_orgao_julgador ilike '%Vara%';

select 
	*
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0001165-44.2024.5.07.0027'
and tpd.dt_juntada is null;

select 
	tpt.*
from pje.tb_processo_trf tpt inner join pje.tb_processo tp on tpt.id_processo_trf = tp.id_processo 
where tp.nr_processo in ( '0001231-91.2024.5.07.0037', '0001165-44.2024.5.07.0027', '0001041-61.2024.5.07.0027', '0001239-69.2022.5.07.0027');

update pje.tb_processo_trf set id_cargo = 1, id_orgao_julgador_cargo = 62 where id_processo_trf in (
	select id_processo from pje.tb_processo where nr_processo in (
	'0001231-91.2024.5.07.0037', 
	'0001165-44.2024.5.07.0027',
	'0001041-61.2024.5.07.0027', 
	'0001239-69.2022.5.07.0027'));

select * from pje.tb_processo_audiencia tpa 
where tpa.id_processo_trf in (select id_processo from pje.tb_processo where nr_processo in (
	'0001231-91.2024.5.07.0037', 
	'0001165-44.2024.5.07.0027',
	'0001041-61.2024.5.07.0027', 
	'0001239-69.2022.5.07.0027'));

update pje.tb_processo_audiencia set cd_status_audiencia = 'F' where id_processo_trf in (
	select id_processo from pje.tb_processo where nr_processo in (
	'0001231-91.2024.5.07.0037', 
	'0001165-44.2024.5.07.0027',
	'0001041-61.2024.5.07.0027', 
	'0001239-69.2022.5.07.0027'
	));

select
	aa.* 
from pje.tb_audiencia_andamento aa 
inner join pje.tb_processo_audiencia tpa on  aa.id_processo_audiencia = tpa.id_processo_audiencia 
inner join pje.tb_processo tp on tpa.id_processo_trf = tp.id_processo
where tp.nr_processo in (
	'0001231-91.2024.5.07.0037', 
	'0001165-44.2024.5.07.0027',
	'0001041-61.2024.5.07.0027', 
	'0001239-69.2022.5.07.0027'
	) order by aa.dt_inclusao desc ;

update pje.tb_audiencia_andamento set in_andamento = 'R' where id_processo_audiencia  in (
	select id_processo_audiencia from pje.tb_processo_audiencia where id_processo_trf in (
	select id_processo from pje.tb_processo where nr_processo in (
	'0001231-91.2024.5.07.0037', 
	'0001165-44.2024.5.07.0027',
	'0001041-61.2024.5.07.0027', 
	'0001239-69.2022.5.07.0027'))) and dt_inclusao > '2024-09-17 14:58:13.029';



update pje.tb_processo_documento set id_localizacao = 6600 where id_processo_documento = 39887869;

update pje.tb_processo_documento 
set id_usuario_inclusao = (select id_usuario from pje.tb_usuario_login where ds_email = 'alexandre.vieira@trt7.jus.br'),
	id_usuario_alteracao = (select id_usuario from pje.tb_usuario_login where ds_email = 'alexandre.vieira@trt7.jus.br'),
	id_papel =  (select id_papel from pje.tb_papel where ds_identificador = 'magistrado' and ds_nome = 'Magistrado'),--assesor 5197
where id_processo_documento = 39887869;

select * from pje.tb_localizacao tl where tl.ds_localizacao ilike '%1VT%'; --1194 1VT - Fortaleza

select * from pje.tb_localizacao tl where tl.ds_localizacao ilike '%1VT%';
select * from pje.tb_papel tp ;

select * from pje.tb_localizacao where ds_localizacao  ilike  '%1VT%';

--------------------------------- SOLUCÃO PARA ASSINAR AS ATAS DE AUDIENCIA FOI: ---------------------------------

-------------------- Pegar o result_sentenca_parte do processo e depois exclui

/*
 * Resultado da sentença:
Homologação da transação
 * */

select 
	trsp.*
from pje.tb_processo_parte tpp
left outer join pje.tb_result_sentenca_parte trsp on trsp.id_processo_parte = tpp.id_processo_parte 
left outer join pje.tb_resultado_sentenca trs on trs.id_processo_trf = tpp.id_processo_trf 
left outer join pje.tb_processo tp on tpp.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0001165-44.2024.5.07.0027';

-- delete from pje.tb_result_sentenca_parte where id_resultado_sentenca_parte = 

----------------------------------------------------------------- Fim - Tentativa de assinar atas de audiencia ------------------------------------------


select * from pje.tb_result_sentenca_parte trsp ;

select * from pje.tb_usuario_login tul where tul.ds_nome = 'DIEGO AZEVEDO DA COSTA';



select * from pje.tb_processo tp where tp.nr_processo = '0343600-72.2006.5.07.0032';



----------------------------------------------------------------------------------------------------------------------

insert into pje_jt.tb_autotexto
  
select nextval('sq_tb_autotexto'), a.ds_autotexto, a.ds_conteudo_autotexto, 6607 as id_localizacao , a.in_publico, a.id_usuario, a.ds_atalho
from pje_jt.tb_autotexto a
join pje.tb_localizacao l on l.id_localizacao = a.id_localizacao
join pje.tb_orgao_julgador oj on oj.id_localizacao = l.id_localizacao
where 1=1 
and a.id_localizacao = 1211 -- 18VT
and a.id_usuario is null
and a.ds_atalho is not null 
order by a.ds_autotexto;


select * from pje.tb_usuario_login tul where tul.ds_email = 'rodolfo.furtado@trt7.jus.br';

select * from pje.tb_orgao_julgador toj ;



select * from pje.tb_usuario_login tul where tul.ds_nome = 'ROSSANA TALIA MODESTO GOMES SAMPAIO';

select 
	tul2.* 
from pje.tb_usuario_login tul 
inner join pje.tb_usuario_localizacao tul2 on tul2.id_usuario = tul.id_usuario 
where tul.ds_nome = 'ROSSANA TALIA MODESTO GOMES SAMPAIO';

select 
	* 
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0000301-88.2024.5.07.0032';



select * from pje.tb_usuario_login tul where tul.ds_nome = 'ANA PAULA BARROSO SOBREIRA PINHEIRO';


select * from pje.tb_usuario_login tul where tul.ds_email = 'mariacbc@trt7.jus.br';


select * from pje.tb_processo_audiencia tpa where tpa.id_pessoa_marcador = 
(select u. id_usuario from pje.tb_usuario_login u where u.ds_email = 'mariacbc@trt7.jus.br')
order by tpa.dt_inicio desc;

select 
	tp.nr_processo ,
	tai.*
from pje_jt.tb_aud_importacao tai 
--inner join pje.tb_processo_audiencia tpa on tai.id_processo_audiencia = tpa.id_processo_audiencia 
inner join pje.tb_processo tp on tai.id_processo = tp.id_processo 
--inner join pje_jt.tb_aud_parcela_importacao tapi on tapi.id_aud_importacao = tai.id_aud_importacao 
--inner join pje_jt.tb_aud_parte_importacao tapi2 on tapi2.id_aud_importacao = tai.id_aud_importacao 
inner join pje_jt.tb_aud_verba_importacao tavi on tavi.id_aud_importacao = tai.id_aud_importacao 
where tp.nr_processo in(
	'0000914-71.2024.5.07.0012',
	'0000932-92.2024.5.07.0012',
	'0000897-35.2024.5.07.0012',
	'0001000-42.2024.5.07.0012',
	'0001005-64.2024.5.07.0012',
	'0000784-78.2024.5.07.0013',
	'0000857-53.2024.5.07.0012',
	'0000858-38.2024.5.07.0012',
	'0000859-23.2024.5.07.0012',
	'0000466-98.2024.5.07.0012'
	)
order by tai.dt_inicio desc;

select * from pje.tb_tmp_documento_assinando ttda where id_processo_trf = 
(select id_processo from tb_processo where nr_processo like '0000857-53.2024.5.07.0012');



delete from pje_jt.tb_aud_importacao where id_processo = 853819 and dt_inicio = '2024-09-04 09:00:00.000';
delete from pje_jt.tb_aud_importacao where id_processo = 833640 and dt_inicio = '2024-06-05 09:00:00.000';


select * from pje_jt.tb_aud_parcela_importacao tapi ;


select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%Larissa Ricarte%';



select 
	tul2.ds_nome ,
	tp.ds_nome as papel,
	tl.ds_localizacao ,
	tul.*
from 
pje.tb_usuario_localizacao tul 
inner join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario 
inner join pje.tb_papel tp on tul.id_papel = tp.id_papel 
inner join pje.tb_localizacao tl on tul.id_localizacao = tl.id_localizacao 
where tul2.ds_email = 'larissa.sales@trt7.jus.br';



select * from pje.tb_usuario_login tul where tul.ds_email = 'francisco.anjos@trt7.jus.br';

select 
	tpd.* 
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0000984-46.2024.5.07.0026'
--and tpd.dt_juntada is null; --997





select 
	tpd.* 
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0001352-56.2017.5.07.0008' 
and tpd.dt_juntada is null;


update pje.tb_processo_documento set in_ativo = 'N' where id_processo_documento = 4018859;


select * from pje.tb_usuario_login tul where tul.ds_email = 'andrecarvalho.09@gmail.com';

select 
	tpa.* 
from pje.tb_pessoa_advogado tpa 
inner join pje.tb_usuario_login tul on tpa.id = tul.id_usuario 
where tul.ds_email = 'andrecarvalho.09@gmail.com';


select 
	tul.ds_login ,
	tpf.*
from pje.tb_usuario_login tul 
inner join pje.tb_usuario tu on tul.id_usuario = tu.id_usuario 
inner join pje.tb_pessoa_fisica tpf on tpf.id_pessoa_fisica = tul.id_usuario 
where tul.ds_email = 'alexandredouglas.contador@gmail.com';


--2024-10-12 04:30:09.355 antiga data de expiração

update pje.tb_usuario set dt_expiracao_senha = '2024-10-18 04:30:09.355' where id_usuario = 1024916;








select *
from pje.tb_usuario_localizacao tul 
inner join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario 
inner join pje.tb_usuario tu on tu.id_usuario = tul2.id_usuario 
--inner join pje.tb_usuario_papel tup on tup.id_usuario = tul2.id_usuario 
--inner join pje.tb_usuario_configuracao tuc on tuc.id_usuario = tul2.id_usuario 
where tul2.ds_login = '07056792332';


select tu.*
from pje.tb_usuario_localizacao tul 
inner join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario 
inner join pje.tb_usuario tu on tu.id_usuario = tul2.id_usuario 
--inner join pje.tb_usuario_papel tup on tup.id_usuario = tul2.id_usuario 
--inner join pje.tb_usuario_configuracao tuc on tuc.id_usuario = tul2.id_usuario 
where tul2.ds_login in( '62820421350', '11831833301', '07056792332');


insert into pje.tb_usuario_login (ds_email, ds_login, ds_nome, ds_senha, in_ativo, in_utiliza_login_senha, ds_nome_consulta)
values ('maria.sampaio.estag@trt7.jus.br', '07056792332', 'MARIA THEODORA SILVA SAMPAIO', '$2b$12$SlRgwYuTaTB8Z9hNzMD6yu5BRRHWggUfPzziZPcfEBaoUVFxIuMzC', 
'S',  true, 'MARIA THEODORA SILVA SAMPAIO');

insert into pje.tb_usuario_localizacao (id_usuario, in_responsavel_localizacao, id_localizacao, id_papel, id_estrutura, in_favorita)
values (1025998, 'N', 8, 5440, 43373, 'N');

insert into pje.tb_usuario (id_usuario, in_bloqueio, in_provisorio)
values (1025998, 'N', 'N');


select * from pje.tb_usuario_login tul where tul.ds_login = '07056792332';

delete from pje.tb_usuario where id_usuario = 1025998;
delete from pje.tb_usuario_login where ds_login = '07056792332';
delete from pje.tb_usuario_localizacao where id_usuario = 1025998;


select * from pje.tb_usuario_login tul where tul.ds_email = 'ruibl@trt7.jus.br';

select 
	tp.nr_processo ,
	tojc.ds_orgao_julgador_colegiado ,
	tpt.id_orgao_julgador_colegiado 
from pje.tb_processo tp 
left outer join pje.tb_processo_trf tpt on tpt.id_processo_trf = tp.id_processo 
left outer join pje.tb_orgao_julgador_colgiado tojc on tpt.id_orgao_julgador_colegiado = tojc.id_orgao_julgador_colegiado 
where tp.nr_processo = '0000547-98.2020.5.07.0008';


select * from pje.tb_orgao_julgador_colgiado tojc where tojc.id_orgao_julgador_colegiado = 10;



select * from pje.tb_usuario_login tul where tul.ds_email = 'msocorrofso@trt7.jus.br';




select  
	tee.nm_etiqueta ,
	tac.id_aplicacao_classe , --todos em primeira instancia ok
	tepe.*
from pje.tb_processo tp 
inner join pje_etq.tb_etq_processo_etiqueta tepe on tepe.id_processo_trf = tp.id_processo
inner join pje_etq.tb_etq_etiqueta_instancia teei on tepe.id_etq_etiqueta_instancia = teei.id_etq_etiqueta_instancia 
inner join pje_etq.tb_etq_etiqueta tee on teei.id_etq_etiqueta = tee.id_etq_etiqueta 
inner join pje.tb_aplicacao_classe tac on teei.id_instancia = tac.id_aplicacao_classe 
where tp.nr_processo = '0146900-75.1990.5.07.0003';


select * from pje.tb_usuario_login tul where tul.ds_nome = 'MARLEY CISNE DE MORAIS JUNIOR';


select * from pje.tb_usuario_login tul where tul.id_usuario = 51099;
select * from pje.tb_pess_doc_identificacao tpdi where id_pessoa_doc_identificacao = 81204;
select * from pje.tb_pess_doc_identificacao tpdi where id_pessoa = 51099;
select * from pje.tb_processo_parte tpp where tpp.id_pessoa = 51099;

select * from pje_jt.tb_debito_trabalhista tdt where id_processo_parte = 1370383;

select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%RODOVIARIO RAMOS LTDA%';
select * from pje.tb_usuario_login tul where tul.ds_nome = 'FRANCISCO OTAVIO COSTA';

select 
	tpdi.*
from pje.tb_usuario_login tul 
left outer join pje.tb_pess_doc_identificacao tpdi on tpdi.id_pessoa = tul.id_usuario 
left outer join pje.tb_processo_parte tpp on tpp.id_pessoa = tul.id_usuario 
left outer join pje.tb_processo tp on tpp.id_processo_trf = tp.id_processo 
where tul.id_usuario = 10592
and tp.nr_processo = '0000114-11.2013.5.07.0018';

INSERT INTO pje_jt.tb_debito_trabalhista (id_debito_trabalhista, id_processo_parte,id_situacao_debito_trabalhista,in_sincronizacao)
VALUES (nextval('sq_tb_debito_trabalhista'), 58064,1,'S');


  
INSERT INTO pje_jt.tb_debito_trabalhista (id_debito_trabalhista, id_processo_parte,id_situacao_debito_trabalhista,in_sincronizacao)
VALUES (nextval('sq_tb_debito_trabalhista'), 1367457,1,'S');

INSERT INTO pje_jt.tb_debito_trabalhista (id_debito_trabalhista, id_processo_parte,id_situacao_debito_trabalhista,in_sincronizacao)
VALUES (nextval('sq_tb_debito_trabalhista'), 1994451,1,'S');

INSERT INTO pje_jt.tb_debito_trabalhista (id_debito_trabalhista, id_processo_parte,id_situacao_debito_trabalhista,in_sincronizacao)
VALUES (nextval('sq_tb_debito_trabalhista'), 1670426,1,'S');

INSERT INTO pje_jt.tb_debito_trabalhista (id_debito_trabalhista, id_processo_parte,id_situacao_debito_trabalhista,in_sincronizacao)
VALUES (nextval('sq_tb_debito_trabalhista'), 1296824,1,'S');


INSERT INTO pje_jt.tb_debito_trabalhista (id_debito_trabalhista, id_processo_parte,id_situacao_debito_trabalhista,in_sincronizacao)
VALUES (nextval('sq_tb_debito_trabalhista'), 131450,1,'S');

INSERT INTO pje_jt.tb_debito_trabalhista (id_debito_trabalhista, id_processo_parte,id_situacao_debito_trabalhista,in_sincronizacao)
VALUES (nextval('sq_tb_debito_trabalhista'), 1708943,1,'S');


------------------------------------------------------------------------------------------------- OLHAR DEPOIS O 39040

select * from pje.tb_usuario_login tul where tul.ds_email = 'tiago.oliveira@trt7.jus.br';

select tpd.*
from pje.tb_processo_documento tpd 
inner join pje.tb_processo p on tpd.id_processo = p.id_processo 
where p.nr_processo = '0001768-81.2024.5.07.0039';


select 
	tai.*
from pje_jt.tb_aud_importacao tai 
--inner join pje_jt.tb_aud_parcela_importacao tapi on tapi.id_aud_importacao = tai.id_aud_importacao 
--inner join pje_jt.tb_aud_parte_importacao tapi2 on tapi2.id_aud_importacao = tai.id_aud_importacao 
inner join pje_jt.tb_aud_verba_importacao tavi on tavi.id_aud_importacao = tai.id_aud_importacao 
inner join pje.tb_processo_audiencia tpa on tai.id_processo_audiencia = tpa.id_processo_audiencia 
where  tai.id_processo in (
select id_processo from pje.tb_processo 
where nr_processo 
in(
'0001262-26.2024.5.07.0033',
'0001062-19.2024.5.07.0033',
'0001064-86.2024.5.07.0033',
'0001066-56.2024.5.07.0033',
'0001065-71.2024.5.07.0033',
'0001067-41.2024.5.07.0033',
'0001176-55.2024.5.07.0033',
'0001186-02.2024.5.07.0033',
'0001236-28.2024.5.07.0033',
'0001190-39.2024.5.07.0033'
)) and tai.dt_inicio between '2024-10-23 00:00:00.000' and '2024-10-23 23:59:00.000';


delete from pje_jt.tb_aud_importacao where id_aud_importacao = 825641 and  id_processo = 861752;
update pje.tb_processo_documento set in_ativo = 'N' where id_processo_documento = 40295141;



select 
	tai.*
from pje_jt.tb_aud_importacao tai 
--inner join pje_jt.tb_aud_parcela_importacao tapi on tapi.id_aud_importacao = tai.id_aud_importacao 
inner join pje_jt.tb_aud_parte_importacao tapi2 on tapi2.id_aud_importacao = tai.id_aud_importacao 
inner join pje_jt.tb_aud_verba_importacao tavi on tavi.id_aud_importacao = tai.id_aud_importacao 
inner join pje.tb_processo_audiencia tpa on tai.id_processo_audiencia = tpa.id_processo_audiencia 
where  tai.id_processo in (
select id_processo from pje.tb_processo 
where nr_processo 
in(
	'0001186-02.2024.5.07.0033'
)) and tai.dt_inicio between '2024-10-23 00:00:00.000' and '2024-10-23 23:59:00.000';


--------
select * from pje.tb_processo_audiencia tpa where tpa.id_processo_trf in (
	select id_processo from pje.tb_processo tp where tp.nr_processo in('0000680-35.2024.5.07.0030', '0000679-50.2024.5.07.0030'));



select * from pje.tb_usuario_login tul where tul.ds_email = 'mariavla@trt7.jus.br';


-- Lei 8112/90 - Regime juridico dos Servidores Publicos Civis da União
-- Lei 11091/05 - Estruturação do Plano de Carreira dos Cargos Técnico-Administrativo em Educação


select 
	tu.*
from pje.tb_usuario_login tul
inner join pje.tb_usuario tu on tu.id_usuario = tul.id_usuario 
inner join pje.tb_usuario_localizacao tul2 on tul2.id_usuario = tul.id_usuario 
inner join pje.tb_usuario_papel tup on tup.id_usuario = tul.id_usuario 
inner join pje.tb_perito_profissao tpp on tpp.id_pessoa_perito = tul.id_usuario 
inner join pje.tb_pessoa_perito tpp2 on tpp2.id = tul.id_usuario 
where tul.ds_login = '05058034379';

update pje.tb_usuario
set in_bloqueio = 'N',
	 in_provisorio = 'N',
	  dt_expiracao_senha = null
where id_usuario = (select id_usuario from pje.tb_usuario_login where ds_login = '05058034379');

--2024-08-22 04:30:14.592

 
select * from pje.tb_usuario_login tul where tul.ds_email = 'marcela.sales@trt7.jus.br';


----------------------------OLHAR DEPOIS A RESOLUÇÃO DO CHAMADO S108479----------------------------------------

select 
	tpe.*
from pje.tb_processo_evento tpe  
inner join pje.tb_complemento_segmentado tcs on (tcs.id_movimento_processo = tpe.id_processo_evento and tcs.ds_texto = '5005')
inner join pje.tb_processo tp on tpe.id_processo = tp.id_processo 
inner join pje.tb_processo_trf tpt on tpe.id_processo = tpt.id_processo_trf 
inner join pje.tb_orgao_julgador toj on tpt.id_orgao_julgador = toj.id_orgao_julgador 
where dt_atualizacao > '2024-08-31 00:00:00.000' ;


SELECT 
    toj.id_orgao_julgador,
    ARRAY_AGG(tp.nr_processo) AS processos,
    ARRAY_AGG(SUBSTRING(tcs.ds_valor_complemento FROM 1 FOR 10)) AS complemento,
    ARRAY_AGG(tpe.ds_texto_final_interno ilike '%Audiência una cancelada%') AS  canceladas
FROM pje.tb_processo_evento tpe  
INNER JOIN pje.tb_complemento_segmentado tcs ON (tcs.id_movimento_processo = tpe.id_processo_evento AND tcs.ds_texto = '5005')
INNER JOIN pje.tb_processo tp ON tpe.id_processo = tp.id_processo 
INNER JOIN pje.tb_processo_trf tpt ON tpe.id_processo = tpt.id_processo_trf 
INNER JOIN pje.tb_orgao_julgador toj ON tpt.id_orgao_julgador = toj.id_orgao_julgador 
WHERE tpe.dt_atualizacao > '2024-08-31 00:00:00.000'
GROUP BY toj.id_orgao_julgador;




select tcs.* from pje.tb_processo_evento tpe 
inner join pje.tb_complemento_segmentado tcs on tpe.id_processo_evento = tcs.id_movimento_processo 
inner join pje.tb_processo_trf tpt on tpe.id_processo = tpt.id_processo_trf 
inner join pje.tb_orgao_julgador toj on tpt.id_orgao_julgador = toj.id_orgao_julgador 
inner join pje.tb_processo tp on tpe.id_processo = tp.id_processo 
where tcs.ds_texto = '5005'
and tpe.id_evento = 970
and tpe.dt_atualizacao > '2024-08-31 00:00:00.000'
and tpe.ds_texto_final_interno ilike '%Audiência una cancelada%'

order by tpe.dt_atualizacao desc;


select tcs.* from pje.tb_processo_evento tpe inner join pje.tb_complemento_segmentado tcs on tpe.id_processo_evento = tcs.id_movimento_processo 
where tpe.id_processo = (select id_processo from pje.tb_processo where nr_processo = '0001635-72.2024.5.07.0028')
and tpe.id_evento = 970
and tpe.dt_atualizacao > '2024-08-31 00:00:00.000';


-------------------------------------------------------------------------------------------------------------------------------------------------------

select tul.ds_login from pje.tb_usuario_login tul where tul.ds_nome = 'FREDERICO SERGIO UCHOA FEITOSA' and tul.ds_email is not null;
select tul.ds_login from pje.tb_usuario_login tul where tul.ds_email = 'leyaramr@trt7.jus.br';

select 
	tpp3.*
from pje.tb_usuario_login tul
inner join pje.tb_usuario tu on tu.id_usuario = tul.id_usuario 
inner join pje.tb_pessoa_perito tpp on tpp.id = tul.id_usuario 
inner join pje.tb_processo_pericia tpp3 on tpp3.id_pessoa_perito = tpp.id 
inner join pje.tb_processo tp on tpp3.id_processo_trf = tp.id_processo 
where tul.ds_nome = 'FREDERICO SERGIO UCHOA FEITOSA'
and tp.nr_processo = '0000991-87.2018.5.07.0013';

update pje.tb_processo_pericia set id_processo_documento = 19286292 where id_processo_pericia = 19451; --19286292


select 
	tpd.* 
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0000991-87.2018.5.07.0013'
and tpd.ds_processo_documento ilike '%laudo%';



select * from pje.tb_processo_pericia tpp ;

/*
 * Lei 9784/1999 - Processo Administrativo no Ambito da Administração Pública Federal: Estabelece normas para os processos administrativos, garantindo direitos aos administados.
 * 
 * Lei 8429/1992 - Alterada pela Lei 14230/2021 - Improbidade Admnistrativa: Regulamenta  as sanções para agentes públicos que praticam atos de improbidade administativa
 * 
 * Lei 13726/2018 - Desburocratização e Simplificação: Visa eliminar formalidades excessivas e simplificar o atendimento ao público.
 * 
 * Lei 14133/2021 - Nova Lei de Licitações e Contratos Administrativos: Moderniza a regulamentação de licitações e contratos na administração pública.
 * 
 * Decreto 11072/2022 - Programa de Gestão e Desempenho: Implementa o Programa de Gestão e Desempenho no âmbito do Serviço Público Federal, buscando
 * otimizar a produtividade e qualidade no trabalho dos servidores.
 * 
 * Lei 14681/2023 - Política de Bem-Estar, Sáude e Qualidade de Vida no Trabalho e Valorização dos Profissionais de Educação: 
 * Estabelece diretrizes para melhorar a saúde, bem-estar e qualidade de vida dos profissionais da educação.
 * */


select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%giselle bringel%';
select * from pje.tb_orgao_julgador toj ;


select 
		tulms.*
from pje.tb_usuario_login tul 
inner join pje.tb_usuario_localizacao tul2 on tul2.id_usuario = tul.id_usuario 
inner join pje.tb_usu_local_mgtdo_servdor tulms on tulms.id_usu_local_mgstrado_servidor = tul2.id_usuario_localizacao 
inner join pje.tb_orgao_julgador toj on tulms.id_orgao_julgador = toj.id_orgao_julgador 
where tul.ds_email = 'theanna.borges@trt7.jus.br'
and toj.ds_orgao_julgador = '6ª Vara do Trabalho de Fortaleza';

------------------------------------------------------------------------------------------------------------------------------



----------------------------------------------------------- S108605 --------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_nome = 'THEANNA DE ALENCAR BORGES';
select * from pje.tb_usuario_login tul where tul.ds_email = 'antonia.saldanha@trt7.jus.br';

select 
		tulms.*
from pje.tb_usuario_login tul 
inner join pje.tb_usuario_localizacao tul2 on tul2.id_usuario = tul.id_usuario 
inner join pje.tb_usu_local_mgtdo_servdor tulms on tulms.id_usu_local_mgstrado_servidor = tul2.id_usuario_localizacao 
inner join pje.tb_orgao_julgador toj on tulms.id_orgao_julgador = toj.id_orgao_julgador 
where tul.ds_email = 'theanna.borges@trt7.jus.br'
and toj.ds_orgao_julgador = '6ª Vara do Trabalho de Fortaleza';

select 
	tpd.*
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0000621-22.2024.5.07.0006'
and tpd.dt_juntada is null;

--id_usuario_inclusao = 660897, id_usuario_alteracao = 660897, id_papel = 5197
update pje.tb_processo_documento set id_usuario_inclusao = 660897, id_usuario_alteracao = 1003182, id_papel = 5197
where id_processo_documento = 40443703;

select * from pje.tb_papel tp ;


select 
	tai.id_aud_importacao,
	tai.dt_inicio ,
	tpa.*
from pje_jt.tb_aud_importacao tai 
--inner join pje_jt.tb_aud_parcela_importacao tapi on tapi.id_aud_importacao = tai.id_aud_importacao 
--inner join pje_jt.tb_aud_parte_importacao tapi2 on tapi2.id_aud_importacao = tai.id_aud_importacao 
--inner join pje_jt.tb_aud_verba_importacao tavi on tavi.id_aud_importacao = tai.id_aud_importacao 
inner join pje.tb_processo tp on tai.id_processo = tp.id_processo 
inner join pje.tb_processo_audiencia tpa on tai.id_processo_audiencia = tpa.id_processo_audiencia 
where  tp.nr_processo = '0000621-22.2024.5.07.0006';


update pje.tb_processo_audiencia set id_processo_documento = null where id_processo_audiencia = 1025328; -- id_processo_documento = 40443703



---------------------------------------------------------------------------------------------------------------------------------------



select * from pje.tb_usuario_login tul where tul.ds_email = 'tiago.oliveira@trt7.jus.br';

select * from pje_jt.tb_aud_importacao where  id_processo = 859724;

select * from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0001768-81.2024.5.07.0039';

update pje.tb_processo_documento set in_ativo = 'S' where id_processo_documento = 40295141;


select * from pje.tb_sessao ts 

select * from pje.tb_usuario_login tul where tul.ds_nome = 'THEANNA DE ALENCAR BORGES';



select * from pje.tb_usuario_login tul where tul.ds_email = 'livia.pereira@trt7.jus.br'; --0111300-29.2009.5.07.0002

select * from pje_jt.tb_aud_importacao tai where tai.id_processo = (select id_processo from pje.tb_processo where nr_processo = '0111300-29.2009.5.07.0002');

select * from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0111300-29.2009.5.07.0002';


select * from pje.tb_usuario_login tul where tul.ds_email = 'antonia.saldanha@trt7.jus.br';

update pje.tb_processo_audiencia set id_processo_documento = null where id_processo_audiencia = 1025328; -- id_processo_documento = 40443703


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_nome = 'KILVIA SILVA DE SENA';

select * from pje.tb_orgao_julgador toj ;

select * from pje_jt.tb_aud_importacao tai where tai.id_processo = (select id_processo from pje.tb_processo where nr_processo = '0000456-89.2018.5.07.0036');

select * from pje.tb_usuario_login tul 
inner join pje.tb_usuario_localizacao tul2 on tul.id_usuario = tul2.id_usuario 
inner join pje.tb_usu_local_mgtdo_servdor tulms on tulms.id_usu_local_mgstrado_servidor = tul2.id_usuario_localizacao 
inner join pje.tb_orgao_julgador toj on tulms.id_orgao_julgador = toj.id_orgao_julgador 
inner join pje.tb_pessoa_magistrado tpm on tpm.id = tul.id_usuario 
where tul.ds_nome ilike '%GUILHERME%'
and tul.ds_email is not null
and toj.ds_orgao_julgador = '2ª Vara do Trabalho de Caucaia';



------------------------------------------------------------------------------------------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%JOSE BEZERRA LIMA%';

select * from pje.tb_usuario_login tul where tul.ds_email = 'josebl@trt7.jus.br';

select 
	tpa.*
from pje.tb_processo tp
--inner join pje_jt.tb_aud_importacao tai on tai.id_processo = tp.id_processo 
inner join pje.tb_processo_audiencia tpa on tpa.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0000170-42.2021.5.07.0025';

update pje.tb_processo_audiencia set id_processo_documento = null --25686270
where id_processo_audiencia = 732698
and dt_inicio = '2021-05-27 12:30:00.000';



select * from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0000170-42.2021.5.07.0025'
and tpd.ds_processo_documento = 'Ata da Audiência';





------------------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_nome = 'ROSANNA DE MOURA BARROS';
select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%Karla Yacy%';


-------------------------------------------------------------------------------------------------

select * from pje_jt.tb_aud_importacao tai where tai.id_aud_importacao = 833772;

UPDATE pje_jt.tb_aud_importacao
    SET dt_validacao=NULL
    WHERE id_aud_importacao=833772;

--------------------------------------------------------------------------------------------
   
  select * from pje.tb_usuario_login tul where tul.ds_login = '24189537349';
  select * from pje.tb_usuario_login tul;


----------------------------------------------------------------------------------------------
 
 select * from pje.tb_usuario_login;



---------------------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_email =  'denise.araujo@trt7.jus.br';



select * from pje.tb_processo_audiencia tpa 
inner join pje.tb_processo tp on tpa.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0001012-42.2022.5.07.0007'
and tpa.dt_inicio = '2024-11-29 08:00:00.000';


select * from pje.tb_audiencia_andamento taa  where taa.id_processo_audiencia = 1015174;

select
te.ds_evento ,
*
from pje.tb_processo_evento tpe 
inner join pje.tb_evento te on tpe.id_evento = te.id_evento 
where tpe.id_processo = (select id_processo from pje.tb_processo where nr_processo = '0001012-42.2022.5.07.0007')
and te.ds_evento = 'Audiência';

select * from pje_spl.tb_pauta_sessao tps ;


-------------------------------------------------------------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_nome = 'MARIA CAROLINE BARBOSA COELHO';




select 
	tp.nr_processo ,
	tpa.*
from pje.tb_processo_audiencia tpa
inner join pje.tb_processo tp on tpa.id_processo_trf = tp.id_processo 
where tp.nr_processo in (
	'0001197-94.2024.5.07.0012', --tem
	' 0000784-81.2024.5.07.0012',
	'0000891-28.2024.5.07.0012',  --tem
	'0001425-69.2024.5.07.0012', --tem
	 '0001424-84.2024.5.07.0012', --tem
	 '0000015-83.2018.5.07.0012', -- tem
	'0000720-71.2024.5.07.0012', -- tem
	'0001377-13.2024.5.07.0012', -- tem
	 '0001405-78.2024.5.07.0012' --tem
	)
and tpa.dt_inicio between '2024-12-16 00:00:00.000' and '2024-12-16 16:00:00.000';






update pje.tb_processo_audiencia set id_processo_documento = null 
where id_processo_audiencia in (
1033235,
1027828,
1007198,
1035145,
1035495,
1035494,
1035497,
1035496,
1006800
); 


update pje.tb_processo_audiencia set id_processo_documento = null 
where id_processo_audiencia  = 999993 ;


update pje.tb_processo_audiencia set id_processo_documento = null
where id_processo_audiencia = 1006800;


select 
	tpa.*
from pje.tb_processo_audiencia tpa
inner join pje.tb_processo tp on tpa.id_processo_trf = tp.id_processo 
where tp.nr_processo in (
		'0001290-91.2023.5.07.0012'
	)
and tpa.dt_inicio between '2024-12-16 00:00:00.000' and '2024-12-16 16:00:00.000';


select 
	tpa.*
from pje.tb_processo_audiencia tpa
inner join pje.tb_processo tp on tpa.id_processo_trf = tp.id_processo 
where tp.nr_processo in (
		'0000784-81.2024.5.07.0012'
	)
and tpa.dt_inicio between '2024-12-16 00:00:00.000' and '2024-12-16 16:00:00.000';





select * from pje.tb_usuario_login tul where tul.ds_email = 'francisco.anjos@trt7.jus.br';



select * from pje.tb_usuario_login tul where tul.ds_nome = 'ABEL TEIXEIRA ARIMATEIA';



select 
	tpd.*
from pje.tb_processo tp 
inner join pje.tb_processo_documento tpd on tp.id_processo = tpd.id_processo
where tp.nr_processo = '0001485-25.2023.5.07.0029'
and tpd.dt_juntada is null;


update pje.tb_processo_documento set in_ativo = 'N' where id_processo_documento = 36145296;




select * from pje.tb_usuario_login tul where tul.ds_email = 'mariacbc@trt7.jus.br';





select * from pje.tb_usuario_login tul where tul.ds_nome = 'ANA PAULA BARROSO SOBREIRA PINHEIRO';





select 
tpd.* 
from pje.tb_processo tp
inner join pje.tb_processo_documento tpd on tp.id_processo = tpd.id_processo 
where tp.nr_processo = '0001735-93.2015.5.07.0011'
and tpd.dt_juntada is null;



select * from pje.tb_usuario_login tul where tul.ds_email = 'marley.morais@trt7.jus.br';



select * from pje.tb_usuario_login tul where tul.ds_email = 'fabricio@trt7.jus.br';



select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%ANDRE ESTEVES%'

select 
	tpd.*
from pje.tb_processo tp 
inner join pje.tb_processo_documento tpd on tp.id_processo = tpd.id_processo 
where tp.nr_processo = '0000509-17.2025.5.07.0039'
and tpd.dt_juntada is null;

update tb_processo_documento set id_usuario_inclusao = 15276,  id_papel = 1469, id_usuario_alteracao = 15276 where id_processo_documento = 41658796; --id_papel = 1338 e id_usuario_alteracao = 135926

select * from pje.tb_papel;
-----------


select 
	tpa.*
from pje.tb_processo tp 
inner join pje_jt.tb_aud_importacao tai on tp.id_processo = tai.id_processo 
inner join pje.tb_processo_audiencia tpa on tpa.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0000509-17.2025.5.07.0039';


update tb_processo_audiencia set in_ativo = 'S' where id_processo_trf = 887269 and cd_status_audiencia = 'C';

update tb_processo_audiencia set id_processo_documento = 41658796 where  id_processo_audiencia = 1044234;-- id_processo_documento = 41658796



select * from pje.tb_usuario_login tul where tul.ds_email = 'saymon.cabral@trt7.jus.br';



select * from pje.tb_usuario_login tul where tul.ds_email = 'simonefb@trt7.jus.br';


select 
	taf.*
from pje.tb_processo tp 
inner join pje_jt.tb_agrupamento_fase taf on tp.id_agrupamento_fase = taf.id_agrupamento_fase
where tp.nr_processo = '0000706-87.2024.5.07.0012';

select * from pje_jt.tb_agrupamento_fase taf ;

select 
	tpd.*
from pje.tb_processo tp
inner join pje.tb_processo_documento tpd on tpd.id_processo = tp.id_processo
where tp.nr_processo = '0001669-97.2017.5.07.0026'
and tpd.dt_juntada is null;


select * from pje.tb_usuario_login tul where tul.ds_email = 'aterezacr@trt7.jus.br';



select * from pje.tb_usuario_login tul where tul.ds_nome = 'FRANCISCO THIAGO FERREIRA DOS ANJOS';
select *  from pje.tb_usuario_login tul where tul.ds_email = 'diana@trt7.jus.br';
select * from pje.tb_usuario_login tul where tul.ds_nome = 'NEY FRAGA FILHO';

select 
	tdth.*
from pje.tb_processo tp 
inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
inner join pje_jt.tb_dbto_trblhsta_historico tdth on tdth.id_processo_parte = tpp.id_processo_parte
inner join pje.tb_usuario_login tul on tpp.id_pessoa = tul.id_usuario
where tp.nr_processo = '0001399-46.2016.5.07.0014';


select * from pje.tb_processo_parte;


DELETE FROM pje_jt.tb_dbto_trblhsta_historico
WHERE id_debto_trabalhista_historico=298082;

DELETE FROM pje_jt.tb_dbto_trblhsta_historico
WHERE id_debto_trabalhista_historico=298083;

DELETE FROM pje_jt.tb_dbto_trblhsta_historico
WHERE id_debto_trabalhista_historico=298084;

-------------------------------------------------------------------------------------------------------------------------
select * from pje_jt.tb_dbto_trblhsta_historico tdth where tdth.id_debto_trabalhista_historico  = 298082;

select * from pje.tb_usuario_login tul where tul.ds_email = 'fernando.feitosaa@hotmail.com';



SELECT * 
FROM pje.tb_usuario_login tul 
WHERE tul.ds_nome = 'ANA RITA SILVA DOS SANTOS - ESPAÇO DON''ANA';

select * from pje.tb_usuario_login tul where tul.ds_nome = 'VIVIA CRISTIANE MUNIZ DA SILVA';

select 
	dt.*
from pje.tb_processo tp 
inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
inner join pje_jt.tb_dbto_trblhsta_historico  dt on dt.id_processo_parte = tpp.id_processo_parte
where tp.nr_processo = '0000534-23.2021.5.07.0022';

select * from pje_jt.tb_dbto_trblhsta_historico tdth order by tdth.id_debto_trabalhista_historico desc;

select tdt.* from pje.tb_processo tp 
inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
inner join pje_jt.tb_debito_trabalhista tdt on tdt.id_processo_parte = tpp.id_processo_parte
where tp.nr_processo = '0000534-23.2021.5.07.0022';

select * from pje_jt.tb_debito_trabalhista tdt order by tdt.id_debito_trabalhista desc;

select tpp.id_processo_parte
from pje.tb_processo tp 
inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
inner join pje.tb_usuario_login tul on tpp.id_pessoa = tul.id_usuario
where tp.nr_processo = '0010159-20.2012.5.07.0015'
and tul.ds_nome = 'CESAR CONSTRUCOES LTDA                                                                                                                                ';

--CESAR CONSTRUCOES LTDA                                                                                                                                
where tp.nr_processo = '0010159-20.2012.5.07.0015';
--and tsdt.in_tipo_operacao = 'I';

select * from pje_jt.tb_debito_trabalhista tdt ;

select * from pje_jt.tb_debito_trabalhista tdt order by tdt.id_debito_trabalhista;
select * from pje_jt.tb_dbto_trblhsta_historico order by id_debto_trabalhista_historico desc;
select * from pje.tb_processo_parte tpp ;
select * from pje.tb_usuario_login;

select * from pje.tb_processo_parte tpp ;
select * from pje.tb_situacao_cnpj_receita_fed tscrf ;

insert into pje_jt.tb_debito_trabalhista (id_debito_trabalhista , id_processo_parte, id_situacao_debito_trabalhista, in_sincronizacao)
values (nextval('pje_jt.sq_tb_debito_trabalhista'),1411682, 1, null);

insert into pje_jt.tb_dbto_trblhsta_historico
select nextval('pje_jt.sq_tb_dbto_trblhista_historico'), (current_timestamp-interval '4822 days'), 
               (current_timestamp-interval '4822 days'), 'I', null, null, 1411682, 2, 1, 'N', null, null;



----------------------------------------------------------------------------------------------------------------------------------
select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%SEULAJ%';


select * from pje.tb_usuario_login tul where tul.ds_nome = 'NIVEA MARIA SILVA BARROS';


do $$
declare
id_processo int;
v_id_processo int;
v_ds_frase_exclusao varchar;
begin
	raise notice 
			'	DO $$
				DECLARE
				    idProcessoEvento INT;
				BEGIN
					
				    INSERT INTO tb_processo_evento(id_processo, id_evento, id_usuario, dt_atualizacao, in_processado, in_verificado_processado, tp_processo_evento, 
				                ds_texto_final_externo, ds_texto_final_interno, in_visibilidade_externa, ds_texto_parametrizado)
				        VALUES(%, 50085, 0, now(), ''N'', ''N'', ''M'', %,  %,  ''t'', ''Registrada a #{tipo de determinação} de dados de #{nome da parte} no BNDT #{complemento do tipo de determinação}'')
				        RETURNING id_processo_evento INTO idProcessoEvento;
				    INSERT INTO tb_complemento_segmentado(vl_ordem, ds_texto, ds_valor_complemento, id_movimento_processo, id_tipo_complemento, in_visibilidade_externa, in_multivalorado, cd_tipo_complemento_dinamico)
				        VALUES
				            (0, 1, v_ds_nome_empresa, idProcessoEvento, 13, ''t'', ''f'', ''PA''),
				            (0, 7266, ''exclusão'', idProcessoEvento , 54, ''t'', ''f'', NULL);
				end;$$;
				', v_id_processo, v_ds_frase_exclusao, v_ds_frase_exclusao;    
end;
$$;



select * from pje.tb_complemento_segmentado tcs where tcs.ds_valor_complemento = 'v_ds_nome_empresa';


DO $$
				DECLARE
				    idProcessoEvento INT;
				BEGIN
					
				    INSERT INTO tb_processo_evento(id_processo, id_evento, id_usuario, dt_atualizacao, in_processado, in_verificado_processado, tp_processo_evento, 
				 ds_texto_final_externo, ds_texto_final_interno, in_visibilidade_externa, ds_texto_parametrizado)
				 VALUES(651450, 50085, 0, now(), 'N', 'N', 'M', 'Registrada a exclusão de dados de BORGES CONSTRUCOES E SERVICOS LTDA                                                                                                                     no BNDT',  'Registrada a exclusão de dados de BORGES CONSTRUCOES E SERVICOS LTDA                                                                                                                     no BNDT',  't', 'Registrada a #{tipo de determinação} de dados de #{nome da parte} no BNDT #{complemento do tipo de determinação}')
				 RETURNING id_processo_evento INTO idProcessoEvento;
	 	INSERT INTO tb_complemento_segmentado(vl_ordem, ds_texto, ds_valor_complemento, id_movimento_processo, id_tipo_complemento, in_visibilidade_externa, in_multivalorado, cd_tipo_complemento_dinamico)
				VALUES
				(0, 1, 'BORGES CONSTRUCOES E SERVICOS LTDA                                                                                                                    ', idProcessoEvento, 13, 't', 'f', 'PA'),
				(0, 7266, 'exclusão', idProcessoEvento, 54, 't', 'f', NULL);END$$;



---------------------------------------------------------------------------------------

select tul2.* from pje.tb_usuario_login tul
inner join pje.tb_usuario tu on tu.id_usuario = tul.id_usuario
inner join pje.tb_usuario_localizacao tul2 on tul2.id_usuario = tul.id_usuario
where tul.ds_nome = 'RAQUEL BRAGA OLINDA MACEDO';


-------------------------------------------------------------------------

--------------------------------------------------------------------------------------

select tul2.* from pje.tb_usuario_login tul
inner join pje.tb_usuario tu on tu.id_usuario = tul.id_usuario
inner join pje.tb_usuario_localizacao tul2 on tul2.id_usuario = tul.id_usuario
where tul.ds_nome = 'ANTONIO BIANOR NETO PINHEIRO';


-------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_email = 'claudiacn@trt7.jus.br';

select * from pje.tb_localizacao tl where tl.ds_localizacao ilike '%Iguatu%';



----------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_login = '02733111400'; -- id_usuario = 1031965 - Liliane

select 
	tul.ds_nome, tpp.* from pje.tb_processo tp 
inner join pje.tb_processo_pericia tpp on tpp.id_processo_trf = tp.id_processo
inner join pje.tb_usuario_login tul on tpp.id_pessoa_perito = tul.id_usuario
where tp.nr_processo = '0201000-07.2009.5.07.0005'; -- não tem a liliane nos registros da tb_processo_pericia. É preciso ter sera?



-------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_nome = 'SIMONE FONTENELE BOMFIM';

----------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%ANA ELIZA FLORENTINO HOLANDA%';



select 
	tpd.*
from pje.tb_processo tp 
inner join pje.tb_processo_documento tpd on tpd.id_processo = tp.id_processo
where tp.nr_processo = '0000153-64.2016.5.07.0030'
and tpd.ds_processo_documento = 'Mandado';

update pje.tb_processo_documento set in_ativo = 'S' where id_processo = 242622 and ds_processo_documento = 'Mandado';



select * from pje.tb_usuario_login tul where tul.ds_nome = 'GLENDA GONCALVES LIMA FEITOSA MOREIRA';


select * from pje.tb_pessoa_advogado tpa;


select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%RAIMUNDO DIAS DE OLIVEIRA NETO%';


select tpd.* from pje.tb_processo tp 
inner join pje.tb_processo_documento tpd on tpd.id_processo = tp.id_processo
where tp.nr_processo = '0001911-12.2024.5.07.0026'
and tpd.ds_processo_documento ilike '%Alvará%';

select tpd.* from pje.tb_processo tp 
inner join pje.tb_processo_documento tpd on tpd.id_processo = tp.id_processo
where tp.nr_processo = '0001911-12.2024.5.07.0026'
and tpd.dt_juntada is null;



----------------- INCLUIR PERITO ------------------------------

select * from pje.tb_perito_profissao tpp ;
select * from pje.tb_pessoa_perito tpp ;
select * from pje.tb_processo_pericia;

select * from pje.tb_usuario_login tul where tul.ds_nome = 'MARIA NEUMA NOBRE BARROS';
select * from pje.tb_usuario_login tul where tul.ds_nome = 'DANIEL WALKER ALMEIDA MARQUES JUNIOR';

select 
	tul.ds_nome ,
	tpp.*
from pje.tb_usuario_login tul 
inner join pje.tb_perito_profissao tpp on tpp.id_pessoa_perito = tul.id_usuario
where tul.ds_login in( '69935351300', '96273054304');

----
select 
	tul.ds_nome,
	tpp.*
from pje.tb_usuario_login tul 
inner join pje.tb_pessoa_perito tpp on tpp.id = tul.id_usuario
where tul.ds_login in ('69935351300', '96273054304');

select 
	tpp.*
from pje.tb_processo_pericia tpp 
inner join pje.tb_processo tp on tpp.id_processo_trf = tp.id_processo
where tp.nr_processo in ('0000076-61.2025.5.07.0023', '0000077-46.2025.5.07.0023');


select * from pje.tb_participacao_sorteio_pericia tpsp where tpsp.id_sorteio_pericia = 843;


select 
	tpsp.*,
	tul.ds_nome
from pje.tb_sorteio_pericia tsp 
inner join pje.tb_processo tp on tsp.id_processo = tp.id_processo
inner join pje.tb_participacao_sorteio_pericia tpsp on tpsp.id_sorteio_pericia = tsp.id_sorteio_pericia
inner join pje.tb_usuario_login tul on tpsp.id_pessoa_perito = tul.id_usuario
where tp.nr_processo  = '0000077-46.2025.5.07.0023';


---------------------- solução ----------------------------------

/*
 * update pje.tb_participacao_sorteio_pericia tpsp set in_pessoa_sorteada = 'N' where id_sorteio_pericia = 843

	insert into pje.tb_participacao_sorteio_pericia (id_sorteio_pericia, id_pessoa_perito, in_pessoa_sorteada) values (843, 696873, 'S')

	update pje.tb_participacao_sorteio_pericia tpsp set in_pessoa_sorteada = 'N' where id_sorteio_pericia = 842

	insert into pje.tb_participacao_sorteio_pericia (id_sorteio_pericia, id_pessoa_perito, in_pessoa_sorteada) values (842, 696873, 'S')
 * 
 * */

-----------------------------------------------------------------------------------------------------------



-----------------------------	VERIFICAR SOLUÇÃO DO THIAGO DEPOIS   -------------------------------------------


-------------- CRIAR DEPOIS UM PROCEDIMENTO PARA AUTOMATIZAR ESSE SCRIPT -----------------------------

select tsp.id_sorteio_pericia,
       tsp.dh_sorteio,
       tul.ds_nome,
       te.ds_especialidade,
       concat('UPDATE pje.tb_participacao_sorteio_pericia SET in_pessoa_sorteada = ''N'' where id_sorteio_pericia = ', 843, ';'),
       'INSERT INTO pje.tb_participacao_sorteio_pericia (id_sorteio_pericia, id_pessoa_perito, in_pessoa_sorteada) VALUES (' || tsp.id_sorteio_pericia || ',' || tul.id_usuario || ', ''S'')' || ';',
       concat('INSERT INTO pje.tb_participacao_sorteio_pericia (id_sorteio_pericia, id_pessoa_perito, in_pessoa_sorteada) VALUES (', tsp.id_sorteio_pericia, ',', tul.id_usuario,',S')
from pje.tb_processo tp
inner join pje.tb_sorteio_pericia tsp on tsp.id_processo = tp.id_processo
inner join pje.tb_participacao_sorteio_pericia tpsp on tpsp.id_sorteio_pericia = tsp.id_sorteio_pericia
inner join pje.tb_especialidade te on te.id_especialidade = tsp.id_especialidade 
inner join pje.tb_usuario_login tul on tul.id_usuario = tpsp.id_pessoa_perito
where tpsp.in_pessoa_sorteada = 'S'
  and tp.nr_processo = '0000076-61.2025.5.07.0023' --NUMERO DO PROCESSO
  and te.id_especialidade = (select te.id_especialidade
from pje.tb_usuario_login tul
inner join pje.tb_pessoa_perito tpp on tpp."id" = tul.id_usuario
inner join pje.tb_perito_profissao tpp2 on tpp."id" = tpp2.id_pessoa_perito
inner join pje.tb_especialidade_profissao tep on tpp2.id_profissao = tep.id_profissao
inner join pje.tb_especialidade te on te.id_especialidade = tep.id_especialidade
inner join pje.tb_profissao tp on tp.id_profissao = tep.id_profissao
where tul.ds_nome ilike '%CICERO%CRUZ%') ;-- NOME DO PERITO



--------------------------------------------------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_login = '70240299353';

select tul.* from pje.tb_usuario_login tul 
inner join pje.tb_usuario tu on tul.id_usuario = tu.id_usuario
where tul.ds_nome = 'DANIELLY GONCALVES SOMBRA LIMA';


select * from pje.tb_pessoa_advogado tpa ;


select *  from pje.tb_usuario_login tul where tul.ds_email = 'francisco.anjos@trt7.jus.br';

select * from pje.tb_processo tp where tp.nr_processo = '0000781-21.2023.5.07.0026';



----------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_nome = 'FRANCIALDO REBOUCAS GONDIM';





select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%RONALDO SOLANO%';

select * from pje.tb_usuario_login tul where tul.ds_nome = 'ROBERTA MIRANDA EUFRASIO';


select
	tul.ds_nome ,
	tpd.*
from pje.tb_processo tp 
inner join pje.tb_processo_documento tpd on tpd.id_processo = tp.id_processo
inner join pje.tb_usuario_login tul on tpd.id_usuario_inclusao = tul.id_usuario
where tp.nr_processo = '0000682-08.2024.5.07.0029'
and tpd.dt_juntada is null;

update pje.tb_processo_documento set in_ativo = 'S' where id_processo_documento = 42500041;





------------------------------------------------------------------------------------------------------


SELECT ds_nome nome,
       in_utiliza_login_senha possui_senha,
       SUBSTRING (CASE
                      WHEN ((in_especializacoes::bit(16) & 1::bit(16))::integer > 0) THEN ',2'
                      ELSE ''
                  END || CASE
                             WHEN ((in_especializacoes::bit(16) & 8::bit(16))::integer > 0) THEN ',3'
                             ELSE ''
                         END || CASE
                                    WHEN ((in_especializacoes::bit(16) & 16::bit(16))::integer > 0) THEN ',8'
                                    ELSE ''
                                END || CASE
                                           WHEN ((in_especializacoes::bit(16) & 32::bit(16))::integer > 0) THEN ',6'
                                           ELSE ''
                                       END || CASE
                                                  WHEN ((in_especializacoes::bit(16) & 64::bit(16))::integer > 0) THEN ',7'
                                                  ELSE ''
                                              END || CASE
                                                         WHEN ((in_especializacoes::bit(16) & 128::bit(16))::integer > 0) THEN ',4'
                                                         ELSE ''
                                                     END,
                                                     2,
                                                     50) AS perfil,
                 (coalesce(pf.nr_celular, '') !=''
                  AND coalesce(u.ds_email, '') !='') AS possui_dados_pessoais,
  (SELECT count(vl_meio_contato)
   FROM tb_meio_contato
   WHERE id_pessoa = u.id_usuario) qtd_meios_contato,
  (SELECT json_agg(DISTINCT p.ds_nome::TEXT)::TEXT
   FROM tb_usuario_localizacao ul, pje.tb_papel p
   WHERE ul.id_usuario = u.id_usuario
     AND ul.id_papel = p.id_papel ) papel,
  (SELECT vl_variavel
   FROM tb_parametro
   WHERE nm_variavel = 'aplicacaoSistema') AS "grau"
FROM tb_usuario_login u
LEFT JOIN tb_pessoa_fisica pf ON id_usuario = id_pessoa_fisica
LEFT JOIN tb_pessoa_juridica pj ON id_usuario = id_pessoa_juridica
WHERE ds_nome = 'ANA ELIZA FLORENTINO HOLANDA'
  AND in_ativo = 'S';


--------------------------


select * from pje.tb_usuario_login tul where tul.ds_email = 'laedson.silva@trt7.jus.br';
select * from pje.tb_usuario_login tul where tul.ds_email = 'anaeliza@trt7.jus.br';

select * from pje.tb_usuario_login tul where tul.ds_nome = 'ANTONIO GONCALVES PEREIRA';



select * from pje.tb_usuario_login tul where tul.ds_nome = 'ANA ELIZA FLORENTINO HOLANDA';


--0001085-71.2024.5.07.0030
--0000667-12.2019.5.07.0030


--------------------------------------------- CHAMADO S113878 ------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_email = 'francisco.anjos@trt7.jus.br';


select 
	tul.*
from pje.tb_usuario_login tul
inner join pje.tb_usuario_localizacao tul2 on tul2.id_usuario = tul.id_usuario
inner join pje.tb_localizacao tl  on tul2.id_localizacao = tl.id_localizacao
where tul.ds_email = 'francisco.anjos@trt7.jus.br';


-- insert into pje.tb_pessoa_oficial_justica (id) values(918443); -> registro já existe

insert into pje.tb_usuario_localizacao (id_usuario, in_responsavel_localizacao, id_localizacao, id_papel, id_estrutura) 
values (918443, 'N', 60450, 5251, null);



select * from pje.tb_localizacao tl where tl.ds_localizacao ilike '%CTM%';

























