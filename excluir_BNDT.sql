

--OBS: COLOCAR NO GITHUB DEPOIS HEHE

/***************************************************
***************************************************
*Esse erro de exclusão  nos processos antigos e anteriores ao PJe (data de protocolo anterior a 2013), em que o 
registro do BNDT foi incluido e o processo foi migrado para o PJe. O problema acontece porque nessa migração não foram
migrados os dados de inclusão no BNDT. Então, para resolver esse problema, basta incluir esses dados na tabela tb_dbto_trabalhista_historico e
realizar os movimentos necessarios para que a exclusão no PJe seja efetuada com sucesso.


Há 4 casos possiveis que podem ocorrer:

1 - Os casos em que não há nenhuma parte registrada no PJe para tal processo. 
 Nestes casos é feito os registros nas tabelas tb_debito_trabalhista e tb_dbto_trblhsta_historico.

2 - Os casos mais comuns, em que há somente uma parte de tal processo para ser habilitado a exclusão.
Nesse caso em especifico, basta passar o número do processo como parametro na função e deixar o segundo parametro default em null.

3 - Os casos em que há registros duplicados da parte devedora nas tabelas tb_debito_trabalhista e td_dbto_trbhlista_historico.
Nesse caso, basta excluir um dos reigistros em cada uma das duas tabelas.

4 - E temos também os casos em que o processo tem varias partes então, é necessário, além do número do processo,
passar também o nome da parte devedora como segundo parametro da função ;)

O script aborda todos esses casos. Porém, caso apareçam outros casos diferentes desses, a implementação do script será 
melhorada para resolver todas as soluções possiveis.

Ref.: https://jira.trt7.jus.br/jira/browse/CSTIC-4964
***************************************************
***************************************************/


CREATE OR REPLACE FUNCTION habilitar_exclusao_BNDT(p_nr_processo varchar, p_ds_nome_parte_devedora varchar default null) 
RETURNS void as $$
DECLARE
    v_id_processo_parte integer;
    v_id_processo_evento integer;
    v_qtd_debitos_trabalhistas integer;
    v_id_processo integer;
    v_ds_nome_empresa varchar;
    v_ds_frase_exclusao varchar;
    v_id_debito_trabalhista integer;
    v_id_debto_trabalhista_historico integer;
    v_id_registros_debito_trabalhista_array integer [2];
    v_id_registros_debto_trabalhista_historico_array integer [2];
    v_id_processo_parte_array integer [2];

-------------------------------------------------
	 vs_ds_nome_parte varchar;
	 v_dt_alteracao varchar;
	 v_dt_envio varchar;
	 v_in_tipo_operacao varchar;
	 v_id_usuario integer;

BEGIN
  
--verifica a quantidade de registros na tabela debito_trabalhista
select count(dt.id_debito_trabalhista) into  v_qtd_debitos_trabalhistas
from pje.tb_processo tp 
inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
inner join pje_jt.tb_debito_trabalhista dt on dt.id_processo_parte = tpp.id_processo_parte
inner join pje_jt.tb_sit_debito_trabalhista tsdt on dt.id_situacao_debito_trabalhista = tsdt.id_situacao_debito_trabalhista
where tp.nr_processo = p_nr_processo
and tsdt.in_tipo_operacao = 'I';


--Verificar o historico de registros encontrados para um processo
FOR v_id_debto_trabalhista_historico, vs_ds_nome_parte, v_dt_alteracao, v_dt_envio, v_in_tipo_operacao IN
    SELECT dth.id_debto_trabalhista_historico, tul.ds_nome, dth.dt_alteracao, dth.dt_envio, dth.in_tipo_operacao
    FROM pje.tb_processo tp
    INNER JOIN pje.tb_processo_parte tpp ON tpp.id_processo_trf = tp.id_processo
    INNER JOIN pje_jt.tb_dbto_trblhsta_historico dth ON dth.id_processo_parte = tpp.id_processo_parte
    INNER JOIN pje.tb_pessoa tu ON tu.id_pessoa = tpp.id_pessoa
    INNER JOIN pje.tb_usuario_login tul ON tu.id_pessoa = tul.id_usuario
    WHERE tp.nr_processo = p_nr_processo
LOOP
	raise notice'-----------------------------------------------------------------------------------------------------------------';
    raise notice 'ID: %, nome_parte: %, data_alt:%, Data_env: %, tipo: %', v_id_debto_trabalhista_historico, vs_ds_nome_parte, v_dt_alteracao, v_dt_envio, v_in_tipo_operacao;
END LOOP;


--verifica se não há registros
IF COALESCE(v_qtd_debitos_trabalhistas, 0) = 0 THEN
   
	if p_ds_nome_parte_devedora is null then
		raise notice '---------------------------------------------------------------------------------';
		raise notice 'Não foi encontrado nenhum registro na tabela tb_debito_trabalhista.';
		raise notice 'Execute a função novamente e passe o nome da parte como parametro para que seja inseridos os registros necessários para habilitar a exclusão';
		raise notice '---------------------------------------------------------------------------------';
		return;
	end if;

		select tpp.id_processo_parte into v_id_processo_parte
		from pje.tb_processo tp 
		inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
		inner join pje.tb_usuario_login tul on tpp.id_pessoa = tul.id_usuario
		where tp.nr_processo = p_nr_processo
		and tul.ds_nome = p_ds_nome_parte_devedora;

		if  v_id_processo_parte is null then
			raise notice 'Não foi encontrado nenhum registro de parte com esse nome. Verifique se o nome passado como parametro está correto';
			return;
		end if;


		insert into pje_jt.tb_debito_trabalhista (id_debito_trabalhista , id_processo_parte, id_situacao_debito_trabalhista, in_sincronizacao)
		values (nextval('pje_jt.sq_tb_debito_trabalhista'), v_id_processo_parte, 1, null);

		insert into pje_jt.tb_dbto_trblhsta_historico
		select nextval('pje_jt.sq_tb_dbto_trblhista_historico'), (current_timestamp-interval '4822 days'), 
        (current_timestamp-interval '4822 days'), 'I', null, null, v_id_processo_parte, 2, 1, 'N', null, null;
		raise notice 'Os registros necessários para a exclusão foram inseridos no PJe. Teste a exclusão em bugfix';
 	   return; 
END IF;


--verificar se há ou não registro duplicado
IF COALESCE(v_qtd_debitos_trabalhistas, 0) = 2 and p_ds_nome_parte_devedora is null THEN
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

		for v_dt_alteracao, v_dt_envio, v_id_usuario in
			(select dt_alteracao, dt_envio, id_usuario
			from pje_jt.tb_dbto_trblhsta_historico
			where id_processo_parte = v_id_processo_parte_array[1])
		loop
		--fazer uma validação dps
		end loop;

		raise notice' ';
		raise notice'--Para ficar o registro caso seja necessária a reversão:';
		raise notice '-- INSERT INTO tb_dbto_trblhsta_historico (id_debto_trabalhista_historico, dt_alteracao, dt_envio, in_tipo_operacao, ds_resposta_envio, id_motivo, 
         id_processo_parte, id_situacao_debito_trabalhista, id_usuario, in_adiar_envio, in_assinado, cd_erro_bndt) 
       	VALUES(%, %, %, ''I'', NULL, NULL, %, 1, %, ''N'', ''N'', NULL);',v_id_registros_debto_trabalhista_historico_array[1], v_dt_alteracao, v_dt_envio, v_id_processo_parte_array[1], v_id_usuario;
		raise notice '------------------------------------Exclusão:---------------------------------------------------';
	  	 raise notice 'DELETE FROM pje_jt.tb_dbto_trblhsta_historico WHERE id_debto_trabalhista_historico = %;', v_id_registros_debto_trabalhista_historico_array[2];

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
		raise notice' ';
		raise notice'--Para ficar o registro caso seja necessária a reversão:';
		raise notice '--INSERT INTO pje_jt.tb_debito_trabalhista (id_debito_trabalhista, id_processo_parte, id_situacao_debito_trabalhista, in_sincronizacao) 
		VALUES(%, %, 1, ''S'');', v_id_registros_debito_trabalhista_array[1], v_id_processo_parte_array[1];
		raise notice '------------------------------------Exclusão:---------------------------------------------------';
	    raise notice 'DELETE FROM pje_jt.tb_debito_trabalhista WHERE id_debito_trabalhista = %;', v_id_registros_debito_trabalhista_array[2];
   		 return; -- Apenas encerra a execução, sem retornar valores
	END IF;

    --caso não entre nas condições acima, signifca que as duas partes devedoras são diferentes, ou seja, que não tem registro duplicado
	raise notice' ';
     raise notice 'Há mais de um registro na tabela, informe qual deseja habilitar para excluir';
    return; -- Apenas encerra a execução, sem retornar valores
END IF;

------------------------------------------------------------------------------------------------------------------------------
 -- caso tenha passado pela validação acima, então há apenas um registro na tb_dbto_trblhsta_historico do qual queremos o id_processo e o id_processo_parte
IF COALESCE(v_qtd_debitos_trabalhistas, 0) = 1 THEN
    select tp.id_processo, tdth.id_processo_parte  into  v_id_processo, v_id_processo_parte
    from pje.tb_processo tp 
    inner join pje.tb_processo_parte tpp on tpp.id_processo_trf = tp.id_processo
    inner join pje_jt.tb_dbto_trblhsta_historico tdth on tdth.id_processo_parte = tpp.id_processo_parte
    where tp.nr_processo = p_nr_processo
	and tdth.in_tipo_operacao = 'I';


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

	if v_ds_nome_empresa is null then
		raise notice 'Nome da empresa não foi encontrado na base de dados';
		return;
	end if;

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
	raise notice'--------------------------------------------------------------------------------------------------';
    raise notice 'Operaçoes executadas com sucesso! Verifique se é possivel excluir a parte do BNDT do PJE';
    return; -- Apenas encerra a execução, sem retornar valores
END IF;

------------------------------------------------------------------------------------------------------------------------------
--verificar melhor essa condição depois
IF COALESCE(v_qtd_debitos_trabalhistas, 0) > 1 and p_ds_nome_parte_devedora is null THEN
	raise notice' ';
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

		if v_id_processo, v_id_processo_parte is null then
			raise notice 'Não foi encontrado a parte do processo que foi passado como parametro. Verifique se o p_ds_nome_parte_devedora passado como parametro está correto';
			return;
		end if;

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
	
		raise notice' ';
	    raise notice 'Operaçoes executadas com sucesso! Verifique se é possivel excluir a parte do BNDT do PJE';
	    return; -- Apenas encerra a execução, sem retornar valores




END;
$$ LANGUAGE plpgsql;



-------------------------CHAMADA DA FUNCAO----------------------------------------

do $$
begin
		perform habilitar_exclusao_BNDT('0000534-23.2021.5.07.0022', 'JOSE EYMARD DE QUEIROZ MENDES');
end $$;


--------------------------------------------------------







 