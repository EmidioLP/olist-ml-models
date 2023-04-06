
WITH tb_pedidos AS (

  SELECT 
      DISTINCT 
      t1.idPedido,
      t2.idVendedor

  FROM pedido AS t1

  LEFT JOIN item_pedido as t2
  ON t1.idPedido = t2.idPedido

  WHERE t1.dtPedido < '2018-01-01'
    AND dtPedido >= julianday('2018-01-01', '-6 months')
    AND idVendedor IS NOT NULL
),

tb_join AS (

  SELECT 
        t1.idVendedor,
        t2.*         

  FROM tb_pedidos AS t1

  LEFT JOIN pagamento_pedido AS t2
  ON t1.idPedido = t2.idPedido

),


tb_group AS (
    SELECT idVendedor, 
            descTipoPagamento,
            count(DISTINCT idPedido) as qtdePedidoMeioPagamento,
            sum(vlPagamento) as vlPedidoMeioPagamento

    FROM tb_join

    GROUP BY idVendedor, descTipoPagamento
    ORDER BY idVendedor, descTipoPagamento
),

tb_summary AS(

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

    GROUP BY idVendedor
),

tb_cartao AS(

  SELECT idVendedor,
        AVG(nrParcelas) AS avgQtdeParcelas,
        MAX(nrParcelas) AS maxQtdeParcelas,
        MIN(nrParcelas) AS minQtdeParcelas

  FROM tb_join

  WHERE descTipoPagamento = 'credit_card'

  GROUP BY idVendedor
)

SELECT 
       '2018-01-01' AS dtReference,
       t1.*,
       t2.avgQtdeParcelas,
       t2.maxQtdeParcelas,
       t2.minQtdeParcelas

FROM tb_summary as t1

LEFT JOIN tb_cartao as t2
ON t1.idVendedor = t2.idVendedor