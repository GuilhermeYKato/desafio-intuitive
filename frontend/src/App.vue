<template>
  <div id="app">
    <h1>Operadoras de Saúde</h1>
    <img alt="Vue logo" src="./assets/logo.png">
    <SearchOperadora />
  </div>
</template>

<script>
import SearchOperadora from './components/SearchOperadora.vue';

export default {
  components: {
    SearchOperadora
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2d2e6b;
  margin-top: 60px;
}
</style>
