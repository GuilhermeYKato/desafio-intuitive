<template>
    <div>
        <h1>Buscar Operadora</h1>
        <input v-model="searchQuery" @keyup.enter="searchOperadora" placeholder="Buscar operadora..." />
        <div v-if="loading">Carregando...</div>
        <div v-if="error" class="error">
            <p>Ocorreu um erro ao buscar os dados. Tente novamente.</p>
        </div>
        <div v-if="operadoras.length > 0">
            <ul>
                <li v-for="operadora in operadoras.slice(0, 10)" :key="operadora.CNPJ">
                    <p><strong>Nome Fantasia:</strong> {{ operadora.Nome_Fantasia }}</p>
                    <p><strong>CNPJ:</strong> {{ operadora.CNPJ }}</p>
                    <p><strong>Cidade:</strong> {{ operadora.Cidade }}</p>
                    <p><strong>UF:</strong> {{ operadora.UF }}</p>
                    <hr />
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    data() {
        return {
            searchQuery: '',  // Termo de pesquisa
            operadoras: [],   // Lista de operadoras encontradas
            loading: false,   // Indicador de carregamento
            error: false,     // Indicador de erro
        };
    },
    methods: {
        // Função para buscar operadoras
        async searchOperadora() {
            if (!this.searchQuery.trim()) {
                this.operadoras = [];
                return;
            }

            this.loading = true;
            this.error = false;

            try {
                const query = encodeURIComponent(this.searchQuery);
                const response = await axios.get(`http://127.0.0.1:8000/search?q=${query}`, {
                    headers: {
                        'Content-Type': 'application/json',
                    },
                });

                // Verifica se a resposta contém dados");
                console.log('Resposta da API:', response.status, response.headers);
                this.operadoras = response.data;
                // console.log('Operadoras encontradas:', this.operadoras);
            } catch (error) {
                this.error = true;
                console.error('Erro ao buscar operadora:', error);
            } finally {
                this.loading = false;
            }
        },
    },
};
</script>

<style scoped>
.error {
    color: red;
    font-weight: bold;
}

ul {
    list-style-type: none;
    padding: 0;
}

li {
    margin-bottom: 10px;
}
</style>