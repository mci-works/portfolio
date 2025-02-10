
# Indice
# 1. Osservazioni e verifiche preliminari
# ***************************************
# 2. Esecuzione dei singoli task a scopo didattico
# ************************************************
# 3. Tabella completa


# 1. Osservazioni e verifiche preliminari
select * from banca.cliente;
select * from banca.conto;
select * from banca.tipo_conto;
select * from banca.tipo_transazione;
select * from banca.transazioni;

	# verifica che a ogni cliente sia associato un solo conto
select
max(cli.id_cliente) as n_clienti, max(con.id_conto) n_conti
from
banca.cliente cli
left join banca.conto con
on cli.id_cliente = con.id_cliente;
	# dall'analisi emerge che non c'è corrispondenza tra il numero di clienti (199) e il numero di conti (239) 
	# pertanto ad ogni id_cliente può essere associato più di un conto.

# ********************************************************************************************************

# 2. Esecuzione dei singoli task a scopo didattico

# Primo quesito: 
# calcolare l'età per ogni cliente
select
distinct(id_cliente), floor(datediff(current_date(), data_nascita) / 365) as eta
from banca.cliente;

# Secondo quesito:
# Numero di transazioni in uscita su tutti i conti
# Numero di transazioni in entrata su tutti i conti
select
sum(case when id_tipo_trans in (0,1,2) then 1 else 0 end) as entrate,
sum(case when id_tipo_trans in (3,4,5,6,7) then 1 else 0 end) as uscite
from
banca.transazioni;

# Terzo quesito:
# Importo transato in uscita su tutti i conti
# Importo transato in entrata su tutti i conti
select
sum(case when id_tipo_trans in (0,1,2) then importo else 0 end) as totale_trans_entrata, 
sum(case when id_tipo_trans in (3,4,5,6,7) then importo else 0 end) as totale_trans_uscita
from banca.transazioni;

# Quarto quesito:
# Numero totale di conti posseduti
select count(id_conto) from banca.conto;

# Quinto quesito:
# Numero di conti posseduti per tipologia (un indicatore per tipo)
select * from banca.tipo_conto;
select 
sum(case when id_tipo_conto = 0 then 1 else 0 end) as num_conti_base,
sum(case when id_tipo_conto = 1 then 1 else 0 end) as num_conti_business,
sum(case when id_tipo_conto = 2 then 1 else 0 end) as num_conti_privati,
sum(case when id_tipo_conto = 3 then 1 else 0 end) as num_conti_famiglie
from banca.conto;

# Sesto quesito:
# Numero di transazioni in uscita per tipologia (un indicatore per tipo)
select 
sum(case when id_tipo_trans = 3 then 1 else 0 end) as num_trans_amazon,
sum(case when id_tipo_trans = 4 then 1 else 0 end) as num_trans_r_mutuo,
sum(case when id_tipo_trans = 5 then 1 else 0 end) as num_trans_hotel,
sum(case when id_tipo_trans = 6 then 1 else 0 end) as num_trans_b_aereo,
sum(case when id_tipo_trans = 7 then 1 else 0 end) as num_trans_supermercato
from banca.transazioni;

# Settimo quesito
# Numero di transazioni in entrata per tipologia (un indicatore per tipo)
select 
sum(case when id_tipo_trans = 0 then 1 else 0 end) as num_trans_stipendio,
sum(case when id_tipo_trans = 1 then 1 else 0 end) as num_trans_r_pensione,
sum(case when id_tipo_trans = 2 then 1 else 0 end) as num_trans_dividendi
from banca.transazioni;

# Ottavo quesito:
# Importo transato in uscita per tipologia di conto (un indicatore per tipo)
select 
sum(case when id_tipo_trans = 3 then importo else 0 end) as tot_trans_amazon,
sum(case when id_tipo_trans = 4 then importo else 0 end) as tot_trans_r_mutuo,
sum(case when id_tipo_trans = 5 then importo else 0 end) as tot_trans_hotel,
sum(case when id_tipo_trans = 6 then importo else 0 end) as tot_trans_b_aereo,
sum(case when id_tipo_trans = 7 then importo else 0 end) as tot_trans_supermercato
from banca.transazioni;

# Nono quesito:
# Importo transato in entrata per tipologia di conto (un indicatore per tipo)
select 
sum(case when id_tipo_trans = 0 then importo else 0 end) as tot_trans_stipendio,
sum(case when id_tipo_trans = 1 then importo else 0 end) as tot_trans_r_pensione,
sum(case when id_tipo_trans = 2 then importo else 0 end) as tot_trans_dividendi
from banca.transazioni;

# --------------------------------------------------------------------------------

# 3. Tabella completa

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


