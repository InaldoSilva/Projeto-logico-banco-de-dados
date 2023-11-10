use ecommerce;
-- SELECT Statement.
SELECT `product`.`ProductID`,
    `product`.`Category`,
    `product`.`product_description`,
    `product`.`Classification_age`,
    `product`.`Ratting`,
    `product`.`Package_size`,
    `product`.`Valor`
FROM `ecommerce`.`product`;

-- WHERE statement.
-- Selecionar todos os clientes com idade superior a 25 anos.
SELECT * FROM customer
WHERE TIMESTAMPDIFF(YEAR, BirthDate, CURDATE()) > 25;

-- Selecionar todos os produtos da categoria 'Eletronics'.
SELECT * FROM product
WHERE Category = 'Eletronics';

-- Selecionar todos os pagamentos do tipo 'Credit Card' realizados por clientes com idade superior a 30 anos.
SELECT payments.*, customer.*
FROM payments
JOIN customer ON payments.CustomerID = customer.CustomerID
WHERE payments.type_payment = 'Credit Card'
    AND TIMESTAMPDIFF(YEAR, customer.BirthDate, CURDATE()) > 30;

-- Selecionar todos os produtos que estão fora de estoque.
SELECT * FROM productOrder
WHERE poStatus = 'Out of Stock';

-- Gerando atributos derivados.
-- Calcular a idade dos clientes:
SELECT *,
       TIMESTAMPDIFF(YEAR, BirthDate, CURDATE()) AS Age
FROM customer;

-- Calcular o preço total de um pedido.
SELECT orders.*,
       SUM(productOrder.prodQuantity * product.Valor) AS TotalPrice
FROM orders
JOIN productOrder ON orders.OrderID = productOrder.POorderID
JOIN product ON productOrder.orderProductID = product.ProductID
GROUP BY orders.OrderID;

-- Calcular o número de produtos em estoque por local.
SELECT stockLocation.stockLocal,
       COUNT(stockLocation.ProductID) AS NumProductsInStock
FROM stockLocation
GROUP BY stockLocation.stockLocal;

-- Ordenações dos dados com ORDER BY.
-- Ordenar clientes por idade em ordem decrescente.
SELECT *
FROM customer
ORDER BY TIMESTAMPDIFF(YEAR, BirthDate, CURDATE()) DESC;

-- Ordenar produtos por categoria e classificação de idade em ordem crescente.
SELECT *
FROM product
ORDER BY Category, Classification_age ASC;

-- Ordenar pedidos por status e preço em ordem decrescente.
SELECT *
FROM orders
ORDER BY Order_Status, CAST(Price AS DECIMAL(10, 2)) DESC;

-- Ordenar pagamentos por tipo de pagamento em ordem alfabética e, em seguida, por CustomerID em ordem crescente.
SELECT *
FROM payments
ORDER BY type_payment, CustomerID ASC;


-- Condções de filtros aos grupos - HAVING statement.
-- Selecionar categorias de produtos com mais de 5 produtos em estoque.
SELECT Category, COUNT(ProductID) AS NumProductsInStock
FROM product
JOIN stockLocation ON product.ProductID = stockLocation.ProductID
GROUP BY Category
HAVING NumProductsInStock > 5;

-- Selecionar locais de estoque com mais de 100 unidades no total.
SELECT stockLocal, SUM(Quantity) AS TotalQuantity
FROM stock
GROUP BY stockLocal
HAVING TotalQuantity > 100;

-- Selecionar clientes com mais de 3 pedidos confirmados.
SELECT CustomerID, COUNT(OrderID) AS NumConfirmedOrders
FROM orders
WHERE Order_Status = 'Confirmed'
GROUP BY CustomerID
HAVING NumConfirmedOrders > 3;


-- Junções entre tabelas fornecendo perspectiva mais complexa dos dados.
-- Selecionar informações completas sobre produtos em pedidos confirmados.
SELECT orders.OrderID, orders.Order_Status, productOrder.prodQuantity, product.product_description
FROM orders
JOIN productOrder ON orders.OrderID = productOrder.POorderID
JOIN product ON productOrder.orderProductID = product.ProductID
WHERE orders.Order_Status = 'Confirmed';

-- Mostrar detalhes de pagamento para pedidos processados, incluindo informações do cliente.
SELECT orders.OrderID, orders.Order_Status, payments.type_payment, customer.FName, customer.LName
FROM orders
JOIN payments ON orders.OrderID = payments.OrderID
JOIN customer ON orders.CustomerID = customer.CustomerID
WHERE orders.Order_Status = 'Processing';

-- Listar produtos e suas quantidades em estoque por local.
SELECT stockLocation.stockLocal, product.product_description, stock.Quantity
FROM stockLocation
JOIN stock ON stockLocation.ProductID = stock.ProductID
JOIN product ON stock.ProductID = product.ProductID;

-- Mostrar todos os pedidos com detalhes de pagamento e informações do cliente.
SELECT orders.OrderID, orders.Order_Status, payments.type_payment, customer.FName, customer.LName
FROM orders
LEFT JOIN payments ON orders.OrderID = payments.OrderID
JOIN customer ON orders.CustomerID = customer.CustomerID;
