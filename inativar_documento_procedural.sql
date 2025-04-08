
/*
 * Para pegar o nome correto do documento, você pode ir em bugfix, na timeline do proceso, lá estará toda a documentação
 * já inserida nos autos. Então, basta clicar no documento que será desativado e copiar o nome para passar como parametro na funcao
 * */

create or replace function public.inativar_documento(p_nr_processo character varying, p_ds_documento character varying)
returns character varying 
language plpgsql
as $$
declare 
	--declarar variaveis
	v_id_processo_documento integer;
	v_id_processo integer;
	resultado character varying;
begin 
	--logica procedural
	--verificar se o processo realmente existe
	select 
		tp.id_processo into v_id_processo 
	from pje.tb_processo tp where tp.nr_processo = p_nr_processo;

	if not found then
		raise exception 'Processo não encontrado!';
	end if;

	--pegar o id do documento para ser utilizado no update posteriormente
	select 
		tpd.id_processo_documento into v_id_processo_documento 
	from pje.tb_processo_documento tpd 
	where tpd.id_processo = v_id_processo 
	and tpd.dt_juntada is null
	and tpd.ds_processo_documento ilike p_ds_documento; 

	if not found then
		raise exception 'Documento não encontrado. Verifique se o nome passado como parametro está correto';
	end if;

	update pje.tb_processo_documento set in_ativo = 'N' where id_processo_documento = v_id_processo_documento;

	raise notice '------------------------- Processo: % --------------------------', p_nr_processo;
	raise notice 'update pje.tb_processo_documento set in_ativo = ''N'' where id_processo_documento = %;', v_id_processo_documento;

	resultado := 'Documento inativado com sucesso. Verifique em bugfix e copie o script para validação';
	return resultado;
	
end;
$$;

select  public.inativar_documento('0001624-54.2016.5.07.0018', 'Cumprimento.Sentença');
