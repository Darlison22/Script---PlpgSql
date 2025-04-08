


select * from pje.tb_usuario_login tul where tul.ds_email = 'simonefb@trt7.jus.br';


-- Alterar a fase de um processo para uma destas:
-- Conhecimento, Liquidação, Execução, Arquivados, Finalizados

do $$
declare

-----------------
--  PARAMETROS
-----------------

-- Informar numero do processo e fase sugerida 

p_nr_processos varchar[] := 
ARRAY
[
'0001257-67.2024.5.07.0012'
];
p_fase_sugerida varchar := 'Liquidação';
-----------------
--   VARIAVEIS
-----------------

i varchar;

v_id_processo integer;
v_nr_processo varchar;

v_id_fase_sugerida integer;
v_nm_fase_sugerida varchar;

v_id_fase_anterior varchar;
v_nm_fase_anterior varchar;

v_id_fase_corrente integer;
v_nm_fase_corrente varchar;

v_nr_instancia integer;
v_dt_distribuicao timestamp;
v_ds_classe_judicial varchar;

v_id_movimento_liquidacao integer;
v_dt_movimento_liquidacao timestamp;
v_ds_movimento_liquidacao varchar;

v_id_movimento_execucao integer;
v_dt_movimento_execucao timestamp;
v_ds_movimento_execucao varchar;

v_id_movimento_julgamento integer;
v_dt_movimento_julgamento timestamp;
v_ds_movimento_julgamento timestamp;

v_id_movimento_arquivamento integer;
v_dt_movimento_arquivamento timestamp;
v_ds_movimento_arquivamento varchar;

v_id_movimento_desarquivamento integer;
v_dt_movimento_desarquivamento timestamp;
v_ds_movimento_desarquivamento varchar;

v_id_movimento_devolucao integer;
v_dt_movimento_devolucao timestamp;
v_ds_movimento_devolucao varchar;

v_id_movimento_novo_recebimento integer;
v_dt_movimento_novo_recebimento timestamp;
v_ds_movimento_novo_recebimento varchar;

v_id_movimento_baixa integer;
v_dt_movimento_baixa timestamp;
v_ds_movimento_baixa varchar;

v_id_movimento_nova_subida integer;
v_dt_movimento_nova_subida timestamp;
v_ds_movimento_nova_subida varchar;

v_msg_buffer text;

v_ds_primeira_tarefa varchar;

v_gerar_update boolean := false;

begin

FOREACH i IN ARRAY p_nr_processos loop

v_msg_buffer :='';

select p.id_processo, p.nr_processo, t.dt_distribuicao, cj.ds_classe_judicial
into v_id_processo, v_nr_processo, v_dt_distribuicao, v_ds_classe_judicial
from tb_processo p
join tb_processo_trf t on t.id_processo_trf = p.id_processo
join tb_classe_judicial cj on cj.id_classe_judicial = t.id_classe_judicial
where p.nr_processo = i;

if coalesce(v_id_processo, 0) <> 0 
then
	v_msg_buffer := v_msg_buffer || chr(13) || '-- Processo: ' || v_nr_processo || ' (' || v_id_processo || ')';
	v_msg_buffer := v_msg_buffer || chr(13) || '-- Classe judicial: ' || v_ds_classe_judicial;
	v_msg_buffer := v_msg_buffer || chr(13) || '-- Distribuição: ' || to_char(v_dt_distribuicao, 'dd/mm/yyyy');
else
	raise exception 'Processo nao localizado %', i;
end if;

select ti.name_
into v_ds_primeira_tarefa
from tb_processo_instance px
join jbpm_taskinstance ti on ti.procinst_ = px.id_proc_inst
where 1=1
and px.id_processo = v_id_processo
order by ti.id_
fetch first row only;


select x.vl_variavel::integer
into v_nr_instancia
from tb_parametro x
where x.nm_variavel = 'aplicacaoSistema';

if coalesce(v_nr_instancia, 0) in (1, 2)
then
	v_msg_buffer := v_msg_buffer || chr(13) || '-- Instancia: ' || v_nr_instancia || 'o Grau';
else
	v_msg_buffer := v_msg_buffer || chr(13) || '-- Instancia nao eh de 1o ou 2o grau.';
end if;

-- Localiza movimento de inicio de liquidacao
select pe.id_processo_evento, pe.dt_atualizacao, pe.ds_texto_final_externo
into v_id_movimento_liquidacao, v_dt_movimento_liquidacao, v_ds_movimento_liquidacao
from tb_processo p
join tb_processo_evento pe on pe.id_processo = p.id_processo
where 1=1
and p.id_processo = v_id_processo
and pe.id_processo_evento = (
	select max(x0.id_processo_evento) id_processo_evento
	from tb_processo_evento x0
	where 1=1
	and x0.id_evento in  (11384) -- Iniciada a Liquidacao
	and x0.id_processo = p.id_processo
)
order by pe.id_processo_evento desc
fetch first 1 row only;

-- Localiza movimento de inicio de execucao
select pe.id_processo_evento, pe.dt_atualizacao, pe.ds_texto_final_externo
into v_id_movimento_execucao, v_dt_movimento_execucao, v_ds_movimento_execucao
from tb_processo p
join tb_processo_evento pe on pe.id_processo = p.id_processo
where 1=1
and p.id_processo = v_id_processo
and pe.id_processo_evento = (
	select max(x0.id_processo_evento) id_processo_evento
	from tb_processo_evento x0
	where 1=1
	and x0.id_evento in  (11385) -- Iniciada a Execução
	and x0.id_processo = p.id_processo
)
order by pe.id_processo_evento desc
fetch first 1 row only;

-- Localiza movimento de arquivamento
select pe.id_processo_evento, pe.dt_atualizacao, pe.ds_texto_final_externo
into v_id_movimento_arquivamento, v_dt_movimento_arquivamento, v_ds_movimento_arquivamento
from tb_processo p
join tb_processo_evento pe on pe.id_processo = p.id_processo
where 1=1
and p.id_processo = v_id_processo
and pe.id_processo_evento = (
	select max(y0.id_processo_evento) id_processo_evento
	from tb_processo_evento y0
	where 1=1
	and y0.id_processo = p.id_processo
	and y0.id_evento in (245, 246) -- Arquivados os autos provisoriamente ou definitivamente
)
order by pe.id_processo_evento desc
fetch first 1 row only;

-- Localiza movimento de desarquivamento
select pe.id_processo_evento, pe.dt_atualizacao, pe.ds_texto_final_externo
into v_id_movimento_desarquivamento, v_dt_movimento_desarquivamento, v_ds_movimento_desarquivamento
from tb_processo p
join tb_processo_evento pe on pe.id_processo = p.id_processo
where 1=1
and p.id_processo = v_id_processo
and pe.id_processo_evento = (
	select max(y0.id_processo_evento) id_processo_evento
	from tb_processo_evento y0
	where 1=1
	and y0.id_processo = p.id_processo
	and y0.id_evento in (893) -- Processo desarquivado
	and y0.dt_atualizacao >= v_dt_movimento_arquivamento
)
order by pe.id_processo_evento desc
fetch first 1 row only;

-- Localiza movimento de devolucao de carta
select pe.id_processo_evento, pe.dt_atualizacao, pe.ds_texto_final_externo
into v_id_movimento_devolucao, v_dt_movimento_devolucao, v_ds_movimento_devolucao
from tb_processo p
join tb_processo_evento pe on pe.id_processo = p.id_processo
where 1=1
and p.id_processo = v_id_processo
and pe.id_processo_evento = (
	select max(y0.id_processo_evento) id_processo_evento
	from tb_processo_evento y0
	join tb_complemento_segmentado z0 on z0.id_movimento_processo = y0.id_processo_evento
	where 1=1
	and y0.id_processo = p.id_processo
	and y0.id_evento in (123)       -- Remetidos os autos
	and z0.id_tipo_complemento = 28 -- Destino
	and z0.ds_texto = '7049'        -- Juízo deprecante
)
order by pe.id_processo_evento desc
fetch first 1 row only;

-- Localiza movimento de novo recebimento de carta apos devolucao
select pe.id_processo_evento, pe.dt_atualizacao, pe.ds_texto_final_externo
into v_id_movimento_novo_recebimento, v_dt_movimento_novo_recebimento, v_ds_movimento_novo_recebimento
from tb_processo p
join tb_processo_evento pe on pe.id_processo = p.id_processo
join tb_complemento_segmentado cs on cs.id_movimento_processo = pe.id_processo_evento
where 1=1
and p.id_processo = v_id_processo
and pe.id_evento in (132)       -- Recebidos os autos
and cs.id_tipo_complemento = 35 -- motivo do recebimento
and cs.ds_texto = '40'          -- para prosseguir
and exists (
	select 1
	from tb_processo_evento y1
	join tb_complemento_segmentado z1 on z1.id_movimento_processo = y1.id_processo_evento
	where 1=1
	and y1.id_processo = pe.id_processo
	and y1.dt_atualizacao < pe.dt_atualizacao
	and y1.id_evento in (123)       -- Remetidos os autos
	and z1.id_tipo_complemento = 28 -- Destino
	and z1.ds_texto = '7049'        -- Juízo deprecante
)
order by pe.id_processo_evento asc
fetch first 1 row only;

-- Localiza movimento de baixado ao primeiro grau
select pe.id_processo_evento, pe.dt_atualizacao, pe.ds_texto_final_externo
into v_id_movimento_baixa, v_dt_movimento_baixa, v_ds_movimento_baixa
from tb_processo p
join tb_processo_evento pe on pe.id_processo = p.id_processo
where 1=1
and p.id_processo = v_id_processo
and pe.id_processo_evento = (
	select max(y0.id_processo_evento) id_processo_evento
	from tb_processo_evento y0
	join tb_complemento_segmentado z0 on z0.id_movimento_processo = y0.id_processo_evento
	where 1=1
	and y0.id_processo = p.id_processo
	and y0.id_evento in (123)       -- Remetidos os autos
	and z0.id_tipo_complemento = 28 -- Destino
	and z0.ds_texto = '7051'        -- Orgao jurisdicional competente
)
order by pe.id_processo_evento desc
fetch first 1 row only;

-- Localiza movimento de distribuicao apos baixa
select pe.id_processo_evento, pe.dt_atualizacao, pe.ds_texto_final_externo
into v_id_movimento_nova_subida, v_dt_movimento_nova_subida, v_ds_movimento_nova_subida
from tb_processo p
join tb_processo_evento pe on pe.id_processo = p.id_processo
where 1=1
and p.id_processo = v_id_processo
and pe.id_processo_evento = (
	select max(y0.id_processo_evento) id_processo_evento
	from tb_processo_evento y0
	where 1=1
	and y0.id_processo = p.id_processo
	and y0.id_evento in (26)       -- Distribuido
	and exists (
		select 1
		from tb_processo_evento y1
		join tb_complemento_segmentado z1 on z1.id_movimento_processo = y1.id_processo_evento
		where 1=1
		and y1.id_processo = y0.id_processo
		and y1.dt_atualizacao < y0.dt_atualizacao
		and y1.id_evento in (123)       -- Remetidos os autos
		and z1.id_tipo_complemento = 28 -- Destino
		and z1.ds_texto = '7051'        -- Orgao jurisdicional competente
	)
)
order by pe.id_processo_evento desc
fetch first 1 row only;

if coalesce(v_ds_primeira_tarefa, '') ilike '%inici%exec%'
then
	v_nm_fase_sugerida := 'Execução';
elsif coalesce(v_ds_primeira_tarefa, '') ilike '%inici%liqu%'
then
	v_nm_fase_sugerida := 'Liquidação';
else
	v_nm_fase_sugerida := 'Conhecimento';
end if;

if coalesce(v_nr_instancia, 0) = 1
then

	if coalesce(v_id_movimento_liquidacao, 0) <> 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Movimento: ' || to_char(v_dt_movimento_liquidacao, 'dd/mm/yyyy') || ' ' || v_ds_movimento_liquidacao || ' ' || v_id_movimento_liquidacao;
		v_nm_fase_anterior := v_nm_fase_sugerida;
		v_nm_fase_sugerida := 'Liquidação';
	end if;

	if coalesce(v_id_movimento_execucao, 0) <> 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Movimento: ' || to_char(v_dt_movimento_execucao, 'dd/mm/yyyy') || ' ' || v_ds_movimento_execucao || ' ' || v_id_movimento_execucao;
		v_nm_fase_anterior := v_nm_fase_sugerida;
		v_nm_fase_sugerida := 'Execução';
	end if;

	if coalesce(v_id_movimento_arquivamento, 0) <> 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Movimento: ' || to_char(v_dt_movimento_arquivamento, 'dd/mm/yyyy') || ' ' || v_ds_movimento_arquivamento || ' ' || v_id_movimento_arquivamento;
		v_nm_fase_anterior := v_nm_fase_sugerida;
		v_nm_fase_sugerida := 'Arquivados';
	end if;

	if coalesce(v_id_movimento_desarquivamento, 0) <> 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Movimento: ' || to_char(v_dt_movimento_desarquivamento, 'dd/mm/yyyy') || ' ' || v_ds_movimento_desarquivamento || ' ' || v_id_movimento_desarquivamento;
		v_nm_fase_sugerida := v_nm_fase_anterior;
	end if;

	if coalesce(v_id_movimento_devolucao, 0) <> 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Movimento: ' || to_char(v_dt_movimento_devolucao, 'dd/mm/yyyy') || ' ' || v_ds_movimento_devolucao || ' ' || v_id_movimento_devolucao;
		v_nm_fase_anterior := v_nm_fase_sugerida;
		v_nm_fase_sugerida := 'Arquivados';
	end if;

	if coalesce(v_id_movimento_novo_recebimento, 0) <> 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Movimento: ' || to_char(v_dt_movimento_novo_recebimento, 'dd/mm/yyyy') || ' ' || v_ds_movimento_novo_recebimento || ' ' || v_id_movimento_novo_recebimento;
		v_nm_fase_sugerida := v_nm_fase_anterior;
	end if;

elsif coalesce(v_nr_instancia, 0) = 2
then
	if coalesce(v_id_movimento_baixa, 0) <> 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Movimento: ' || to_char(v_dt_movimento_baixa, 'dd/mm/yyyy') || ' ' || v_ds_movimento_baixa || ' ' || v_id_movimento_baixa;
		v_nm_fase_anterior := v_nm_fase_sugerida;
		v_nm_fase_sugerida := 'Finalizados';
	end if;

	if coalesce(v_id_movimento_nova_subida, 0) <> 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Movimento: ' || to_char(v_dt_movimento_nova_subida, 'dd/mm/yyyy') || ' ' || v_ds_movimento_nova_subida || ' ' || v_id_movimento_nova_subida;
		v_nm_fase_sugerida := v_nm_fase_anterior;
	end if;

	if coalesce(v_nr_instancia, 0) = 1 and v_nm_fase_sugerida not in ('Conhecimento', 'Liquidação', 'Execução', 'Arquivados') 
	or coalesce(v_nr_instancia, 0) = 2 and v_nm_fase_sugerida not in ('Conhecimento', 'Finalizados')
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Fase sugerida nao corresponde com a instancia.';
	end if;

end if;

select f.id_agrupamento_fase, f.nm_agrupamento_fase
into v_id_fase_corrente, v_nm_fase_corrente
from tb_processo p
join tb_agrupamento_fase f on f.id_agrupamento_fase = p.id_agrupamento_fase
where 1=1
and p.id_processo = v_id_processo;

select f.id_agrupamento_fase, f.nm_agrupamento_fase
into v_id_fase_sugerida, v_nm_fase_sugerida
from tb_agrupamento_fase f
where f.nm_agrupamento_fase = v_nm_fase_sugerida;

if coalesce(v_id_fase_corrente, 0) = 0
then 
	raise exception 'Fase corrente nao localizada';
elsif coalesce(v_id_fase_sugerida, 0) = 0
then
	raise exception 'Fase sugerida nao localizada';
else
	v_msg_buffer := v_msg_buffer || chr(13) || '-- Fase corrente: ' || v_nm_fase_corrente || ' (' || v_id_fase_corrente || ')';
	v_msg_buffer := v_msg_buffer || chr(13) || '-- Fase sugerida: ' || v_nm_fase_sugerida || ' (' || v_id_fase_sugerida || ')';
end if;

if coalesce(v_nr_instancia, 0) = 1
then
	-- Validar a fase sugerida confrontando-a com os movimentos do processo
	if (v_nm_fase_sugerida = 'Conhecimento' and (coalesce(v_id_movimento_liquidacao, 0) = 0 and coalesce(v_id_movimento_execucao, 0) = 0))
	or (v_nm_fase_sugerida = 'Liquidação' and coalesce(v_id_movimento_liquidacao, 0) <> 0)
	or (v_nm_fase_sugerida = 'Execução' and coalesce(v_id_movimento_execucao, 0) <> 0)
	or (v_nm_fase_sugerida = 'Arquivados' and coalesce(v_id_movimento_arquivamento, 0) <> 0)
	or (v_nm_fase_sugerida = 'Arquivados' and coalesce(v_id_movimento_devolucao, 0) <> 0)
	then
		v_gerar_update := true;
	elsif v_nm_fase_sugerida = 'Conhecimento'
	then
		if coalesce(v_id_movimento_liquidacao, 0) <> 0
		then
			v_msg_buffer := v_msg_buffer || chr(13) || '-- Existe movimento de inicio da liquidacao.';
		elsif coalesce(v_id_movimento_execucao, 0) <> 0
		then
			v_msg_buffer := v_msg_buffer || chr(13) || '-- Existe movimento de inicio da execucao.';
		elsif coalesce(v_id_movimento_devolucao, 0) <> 0 and coalesce(v_id_movimento_novo_recebimento, 0) = 0
		then
			v_msg_buffer := v_msg_buffer || chr(13) || '-- Existe movimento de devolucao de carta sem novo recebimento.';
		end if;
	elsif v_nm_fase_sugerida = 'Liquidação' and coalesce(v_id_movimento_liquidacao, 0) = 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Nao ha movimento de inicio da liquidacao.';
	elsif v_nm_fase_sugerida = 'Execução' and coalesce(v_id_movimento_execucao, 0) = 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Nao ha movimento de inicio da execucao.';
	elsif v_nm_fase_sugerida = 'Arquivados' and coalesce(v_id_movimento_arquivamento, 0) = 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Nao ha movimento de arquivamento.';
	elsif v_nm_fase_sugerida = 'Finalizados' and coalesce(v_id_movimento_baixa, 0) = 0
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Nao ha movimento de baixa.';
	elsif v_nm_fase_sugerida = 'Elaboração'
	then 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Nada implementado para a fase sugerida.';
	else 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- As movimentacoes nao atendem as condicoes para mudanca de fase.';
	end if;

	-- Se o processo estiver arquivado, mantem o update bloqueado
	if v_nm_fase_corrente = 'Arquivados' and (coalesce(v_id_movimento_arquivamento) <> 0 and coalesce (v_id_movimento_desarquivamento) = 0)
	then
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Existe movimento de arquivamento, mas sem desarquivamento.';
		v_gerar_update := false;
	end if;

	-- Se o processo de carta estiver devolvido, mantem o update bloqueado
	if v_nm_fase_corrente = 'Arquivados' and (coalesce(v_id_movimento_devolucao) <> 0 and coalesce (v_id_movimento_novo_recebimento) = 0)
	then
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Existe movimento de arquivamento, mas sem desarquivamento.';
		v_gerar_update := false;
	end if;

elsif coalesce(v_nr_instancia, 0) = 2
then
	-- Validar a fase sugerida confrontando-a com os movimentos do processo
	if (v_nm_fase_sugerida = 'Conhecimento' and (coalesce(v_id_movimento_baixa, 0) = 0 or coalesce(v_id_movimento_nova_subida, 0) <> 0))
	or (v_nm_fase_sugerida = 'Finalizados' and coalesce(v_id_movimento_nova_subida, 0) = 0)
	then
		v_gerar_update := true;
	else 
		v_msg_buffer := v_msg_buffer || chr(13) || '-- As movimentacoes nao atendem as condicoes para mudanca de fase.';
	end if;

	-- Se o processo estiver finalizado, mantem o update bloqueado
	if v_nm_fase_corrente = 'Finalizados' and coalesce(v_id_movimento_baixa, 0) <> 0 and coalesce(v_id_movimento_nova_subida, 0) = 0
	then
		v_msg_buffer := v_msg_buffer || chr(13) || '-- Existe movimento de baixa, mas sem nova subida.';
		v_gerar_update := false;
	end if;
end if;

if v_nm_fase_sugerida = v_nm_fase_corrente
then
	v_msg_buffer := v_msg_buffer || chr(13) || '-- O processo ja estah na fase sugerida.';
	v_gerar_update := false;
end if;

if v_gerar_update = true
then
	v_msg_buffer := v_msg_buffer || chr(13) || '-- Alterar a fase do processo ' || v_nr_processo || ' de ''' || v_nm_fase_corrente || ''' para ''' || v_nm_fase_sugerida || '''';
	v_msg_buffer := v_msg_buffer || chr(13) || 'update tb_processo set id_agrupamento_fase = ' || v_id_fase_sugerida || ' where id_processo = ' || v_id_processo || ';';
	raise notice '%', v_msg_buffer || chr(13);
end if;

end loop;

end $$ language plpgsql;
