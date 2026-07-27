# Integração do Pixel Estoque

## Objetivo

Este documento registra como incorporar o módulo de estoque ao futuro sistema da
Pixel Oficina Criativa sem perder produtos, variações, movimentações ou saldos.

## Estado atual

- Interface: aplicação web estática/PWA publicada na Vercel.
- Autenticação: Supabase Auth.
- Persistência principal: registro `pixel-main` da tabela pública `app_state`.
- Persistência auxiliar: `localStorage`, chave `pixelEstoqueDB_v2`.
- Projeto Supabase: `hkuiwqbnbbhvmrlnykah`.
- Repositório: `pixeloficinacriativa/pixel-estoque-temporario`.

O campo `app_state.data` contém um documento JSON com produtos, variações,
categorias, marcas, fornecedores, movimentações e importações de NF-e.

## Regra de preservação

Até a integração ser homologada:

1. Não excluir o projeto Supabase atual.
2. Não excluir a tabela `app_state`.
3. Não desativar a implantação da Vercel.
4. Não alterar IDs existentes.
5. Gerar um backup completo antes de qualquer migração.
6. Testar a migração em ambiente separado antes de trocar a aplicação em uso.

## Pacote de integração

O aplicativo gera `pixel_estoque_integracao_AAAA-MM-DD.json` na área
**Backup e exportação**.

Formato:

```text
pixel-stock-integration / versão 1
├── source
├── counts
└── entities
    ├── categories
    ├── brands
    ├── suppliers
    ├── products
    ├── variants
    ├── movements
    ├── stockBalances
    └── imports
```

`stockBalances` é uma fotografia para conferência. O saldo oficial deve ser
recalculado a partir de `movements`.

Os usuários do Supabase Auth não são incluídos no pacote porque o navegador não
possui autorização administrativa para exportá-los.

## IDs e relacionamentos

- `products.id` é permanente.
- `variants.id` é permanente e aponta para `variants.productId`.
- `movements.productId` aponta para o produto.
- `movements.variantId` é nulo para produtos simples e aponta para uma variação
  quando o estoque é controlado por combinação.
- SKU é um identificador operacional e pode mudar; integrações devem usar UUID.

## Estratégia recomendada

### Etapa 1 — módulo no sistema principal

1. Clonar este repositório na máquina do sistema principal.
2. Manter o Supabase atual.
3. Incorporar as telas em uma rota `/estoque`.
4. Publicar uma versão de teste no Cloudflare Workers.
5. Manter a Vercel como retorno seguro.

### Etapa 2 — banco relacional

1. Criar as tabelas descritas em `future-relational-schema.sql` em um ambiente
   de teste.
2. Importar o pacote de integração.
3. Recalcular os saldos pelo histórico.
4. Comparar o resultado com `stockBalances`.
5. Testar entradas, saídas, descontos, custos e variações.
6. Trocar a origem de dados somente após a conferência.

### Etapa 3 — integração com vendas

Cada item de venda deve guardar `product_id` e, quando aplicável,
`product_variant_id`. A confirmação da venda deve criar uma saída de estoque na
mesma transação que confirma o item vendido.

## Segurança

- A chave pública/publishable do Supabase pode ser usada no navegador com RLS.
- Nunca publicar a chave `service_role`.
- Segredos do Cloudflare devem ficar em Secrets/Environment Variables.
- Alterações de esquema devem ser versionadas.

