# Camera Manager - Sistema de Gerenciamento de Câmeras

O **Camera Manager** é um sistema desenvolvido para gerenciar usuários e suas câmeras de segurança. O sistema permite que os usuários sejam cadastrados e associados a várias câmeras, além de fornecer funcionalidades para filtrar e notificar usuários com câmeras específicas.

## Funcionalidades

- **Gerenciamento de Usuários e suas respectivas Câmeras:**
  - Criar registros de usuários.
  - Criar registros de câmeras associadas aos seus usuários.
  - Busca usuários ativos e lista suas camêras.
  - Para o caso de usuários inativos, retorna a data em que foi inativado.
  - Filtra câmeras por sua marca
  - Notifica usuários que possuem câmeras da marca Hikvision.

- **Infraestrutura:**
  - PostgreSQL como banco de dados.

## Requisitos

- Elixir 1.14
- PostgreSQL
- Curl para teste dos endpoints

## Como Executar o Projeto

### 1. Configuração do Banco de Dados

Para configurar o banco de dados, caso queira editar, as credenciais do banco de dados PostgreSQL encontra-se no arquivo `config/dev.exs`.

### 2. Para criar o banco de dados, rodar as migrações e popular o banco

Execute o comando:

```bash
mix ecto.setup
```

### 3. Caso queira executar passo a passo:

Crie o banco de dados:

```bash
mix ecto.create
```

Execute as migrações do banco de dados:

```bash
mix ecto.migrate
```

Popular o banco de dados:

```bash
mix run priv/repo/seeds.exs
```

Isso irá criar 1.000 usuários e associar a cada um até 50 câmeras com marcas aleatórias.

Para rodar o servidor Phoenix, execute:

```bash
mix phx.server
```

O servidor estará disponível em `http://localhost:4000`.

## Endpoints da API

### Testes utilizando `curl`

### 1. `GET /api/cameras`

Retorna uma lista de usuários e suas câmeras associadas.

```bash
curl -X GET "http://localhost:4000/api/cameras"
```

Você pode filtrar a lista passando um parâmetro de `brand`, marca da câmera:

```bash
curl -X GET "http://localhost:4000/api/cameras?brand=Hikvision"
```

### 2. `POST /api/notify-users`

Envia um e-mail para os usuários com câmeras da marca **Hikvision**.

```bash
curl -X POST http://localhost:4000/api/notify-users \
      -H "Content-Type: application/json" \
      -d '{}'
```
