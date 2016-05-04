.headers on
select categorie,count(categorie) from
(select 
	case 
	when churn = 0 then '00000' 
	when churn = 1 then '00001' 
	when churn = 2 then '00002' 
	when churn = 3 then '00003' 
	when churn = 4 then '00004' 
	when churn = 5 then '00005' 
	when churn = 6 then '00006' 
	when churn = 7 then '00007' 
	when churn = 8 then '00008' 
	when churn = 9 then '00009'
	when churn >= 10 and churn < 20 then '00010-20' 
	when churn >= 20 and churn < 30 then '00020-30' 
	when churn >= 30 and churn < 40 then '00030-40' 
	when churn >= 40 and churn < 50 then '00040-50' 
	when churn >= 50 and churn < 60 then '00050-60' 
	when churn >= 60 and churn < 70 then '00060-70' 
	when churn >= 70 and churn < 80 then '00070-80' 
	when churn >= 80 and churn < 90 then '00080-90' 
	when churn >= 90 and churn < 100 then '00090-100' 
	when churn >= 100 and churn < 200 then '00100-200' 
	when churn >= 200 and churn < 300 then '00200-300'
	when churn >= 300 and churn < 400 then '00300-400'
	when churn >= 400 and churn < 500 then '00400-500'
	when churn >= 500 and churn < 600 then '00500-600'
	when churn >= 600 and churn < 700 then '00600-700'
	when churn >= 700 and churn < 800 then '00700-800'
	when churn >= 800 and churn < 900 then '00800-900'
	when churn >= 900 and churn < 1000 then '00900-1000'
	when churn >= 1000 and churn < 2000 then '01000-2000'
	when churn >= 2000 and churn < 3000 then '02000-3000'
	when churn >= 3000 and churn < 4000 then '03000-4000'
	when churn >= 4000 and churn < 5000 then '04000-5000'
	when churn >= 5000 and churn < 6000 then '05000-6000'
	when churn >= 6000 and churn < 7000 then '06000-7000'
	when churn >= 7000 and churn < 8000 then '07000-8000'
	when churn >= 8000 and churn < 9000 then '08000-9000'
	when churn >= 9000 and churn < 10000 then '09000-10000'
	when churn >= 10000 then '10000+' 
	else ''
	end categorie
from filechurn)
group by categorie
order by categorie;

