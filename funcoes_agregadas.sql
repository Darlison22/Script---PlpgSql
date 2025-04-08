
-- Retorna o valor maximo do id de um processo.
select max (id_processo) from pje.tb_processo tp; 

-- Retorna o valor minimo do id de um processo.
select min (id_processo) from pje.tb_processo tp ;

-- Retorna a soma dos ids de todos os processos cadastrados
select sum (id_processo) from pje.tb_processo tp ;


-- Retornando dados atraves do group by
select id_fluxo , sum(id_processo) from pje.tb_processo tp group by id_fluxo  ;

-- Usando o grupo by com condições atraves do having
select id_fluxo, sum(id_processo) from pje.tb_processo group by id_fluxo having sum (id_processo) > 6000;


select id_fluxo from pje.tb_processo;