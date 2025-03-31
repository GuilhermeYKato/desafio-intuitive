# desafio-intuitive

Este projeto envolve a coleta de dados via Web Scraping, armazenamento em banco de dados PostgreSQL e exposição de dados via API RESTful, com um front-end desenvolvido em Vue.js.

## 1. Instalação

O projeto foi desenvolvido no Windows 10. As versões utilizadas foram:
- **Python 3.12.6**
- **PostgreSQL 17.4**
- **Node 20.18**


### Passos para instalação:

1. **Criar um ambiente virtual para Python:**

   Recomendamos a criação de um ambiente virtual para gerenciar as dependências do projeto. Execute o seguinte comando para criar e ativar o ambiente virtual:

2. **Instalar dependências Python:**

Com o ambiente virtual ativo, instale as bibliotecas necessárias utilizando o arquivo `requirements.txt`.

```bash
pip install -r requirements.txt
```

## 2. Web Scraping

Para realizar o download e a coleta dos dados:

1. **Compilar os arquivos de scraping:**
Na raiz do projeto, compile os arquivos `web_scraping.py` e depois `data_scraping.py` para realizar o download dos PDFs solicitados e realizar o scraping dos dados.

- Execute o `web_scraping.py` para fazer o download dos arquivos PDF.
- Execute o `data_scraping.py` para processar os PDFs e extrair as informações necessárias.

## 3. Banco de Dados

O banco de dados utilizado é o **PostgreSQL** na versão 17.4. 

### Passos para criar o banco de dados:

1. **Alterar o path dos arquivos CSV:**

Antes de compilar o arquivo `sql_create_db.sql`, altere o caminho dos arquivos CSV que serão carregados para o banco de dados.

2. **Criar o banco de dados:**

Execute o script `sql_create_db.sql` para criar a estrutura do banco de dados e carregar os dados dos arquivos CSV.

3. **Consultas Analíticas:**

As consultas analíticas podem ser compiladas utilizando o script `analytic_query.sql`. O resultado dessas consultas será gravado em um arquivo `resultados_query.txt`.

## 4. API

### Front-End (Vue.js)

1. **Instalar dependências:**

Navegue até o diretório `frontend` e instale as dependências do Vue.js. 

```
npm install
```

2. **Compilar e rodar o front-end:**

Para compilar e rodar o front-end, execute o comando adequado no seu terminal ou prompt de comando para rodar o servidor Vue.js. 

```
npm run serve
```

O front-end estará acessível em: [http://localhost:8080/](http://localhost:8080/)

### Back-End (FastAPI Python)

1. **Instalar dependências:**
Ter instalado todas as dependências do arquivo `requirements.txt`

1. **Compilar e rodar o back-end:**

Para rodar o servidor da API, use o comando adequado no diretorio `backend` para iniciar o servidor. 

```
uvicorn app:server --reload
```

O back-end estará acessível em: [http://127.0.0.1:8000/search?q=Unimed](http://127.0.0.1:8000/search?q=Unimed)

### Testar a API

A API pode ser testada de duas formas:

1. **Usando o Front-End (Vue.js):**
Acesse [http://localhost:8080/](http://localhost:8080/) para interagir com a API via interface gráfica.

2. **Usando o Postman:**
Você pode importar a coleção de testes do Postman (`postman.json`) e utilizá-la para testar as diferentes rotas da API.

- Importe o arquivo `postman.json` no Postman para testar os endpoints da API.
