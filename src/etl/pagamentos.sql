
WITH tb_join AS (
    SELECT t2.*, t3.idVendedor

    FROM pedido AS t1

    LEFT JOIN pagamento_pedido AS t2
    ON t1.idPedido = t2.idPedido

    LEFT JOIN item_pedido AS t3
    ON t1.idPedido = t3.idPedido

    WHERE dtPedido < '2018-01-01'
    AND dtPedido >= julianday('2018-01-01', '-6 months')
    AND t3.idVendedor IS NOT NULL
    AND t2.descTipoPagamento IS NOT NULL
),

tb_group AS (
    SELECT idVendedor, 
            descTipoPagamento,
            count(DISTINCT idPedido) as qtdePedidoMeioPagamento,
            sum(vlPagamento) as vlPedidoMeioPagamento

    FROM tb_join

    GROUP BY idVendedor, descTipoPagamento
    ORDER BY idVendedor, descTipoPagamento
)

SELECT idVendedor,

sum(CASE WHEN descTipoPagamento = 'boleto' then qtdePedidoMeioPagamento else 0 END) as qtde_boleto_pedido,
sum(CASE WHEN descTipoPagamento = 'credit_card' then qtdePedidoMeioPagamento else 0 END) as qtde_credit_card_pedido,
sum(CASE WHEN descTipoPagamento = 'voucher' then qtdePedidoMeioPagamento else 0 END) as qtde_voucher_pedido,
sum(CASE WHEN descTipoPagamento = 'debit_card' then qtdePedidoMeioPagamento else 0 END) as qtde_debit_card_pedido,

sum(CASE WHEN descTipoPagamento = 'boleto' then vlPedidoMeioPagamento else 0 END) as valor_boleto_pedido,
sum(CASE WHEN descTipoPagamento = 'credit_card' then vlPedidoMeioPagamento else 0 END) as valor_credit_card_pedido,
sum(CASE WHEN descTipoPagamento = 'voucher' then vlPedidoMeioPagamento else 0 END) as valor_voucher_pedido,
sum(CASE WHEN descTipoPagamento = 'debit_card' then vlPedidoMeioPagamento else 0 END) as valor_debit_card_pedido,

sum(CASE WHEN descTipoPagamento = 'boleto' then qtdePedidoMeioPagamento else 0 END) / sum(qtdePedidoMeioPagamento) as pct_boleto_pedido,
sum(CASE WHEN descTipoPagamento = 'credit_card' then qtdePedidoMeioPagamento else 0 END) / sum(qtdePedidoMeioPagamento) as pct_credit_card_pedido,
sum(CASE WHEN descTipoPagamento = 'voucher' then qtdePedidoMeioPagamento else 0 END) / sum(qtdePedidoMeioPagamento) as pct_voucher_pedido,
sum(CASE WHEN descTipoPagamento = 'debit_card' then qtdePedidoMeioPagamento else 0 END) / sum(qtdePedidoMeioPagamento) as pct_debit_card_pedido,

sum(CASE WHEN descTipoPagamento = 'boleto' then vlPedidoMeioPagamento else 0 END) / sum(vlPedidoMeioPagamento) as pct_valor_boleto_pedido,
sum(CASE WHEN descTipoPagamento = 'credit_card' then vlPedidoMeioPagamento else 0 END) / sum(vlPedidoMeioPagamento) as pct_valor_credit_card_pedido,
sum(CASE WHEN descTipoPagamento = 'voucher' then vlPedidoMeioPagamento else 0 END) / sum(vlPedidoMeioPagamento) as pct_valor_voucher_pedido,
sum(CASE WHEN descTipoPagamento = 'debit_card' then vlPedidoMeioPagamento else 0 END) / sum(vlPedidoMeioPagamento) as pct_valor_debit_card_pedido

FROM tb_group

GROUP BY 1

