


create or replace function public.verificar_movimentacao_chip(p_nr_processo character varying, p_nm_etiqueta character varying)
returns character varying 
language plpgsql
as $$
declare 
	
	v_id_processo integer;
	v_nm_etiqueta character varying;
	resultado character varying;

begin
	
	--verificar se o processo existe
	select id_processo into v_id_processo from pje.tb_processo where nr_processo = p_nr_processo;
	if not found then
		raise exception 'processo não encontrado';
	end if;

	-- regras para inclusão / exclusão de acordo com a classe do processo
	select 
		tcj.cd_classe_judicial ,
		tcj.ds_classe_judicial ,
		tee.nm_etiqueta 
	from pje_etq.tb_etq_manutencao_classe temc  
	inner join pje_etq.tb_etq_etiqueta_instancia teei on temc.id_etq_etiqueta_instancia = teei.id_etq_etiqueta_instancia 
	inner join pje_etq.tb_etq_etiqueta tee on teei.id_etq_etiqueta = tee.id_etq_etiqueta 
	inner join pje.tb_classe_aplicacao tca on temc.id_classe_aplicacao = tca.id_classe_aplicacao
	inner join pje.tb_classe_judicial tcj on tca.id_classe_judicial = tcj.id_classe_judicial 
	where tee.nm_etiqueta = p_nm_etiqueta;
	
	
	
	
	
end;
$$;
