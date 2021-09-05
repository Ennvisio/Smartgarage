<template>
  <v-container>
    <purchase-report/>
  </v-container>
</template>

<script>

import purchaseReport from "~/components/reports/purchaseReport";
export default {
  name: "purchase",
  middleware: "auth",
  head: {
    title: "Purchase Report",
  },
  components: {purchaseReport},
  data() {
    return {};
  },
  computed: {},
  async asyncData({ params, axios }) {},
  mounted() {},
  methods: {},
};
</script>

<style lang="scss" scoped>
</style>
