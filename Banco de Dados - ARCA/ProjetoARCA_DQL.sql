--Primeira query: relação entre mês, gatos e cachorros adotados
select TO_CHAR(s.data, 'MM/YYYY') as mes, an.especie, count(*) as total_adocao from solicitacoes s join adocao a on s.id = a.solicitacoes_id join animal an on
an.adocao_id = a.solicitacoes_id where s.status = 'Concluído' group by TO_CHAR(s.data, 'MM/YYYY'), an.especie order by min(s.data);

--Segunda query: relação entre demanda de castração de caes e gatos
select an.especie, count(*) as total_demanda from servicos se join animal an on se.solicitacoes_id = an.servicos_id where se.tipo = 'Castração'
group by an.especie 

--Terceira query: relação média mensal de adoções de todos os anos separadamente
select ano, ROUND(avg(total_adocao), 2) as media_mensal from (select TO_CHAR(s.data, 'MM/YYYY') as mes, TO_CHAR(s.data, 'YYYY') as ano, count(*) as total_adocao
from solicitacoes s join adocao a on s.id = a.solicitacoes_id where s.status = 'Concluído' group by TO_CHAR(s.data, 'MM/YYYY'), TO_CHAR(s.data, 'YYYY')
) as subquery group by ano order by ano;

--Terceira query complementar: relação média mensal de adoções de todos os meses do periodo de 2023-2025
select ROUND(avg(total_adocao), 2) as media_mensal from(select TO_CHAR(s.data, 'MM/YYYY') as mes, count(*) as total_adocao
from solicitacoes s join adocao a on s.id = a.solicitacoes_id where s.status = 'Concluído' group by TO_CHAR(s.data, 'MM/YYYY')) as subquery;