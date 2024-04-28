-- Using PostgreSQL

-- 6.Скільки клієнтів в середньому заклад має кожен день?
-- примітка1: 1 клієнт = 1 замовлення

SELECT ROUND(CAST(COUNT(order_id) AS DECIMAL)/COUNT(DISTINCT date), 2) AS average_order_by_day
FROM orders;

-- результат: 59.64


-- 7.Яка була середня кількість піц в замовленні восени?

SELECT ROUND(SUM(cnt_p)/COUNT(DISTINCT o.order_id), 2) AS avg_pizza_in_order
FROM orders o
LEFT JOIN (SELECT order_id,
                  SUM(quantity) AS cnt_p
           FROM order_details
           GROUP BY 1) od ON od.order_id = o.order_id
WHERE EXTRACT('MONTH' FROM o.date) IN (9, 10, 11);

-- результат: 2.36


-- 8.Скільки грошей заклад заробив в червні з трьох найпопулярніших піц?
-- примітка 1: найпопулярніша за сумарною кількістю замовлених піц, а не замовлень
-- примітка 2: з трьох найпопулярніших піц за увесь час

SELECT SUM(p.price*od.quantity) AS revenue
FROM order_details od
LEFT JOIN pizzas p ON od.pizza_id = p.pizza_id
INNER JOIN (SELECT order_id
            FROM orders
            WHERE EXTRACT('MONTH' FROM date) = 6) o ON o.order_id = od.order_id
WHERE od.pizza_id IN (SELECT pizza_id FROM order_details GROUP BY 1 ORDER BY SUM(quantity) DESC LIMIT 3);

-- результат: 6410.5


-- 9.Порахуйте кількість замовлених піц кожного розміру для кожної категорії піц.

SELECT pt.category,
       p.size,
       SUM(quantity) AS count
FROM order_details od
INNER JOIN pizzas p ON p.pizza_id = od.pizza_id
INNER JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY 1, 2;

