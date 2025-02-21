
----------------------------- VERSÃO 1 ------------------------------------------------ (REGISTROS DUPLICADOS DA PARTE DEVEDORA)

--caso retorne mais de um registro, é possivel verificar esses registros com esse select

-- Verificar se há registro duplicado na tabela trblhsta_historico 
-- Caso haja, excluir um dos registros na tabela dbto_trblhsta_historico e tb_debito_trabalhista
select tdth.* from pje.tb_processo tp 
inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
inner join pje_jt.tb_dbto_trblhsta_historico tdth on tdth.id_processo_parte = tpp.id_processo_parte
where tp.nr_processo = '0001266-32.2010.5.07.0008'; 


CREATE OR REPLACE FUNCTION excluir_BNDT_1(p_nr_processo varchar, p_ds_nome_parte_devedora varchar default null) 
RETURNS void as $$
DECLARE
    v_id_processo_parte integer;
    v_id_processo_evento integer;
    v_count integer;
    v_id_processo integer;
    v_ds_nome_empresa varchar;
    v_ds_frase_exclusao varchar;
    v_id_debito_trabalhista integer;
    v_id_debto_trabalhista_historico integer;
    v_id_registros_debito_trabalhista_array integer [2];
    v_id_registros_debto_trabalhista_historico_array integer [2];
    v_id_processo_parte_array integer [2];

BEGIN
  
--verifica a quantidade de registros na tabela debto_trabalhista_historico para um mesmo processo
select count(tdth.id_debto_trabalhista_historico) into  v_count
from pje.tb_processo tp 
inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
inner join pje_jt.tb_dbto_trblhsta_historico tdth on tdth.id_processo_parte = tpp.id_processo_parte
where tp.nr_processo = p_nr_processo
and tdth.in_tipo_operacao = 'I';

IF COALESCE(v_count, 0) = 0 THEN
    raise notice 'Não foi encontrado nenhum registro';
    return; -- Apenas encerra a execução, sem retornar valores
END IF;

--verificar se há ou não registro duplicado
IF COALESCE(v_count, 0) = 2 and p_ds_nome_parte_devedora is null THEN
   -- Verificar se há registro duplicado na tabela trblhsta_historico
	-- Caso haja, excluir um dos registros na tabela dbto_trblhsta_historico 
	FOR v_id_debto_trabalhista_historico, v_id_processo_parte IN
	    SELECT tdth.id_debto_trabalhista_historico, tpp.id_processo_parte
	    FROM pje.tb_processo tp 
	    INNER JOIN pje.tb_processo_parte tpp ON tpp.id_processo_trf = tp.id_processo
	    INNER JOIN pje_jt.tb_dbto_trblhsta_historico tdth ON tdth.id_processo_parte = tpp.id_processo_parte
	    WHERE tp.nr_processo = p_nr_processo
		and tdth.in_tipo_operacao = 'I'
	LOOP
	    v_id_registros_debto_trabalhista_historico_array := array_append(v_id_registros_debto_trabalhista_historico_array, v_id_debto_trabalhista_historico);
	    v_id_processo_parte_array := array_append(v_id_processo_parte_array, v_id_processo_parte);
	END LOOP;
	
	-- Se houver registro duplicado na tabela, excluir um deles aqui!!!
	IF v_id_processo_parte_array[1] = v_id_processo_parte_array[2] THEN
	    DELETE FROM pje_jt.tb_dbto_trblhsta_historico WHERE id_debto_trabalhista_historico = v_id_registros_debto_trabalhista_historico[2];
	END IF;
	
	-- Limpar a variável v_id_processo_parte_array
	v_id_processo_parte_array := '{}';
	
	-- Verificar se há registro duplicado na tabela debito_trabalhista
	-- Caso haja, excluir um dos registros na tabela tb_debito_trabalhista
	FOR v_id_debito_trabalhista, v_id_processo_parte IN
	    SELECT tdt.id_debito_trabalhista, tpp.id_processo_parte
	    FROM pje.tb_processo tp 
	    INNER JOIN pje.tb_processo_parte tpp ON tpp.id_processo_trf = tp.id_processo
	    INNER JOIN pje_jt.tb_debito_trabalhista tdt ON tdt.id_processo_parte = tpp.id_processo_parte
	    WHERE tp.nr_processo = p_nr_processo
	LOOP
	    v_id_registros_debito_trabalhista_array := array_append(v_id_registros_debito_trabalhista_array, v_id_debito_trabalhista);
	    v_id_processo_parte_array := array_append(v_id_processo_parte_array, v_id_processo_parte);
	END LOOP;
	
	-- Se houver registro duplicado na tabela, excluir um deles aqui!!!
	IF v_id_processo_parte_array[1] = v_id_processo_parte_array[2] THEN
	    DELETE FROM pje_jt.tb_debito_trabalhista WHERE id_debito_trabalhista = v_id_registros_debito_trabalhista_array[1];
		raise notice 'Operaçoes executadas com sucesso! Verifique se é possivel excluir a parte do BNDT do PJE';
   		 return; -- Apenas encerra a execução, sem retornar valores
	END IF;

    --caso não entre nas condições acima, signifca que as duas partes devedoras são diferentes, ou seja, que não tem registro duplicado
     raise notice 'Há mais de um registro na tabela, informe qual deseja habilitar para excluir';
    return; -- Apenas encerra a execução, sem retornar valores
END IF;

------------------------------------------------------------------------------------------------------------------------------
IF COALESCE(v_count, 0) = 1 THEN
    -- caso tenha passado pela validação acima, então há apenas um registro na tb_dbto_trblhsta_historico do qual queremos o id_processo e o id_processo_parte
    select tp.id_processo, tdth.id_processo_parte  into  v_id_processo, v_id_processo_parte
    from pje.tb_processo tp 
    inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
    inner join pje_jt.tb_dbto_trblhsta_historico tdth on tdth.id_processo_parte = tpp.id_processo_parte
    where tp.nr_processo = p_nr_processo
	and tdth.in_tipo_situacao = 'I';

    INSERT INTO tb_dbto_trblhsta_historico
        (id_debto_trabalhista_historico, dt_alteracao, dt_envio, in_tipo_operacao,
        ds_resposta_envio, id_motivo,
        id_processo_parte, id_situacao_debito_trabalhista, id_usuario)
    VALUES
        (nextval('sq_tb_dbto_trblhista_historico'), now(), now(), 'E', --Exclusão
        NULL, NULL,
        v_id_processo_parte, 4, 0 --id_situacao_debito_trabalhista 4 = Negativa
    );

    --pegar o nome da parte para inserir nas tabelas tb_processo_evento e tb_complemento_segmentado.
    select tul.ds_nome into v_ds_nome_empresa
    from pje.tb_processo_parte tpp 
    inner join pje.tb_pessoa p on tpp.id_pessoa = p.id_pessoa
    inner join pje.tb_usuario_login tul on p.id_pessoa = tul.id_usuario
    where tpp.id_processo_parte = v_id_processo_parte;

    v_ds_frase_exclusao := FORMAT('Registrada a exclusão de dados de %s %s', v_ds_nome_empresa, 'no BNDT');

    --salvar as movimentações realizadas nesse contexto nas tabelas tb_processo_evento e tb_complemento_segmentado
    INSERT INTO tb_processo_evento(id_processo, id_evento, id_usuario, dt_atualizacao, in_processado, in_verificado_processado, tp_processo_evento,
    ds_texto_final_externo, ds_texto_final_interno, in_visibilidade_externa, ds_texto_parametrizado)
    VALUES(v_id_processo, 50085, 0, now(), 'N', 'N', 'M', v_ds_frase_exclusao, v_ds_frase_exclusao,
        't', 'Registrada a #{tipo de determinação} de dados de #{nome da parte} no BNDT #{complemento do tipo de determinação}')
    RETURNING id_processo_evento INTO v_id_processo_evento;
    
    INSERT INTO tb_complemento_segmentado(vl_ordem, ds_texto, ds_valor_complemento,
     id_movimento_processo, id_tipo_complemento, in_visibilidade_externa, in_multivalorado, cd_tipo_complemento_dinamico)
    VALUES
        (0, 1, v_ds_nome_empresa , v_id_processo_evento, 13, 't', 'f', 'PA'),
        (0, 7266, 'exclusão', v_id_processo_evento , 54, 't', 'f', NULL);

    raise notice 'Operaçoes executadas com sucesso! Verifique se é possivel excluir a parte do BNDT do PJE';
    return; -- Apenas encerra a execução, sem retornar valores
END IF;

------------------------------------------------------------------------------------------------------------------------------

IF COALESCE(v_count, 0) > 1 and p_ds_nome_parte_devedora is null THEN
    raise notice 'Há mais de um registro na tabela, informe qual deseja habilitar para excluir';
    return; -- Apenas encerra a execução, sem retornar valores
END IF;

-- Aqui trata os casos em que há mais de uma parte devedora na tabela tb_dbto_historico e o usuário informa qual a parte deve ser excluida.
--OBS: O nome da parte deve ser passado sem abreviações ou caracteres errados
	  select tp.id_processo, tdth.id_processo_parte  into  v_id_processo, v_id_processo_parte
	    from pje.tb_processo tp 
	    inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
	    inner join pje_jt.tb_dbto_trblhsta_historico tdth on tdth.id_processo_parte = tpp.id_processo_parte
		inner join pje.tb_usuario_login tul on tpp.id_pessoa = tul.id_usuario
	    where tp.nr_processo = p_nr_processo
		and tul.ds_nome = p_ds_nome_parte_devedora;
	
	    INSERT INTO tb_dbto_trblhsta_historico
	        (id_debto_trabalhista_historico, dt_alteracao, dt_envio, in_tipo_operacao,
	        ds_resposta_envio, id_motivo,
	        id_processo_parte, id_situacao_debito_trabalhista, id_usuario)
	    VALUES
	        (nextval('sq_tb_dbto_trblhista_historico'), now(), now(), 'E', --Exclusão
	        NULL, NULL,
	        v_id_processo_parte, 4, 0 --id_situacao_debito_trabalhista 4 = Negativa
	    );
	
	  
	
	    v_ds_frase_exclusao := FORMAT('Registrada a exclusão de dados de %s %s', p_ds_nome_parte_devedora, 'no BNDT');
	
	    --salvar as movimentações realizadas nesse contexto nas tabelas tb_processo_evento e tb_complemento_segmentado
	    INSERT INTO tb_processo_evento(id_processo, id_evento, id_usuario, dt_atualizacao, in_processado, in_verificado_processado, tp_processo_evento,
	    ds_texto_final_externo, ds_texto_final_interno, in_visibilidade_externa, ds_texto_parametrizado)
	    VALUES(v_id_processo, 50085, 0, now(), 'N', 'N', 'M', v_ds_frase_exclusao, v_ds_frase_exclusao,
	        't', 'Registrada a #{tipo de determinação} de dados de #{nome da parte} no BNDT #{complemento do tipo de determinação}')
	    RETURNING id_processo_evento INTO v_id_processo_evento;
	    
	    INSERT INTO tb_complemento_segmentado(vl_ordem, ds_texto, ds_valor_complemento,
	     id_movimento_processo, id_tipo_complemento, in_visibilidade_externa, in_multivalorado, cd_tipo_complemento_dinamico)
	    VALUES
	        (0, 1, v_ds_nome_empresa , v_id_processo_evento, 13, 't', 'f', 'PA'),
	        (0, 7266, 'exclusão', v_id_processo_evento , 54, 't', 'f', NULL);
	
	    raise notice 'Operaçoes executadas com sucesso! Verifique se é possivel excluir a parte do BNDT do PJE';
	    return; -- Apenas encerra a execução, sem retornar valores




END;
$$ LANGUAGE plpgsql;



-------------------------CHAMADA DA FUNCAO----------------------------------------

do $$
begin
		perform excluir_BNDT_1('0001399-46.2016.5.07.0014', null);
end $$;


--------------------------------------------------------









 