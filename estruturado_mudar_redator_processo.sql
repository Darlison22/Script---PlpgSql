


--retorna as demais informações do processo
select
    toj.ds_orgao_julgador ,
    tojc.ds_cargo,   
    tpt.id_processo_trf ,
    tpt.id_orgao_julgador ,
    tpt.id_orgao_julgador_cargo ,
    tps.id_orgao_julgador_redator ,
    tps.id_pauta_sessao ,
    tcs.id_composicao_sessao
from pje.tb_processo_trf tpt inner join pje.tb_processo tp
on tpt.id_processo_trf = tp.id_processo inner join pje.tb_orgao_julgador toj
on tpt.id_orgao_julgador = toj.id_orgao_julgador inner join pje.tb_orgao_julgador_cargo tojc
on tpt.id_orgao_julgador_cargo = tojc.id_orgao_julgador_cargo inner join pje_spl.tb_pauta_sessao tps
on tpt.id_processo_trf = tps.id_processo_trf inner join pje_spl.tb_composicao_sessao tcs
on tpt.id_orgao_julgador = tcs.id_orgao_julgador where tp.nr_processo = '0001163-87.2022.5.07.0013' and tcs.id_sessao = 8634;



---------------------------------------------------------------------------------------------------------------------------------
--retorna  o id do magistrado redator
select * from pje.tb_pessoa_magistrado pm inner join pje.tb_usuario_login tul 
on pm.id = tul.id_usuario where tul.ds_nome = 'REGINA GLAUCIA CAVALCANTE NEPOMUCENO' and tul.ds_email is not null;

---------------------------------------------------------------------------------------------------------------------------------

update pje_spl.tb_pauta_sessao set id_orgao_julgador_redator = 39, id_magistrado_redator = 838 where id_pauta_sessao = 225587;
update pje.tb_processo_trf set id_orgao_julgador = 39, id_orgao_julgador_cargo = 192 where id_processo_trf = 134166;
update pje_spl.tb_composicao_sessao set id_magistrado_presente = 838 where id_composicao_sessao = 36185 and id_sessao = 8634;



CREATE OR REPLACE FUNCTION alterar_redator(p_nr_processo varchar, p_nome_magistrado varchar, p_id_pauta_sessao integer, p_id_sessao integer)
RETURNS varchar 
AS $$
DECLARE
    -- Variáveis
    v_id_orgao_julgador_redator integer;
    v_id_magistrado_redator integer;
    v_id_orgao_julgador integer;
    v_id_orgao_julgador_cargo integer;
    v_id_processo_trf integer;
    v_id_composicao_sessao integer;
    resultado varchar;
BEGIN
    -- Buscar o id do magistrado
    SELECT id INTO v_id_magistrado_redator 
    FROM pje.tb_pessoa_magistrado pm 
    INNER JOIN pje.tb_usuario_login tul ON pm.id = tul.id_usuario 
    		WHERE tul.ds_nome ILIKE p_nome_magistrado
      			AND tul.ds_email IS NOT NULL;  -- Corrigido 'ds_meail' para 'ds_email'

    -- Verifica se o magistrado foi encontrado
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Magistrado não encontrado';
    END IF;

    -- Buscar os dados do processo necessários para realizar a operação desejada
    SELECT
        tpt.id_processo_trf,
        toj.id_orgao_julgador,
        tojc.id_orgao_julgador_cargo,
        tps.id_orgao_julgador_redator,
        tcs.id_composicao_sessao
    INTO
        v_id_processo_trf,
        v_id_orgao_julgador,
        v_id_orgao_julgador_cargo,
        v_id_orgao_julgador_redator,
        v_id_composicao_sessao
    FROM pje.tb_processo_trf tpt 
    INNER JOIN pje.tb_processo tp ON tpt.id_processo_trf = tp.id_processo
   		 INNER JOIN pje.tb_orgao_julgador toj ON tpt.id_orgao_julgador = toj.id_orgao_julgador
    		INNER JOIN pje.tb_orgao_julgador_cargo tojc ON tpt.id_orgao_julgador_cargo = tojc.id_orgao_julgador_cargo
    		INNER JOIN pje_spl.tb_pauta_sessao tps ON tpt.id_processo_trf = tps.id_processo_trf
    	INNER JOIN pje_spl.tb_composicao_sessao tcs ON tcs.id_orgao_julgador = toj.id_orgao_julgador
    WHERE tp.nr_processo = p_nr_processo
      		AND tcs.id_sessao = p_id_sessao
     			 AND tps.id_pauta_sessao = p_id_pauta_sessao;

    -- Verifica se os dados do processo foram encontrados
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Dados do processo não localizados';
    END IF;

    -- Atualizar as tabelas necessárias para registrar o novo redator
    UPDATE pje_spl.tb_pauta_sessao 
    	SET id_orgao_julgador_redator = v_id_orgao_julgador_redator, id_magistrado_redator = v_id_magistrado_redator 
    		WHERE id_pauta_sessao = p_id_pauta_sessao;

    UPDATE pje.tb_processo_trf 
   		 SET id_orgao_julgador = v_id_orgao_julgador, id_orgao_julgador_cargo = v_id_orgao_julgador_cargo
   			 WHERE id_processo_trf = v_id_processo_trf;

    UPDATE pje_spl.tb_composicao_sessao 
    	SET id_magistrado_presente = v_id_magistrado_redator
    		WHERE id_composicao_sessao = v_id_composicao_sessao
      			AND id_sessao = p_id_sessao;

    raise notice '-----------------------------------------------------------------------------------------------------------------------------------';
    RAISE NOTICE 'update pje_spl.tb_pauta_sessao set id_orgao_julgador_redator = %, id_magistrado_redator = % where id_pauta_sessao = %', v_id_orgao_julgador_redator, v_id_magistrado_redator, p_id_pauta_sessao;
    RAISE NOTICE 'update pje.tb_processo_trf set id_orgao_julgador = %, id_orgao_julgador_cargo = % where id_processo_trf = %', v_id_orgao_julgador, v_id_orgao_julgador_cargo, v_id_processo_trf;
    RAISE NOTICE 'update pje_spl.tb_composicao_sessao set id_magistrado_presente = % where id_composicao_sessao = % and id_sessao = %', v_id_magistrado_redator, v_id_composicao_sessao, p_id_sessao;
    raise notice '------------------------------------------------------------------------------------------------------------------------------------';
    
    resultado := 'Scripts executados com sucesso. Coloque para validarrr hahahahahahahah';
    RETURN resultado;

END;
$$ LANGUAGE plpgsql;



-- chamada da funcao  
/*
 * Deve ser passado como parametro, o numero do processo, nome do magistrado, a pauta_sessao e a sessao
 * Todos esses dados podem ser obtidos na tela de PautaJulgamento
 * */
DO $$
DECLARE
    resultado varchar;
BEGIN
    resultado := alterar_redator('0001163-87.2022.5.07.0013', 'REGINA GLAUCIA CAVALCANTE NEPOMUCENO', 225587, 8634);
    RAISE NOTICE '%', resultado;
END;
$$;

































