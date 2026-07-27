-- MODELO FUTURO PARA INTEGRAÇÃO.
-- NÃO EXECUTAR NO BANCO DE PRODUÇÃO ATUAL.
-- Este arquivo é uma proposta a ser comparada com o sistema principal.

create table categories (
  id uuid primary key,
  name text not null,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create unique index categories_name_unique on categories (lower(name));

create table brands (
  id uuid primary key,
  name text not null,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create unique index brands_name_unique on brands (lower(name));

create table suppliers (
  id uuid primary key,
  name text not null,
  contact text,
  notes text,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create unique index suppliers_name_unique on suppliers (lower(name));

create table products (
  id uuid primary key,
  sku text not null unique,
  name text not null,
  category_id uuid references categories(id),
  brand_id uuid references brands(id),
  supplier_id uuid references suppliers(id),
  supplier_product_code text,
  unit text not null,
  size text,
  capacity text,
  min_stock numeric(14,3) not null default 0,
  cost numeric(14,2) not null default 0,
  sale_price numeric(14,2) not null default 0,
  location text,
  barcode text,
  status text not null default 'ativo',
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create table product_variants (
  id uuid primary key,
  product_id uuid not null references products(id),
  sku text not null unique,
  model text,
  color text,
  size text,
  capacity text,
  brand_name text,
  min_stock numeric(14,3),
  cost numeric(14,2),
  sale_price numeric(14,2),
  barcode text,
  status text not null default 'ativo',
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create index product_variants_product_idx on product_variants(product_id);

create table stock_movements (
  id uuid primary key,
  occurred_at timestamptz not null,
  product_id uuid not null references products(id),
  product_variant_id uuid references product_variants(id),
  type text not null check (type in ('entrada', 'saida', 'ajuste')),
  direction text,
  quantity numeric(14,3) not null check (quantity > 0),
  unit_value numeric(14,2) not null default 0,
  discount_percent numeric(7,3) not null default 0,
  net_unit_value numeric(14,2) not null default 0,
  total_value numeric(14,2) not null default 0,
  cost_at_movement numeric(14,2) not null default 0,
  origin_destination text,
  document_ref text,
  responsible text,
  reason text,
  notes text,
  created_at timestamptz not null default now()
);

create index stock_movements_product_idx on stock_movements(product_id);
create index stock_movements_variant_idx on stock_movements(product_variant_id);
create index stock_movements_occurred_at_idx on stock_movements(occurred_at);

create view stock_balances as
select
  product_id,
  product_variant_id,
  sum(
    case
      when type = 'entrada' then quantity
      when type = 'saida' then -quantity
      when direction = 'entrada' then quantity
      else -quantity
    end
  ) as quantity
from stock_movements
group by product_id, product_variant_id;

