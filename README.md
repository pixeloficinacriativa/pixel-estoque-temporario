# Pixel Estoque

Aplicativo temporário, responsivo e instalável para controle de estoque da Pixel Oficina Criativa.

## Recursos

- Login local para acesso casual (não substitui autenticação de servidor)
- Dashboard mobile-first
- Produtos, fornecedores, entradas e saídas
- Alertas de estoque baixo e zerado
- Importação inicial de DANFE/NF-e em PDF com conferência
- Backup JSON e exportações CSV compatíveis com a versão anterior

## Dados

Os registros continuam na chave `pixelEstoqueDB_v2` do `localStorage`, preservando os dados da versão anterior no mesmo navegador e domínio. Faça backups JSON frequentes.

## Publicação

Projeto estático pronto para Vercel, sem comando de build.
