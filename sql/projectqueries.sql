create database p ;
use p ;

create table region (
    reg_code INT PRIMARY KEY,
    reg_nom VARCHAR(50) NOT NULL
);
select *from region;


create table departments (
	dep_code VARCHAR (10) PRIMARY KEY,
    dep_nom  VARCHAR(50) NOT NULL,
    reg_code  INT NOT NULL,
	FOREIGN KEY (reg_code) REFERENCES region(reg_code) 
);
select *from departments ; 


create table communes (
    insee_codcom VARCHAR(10) PRIMARY KEY,
	coddep VARCHAR(10),
    commune VARCHAR(50) NOT NULL,
    ptot INT NOT NULL,
    reg_code INT NOT NULL,
    FOREIGN KEY (reg_code) REFERENCES region(reg_code)
);
select * from communes limit 10 ;


create table properties (
    property_id INT PRIMARY KEY,
    type_local VARCHAR(50) NOT NULL,
    surface_m2 INT NOT NULL,
    no_pieces INT NOT NULL,
    no_voie INT NOT NULL,
    type_de_voie VARCHAR(50),
    voie VARCHAR(50),
    code_postal INT NOT NULL,
    insee_codcom VARCHAR(10) NOT NULL,
    FOREIGN KEY (insee_codcom) REFERENCES communes(insee_codcom)
);
select * from properties limit 10 ;



create table transactions (
    transaction_id INT PRIMARY KEY,
    date_mutation DATE NOT NULL,
    nature_mutation VARCHAR(50) NOT NULL,
    valeur_fonciere FLOAT,
    property_id INT NOT NULL,
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
);
select * from transactions limit 10 ;

-- 1. Total number of apartments sold in the first half of 2020.
-- 1. Nombre total d’appartements vendus au 1er semestre 2020.

select count(t.transaction_id)  as  No_total_appartements_vendus
from transactions t 
join properties p
on t.property_id = p.property_id
where p.type_local = 'Appartement' and t.nature_mutation = 'Vente'and
 t.date_mutation between '2020-01-01' and '2020-06-30';

-- 2. The number of apartment sales by region for the first half of 2020.
-- 2. Le nombre de ventes d’appartement par région pour le 1er semestre 2020.

SELECT 
    r.reg_nom AS region_name,
    COUNT(t.transaction_id) AS No_total_appartements_vendus
FROM
    transactions t
        JOIN
    properties p ON t.property_id = p.property_id
        JOIN
    communes c ON c.insee_codcom = p.insee_codcom
        JOIN
    region r ON r.reg_code = c.reg_code
WHERE
    p.type_local = 'Appartement'
        AND t.nature_mutation = 'Vente'
        AND t.date_mutation BETWEEN '2020-01-01' AND '2020-06-30'
GROUP BY r.reg_nom
ORDER BY No_total_appartements_vendus DESC;

-- -- 3. Proportion of apartment sales by number of rooms.
-- 3. Proportion des ventes d’appartements par le nombre de pièces.

 --  total sales per room / total sales per apartment 
select  
	p.no_pieces ,
    count(t.transaction_id) as total_sales_per_room ,
    count(t.transaction_id)* 1.0 /(
		select count(t1.transaction_id) 
        from transactions t1 
		join properties p1
		on t1.property_id = p1.property_id
		where p1.type_local = 'Appartement' and t1.nature_mutation = 'Vente') as  proportion_of_sales
from transactions t 
join properties p  on t.property_id = p.property_id
where p.type_local = 'Appartement' and t.nature_mutation = 'Vente'
 group by p.no_pieces 
 order by proportion_of_sales desc;


-- -- 4. List of the 10 departments where the price per square meter is the highest.

-- 4. Liste des 10 départements où le prix du mètre carré est le plus élevé.

-- price_per_m2 =  price / total_area_m2

select d.dep_nom , (t.valeur_fonciere/p.surface_m2) as prix_per_m2 , p.surface_m2 
from transactions t 
join properties p on t.property_id = p.property_id
join communes c on c.insee_codcom = p.insee_codcom
join region r on r.reg_code = c.reg_code
join departments d on d.reg_code = r.reg_code
where p.surface_m2> 0
order by prix_per_m2 desc limit 10 ; 



-- 5. Prix moyen du mètre carré d’une maison en Île-de-France.
-- -- 5. Average price per square meter of a house in Île-de-France.

select avg(t.valeur_fonciere/p.surface_m2) as avg_price_per_m2 ,
	   r.reg_nom as region_name 
from transactions t 
join properties p on t.property_id = p.property_id
join communes c on c.insee_codcom = p.insee_codcom
join region r on r.reg_code = c.reg_code
where r.reg_nom = 'Île-de-France' and p.type_local = 'Maison'  ;

-- 6. Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés.
-- -- 6. List of the 10 most expensive apartments with region and number of square meters.

select t.valeur_fonciere as prix , r.reg_nom Region, p.surface_m2 as 'Surface (m²)'
from transactions t 
join properties p on t.property_id = p.property_id
join communes c on c.insee_codcom = p.insee_codcom
join region r on r.reg_code = c.reg_code 
where p.type_local = 'Appartement' 
order by valeur_fonciere desc limit 10 ;

-- 7. Taux d’évolution du nombre de ventes entre le premier et le second trimestre de 2020.

-- 7. Rate of change in the number of sales between the first and second quarters of 2020.
-- (no. salesQ2 - no. sales Q1 / no. sales Q1) * 100 

select (
           (
               (select count(*) 
               from transactions 
               where nature_mutation = 'Vente' and
               date_mutation between '2020-04-01' and '2020-06-30')
			  - 
              (select count(*) 
              from transactions 
              where nature_mutation = 'Vente' and
              date_mutation between '2020-01-01' and '2020-03-31') 
		) 
        / 
        (select count(*)
        from transactions 
        where nature_mutation = 'Vente' and
        date_mutation between '2020-01-01' and '2020-03-31')
	) * 100  as  Taux_evolution 
 ;
-- using  Common Table Expressions (CTEs)
 with sales_q1 as (
    select count(*) as no_sales
    from transactions
    where nature_mutation = 'Vente' and date_mutation between '2020-01-01' and '2020-03-31'
),
sales_q2 as (
    select count(*) as no_sales
    from transactions
    where nature_mutation = 'Vente' and date_mutation between '2020-04-01' and '2020-06-30'
)
select 
    ((sales_q2.no_sales - sales_q1.no_sales) * 100.0 / sales_q1.no_sales) as Taux_evolution
from 
    sales_q1, sales_q2;
    
    
-- 8. The ranking of regions in relation to the price per square meter of apartments with more than 4 rooms.
-- 8. Le classement des régions par rapport au prix au mètre carré des appartement de plus de 4 pièces.


select  r.reg_nom ,
sum(t.valeur_fonciere)/sum(p.surface_m2) as prix_per_m2 ,
rank() over  (order by SUM(t.valeur_fonciere) / sum(p.surface_m2) desc) as region_rank
from transactions t 
join properties p on t.property_id = p.property_id
join communes c on c.insee_codcom = p.insee_codcom
join region r on r.reg_code = c.reg_code 
where p.no_pieces = 4 
group by r.reg_nom 
order by region_rank ;

-- since we are grouping by region name , that's why the rank will be for the regions and the price per m2 

-- 9. List of municipalities with at least 50 sales in the first quarter
-- 9. Liste des communes ayant eu au moins 50 ventes au 1er trimestre

select count(t.transaction_id) as total_no_sales_Q1 , c.commune 
from transactions t 
join properties p on p.property_id  = t.property_id
join communes c on c.insee_codcom = p.insee_codcom
where  t.date_mutation between '2020-01-01' and '2020-03-31'
group by c.commune  having count(t.transaction_id) >= 50 
order by total_no_sales_Q1 desc ;



-- -- 10. Percentage difference in price per square meter between a 2-room apartment and a 3-room apartment.
-- 10. Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces.
-- CTE  Common Table Expressions (CTEs)
-- Percentage Difference = ( (Price per m² for 3 rooms − Price per m² for 2 rooms)/ Price per m² for 2 rooms) * 100 


with prix_m2_pieces2 as (
select (avg(t.valeur_fonciere / p.surface_m2)) as prix_m2
from transactions t
join properties p on t.property_id = p.property_id
where p.no_pieces = 2 and t.nature_mutation = 'Vente' and p.type_local = 'Appartement' ), 

prix_m2_pieces3 as (select (avg(t.valeur_fonciere / p.surface_m2)) as prix_m2
from transactions t
join properties p on t.property_id = p.property_id
where p.no_pieces = 3 and t.nature_mutation = 'Vente' and p.type_local = 'Appartement')

select ((prix_m2_pieces3.prix_m2 - prix_m2_pieces2.prix_m2 )/prix_m2_pieces2.prix_m2*100)  as Percentage Difference
from prix_m2_pieces3 , prix_m2_pieces2 ; 




-- 11. Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59 et 69.
-- The average total sale prices of properties in the top 3 municipalities by number of sales,
-- for departments 6, 13, 33, 59, and 69.

with com_dep_sales as (
select c.coddep , c.commune, count(t.transaction_id) as no_sales , 
avg(t.valeur_fonciere) as avg_valeur_fonciere 
from transactions t 
join properties p    on t.property_id = p.property_id
join communes c      on c.insee_codcom = p.insee_codcom
where c.coddep in ('06', '13', '33', '59', '69')
group by c.coddep, c.commune ) ,

top3communes as (
select coddep, commune, no_sales, avg_valeur_fonciere ,
row_number() over (partition by coddep order by no_sales desc , avg_valeur_fonciere desc ) as rank_top_3
from com_dep_sales) 

select   coddep, commune, no_sales, avg_valeur_fonciere , rank_top_3
from top3communes 
where rank_top_3 <= 3
order by coddep, rank_top_3 ; 


-- 12. The 20 municipalities with the most transactions per 1000 inhabitants for municipalities
--  which exceed 10,000 inhabitants.

-- 12. Les 20 communes avec le plus de transactions pour 1000 habitants pour les communes 
-- qui dépassent les 10 000 habitants.

-- Transactions per 1000 inhabitants=(Number of sales (transactions)/ Total population)×1000

with transaction_per_commune as (
select c.commune , c.ptot as population , count(t.transaction_id) as no_transactions ,
(count(t.transaction_id)/c.ptot)*1000 as transactions_per_1000
from transactions t 
join properties p    on t.property_id = p.property_id
join communes c      on c.insee_codcom = p.insee_codcom
where c.ptot > 10000
group by c.commune , c.ptot )

select commune , population, no_transactions , transactions_per_1000
from transaction_per_commune 
order by transactions_per_1000 desc limit 20 ;





-- --------------------

