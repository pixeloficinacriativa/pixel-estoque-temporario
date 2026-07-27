# Pixel Estoque

Aplicativo temporário, responsivo e instalável para controle de estoque da Pixel Oficina Criativa.

## Recursos

- Login seguro com Supabase Auth
- Dashboard mobile-first
- Produtos, fornecedores, entradas e saídas
- Alertas de estoque baixo e zerado
- Importação de XML da NF-e e alternativa por PDF com conferência
- Backup JSON e exportações CSV compatíveis com a versão anterior
- Banco online compartilhado entre os usuários autorizados

## Dados

Os registros ficam no Supabase e mantêm uma cópia local na chave `pixelEstoqueDB_v2`, preservando os dados da versão anterior no mesmo navegador e domínio.

## Configuração inicial do Supabase

1. Abra o SQL Editor do projeto no Supabase.
2. Execute todo o arquivo `supabase-setup.sql`.
3. Em **Authentication → Users**, crie o primeiro usuário com e-mail e senha.
4. Entre no aplicativo pelo navegador que contém os dados antigos. Se o banco online ainda estiver vazio, essa primeira entrada envia automaticamente os dados locais para o Supabase.

Somente usuários autenticados podem ler ou alterar o estoque. Não habilite cadastro público no aplicativo.

## Publicação

Projeto estático pronto para Vercel, sem comando de build.

## Preparação para integração

A área **Backup e exportação** inclui:

- pacote de integração JSON versionado;
- auditoria de integridade dos dados;
- backup completo no formato original;
- arquivos CSV individuais.

O contrato de integração está documentado em `docs/INTEGRATION.md`. O arquivo
`docs/future-relational-schema.sql` é somente uma proposta para o futuro sistema
e não deve ser executado no banco atual sem homologação.
