from fastapi import FastAPI, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import pandas as pd

# Create FastAPI server
server = FastAPI()

# Enable CORS for Vue.js frontend
server.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load CSV file into a DataFrame
df = pd.read_csv("../db_files/Relatorio_cadop.csv", encoding="utf-8", sep=";")
df_clean = df.fillna("").astype(str)


# Search route
@server.get("/search")
async def search_operator(
    q: str = Query(..., min_length=1, description="Operadora name")
):
    # Convert to lowercase and search in the DataFrame
    query = q.strip().lower()
    results = df_clean[
        df_clean["Razao_Social"].str.lower().str.contains(query, na=False)
    ]

    if results.empty:
        raise HTTPException(status_code=404, detail="Operadora not found!")

    return results.head(10).to_dict(orient="records")


# POST
class RegistroANSRequest(BaseModel):
    registro_ans: list[str]


# POST route to search for operators by Registro_ANS
@server.post("/search_by_registro_ans")
async def search_operator_by_registro_ans(request: RegistroANSRequest):
    # Pegando os valores da lista de Registro_ANS
    registros_ans = request.registro_ans
    results = df_clean[df_clean["Registro_ANS"].isin(registros_ans)]

    if results.empty:
        raise HTTPException(
            status_code=404,
            detail="Operadora(s) não encontrada(s) para o(s) Registro(s) ANS fornecido(s)!",
        )

    return results.to_dict(orient="records")


# GET route to search for operators by city
@server.get("/search_by_city")
async def search_city(
    city: str = Query(..., min_length=1, description="Nome da cidade")
):

    # Convert to lowercase and search in the DataFrame
    city_query = city.strip().lower()
    results_city = df_clean[
        df_clean["Cidade"].str.lower().str.contains(city_query, na=False)
    ]

    if results_city.empty:
        raise HTTPException(
            status_code=404,
            detail="Operadora(s) não encontrada(s) para a cidade fornecida!",
        )

    return results_city.head(10).to_dict(orient="records")


# Default route
@server.get("/")
async def home():
    return {"message": "FastAPI is working!"}


# Run the server only if executed directly
if __name__ == "__main__":
    import uvicorn

    uvicorn.run(server, host="0.0.0.0", port=8000, reload=True, log_level="debug")
