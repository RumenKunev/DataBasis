select 
	p.name as product_name,
    count(oi.orderId) as num_orders,
    ifnull(sum(oi.quantity), 0) as quantity,
    p.price,
    ifnull((sum(oi.quantity) * p.price), 0) as total_price
from products p
left join order_items oi on p.productId = oi.productId
group by p.productId
order by p.name