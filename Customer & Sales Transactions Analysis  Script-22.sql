select * from customer_info;
select * from sales_transactions;

---1) Find the total number of transactions per city.
select COUNT(transaction_id) as "Total Transactions" , city
from sales_transactions
join customer_info
on customer_info.customer_id = sales_transactions.customer_id
group by city 
order by "Total Transactions" desc;

---2) Retrieve the top 5 most purchased products based on total quantity sold.
select product_name, sum(quantity) as total_purchases
from sales_transactions
group by product_name 
order by total_purchases desc
limit 5;

---3) Find the average transaction amount per category.
select category, (avg(total_amount))::numeric(10,2) as average_transaction
from sales_transactions
group by category
order by average_transaction desc;


---4) Identify the payment method that has the highest total sales.
select payment_method, SUM(total_amount) as total_sales
from sales_transactions
group by payment_method 
order by total_sales desc;

---5) Find customers who have made at least 5 transactions.
select first_name,last_name,count(transaction_id) as total_transactions
from customer_info
join
sales_transactions
using (customer_id)
group by first_name,last_name
having count(transaction_id) >=5
order by total_transactions desc;

---6) Retrieve all customers who registered in the last 6 months but have not made any transactions.
select first_name,last_name,registration_date, count(transaction_id) as total_transactions
from customer_info
right join sales_transactions
using (customer_id)
where registration_date <= (current_date-interval '6')
group by first_name,last_name,registration_date
having count(transaction_id)<1;

---alternatively
select first_name,last_name,transaction_id
from sales_transactions 
left join customer_info 
on customer_info.customer_id = sales_transactions.customer_id
where registration_date >= current_date - make_interval(months => 6)
and transaction_id is null;

---7) Find the total revenue generated in each year from sales transactions.
select extract(year from transaction_date) as sales_year, sum(total_amount) as total_revenue
from sales_transactions
group by sales_year
order by sales_year desc;
---checking data_type
select column_name, data_type
from information_schema.columns
where table_name='sales_transactions'
and column_name='transaction_date';
---correcting output "year"
select (extract(year from transaction_date))::char(4) as sales_year, sum(total_amount) as total_revenue
from sales_transactions
group by sales_year
order by sales_year desc;

---8) List the number of unique products sold in each category.
select category,count(distinct product_name) as unique_products
from sales_transactions
group by category
order by unique_products desc;

---9) Find all customers who have made purchases across at least 3 different product categories.
select first_name,last_name,count(category) as product_category
from customer_info
join sales_transactions
using (customer_id)
group by first_name,last_name
having count(category)>=3
order by product_category desc;

---10) Identify the most popular purchase day of the week based on transaction count.
---postgresql(0=Sunday,6=Saturday)
select extract(DOW from transaction_date) as day_of_week,count(transaction_id) as transaction_count
from sales_transactions
group by day_of_week
order by transaction_count desc
limit 1;

---11)Find the top 3 customers who have spent the most in the last 12 months.
select first_name,last_name,sum(total_amount),transaction_date
from sales_transactions
join customer_info
using (customer_id)
group by first_name,last_name,transaction_date
having transaction_date>= (current_date - interval '12 month')
order by sum(total_amount) desc
limit 3; 

---12) Determine the percentage of total revenue contributed by each product category.
select category, ((sum(total_amount)/(select sum(total_amount)from sales_transactions))*100)::numeric(10,2) as percent_total_revenue
from sales_transactions 
group by category
order by percent_total_revenue desc;


---13) Find the month-over-month sales growth for the last 12 months.
select extract(month from transaction_date) as month_,sum(total_amount) as monthly_sales
Lag(monthly_sales) OVER(order by extract(month from transaction_date) desc) as sales_growth
from employees
where transaction_date>= (current_date-interval '12months')
group by month_
order by month_;


---14) Identify customers who have increased their spending by at least 30% compared to the previous year.
select first_name,last_name,(sum(total_amount)/(select sum(total_amount) from sales_transactions))*100 as percent_spending
lag()
from sales_transactions
where percent_spending 

---15) Find the first purchase date for each customer.
select first_name,last_name, min(transaction_date) as first_purchase_date
from customer_info 
join sales_transactions
using (customer_id)
group by first_name,last_name
order by first_purchase_date;

---16) customers that have not made a transaction
select first_name, last_name,count(transaction_id) as total_transactions
from customer_info
left join sales_transactions
using(customer_id)
group by first_name, last_name
having count(transaction_id)<1;




