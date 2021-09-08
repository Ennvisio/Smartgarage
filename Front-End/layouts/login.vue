<template>
  <v-app id="main">
    <nuxt />
  </v-app>
</template>

<script>
export default {
  head: {
    title: "",
  },
  components: {},
  data() {
    return {};
  },
  computed: {},
  async asyncData({ params, axios }) {},
  mounted() {},
  methods: {},
};
</script>

<style>

#main {
  background-image: url("~@/assets/image/login_pic.jpg");
  background-size: cover;
  background-position: top center;
  height: 100vh;
}
</style>
