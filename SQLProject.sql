SQL PROJECT

QUERY-01
select dim_products.product_name, fact_events.base_price,fact_events.promo_type
from dim_products
join fact_events
on dim_products.product_code=fact_events.product_code
where base_price='500' or promo_type='BOGOF'
order by base_price;

QUERY-02
select count(store_id), city
from dim_stores
group by city
order by count(store_id) desc;

QUERY-03
select dim_campaigns.campaign_name,
fact_eventscopy.base_price * fact_eventscopy.Quantity_soldnew as new,
fact_eventscopy.base_price * fact_eventscopy.Quantity_soldold as old
from dim_campaigns
join fact_eventscopy
on dim_campaigns.campaign_id=fact_eventscopy.campaign_id

QUERY-04
with cte1 as 
(select dim_products.category, 
fact_eventscopy.Quantity_soldnew,
fact_eventscopy.Quantity_soldold 
from dim_products
join fact_eventscopy
on dim_products.product_code = fact_eventscopy.product_code)
             
select category,  
round(Quantity_soldnew/ Quantity_soldold,2) as isu_perc,
dense_rank() over(partition by category order by 
round(Quantity_soldnew/ Quantity_soldold,2) ) as RANK1
from cte1;

QUERY-05
with cte as 
		(select dim_campaigns.campaign_name,
         dim_products.category,
         dim_products.product_name,
         fact_eventscopy.Quantity_soldnew*fact_eventscopy.base_price as Rev_new,
         fact_eventscopy.Quantity_soldold*fact_eventscopy.base_price as Rev_old
         from dim_campaigns
         join fact_eventscopy
         on dim_campaigns.campaign_id =fact_eventscopy.campaign_id
         and dim_products.product_code=fact_eventscopy.product_code)
         
select campaign_name,product_name, category,
(Rev_new/Rev_old)*100 as is_perc,
dense_rank() over (partition by campaign_name order by (Rev_new/Rev_old)*100)
from cte ;

