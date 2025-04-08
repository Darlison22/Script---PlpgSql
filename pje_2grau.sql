
select 
    tps.id_processo_sobrestamento ,
    tms.ds_motivo_sobrestamento ,
    tpe.ds_processo_evento,
    tps.dt_revogacao ,
    tps.dt_prazo_expiracao ,
    tps.dt_sobrestamento ,
	tpt.id_processo_trf ,
	tp.id_processo ,
	jp.id_ ,
	tp.nr_processo 
from pje.tb_processo_sobrestamento tps left outer join pje.tb_processo_trf tpt 
on tps.id_processo_trf = tpt.id_processo_trf inner join pje.tb_processo tp 
on tp.id_processo = tpt.id_processo_trf inner join pje_jbpm.jbpm_processinstance jp
on jp.id_ = tp.id_jbpm inner join pje.tb_motivo_sobrestamento tms 
on tms.id_motivo_sobrestamento = tps.id_motivo_sobrestamento 
inner join pje.tb_processo_evento tpe on tpe.id_processo_evento = tps.id_processo_evento_sobrestamento 
where tp.nr_processo like '0000007-02.2015.5.07.0016';



*/

select id_processo_documento from pje.tb_processo_documento tpd left outer join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo where tp.nr_processo = '0000007-02.2015.5.07.0016'
and tpd.ds_processo_documento like 'Decisão'
and tpd.dt_inclusao between '2018-01-01' and '2018-12-31';


select s.id_processo_sobrestamento,
	   tms.ds_motivo_sobrestamento,
	   s.dt_revogacao ,
	   s.dt_prazo_expiracao ,
	   s.dt_sobrestamento ,
	   tpe.ds_processo_evento ,
	   tpd.ds_processo_documento 
from pje.tb_processo_sobrestamento s left outer join pje.tb_motivo_sobrestamento tms 
on s.id_motivo_sobrestamento = tms.id_motivo_sobrestamento join pje.tb_processo_evento tpe 
on tpe.id_processo_evento = s.id_processo_evento_sobrestamento join pje.tb_processo_documento tpd 
on tpd.id_processo_documento = tpe.id_processo_documento where tpd.id_processo_documento = 4683562;

-----------------------------------------------------------------------------------------------


select 
	tul.id_usuario_localizacao,
	tul.in_responsavel_localizacao, 
	tl.id_localizacao ,
	tl.ds_localizacao,
	tp.id_papel ,
	tp.ds_nome 
from pje.tb_usuario_localizacao tul left outer join pje.tb_usuario_login tul2 
on tul.id_usuario = tul2.id_usuario inner join pje.tb_localizacao tl 
on tl.id_localizacao = tul.id_localizacao inner join pje.tb_papel tp 
on tp.id_papel = tul.id_papel where tul2.ds_nome = 'MARIA THEODORA SILVA%%' or tul2.id_usuario = 211163; --5944 --5188 6 3


------------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_nome = 'ANDREA BARRETO DE ALMEIDA';


















select 
	tojc.ds_cargo ,
	toj.ds_orgao_julgador ,
	tp.id_processo ,
	tt.id_tarefa ,
	tt.ds_tarefa ,
	tpt2.*
from pje.tb_processo tp inner join pje.tb_processo_tarefa tpt 
on tp.id_processo = tpt.id_processo_trf inner join pje.tb_tarefa tt
on tpt.id_tarefa  = tt.id_tarefa inner join pje.tb_processo_trf tpt2
on tpt2.id_processo_trf  = tp. id_processo left outer join pje.tb_orgao_julgador toj
on toj.id_orgao_julgador  = tpt2.id_orgao_julgador inner join pje.tb_orgao_julgador_cargo tojc
on tojc.id_orgao_julgador_cargo = tpt2.id_orgao_julgador_cargo where tp.nr_processo = '0005074-15.2023.5.07.0000'; --34

 

update pje.tb_processo_trf set id_orgao_julgador = 34 where id_processo_trf = 36916;





select * from pje_jt.tb_hist_anotacao tha ;



-- ANOTACOES INTERNAS
select subselect.ds_texto from (
    select format('<h2 style="background-color: yellow; font-weight: bold;">%s do %s em %s (ID: %s)</h2>',
           ta.cd_anotacao, toj.ds_orgao_julgador, ta.dt_alteracao, ta.id_anotacao)
           || chr(10) || ta.ds_conteudo || '<hr>' as ds_texto, toj.ds_orgao_julgador, ta.id_anotacao, ta.dt_alteracao
    from pje_jt.tb_anotacao ta
    join pje.tb_orgao_julgador toj on toj.id_orgao_julgador = ta.id_orgao_julgador
    join pje_jt.tb_proc_doc_estruturado tpde on tpde.id_proc_doc_estruturado = ta.id_proc_doc_estruturado
    join pje_jt.tb_proc_doc_est_topico tpdet on tpdet.id_proc_doc_estruturado_topico = ta.id_proc_doc_est_topico
    join pje.tb_processo_documento tpd on tpd.id_processo_documento = tpde.id_proc_doc_estruturado
    join pje.tb_tipo_processo_documento ttpd on ttpd.id_tipo_processo_documento = tpd.id_tipo_processo_documento
    join pje.tb_processo p on p.id_processo = tpd.id_processo 
    where 1=1
    and ta.cd_visibilidade = 'INTERNA'
    and ttpd.ds_tipo_processo_documento = 'Acórdão'
    and p.nr_processo = '0001247-32.2020.5.07.0022'
    and ta.id_pessoa_criacao in (
        select distinct x.id_pessoa
        from pje.tb_pessoa x
        join pje.tb_usuario_localizacao y on y.id_usuario = x.id_pessoa
        join pje.tb_usu_local_mgtdo_servdor z on z.id_usu_local_mgstrado_servidor = y.id_usuario_localizacao
        join pje.tb_orgao_julgador zz on zz.id_orgao_julgador = z.id_orgao_julgador
        where 1=1
        and zz.ds_orgao_julgador ilike '%Gab. Des. Carlos Alberto Trindade Rebonatto%'
    )
    --
    union distinct
    --
    select format('<h2 style="background-color: yellow; font-weight: bold;">%s do %s em %s (ID: %s)</h2>',
           ta.cd_anotacao, toj.ds_orgao_julgador, tha.dt_alteracao, ta.id_anotacao)
           || chr(10) || tha.ds_conteudo || '<hr>' as ds_texto, toj.ds_orgao_julgador, ta.id_anotacao, tha.dt_alteracao
    from pje_jt.tb_anotacao ta
    join pje_jt.tb_hist_anotacao tha on tha.id_anotacao = ta.id_anotacao
    join pje.tb_orgao_julgador toj on toj.id_orgao_julgador = ta.id_orgao_julgador
    join pje_jt.tb_proc_doc_estruturado tpde on tpde.id_proc_doc_estruturado = ta.id_proc_doc_estruturado
    join pje_jt.tb_proc_doc_est_topico tpdet on tpdet.id_proc_doc_estruturado_topico = ta.id_proc_doc_est_topico
    join pje.tb_processo_documento tpd on tpd.id_processo_documento = tpde.id_proc_doc_estruturado
    join pje.tb_tipo_processo_documento ttpd on ttpd.id_tipo_processo_documento = tpd.id_tipo_processo_documento
    join pje.tb_processo p on p.id_processo = tpd.id_processo 
    where 1=1
    and ttpd.ds_tipo_processo_documento = 'Acórdão'
    and tha.cd_visibilidade = 'INTERNA'
    and p.nr_processo = '0001247-32.2020.5.07.0022'
    and tha.id_pessoa in (
        select distinct x.id_pessoa
        from pje.tb_pessoa x
        join pje.tb_usuario_localizacao y on y.id_usuario = x.id_pessoa
        join pje.tb_usu_local_mgtdo_servdor z on z.id_usu_local_mgstrado_servidor = y.id_usuario_localizacao
        join pje.tb_orgao_julgador zz on zz.id_orgao_julgador = z.id_orgao_julgador
        where 1=1
        and zz.ds_orgao_julgador ilike '%Gab. Des. Carlos Alberto Trindade Rebonatto%'
    )
     
) subselect
order by subselect.ds_orgao_julgador, subselect.id_anotacao, subselect.dt_alteracao;



----------------------------------------------------------------------------------------


select * from pje_jt.tb_pauta_sessao tps ;

select * from pje.tb_pessoa_magistrado tpm ;









-----------------------------------------------------------------------------



---------------------------------------------------------------------------------





-- Consertar esse script depois
select 
	tpt.*
from pje.tb_processo_trf tpt 
inner join pje.tb_usu_local_mgtdo_servdor tulms on tpt.id_orgao_julgador = tulms.id_orgao_julgador 
inner join pje.tb_processo tp on tpt.id_processo_trf = tp.id_processo 
inner join pje.tb_orgao_julgador_colgiado tojc on tpt.id_orgao_julgador_colegiado = tojc.id_orgao_julgador_colegiado 
inner join pje.tb_orgao_julgador_cargo tojc2 on tulms.id_orgao_julgador_cargo = tojc2.id_orgao_julgador_cargo 
inner join pje.tb_orgao_julgador toj on tpt.id_orgao_julgador = toj.id_orgao_julgador 
inner join pje_jt.tb_pauta_sessao tps on tps.id_processo_trf = tpt.id_processo_trf 
	where 1=1 and tp.nr_processo in (
		'0000630-40.2014.5.07.0036',
		'0000735-67.2015.5.07.0008',
		'0000680-44.2023.5.07.0006',
		'0000758-49.2021.5.07.0025',
		'0000979-75.2015.5.07.0014',
		'0000971-26.2023.5.07.0012'
	)
	and toj.id_orgao_julgador = tulms.id_orgao_julgador 
	and tojc2.id_orgao_julgador_cargo = tulms.id_orgao_julgador_cargo
	;




select 
	tpt.*
from pje.tb_processo_tarefa tpt 
inner join pje.tb_processo_trf tpt2 on tpt.id_processo_trf = tpt2.id_processo_trf 
inner join pje.tb_processo tp on tpt2.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0000993-78.2023.5.07.0014';


select 
	tpt.*
from pje.tb_processo tp inner join pje.tb_processo_trf tpt
on tp.id_processo = tpt.id_processo_trf where tp.nr_processo = '0000408-60.2023.5.07.0035';



select * from pje.tb_jurisdicao tj ;


select 
	tul.id_usuario ,
	tul.ds_nome ,
	tulms.*
from pje.tb_pessoa_magistrado tpm 
inner join pje.tb_usuario_login tul on tpm.id = tul.id_usuario 
inner join pje.tb_usuario_localizacao tul2 on tul2.id_usuario= tul.id_usuario 
inner join pje.tb_usu_local_mgtdo_servdor tulms on tulms.id_usu_local_mgstrado_servidor = tul2.id_usuario_localizacao 
where tul.ds_email = 'rosala@trt7.jus.br';

update pje.tb_processo_trf set id_jurisdicao = 33 where id_processo_trf = 
(select id_processo from pje.tb_processo where nr_processo = '0000408-60.2023.5.07.0035');


select * from pje.tb_usu_local_mgtdo_servdor tulms ;
select * from pje.tb_usuario_localizacao tul where tul.id_usuario_localizacao = 46414;
select * from pje.tb_usu_local_visibilidade tulv where tulv.id_usu_local_mgstrado_servidor = 46414;


select * from pje.tb_usuario_login tul where tul.ds_nome like '%ROSA DE LOURDES AZEVEDO BRINGEL%';



select * from pje.tb_usuario_login tul where tul.ds_nome = 'FERNANDO FONTOURA GOMES';


select 
	--tps.*,
	tpt.*
from pje.tb_processo tp 
inner join pje.tb_processo_trf tpt on tpt.id_processo_trf = tp.id_processo 
inner join pje_jt.tb_pauta_sessao tps on tps.id_processo_trf = tpt.id_processo_trf 
inner join pje_jt.tb_jt_sessao tjs on tps.id_sessao = tjs.id_sessao 
where tp.nr_processo = '0000096-02.2023.5.07.0030';

UPDATE tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 147856;
UPDATE tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 147856;
UPDATE tb_processo set id_caixa = null where id_processo = 147856;



------------------------------------------------------------------------------------------------------

select 
	tpd.*
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0001137-47.2021.5.07.0006';




select 
	tpd.* 
from pje.tb_processo_documento tpd inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0000477-88.2020.5.07.0038'
and tpd.dt_juntada is null;

-----------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_nome = 'ANDREA BARRETO DE ALMEIDA';





UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 156584;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 156584;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 156584;


select 
	tpt.*
from pje.tb_processo tp inner join pje.tb_processo_trf tpt on tpt.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0000944-02.2017.5.07.0029';

--id_orgao_julgador_revisor = 51
update pje.tb_processo_trf set id_orgao_julgador_revisor = 51 where id_processo_trf =
(select id_processo from pje.tb_processo where nr_processo = '0000944-02.2017.5.07.0029');

select 
	jt.*
from pje.tb_processo_instance tpi inner join pje.tb_processo tp on tpi.id_processo = tp.id_processo 
inner join pje_jbpm.jbpm_processinstance jp on tpi.id_proc_inst = jp.id_
inner join pje_jbpm.jbpm_taskinstance jt on jt.procinst_ = jp.id_
where tp.nr_processo = '0000944-02.2017.5.07.0029'  order by jt.id_  desc limit 5;


select * from pje.tb_usuario_login tul where tul.ds_nome = 'ABEL TEIXEIRA ARIMATEIA';



select * from pje.tb_tarefa tt  where tt.ds_tarefa ilike '%recurso%';




select * from pje.tb_usuario_login tul where tul.ds_nome = 'FABRICIO HOLANDA DE OLIVEIRA';



select * from pje.tb_tarefa tt where tt.ds_tarefa ilike '%gabinete%';


select * from pje.tb_processo_evento tpe where tpe.id_processo = (select id_processo from pje.tb_processo where nr_processo = '0000459-45.2024.5.07.0000') ;


select * from pje.tb_usuario_login tul where tul.ds_nome = 'FERNANDO FONTOURA GOMES';

select * from pje.tb_complemento_segmentado tcs ;



---------------------------------------------------------------------------------------------------------------



select * from pje.tb_usuario_login tul where tul.ds_email = 'marilsafao@trt7.jus.br';

select 
	tee.nm_etiqueta,
	tac.ds_aplicacao_classe, 
	tepe.id_etq_processo_etiqueta ,
	tepe.dh_inclusao 
from pje_etq.tb_etq_processo_etiqueta tepe 
inner join pje_etq.tb_etq_etiqueta_instancia teei on tepe.id_etq_etiqueta_instancia = teei.id_etq_etiqueta_instancia 
inner join pje.tb_aplicacao_classe tac on teei.id_instancia = tac.id_aplicacao_classe 
inner join pje_etq.tb_etq_etiqueta tee on teei.id_etq_etiqueta = tee.id_etq_etiqueta 
inner join pje.tb_processo tp on tepe.id_processo_trf = tp.id_processo 
where nr_processo = '0000777-42.2022.5.07.0018';

delete from pje_etq.tb_etq_processo_etiqueta where id_etq_processo_etiqueta = 1557710;


select * from pje_etq.tb_etq_etiqueta_instancia teei ;
select * from pje_etq.tb_etq_processo_etiqueta tepe ;


--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 146491;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 146491;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 146491;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 154442;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 154442;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 154442;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 162598;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 162598;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 162598;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 139752;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 139752;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 139752;




select * from pje.tb_usuario_login tul where tul.ds_email = 'marilsafao@trt7.jus.br';

select * from pje_jt.tb_movimento_temporario tmt  where id_processo_trf  = 
(select id_processo from pje.tb_processo where nr_processo = '0000201-26.2024.5.07.0003')
order by id_movimento_temporario desc;

select 
	* 
from pje.tb_processo_evento tpe
inner join pje.tb_processo tp on tpe.id_processo = tp.id_processo
where tp.nr_processo = '0000201-26.2024.5.07.0003' order by tpe.id_processo_evento desc;


select 
	te.ds_evento,
	tmt.dt_criacao_movimento_temporario 
from pje_jt.tb_movimento_temporario tmt 
inner join pje.tb_evento te on tmt.id_evento = te.id_evento  
inner join pje.tb_processo tp on tmt.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0000201-26.2024.5.07.0003'
order by tmt.id_movimento_temporario  desc;

------------------------------------------ RELACIONAR MOVIMENTO COM O CHIP -------------------------------------------

select * from pje.tb_evento_processual tep ; --armazena os movimentos processuais da CNJ
select * from pje_etq.tb_etq_manutencao_classe temc ; -- regras para inclusão/exclusão de acordo com a classe do processo
select * from pje_etq.tb_etq_manutencao_movimento temm ; -- regras para inclusão de etiquetas de acordo com o movimento processual
select * from pje_etq.tb_etq_tipo_evento_processador tetep ; -- Indica o envento que dispara o processamento do chips, caso não seja um evento mapeado pela tabela tb_etq_evento_manutencao
select * from pje_etq.tb_etq_tipo_etiqueta tete ; -- Tipo/cor da etiqueta
select * from pje_etq.tb_etq_manutencao_tipo_documento_papel temtdp ; -- associa o tipo de documento ao papel usado como regra
select * from pje_etq.tb_etq_manutencao_tipo_documento temtd ; --regras para inclusão de etiquetas de acordo com o tipo de documento
select * from pje_etq.tb_etq_inclusao_exclusao teie ; -- mapeia as etiquetas que devem ser excluidas quando uma outra é incluida no processo
select * from pje_etq.tb_etq_etiqueta_instancia teei ; -- relação das etiquedas autorizadas por instancias
select * from pje_etq.tb_etq_etiqueta tee ; -- relação de etiquetas pre definidas para indicação de alguma informação processual
select * from pje_etq.tb_etq_classificao_etiqueta tece ; -- tabela de apoio com as possiveis classificações da etiqueta
select * from pje.tb_classe_judicial tcj order by tcj.id_classe_judicial asc;


select * from pje_etq.tb_etq_processo_etiqueta tepe ;

------------ VERIFICAR AMANHÃ ESSE PROBLEMA -----------------------

WITH resultado_etiqueta AS (
    SELECT 
        tepe.id_processo_trf,
        tee.nm_etiqueta,
        tac.ds_aplicacao_classe, 
        tepe.id_etq_processo_etiqueta,
        tepe.dh_inclusao
    FROM pje_etq.tb_etq_processo_etiqueta tepe 
    INNER JOIN pje_etq.tb_etq_etiqueta_instancia teei ON tepe.id_etq_etiqueta_instancia = teei.id_etq_etiqueta_instancia 
    INNER JOIN pje.tb_aplicacao_classe tac ON teei.id_instancia = tac.id_aplicacao_classe 
    INNER JOIN pje_etq.tb_etq_etiqueta tee ON teei.id_etq_etiqueta = tee.id_etq_etiqueta 
    INNER JOIN pje.tb_processo tp ON tepe.id_processo_trf = tp.id_processo 
    WHERE tp.nr_processo = '0000403-08.2018.5.07.0037'
)

select * from resultado_etiqueta;
--                  regras para inclusão/exclusão de acordo com a classe do processo              --
select 
	tcj.cd_classe_judicial ,
	tcj.ds_classe_judicial ,
	tee.nm_etiqueta 
from pje_etq.tb_etq_manutencao_classe temc  
inner join pje_etq.tb_etq_etiqueta_instancia teei on temc.id_etq_etiqueta_instancia = teei.id_etq_etiqueta_instancia
inner join pje_etq.tb_etq_etiqueta tee on teei.id_etq_etiqueta = tee.id_etq_etiqueta 
inner join pje.tb_classe_aplicacao tca on temc.id_classe_aplicacao = tca.id_classe_aplicacao
inner join pje.tb_classe_judicial tcj on tca.id_classe_judicial = tcj.id_classe_judicial 
where tee.nm_etiqueta in(
(select e.nm_etiqueta from resultado_etiqueta e where e.id_processo_trf = 
	(select tp.id_processo from pje.tb_processo tp where tp.nr_processo = '0000403-08.2018.5.07.0037')));

---         VERIFICAR O PROBLEMA DE NÃO ESTÁ RETORNANDO OS VALORES COM A SUBCONSULTA -------

select e.nm_etiqueta from resultado_etiqueta e where e.id_processo_trf = 
	(select tp.id_processo from pje.tb_processo tp where tp.nr_processo = '0000403-08.2018.5.07.0037');


SELECT 
   tcj.cd_classe_judicial,
   tcj.ds_classe_judicial,
    tee.nm_etiqueta 
FROM pje_etq.tb_etq_manutencao_classe temc  
left JOIN pje_etq.tb_etq_etiqueta_instancia teei ON temc.id_etq_etiqueta_instancia = teei.id_etq_etiqueta_instancia 
left JOIN pje_etq.tb_etq_etiqueta tee ON teei.id_etq_etiqueta = tee.id_etq_etiqueta 
left JOIN pje.tb_classe_aplicacao tca ON temc.id_classe_aplicacao = tca.id_classe_aplicacao
left JOIN pje.tb_classe_judicial tcj ON tca.id_classe_judicial = tcj.id_classe_judicial 
WHERE TRIM(LOWER(tee.nm_etiqueta)) = LOWER('Recebido do TST');

SELECT COUNT(*) 
FROM pje_etq.tb_etq_etiqueta tee 
WHERE tee.nm_etiqueta IS NULL;

SELECT DISTINCT nm_etiqueta 
FROM pje_etq.tb_etq_etiqueta
WHERE nm_etiqueta LIKE '%Recebido do TST%';

select * from pje_etq.tb_etq_etiqueta tee where tee.nm_etiqueta = 'Parte sem CPF/CNPJ';

--         regras para inclusão de etiquetas de acordo com o movimento processual            --
select 
	tep.cd_evento ,
	tep.ds_movimento ,
	tee.nm_etiqueta ,
	tac.ds_aplicacao_classe 
from pje_etq.tb_etq_manutencao_movimento temm 
inner join pje.tb_evento_processual tep on temm.id_movimento = tep.id_evento_processual
inner join pje_etq.tb_etq_etiqueta_instancia teei on temm.id_etq_etiqueta_instancia = teei.id_etq_etiqueta_instancia 
inner join pje_etq.tb_etq_etiqueta tee on teei.id_etq_etiqueta = tee.id_etq_etiqueta
inner join pje.tb_aplicacao_classe tac on teei.id_instancia = tac.id_aplicacao_classe ;

---------- CONTINUAR AMANHÃ -------------


SELECT 
    tcj.cd_classe_judicial,
    tcj.ds_classe_judicial,
    resultado.nm_etiqueta 
FROM (
    SELECT * 
    FROM pje_etq.tb_etq_etiqueta tee 
    WHERE tee.nm_etiqueta = 'Recebido do TST'
) resultado
left  JOIN pje_etq.tb_etq_etiqueta_instancia teei ON resultado.id_etq_etiqueta = teei.id_etq_etiqueta 
left  JOIN pje_etq.tb_etq_manutencao_classe temc ON teei.id_etq_etiqueta_instancia = temc.id_etq_etiqueta_instancia 
left  JOIN pje.tb_classe_aplicacao tca ON temc.id_classe_aplicacao = tca.id_classe_aplicacao
left JOIN pje.tb_classe_judicial tcj ON tca.id_classe_judicial = tcj.id_classe_judicial;


select 
	ts.ds_sala ,
	tjs.*
from pje_jt.tb_jt_sessao tjs 
inner join pje.tb_orgao_julgador_colgiado tojc on tjs.id_orgao_julgador_colegiado = tojc.id_orgao_julgador_colegiado 
inner join pje.tb_sala_horario tsh on tjs.id_sala_horario = tsh.id_sala_horario 
inner join pje.tb_sala ts on tsh.id_sala = ts.id_sala 
where tojc.ds_orgao_julgador_colegiado = '2ª Turma'
and tjs.dt_sessao = '2024-09-30 00:00:00.000'
order by tjs.dt_sessao desc;

update pje_jt.tb_jt_sessao set in_situacao_sessao = 'A' where id_sessao = 8552 and dt_sessao = '2024-09-30 00:00:00.000';

select * from pje_jt.tb_pauta_sessao tps ;

select * from pje_jt.tb_hist_situacao_sessao thss  order by thss.dt_situacao_sessao desc;
select * from pje_jt.tb_pauta_sessao tps where id_sessao = 8552 ;

select * from pje_jt.tb_tipo_situacao_pauta ttsp ;

select * from pje.tb_usuario_login tul where tul.ds_nome = 'ARLENE DE PAULA PESSOA STUDART';

--------------- SOLUÇÃO S107480 ------------- QUASE CONSEGUI AFF
--MEU SCRIPT: update pje_jt.tb_jt_sessao set in_situacao_sessao = 'A' where id_sessao = 8552 and dt_sessao = '2024-09-30 00:00:00.000';
--SOLUÇÃO:  update pje_jt.tb_jt_sessao set in_situacao_sessao = 'I' where id_sessao = 8552 and dt_sessao = '2024-09-30 00:00:00.000';
select * from pje_jt.tb_jt_sessao tjs where tjs.id_sessao = 8552 and dt_sessao = '2024-09-30 00:00:00.000';


select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%Larissa Ricarte%';


select * from pje.tb_usuario_login tul where tul.ds_email = 'lilianarbaa@trt7.jus.br';

select 
	tul2.ds_nome ,
	tp.ds_nome as papel,
	tl.ds_localizacao 
from pje.tb_usuario_localizacao tul 
inner join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario 
inner join pje.tb_papel tp on tul.id_papel = tp.id_papel 
inner join pje.tb_localizacao tl on tul.id_localizacao = tl.id_localizacao 
where tul2.ds_email = 'lilianarbaa@trt7.jus.br';


select * from pje.tb_usuario_login tul where tul.ds_email = 'andrecarvalho.09@gmail.com';
select * from pje.tb_usuario_login tul where tul.ds_nome ilike 'ANDREZZA DE OLIVEIRA ALVES';
select * from pje.tb_pessoa_advogado tpa  where tpa.nr_oab = '45792';

select 
	te.*
from pje.tb_endereco te inner join pje.tb_cep tc on te.id_cep = tc.id_cep 
where tc.nr_cep = '60165-210'
and tc.nm_bairro ilike 'MUCURIPE';


select tul.*
from pje.tb_usuario_localizacao tul 
inner join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario 
inner join pje.tb_usuario tu on tu.id_usuario = tul2.id_usuario 
--inner join pje.tb_usuario_papel tup on tup.id_usuario = tul2.id_usuario 
--inner join pje.tb_usuario_configuracao tuc on tuc.id_usuario = tul2.id_usuario 
where tul2.ds_login = '38503611368'
and tul.id_estrutura = 33554;


select tul2.ds_email, tul2.ds_login, tul.*
from pje.tb_usuario_localizacao tul 
inner join pje.tb_usuario_login tul2 on tul.id_usuario = tul2.id_usuario 
inner join pje.tb_usuario tu on tu.id_usuario = tul2.id_usuario 
--inner join pje.tb_usuario_papel tup on tup.id_usuario = tul2.id_usuario 
--inner join pje.tb_usuario_configuracao tuc on tuc.id_usuario = tul2.id_usuario 
where tul2.ds_login in( '62820421350', '11831833301', '07056792332', '38503611368')
and tul.id_estrutura = 33554;

select * from pje.tb_localizacao tl ;

update pje.tb_usuario_localizacao set id_papel = 5197 where id_usuario_localizacao = 47507;

--verificar depois o chamado S108001


select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%LUISA ASS%';



--1171/94 - codigo de etica 
-- 8112/90 - regime juridico 
-- 11091\2005 - estruturação do plano de carreira |
-- 12527/11 - lei de acesso a informação 
-- 13709/18 - lei geral de proteção de dados
-- 9784/99 - processo administrativo no ambito da administração publica
-- 8429/92 - improbidade admnistrativa
-- 13726/18 - desburocratização e simplificação
-- 14133/21 - lei de licitações e contratos admnistrativos
-- 11072/22 - programa de gestão e desempenho
-- 14681/23 - politica de bem-estar, saúde e qualidade de vida no trabalho e valorização da educação


select * from pje.tb_orgao_julgador_colgiado tojc where tojc.id_orgao_julgador_colegiado = 10;




--Campos já estão nulos
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 150028;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 150028;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 150028;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 138372;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 138372;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 138372;


select * from pje.tb_processo tp where tp.id_processo = 20606;



select * from pje.tb_usuario_login tul where tul.ds_nome = 'ANDREA BARRETO DE ALMEIDA';


select tpd.* from pje.tb_processo tp inner join pje.tb_processo_documento tpd on tp.id_processo = tpd.id_processo 
where tp.nr_processo = '0000482-89.2023.5.07.0011';


select * from pje.tb_usuario_login tul where tul.ds_email = 'ilania@trt7.jus.br';

select 
	thsp.*
from pje_spl.tb_pauta_sessao tps
inner join pje_spl.tb_jt_sessao tjs on tps.id_sessao = tjs.id_sessao 
inner join pje_spl.tb_hist_situacao_pauta thsp on thsp.id_pauta_sessao = tps.id_pauta_sessao 
where id_processo_trf = (select id_processo from pje.tb_processo where nr_processo = '0000945-62.2022.5.07.0012');


----------------------------------------------------39324-----------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_nome = 'EDNEVALDO MEDEIROS PEREIRA';

--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 42035;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 42035;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 42035;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 44579;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 44579;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 44579;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 21531;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 21531;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 21531;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 141575;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 141575;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 141575;


-------------------------------------------------------------------------------------------------------------------------




select * from pje.tb_usuario_login tul where tul.ds_email = 'alexei@trt7.jus.br';


------------------------------------------------------------------------------------------------------------------------------------------------------------------


--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 49525;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 49525;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 49525;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 9005;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 9005;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 9005;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 26720;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 26720;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 26720;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 30705;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 30705;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 30705;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 36994;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 36994;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 36994;

----------------------------------------------------------------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_email = 'celenilton.silva@trt7.jus.br';

select tpt.* from pje.tb_processo tp 
inner join pje.tb_processo_trf tpt on tp.id_processo = tpt.id_processo_trf 
where tp.nr_processo = '0004842-66.2024.5.07.0000';


SELECT 
    tpp.*
FROM 
    pje.tb_usuario_login tul 
INNER JOIN   pje.tb_usuario_localizacao tul2 ON tul2.id_usuario = tul.id_usuario
INNER JOIN    pje.tb_papel tp ON tul2.id_papel = tp.id_papel 
inner join pje.tb_usuario tu on tu.id_usuario = tul.id_usuario 
INNER JOIN  pje.tb_processo_parte tpp ON tpp.id_pessoa = tul.id_usuario 
WHERE tp.ds_nome = 'Advogado';


-----------------------------------------------------------------------------------------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_email = 'danielvp@trt7.jus.br';


select * from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0000091-02.2016.5.07.0005'
and tpd.dt_juntada is not null
and tpd.ds_processo_documento = 'Acórdão'
order by tpd.dt_inclusao desc;


-----------------------------------------------------------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_email = 'sofia.lopes.estagio@trt7.jus.br';




select * from pje.tb_usuario_login tul where tul.id_usuario = 213341;


select * from pje.tb_usuario_login tul ;

update pje.tb_usuario_login set ds_login = '24879070378' where id_usuario = 213341



select * from pje.tb_usuario_login tul where tul.ds_email = 'cesaram@trt7.jus.br';



--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 162366;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 162366;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 162366;



--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 162186;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 162186;
UPDATE pje.tb_processo set id_caixa = null  where id_processo = 162186;


select id_processo from pje.tb_processo tp where tp.nr_processo = '0000104-24.2024.5.07.0036';



select * from pje.tb_usuario_login tul where tul.ds_email = 'fabricio@trt7.jus.br';



--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 141575;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 141575;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 141575;



select tulms.*
from pje.tb_usuario_login tul
inner join pje.tb_usuario_localizacao tul2 on tul.id_usuario = tul2.id_usuario 
inner join pje.tb_localizacao tl on tul2.id_localizacao = tl.id_localizacao 
inner join pje.tb_usu_local_mgtdo_servdor tulms on tulms.id_usu_local_mgstrado_servidor = tul2.id_usuario_localizacao 
where tul.ds_nome ilike '%DURVAL CESAR DE VASCONCELOS MAIA%' 
and tul.ds_email is not null
and tulms.dt_final is null;
-- Gab. Desembargador Convocado - 3ª Turma;


select * from pje.tb_localizacao tl where tl.ds_localizacao ilike '%Gab. Desembargador Convocado - 3ª Turma%' ;
select * from pje.tb_usuario_login tul where tul.ds_nome = 'DURVAL CESAR DE VASCONCELOS MAIA';


select * from pje.tb_usu_local_mgtdo_servdor;

UPDATE tb_usu_local_mgtdo_servdor SET dt_final  = '2025-01-01' WHERE id_usu_local_mgstrado_servidor = 50998;

select * from pje.tb_usu_local_mgtdo_servdor tulms where tulms.id_usu_local_mgstrado_servidor = 50998;


select * from pje.tb_orgao_julgador_cargo toj ;


select * from pje.tb_usuario_login tul where tul.ds_email = 'fabricio@trt7.jus.br';




-------------------------------------------- CHAMADO - 40299--------------------------------------------------------------

SELECT jt.id_ , jp2.name_, jt.name_, jt.create_, jt.start_, jt.end_
FROM pje.tb_processo tp
join pje.tb_processo_instance tpi on tpi.id_processo = tp.id_processo
join pje_jbpm.jbpm_processinstance jp on jp.id_ = tpi.id_proc_inst
join pje_jbpm.jbpm_processdefinition jp2 on jp2.id_ = jp.processdefinition_
join pje_jbpm.jbpm_taskinstance jt on jt.procinst_ = jp.id_
where 1=1
and tp.nr_processo = '0001114-51.2014.5.07.0005'
order by jt.id_;


select * from pje.tb_usuario_login tul where tul.ds_nome ilike '%ANTONIO TEOFILO FILHO%';
select * from pje.tb_usuario_login tul where tul.ds_email = 'fabricio@trt7.jus.br';


select 
	toj.ds_orgao_julgador 
from pje.tb_processo tp
inner join pje.tb_processo_trf tpt on tp.id_processo = tpt.id_processo_trf
inner join pje.tb_orgao_julgador toj on tpt.id_orgao_julgador = toj.id_orgao_julgador 
inner join pje.tb_pessoa tp2 on tp2.id_pessoa = tpt.id_pessoa_relator_processo 
where tp.nr_processo in ( '0001114-51.2014.5.07.0005', '0000730-16.2023.5.07.0024');

-- Carlos Alberto Trindade Rebonnato



--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 141575;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 141575;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 141575;
--*************************************************************************************--
UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = 30667;
UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = 30667;
UPDATE pje.tb_processo set id_caixa = null where id_processo = 30667;

----------------------------------------------------

select * from pje.tb_usuario_login tul where tul.ds_email = 'selmammc@trt7.jus.br';


select 
	tpe.*
from pje.tb_processo p
inner join pje_spl.tb_pauta_sessao ps on ps.id_processo_trf = p.id_processo
inner join pje.tb_processo_evento tpe on tpe.id_processo = p.id_processo
and p.nr_processo in( '0000216-45.2017.5.07.0001') 
order by tpe.id_processo_evento desc;  --



----------------------------------------------------------------------------------


SELECT  
prf.id_orgao_julgador_revisor,
p.id_caixa,
pj.id_pessoa_revisor_processo
FROM        pje.tb_processo_trf prf 
        INNER JOIN pje.tb_processo p ON prf.id_processo_trf = p.id_processo
    	INNER JOIN pje_jt.tb_processo_jt pj ON pj.id_processo_trf = prf.id_processo_trf
    	WHERE p.nr_processo = '0001340-36.2023.5.07.0039';


-------------------------------------------------------------------------------------------


select * from pje.tb_usuario_login tul where tul.ds_email = 'cesaram@trt7.jus.br';


select * from pje.tb_usuario_login tul where tul.ds_nome = 'GLENDA GONCALVES LIMA FEITOSA MOREIRA';


select * from pje.tb_usuario_login tul where tul.ds_nome = 'JOSE WILLIAMS MOTA DA SILVA';

select * from pje.tb_orgao_julgador toj ;
select * from pje.tb_orgao_julgador_colgiado tojc ;

select 
	tpt.*
from pje.tb_processo tp 
inner join pje.tb_processo_trf tpt on tpt.id_processo_trf = tp.id_processo
where tp.nr_processo = '0000562-32.2024.5.07.0039'; -- id_orgao_julgador_colegiado = 7 -> 1 turma

--id_orgao_julgador_colegiado = 12 -> seção especializada I

update pje.tb_processo_trf set id_orgao_julgador_colegiado = 12 where id_processo_trf = 169923;










