select * from public.capstone

/* 1. Within the space of the last three years, what was the profit worth of the breweries,
inclusive of the anglophone and the francophone territories? */
select sum(profit) from public.capstone;
	--answer = 105,587,420

/*2. Compare the total profit between these two territories in order for the territory manager,
Mr. Stone made a strategic decision that will aid profit maximization in 2020.*/
select sum(profit) from public.capstone
	where countries in ('Nigeria', 'Ghana');
	--answer = 42,389,260 (Anglophone)
	
select sum(profit) from public.capstone
	where countries not in ('Nigeria', 'Ghana');
	--answer = 63,198,160 (Francophone)

/*3. Country that generated the highest profit in 2019*/
select countries, years, sum(profit) as total_sum from public.capstone
	where years= 2019
	group by countries, years
	order by total_sum desc
	limit 1;
	--answer = Ghana
	
/*4. Help him find the year with the highest profit.*/
select years, sum(profit) as total_profit from public.capstone
	group by years
	order by total_profit desc
	limit 1;
	--answer = 2017
	
/*5. Which month in the three years was the least profit generated?*/
select months, years, sum(profit) as least_profit from public.capstone
group by months, years
	order by least_profit asc
	limit 1;
	--answer = February 2019 1,366,880(the month with the least profit in a single year)
select months, sum(profit) as least_profit from public.capstone
group by months
	order by least_profit asc
	limit 1;
	--answer = April 8,573,830(the month with the least profit in the 3 years combined)
select months, years, profit from public.capstone
	order by profit
	limit 1;
	--answer = December 2017 35000(the month with the least profit in a single country in
	--a single year)
	
/*6. What was the minimum profit in the month of December 2018?*/
select months, years, profit from public.capstone
	where months = 'December'and years = 2018
	order by profit
	limit 1;
	--answer = 38150
	
/*7. Compare the profit in percentage for each of the month in 2019*/
select months, sum(profit),
	round(sum(cast(profit as decimal))/ (select sum(cast(profit as decimal))
	from public.capstone where years =2019) * 100, 2) as percentage
		
	from public.capstone
	where years = 2019
	group by months;

/*8. Which particular brand generated the highest profit in Senegal?*/
select brands, countries, sum(profit) as total_profit
	from public.capstone
	where countries = 'Senegal'
	group by brands, countries
	order by total_profit desc
	limit 1
	--answer = Castle Lite

/*1. Within the last two years, the brand manager wants to know the top three brands
consumed in the francophone countries*/
select brands,  sum(quantity) as total_quantity
	from public.capstone
	where countries in ('Togo', 'Benin', 'Senegal')
	and years in (2018,2019)
	group by brands
	order by total_quantity desc
	limit 3
--answer = Trophy, Hero, Eagle Lager

/*2. Find out the top two choice of consumer brands in Ghana*/
select brands, sum(quantity) total_quantity
	from public.capstone
	where countries = 'Ghana'
	group by brands
	order by total_quantity desc
	limit 2;
-- answer = Eagle Lager and Castle Lite

/*3. Find out the details of beers consumed in the past three years in the most oil reached
country in West Africa.*/
select brands, 
	sum(quantity) as total_quantity, 
	sum(cost) as total_cost, 
	sum(profit) as total_profit 
	from public.capstone
	where countries = 'Nigeria'
	and brands not like '%malt'
	group by brands;
	
/*4. Favorites malt brand in Anglophone region between 2018 and 2019*/
select brands, sum(quantity) as total_quantity
	from public.capstone
	where brands in ('beta malt', 'grand malt')
	and years in (2018, 2019)
	and countries not in ('Senegal', 'Togo', 'Benin')
	group by brands
	order by total_quantity desc
	limit 1;
--answer = Grand Malt

/*5. Which brands sold the highest in 2019 in Nigeria?*/
select brands, sum(quantity) as total_quantity, countries
	from public.capstone
	where countries = 'Nigeria'
	and years = 2019
	group by brands, countries
	order by total_quantity desc
	limit 1;
--answer = Hero

/*6. Favorites brand in South_South region in Nigeria*/
select brands, region, countries, sum(quantity) as total_quantity
	from public.capstone
	where countries = 'Nigeria'
	and region = 'southsouth'
	group by brands, region, countries
	order by total_quantity desc
	limit 1;
--answer = Eagle Lager

/*7. Beer consumption in Nigeria*/
select brands, sum(quantity) as total_quantity
	from public.capstone
	where countries = 'Nigeria'
	and brands in ('eagle lager', 'trophy', 'hero', 'budweiser', 'castle lite')
	group by brands
	order by total_quantity;
	
/*8. Level of consumption of Budweiser in the regions in Nigeria*/
	select brands, sum(quantity) as total_quantity, region
		from public.capstone
		where countries = 'Nigeria'
		and brands = 'budweiser'
		group by brands, region;
	
/*9. Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)*/
select brands, sum(quantity) as total_quantity, region
	from public.capstone
	where countries = 'Nigeria'
	and brands = 'budweiser'
	and years = 2019
	group by brands, region;
	
/*1. Country with the highest consumption of beer.*/
	select countries, sum(quantity) as total_quantity
		from public.capstone
		where brands in ('eagle lager', 'trophy', 'hero', 'budweiser', 'castle lite')
		group by countries
		order by total_quantity desc
	limit 1;
--answer = Senegal

/*2. Highest sales personnel of Budweiser in Senegal*/
select sales_rep, sum(quantity) as total_quantity
	from public.capstone
	where countries = 'Senegal'
	and brands = 'budweiser'
	group by sales_rep
	order by total_quantity desc
	limit 1;
--answer = Jones

/*3. Country with the highest profit of the fourth quarter in 2019*/
select countries, sum(profit) as total_profit
	from public.capstone
	where years = 2019
	and months in ('November', 'October', 'December')
	group by countries
	order by total_profit desc
	limit 1;
--answer = Ghana


	

	