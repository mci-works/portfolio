-- Create a feature table for training machine learning models by enriching customer data with various indicators calculated from their transactions 
-- and owned accounts. The final table will be related to the customer ID and will contain both quantitative and qualitative information.


-- Index
-- 1. Observations and preliminary verifications

-- 2. Complete Table


-- 1. Observations and preliminary verifications
select * from banca.cliente;
select * from banca.conto;
select * from banca.tipo_conto;
select * from banca.tipo_transazione;
select * from banca.transazioni;

-- verifying one single account is associated to every customer
select
max(cli.id_cliente) as n_clienti, max(con.id_conto) n_conti
from
banca.cliente cli
left join banca.conto con
on cli.id_cliente = con.id_cliente;
-- The analysis shows that there is no match between the number of customers (199) and the number of accounts (239).  
-- Therefore, each customer ID can be associated with more than one account.

-- 2. Complete Table

select 
    cli.id_cliente, 
    floor(datediff(current_date(), cli.data_nascita) / 365) as eta,
    sum(tra.n_trans_uscita) as n_trans_uscita,
    sum(tra.n_trans_entrata) as n_trans_entrata,
    sum(tra.importi_uscita) as importi_uscita,
    sum(tra.importi_entrata) as importi_entrata,
    count(distinct con.id_conto) as n_tot_conti,
    sum(case when con.id_tipo_conto = 0 then 1 else 0 end) as c0,
    sum(case when con.id_tipo_conto = 1 then 1 else 0 end) as c1,
    sum(case when con.id_tipo_conto = 2 then 1 else 0 end) as c2,
    sum(case when con.id_tipo_conto = 3 then 1 else 0 end) as c3,
    sum(tra.num_trans_amazon) as num_trans_amazon,
    sum(tra.num_trans_r_mutuo) as num_trans_r_mutuo,
    sum(tra.num_trans_hotel) as num_trans_hotel,
    sum(tra.num_trans_b_aereo) as num_trans_b_aereo,
    sum(tra.num_trans_supermercato) as num_trans_supermercato,
    sum(tra.num_trans_stipendio) as num_trans_stipendio,
    sum(tra.num_trans_r_pensione) as num_trans_r_pensione,
    sum(tra.num_trans_dividendi) as num_trans_dividendi,
    sum(case when con.id_tipo_conto = 0 and tra.id_tipo_trans in (0,1,2) then tra.importo else 0 end) as tot_entrata_conto_0,
    sum(case when con.id_tipo_conto = 0 and tra.id_tipo_trans in (3,4,5,6,7) then tra.importo else 0 end) as tot_uscita_conto_0,
    sum(case when con.id_tipo_conto = 1 and tra.id_tipo_trans in (0,1,2) then tra.importo else 0 end) as tot_entrata_conto_1,
    sum(case when con.id_tipo_conto = 1 and tra.id_tipo_trans in (3,4,5,6,7) then tra.importo else 0 end) as tot_uscita_conto_1,
    sum(case when con.id_tipo_conto = 2 and tra.id_tipo_trans in (0,1,2) then tra.importo else 0 end) as tot_entrata_conto_2,
    sum(case when con.id_tipo_conto = 2 and tra.id_tipo_trans in (3,4,5,6,7) then tra.importo else 0 end) as tot_uscita_conto_2,
    sum(case when con.id_tipo_conto = 3 and tra.id_tipo_trans in (0,1,2) then tra.importo else 0 end) as tot_entrata_conto_3,
    sum(case when con.id_tipo_conto = 3 and tra.id_tipo_trans in (3,4,5,6,7) then tra.importo else 0 end) as tot_uscita_conto_3
from 
    banca.cliente cli
left join
    banca.conto con
    on cli.id_cliente = con.id_cliente
left join (
    select 
        id_conto,
        id_tipo_trans,
        importo,
        sum(case when id_tipo_trans in (3,4,5,6,7) then 1 else 0 end) as n_trans_uscita,
        sum(case when id_tipo_trans in (0,1,2) then 1 else 0 end) as n_trans_entrata,
        sum(case when id_tipo_trans in (3,4,5,6,7) then importo else 0 end) as importi_uscita,
        sum(case when id_tipo_trans in (0,1,2) then importo else 0 end) as importi_entrata,
        sum(case when id_tipo_trans = 3 then 1 else 0 end) as num_trans_amazon,
        sum(case when id_tipo_trans = 4 then 1 else 0 end) as num_trans_r_mutuo,
        sum(case when id_tipo_trans = 5 then 1 else 0 end) as num_trans_hotel,
        sum(case when id_tipo_trans = 6 then 1 else 0 end) as num_trans_b_aereo,
        sum(case when id_tipo_trans = 7 then 1 else 0 end) as num_trans_supermercato,
        sum(case when id_tipo_trans = 0 then 1 else 0 end) as num_trans_stipendio,
        sum(case when id_tipo_trans = 1 then 1 else 0 end) as num_trans_r_pensione,
        sum(case when id_tipo_trans = 2 then 1 else 0 end) as num_trans_dividendi
    from 
        banca.transazioni
    group by 
        id_conto, id_tipo_trans, importo
) tra
on con.id_conto = tra.id_conto
group by 
    cli.id_cliente, cli.data_nascita
order by 
    cli.id_cliente;


