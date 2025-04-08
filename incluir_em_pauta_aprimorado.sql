-- Verificar se o processo esta em uma sessao com a situação diferente de FECHADA
select 
	p.nr_processo ,
	ps.*
from pje.tb_processo p
join pje_spl.tb_pauta_sessao ps on ps.id_processo_trf = p.id_processo
--join pje_spl.tb_jt_sessao s on s.id_sessao = ps.id_sessao
--join pje_spl.tb_tipo_situacao_pauta tsp on tsp.id_tipo_situacao_pauta = ps.id_tipo_situacao_pauta
--where 1=1
--and s.in_situacao_sessao = 'F'
and p.nr_processo in( '0000730-16.2023.5.07.0024');  --Adiado (7) - Julgado (4)

update pje_spl.tb_pauta_sessao set id_tipo_situacao_pauta = 7 where id_pauta_sessao = 220131;

select * from pje_spl.tb_tipo_situacao_pauta ttsp ;

update pje_spl.tb_jt_sessao set in_situacao_sessao = 'F' 
where dt_situacao_sessao = '2025-01-30 13:11:39.537' and id_sessao = 8851 and id_tipo_sessao = 3 and id_orgao_julgador_colegiado = 7;

--------------------------------------------------------------------------------

-- Verificar se o processo pertence a um gabinete que esta no quorum da sessao
select 
	org.ds_orgao_julgador as gabinete,
	tul.ds_nome as nome_redator,
	ttj.nm_tipo_julgamento ,
	tojc.ds_orgao_julgador_colegiado ,
	tts.ds_tipo_sessao ,
	ps.*, --dados da tb_pauta_sessao
	s.*   --dados da tb_jt_sessao
from pje.tb_processo p
join pje.tb_processo_trf pt on pt.id_processo_trf = p.id_processo
join pje_spl.tb_pauta_sessao ps on ps.id_processo_trf = p.id_processo
join pje_spl.tb_jt_sessao s on s.id_sessao = ps.id_sessao
join pje.tb_orgao_julgador org on ps.id_orgao_julgador_redator = org.id_orgao_julgador
join pje.tb_pessoa_magistrado tpm on ps.id_magistrado_redator = tpm.id 
join pje.tb_usuario_login tul on tpm.id = tul.id_usuario 
join pje_jt.tb_tipo_julgamento ttj on ps.cd_tipo_julgamento = ttj.cd_tipo_julgamento
join pje.tb_orgao_julgador_colgiado tojc on s.id_orgao_julgador_colegiado = tojc.id_orgao_julgador_colegiado 
join pje.tb_tipo_sessao tts on s.id_tipo_sessao = tts.id_tipo_sessao 
where 1=1
and pt.id_orgao_julgador in (
    select x.id_orgao_julgador from pje_spl.tb_composicao_sessao x where x.id_sessao = s.id_sessao
)
and p.nr_processo in(
'0000730-16.2023.5.07.0024');


create or replace procedure incluirEmPauta(p_nr_processo text[])
language plpgsql
as $$
declare
	-- variaveis
    v_id_processo_trf integer;
    v_id_caixa integer;
    v_id_orgao_julgador_revisor integer;
    v_id_pessoa_revisor_processo integer;
    v_nr_processo text;
begin
   -- v_nr_processo percorre o array de processos chamado p_nr_processo
    foreach v_nr_processo in array p_nr_processo loop
	
	-- faz a consulta relacionando as tabelas necessárias para retornar os dados requeridos
        select 
            ptf.id_processo_trf,
            ptf.id_orgao_julgador_revisor,
            pj.id_pessoa_revisor_processo,
            p.id_caixa
        into
            v_id_processo_trf,
            v_id_orgao_julgador_revisor,
            v_id_pessoa_revisor_processo,
            v_id_caixa 
        from pje.tb_processo_trf ptf 
        inner join pje.tb_processo p on ptf.id_processo_trf = p.id_processo
        inner join pje_jt.tb_processo_jt pj on pj.id_processo_trf = ptf.id_processo_trf
        where p.nr_processo = v_nr_processo;

	
		
		-- retorna o primeiro valor não nulo. Ou seja, se todas as variaveis forem nulas, retorna 0 e a condição se torna falsa, caindo no comando else
         if coalesce(v_id_orgao_julgador_revisor, v_id_pessoa_revisor_processo, v_id_caixa, 0) <> 0 then
			raise notice '--*************************************************************************************--';
            RAISE NOTICE 'UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = %;', v_id_processo_trf;
            RAISE NOTICE 'UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = %;', v_id_processo_trf;
            RAISE NOTICE 'UPDATE pje.tb_processo set id_caixa = null where id_processo = %;', v_id_processo_trf;
        else
			raise notice '--*************************************************************************************--';
            RAISE NOTICE 'Campos do processo % já estão nulos', v_nr_processo;
        end if;
    end loop;
end;
$$;

--chamada da função passando como parametro uma lista de processos
call incluirEmPauta(
	array[
  	'0000730-16.2023.5.07.0024',
  	'0001114-51.2014.5.07.0005'
    ]);
