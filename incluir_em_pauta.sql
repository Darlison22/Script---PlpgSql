
-- Verificar se o processo esta em uma sessao com a situação diferente de FECHADA
select 
	s.*
from pje.tb_processo p
join pje_jt.tb_pauta_sessao ps on ps.id_processo_trf = p.id_processo
join pje_jt.tb_jt_sessao s on s.id_sessao = ps.id_sessao
where 1=1
and s.in_situacao_sessao != 'F'
and p.nr_processo = '0001340-36.2023.5.07.0039';

update pje_jt.tb_jt_sessao set in_situacao_sessao = 'I', dt_fechamento_pauta = null where id_sessao = 8510 
and id_tipo_sessao = 3 and id_orgao_julgador_colegiado = 7 and dt_situacao_sessao = '2024-09-18 09:04:04.292';

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
join pje_jt.tb_pauta_sessao ps on ps.id_processo_trf = p.id_processo
join pje_jt.tb_jt_sessao s on s.id_sessao = ps.id_sessao
join pje.tb_orgao_julgador org on ps.id_orgao_julgador_redator = org.id_orgao_julgador
join pje.tb_pessoa_magistrado tpm on ps.id_magistrado_redator = tpm.id 
join pje.tb_usuario_login tul on tpm.id = tul.id_usuario 
join pje_jt.tb_tipo_julgamento ttj on ps.cd_tipo_julgamento = ttj.cd_tipo_julgamento
join pje.tb_orgao_julgador_colgiado tojc on s.id_orgao_julgador_colegiado = tojc.id_orgao_julgador_colegiado 
join pje.tb_tipo_sessao tts on s.id_tipo_sessao = tts.id_tipo_sessao 
where 1=1
and pt.id_orgao_julgador in (
    select x.id_orgao_julgador from pje_jt.tb_composicao_sessao x where x.id_sessao = s.id_sessao
)
and p.nr_processo = '0001230-50.2012.5.07.0030';


---------------------------------------------------------------------------------------------------------------------


--- Uma solução genérica que funciona com alguns casos é alterar o flag tb_processo_trf.in_selecionado_julgamento para 'S'. Exemplo:
update pje.tb_processo_trf set in_selecionado_pauta = 'S' where id_processo_trf = (
    select x.id_processo from tb_processo x where x.nr_processo = '0001230-50.2012.5.07.0030'
);




-- Criação do procedimento verificarCamposDosProcesso
CREATE OR REPLACE PROCEDURE incluirEmPauta(p_nr_processo TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    -- Declaração de variáveis locais
    v_id_orgao_julgador_revisor INTEGER;
    v_id_processo_trf INTEGER;
    v_id_pessoa_revisor_processo INTEGER;
    v_id_caixa INTEGER;
BEGIN
    
	/*
		Trazer todas as informações necessárias e trata-las de acordo com o resultado recebido.
		Ou seja, se forem nulas, exibir mensagem informando. Caso estejam preenchidas, informar
		o script de atualização para tornar os respectivos campos nulos.
*/
	
	raise notice '--------------------------------------------------------';

    SELECT 
        prf.id_processo_trf, 
        prf.id_orgao_julgador_revisor, 
        pj.id_pessoa_revisor_processo, 
        p.id_caixa 
    INTO 
        v_id_processo_trf, 
        v_id_orgao_julgador_revisor, 
        v_id_pessoa_revisor_processo, 
        v_id_caixa  
    FROM 
        tb_processo_trf prf 
		INNER JOIN tb_processo p ON prf.id_processo_trf = p.id_processo
    	INNER JOIN tb_processo_jt pj ON pj.id_processo_trf = prf.id_processo_trf
    	WHERE p.nr_processo = p_nr_processo;

    IF COALESCE(v_id_orgao_julgador_revisor, v_id_pessoa_revisor_processo, v_id_caixa, 0) <> 0 THEN
        RAISE NOTICE 'UPDATE pje.tb_processo_trf set id_orgao_julgador_revisor = null where id_processo_trf = %;', v_id_processo_trf;
		RAISE NOTICE 'UPDATE pje_jt.tb_processo_jt set id_pessoa_revisor_processo = null where id_processo_trf = %;', v_id_processo_trf;
		RAISE NOTICE 'UPDATE pje.tb_processo set id_caixa = null where id_processo = %;', v_id_processo_trf;
    ELSE
        RAISE NOTICE 'Informações já constam como nulas';
    END IF;

	raise notice '--------------------------------------------------------';
END;
$$;

--informar o numero do processo como parametro na chamada da função
call incluirEmPauta('0001340-36.2023.5.07.0039'); 